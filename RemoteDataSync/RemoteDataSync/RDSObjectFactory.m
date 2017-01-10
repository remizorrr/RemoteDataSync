//
//  ObjectFactory.m
//  Synchora
//
//  Created by Anton Remizov on 3/26/15.
//  Copyright (c) 2015 synchora. All rights reserved.
//

#import "RDSObjectFactory.h"
#import "RDSTypeConverter.h"
#import <CoreData/CoreData.h>
#import "RDSObjectFactoryCache.h"
#import "RDSMapping+Protected.h"
#import "NSArray+AsyncEnumeration.h"
#import "NSManagedObject+RDS.h"
#import "NSObject+Types.h"

@interface RDSObjectFactory()
{
    RDSObjectFactoryCache* _objectCache;
    NSMutableSet* _cachedTypes;
}

@end

@implementation RDSObjectFactory

- (instancetype)init
{
    self = [super init];
    if (self) {
        _cachedTypes = [NSMutableSet set];
        [self prefillCache];
    }
    return self;
}

- (void) prefillCache {
    NSDictionary* allMappings = [self.mappingProvider mappingsByType];
    for (NSString* type in allMappings) {
        RDSMapping* mapping = allMappings[type];
        if(mapping.primaryKey) {
            [self prefillCacheForType:type mapping:mapping async:YES];
        }
    }
}

- (void) prefillCacheForType:(NSString*)type mapping:(RDSMapping*)mapping async:(BOOL)async {
    if (!mapping || !mapping.primaryKey) {
        return;
    }
    if ([_cachedTypes containsObject:type]) {
        return;
    }
    [_cachedTypes addObject:type];
    NSArray* allObjects = [self.dataStore objectsOfType:type];
    if (async) {
        [allObjects enumerateObjectsAsyncWithSyncChunkSize:100
                                                usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                    [_objectCache cacheObject:obj forKey:mapping.primaryKey];
                                                }];
    } else {
        [allObjects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_objectCache cacheObject:obj forKey:mapping.primaryKey];
        }];
    }
}

- (void) fillObject:(id)object fromData:(id<NSObject>)data
{
    if (![data isKindOfClass:[NSDictionary class]]) {
        return;
    }
    RDSMapping* mapping = [self.mappingProvider mappingForType:[object class]];
    [self fillObject:object fromData:data withMapping:mapping];
}

- (void) fillObject:(id)object fromData:(id<NSObject>)data withMapping:(RDSMapping*)mapping {
    if ([object respondsToSelector:@selector(markState:)]) {
        [object markState:RDSManagedObjectSynced];
    }
    if (mapping && mapping.primaryKey) {
        [self prefillCacheForType:NSStringFromClass([object class])
                          mapping:mapping async:NO];
        [_objectCache removeObject:object cachedWithKey:mapping.primaryKey];
    }
    NSMutableArray* allKeys = [mapping.mappingItems allKeys].mutableCopy;
    for (NSString* key in (NSDictionary*)data) {
        [allKeys removeObject:key];
        id value = data[key];
        RDSMappingItem* mappingItem = mapping.mappingItems[key];
        if (mappingItem.ignore) {
            continue;
        }
        NSString* finalKey = mappingItem.toKeyPath?:key;
        if ([finalKey isEqualToString:@"description"]) {
            NSLog(@"Warning: Can't map \"description\" key");
            continue;
        }
        if ([self object:object hasProperty:finalKey]) {
            if(mappingItem.toBlock) {
                mappingItem.toBlock(value, object);
                continue;
            } else if ([object isKindOfClass:[NSManagedObject class]]) {
                NSPropertyDescription* property = ((NSManagedObject*)object).entity.propertiesByName[finalKey];
                if ([property isKindOfClass:[NSRelationshipDescription class]]) {
                    if ([value isKindOfClass:[NSDictionary class]] && !((NSRelationshipDescription*)property).toMany) {
                        id originalObject = [object valueForKey:finalKey];
                        if (!originalObject) {
                            NSString* type = [(NSRelationshipDescription*)property destinationEntity].name;
                            NSString* uniqueKeyPath = [mapping jsonUniqueKey];
                            id uniqueKeyValue = value[uniqueKeyPath];
                            if (uniqueKeyValue && mapping.primaryKey) {
                                originalObject = [[self.dataStore objectsOfType:type withValue:uniqueKeyValue forKey:mapping.primaryKey] firstObject];
                            }
                            if (!originalObject) {
                                originalObject = [self.dataStore createObjectOfType:type];
                            }
                            [object setValue:originalObject forKey:finalKey];
                        }
                        [self fillObject:originalObject fromData:value];
                    } else if ([value isKindOfClass:[NSArray class]] && ((NSRelationshipDescription*)property).toMany) {
                        [self fillRelationshipOnManagedObject:object withKey:finalKey fromData:value];
                    }
                    continue;

                }
                else {
                    value = [RDSTypeConverter convert:value toEntity:((NSManagedObject*)object).entity key:finalKey];
                }
            } else {
                value = [RDSTypeConverter convert:value toType:[object typeOfPropertyWithName:finalKey]];
            }
            [object setValue:value forKey:finalKey];
        }
    }
    for (NSString* keyPath in allKeys) {
        RDSMappingItem* mappingItem = mapping.mappingItems[keyPath];
        NSArray *items = [keyPath componentsSeparatedByString:@"."];
        id value = data;
        for (NSString* key in items) {
            value = value[key];
        }
        NSString* finalKey = mappingItem.toKeyPath?:keyPath;
        if ([finalKey isEqualToString:@"description"]) {
            NSLog(@"Warning: Can't map \"description\" key");
            continue;
        }
        if(mappingItem.toBlock) {
            mappingItem.toBlock(value, object);
            continue;
        }
        if ([self object:object hasProperty:finalKey]) {
//            } else if ([object isKindOfClass:[NSManagedObject class]]) {
//                NSPropertyDescription* property = ((NSManagedObject*)object).entity.propertiesByName[finalKey];
//                if ([property isKindOfClass:[NSRelationshipDescription class]]) {
//                    if ([value isKindOfClass:[NSDictionary class]] && !((NSRelationshipDescription*)property).toMany) {
//                        id originalObject = [object valueForKey:finalKey];
//                        if (!originalObject) {
//                            NSString* type = [(NSRelationshipDescription*)property destinationEntity].name;
//                            NSString* uniqueKeyPath = [mapping jsonUniqueKey];
//                            id uniqueKeyValue = value[uniqueKeyPath];
//                            if (uniqueKeyValue && mapping.primaryKey) {
//                                originalObject = [[self.dataStore objectsOfType:type withValue:uniqueKeyValue forKey:mapping.primaryKey] firstObject];
//                            }
//                            if (!originalObject) {
//                                originalObject = [self.dataStore createObjectOfType:type];
//                            }
//                            [object setValue:originalObject forKey:finalKey];
//                        }
//                        [self fillObject:originalObject fromData:value];
//                    } else if ([value isKindOfClass:[NSArray class]] && ((NSRelationshipDescription*)property).toMany) {
//                        [self fillRelationshipOnManagedObject:object withKey:finalKey fromData:value];
//                    }
//                    continue;
//                    
//                }
//                else {
//                    value = [RDSTypeConverter convert:value toEntity:((NSManagedObject*)object).entity key:finalKey];
//                }
            //TODO: Add support for ManagedObjects and deep mapping
            value = [RDSTypeConverter convert:value toType:[object typeOfPropertyWithName:finalKey]];
            [object setValue:value forKey:finalKey];
        }
    }
    if (mapping && mapping.primaryKey) {
        [_objectCache cacheObject:object forKey:mapping.primaryKey];
    }
}

- (BOOL) object:(id)object hasProperty:(NSString*)property {
    if ([self.dataStore canStoreObject:object]) {
        return [self.dataStore object:object hasProperty:property];
    } else {
        return [object respondsToSelector:NSSelectorFromString(property)];
    }
}

- (NSInteger) fillRelationshipOnManagedObject:(NSManagedObject*)object withKey:(NSString*)key fromData:(NSArray*)data {
    return [self fillRelationshipOnManagedObject:object withKey:key fromData:data byReplacingData:YES];
}

- (NSInteger) fillRelationshipOnManagedObject:(NSManagedObject*)object withKey:(NSString*)key fromData:(NSArray*)data byReplacingData:(BOOL)replace{
    NSRelationshipDescription* property = object.entity.relationshipsByName[key];
    if (property) {
        Class type = NSClassFromString(property.destinationEntity.name);
        return [self fillRelationshipOnObject:object withKey:key itemsType:type fromData:data byReplacingData:replace];
    } else {
        return 0;
    }
}

- (NSInteger) fillRelationshipOnObject:(id)object withKey:(NSString*)key itemsType:(Class)type fromData:(NSArray*)data byReplacingData:(BOOL)replace{
    if (![data isKindOfClass:[NSArray class]]) {
        return 0;
    }
    
    if (![object isKindOfClass:[NSManagedObject class]]) {
        NSLog(@"RDS Warning: Non core data object are not supported for fillRelationshipOnObject:.");
        return 0;
    }
    
    NSInteger counter = 0;
    
    NSMutableArray* newItems = [NSMutableArray array];
    NSOrderedSet* currentItems = (NSOrderedSet*)[object valueForKey:key];
    NSMutableOrderedSet* itemsToDelete = currentItems.mutableCopy;
    
    if (!replace) {
        [newItems addObjectsFromArray:currentItems.array];
    }
    
    RDSMapping* mapping = [self.mappingProvider mappingForType:type];
    
    for (NSDictionary* itemJSON in data) {
        NSString* uniqueKeyPath = [mapping jsonUniqueKey];
        
        id uniqueKeyValue = itemJSON[uniqueKeyPath];
        id item = nil;
        if (mapping.primaryKey) {
            item = [[self.dataStore objectsOfType:NSStringFromClass(type) withValue:uniqueKeyValue forKey:mapping.primaryKey] firstObject];
            if (item) {
                [itemsToDelete removeObject:item];
            }
        }
        if (!item) {
            item = [self.dataStore createObjectOfType:NSStringFromClass(type)];
            ++counter;
        }
        
        [self fillObject:item
                fromData:itemJSON];

        [newItems addObject:item];
    }

    if (replace) {
//        for (NSManagedObject* item in itemsToDelete) {
//            [self.dataStore deleteObject:item];
// We don't want to delete these objects to keep them in cache.
//        }
    }

    NSRelationshipDescription* property = ((NSManagedObject*)object).entity.propertiesByName[key];
    Class collectionType = (property.ordered)?NSOrderedSet.class:NSSet.class;
    [object setValue:[[collectionType alloc] initWithArray:newItems] forKey:key];
    return counter;
}

@end
