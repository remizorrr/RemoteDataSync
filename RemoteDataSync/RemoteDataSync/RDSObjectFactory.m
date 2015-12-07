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

@implementation RDSObjectFactory

- (void) fillObject:(id)object fromData:(id<NSObject>)data
{
    if (![data isKindOfClass:[NSDictionary class]]) {
        return;
    }
    RDSMapping* mapping = [self.mappingProvider mappingForType:[object class]];
    for (NSString* key in (NSDictionary*)data) {
        id value = data[key];
        RDSMappingItem* mappingItem = mapping.mappingItems[key];
        if (mappingItem.ignore) {
            continue;
        }
        NSString* finalKey = mappingItem?mappingItem.toKeyPath:key;
        if ([finalKey isEqualToString:@"description"]) {
//            NSLog(@"Warning: Can't map \"description\" key");
            continue;
        }
        if ([object respondsToSelector:NSSelectorFromString(finalKey)]) {

//            if ([value isKindOfClass:[NSOrderedSet class]] ||
//                [value isKindOfClass:[NSSet class]] ||
//                [value isKindOfClass:[NSArray class]] ||
//                !value ||
//                value == [NSNull null]) {
//                continue;
//            }

            if ([object isKindOfClass:[NSManagedObject class]]) {
 
                NSPropertyDescription* property = ((NSManagedObject*)object).entity.propertiesByName[finalKey];
                if ([property isKindOfClass:[NSRelationshipDescription class]]) {
                    if ([value isKindOfClass:[NSDictionary class]] && !((NSRelationshipDescription*)property).toMany) {
                        id originalObject = [object valueForKey:finalKey];
                        if (!originalObject) {
                            NSString* type = [(NSRelationshipDescription*)property destinationEntity].name;
                            originalObject = [self.dataStore createObjectOfType:type];
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
            }
            [object setValue:value forKey:finalKey];
        }
    }
}

- (void) fillRelationshipOnManagedObject:(NSManagedObject*)object withKey:(NSString*)key fromData:(NSArray*)data {
    [self fillRelationshipOnManagedObject:object withKey:key fromData:data byReplacingData:YES];
}

- (void) fillRelationshipOnManagedObject:(NSManagedObject*)object withKey:(NSString*)key fromData:(NSArray*)data byReplacingData:(BOOL)replace{
    NSRelationshipDescription* property = object.entity.propertiesByName[key];
    Class type = NSClassFromString(((NSRelationshipDescription*)property).destinationEntity.name);
    [self fillRelationshipOnObject:object withKey:key itemsType:type fromData:data byReplacingData:replace];
}

- (void) fillRelationshipOnObject:(id)object withKey:(NSString*)key itemsType:(Class)type fromData:(NSArray*)data byReplacingData:(BOOL)replace{
    if (![data isKindOfClass:[NSArray class]]) {
        return;
    }
    
    if (![object isKindOfClass:[NSManagedObject class]]) {
        NSLog(@"RDS Warning: Non core data object are not supported for fillRelationshipOnObject:.");
        return;
    }
    
    NSMutableArray* newItems = [NSMutableArray array];
    NSArray* currentItems = [(NSOrderedSet*)[object valueForKey:key] array];
    if (replace) {
        for (NSManagedObject* object in currentItems) {
    #warning Fix the caching
            // Temporary full rewrite.
            [self.dataStore deleteObject:object];
        }
    } else  {
        [newItems addObjectsFromArray:currentItems];
    }
    
//    NSMutableDictionary* cache = [NSMutableDictionary dictionary];
//
//    for (id object in newItems) {
//        if (![[object valueForKey:uniqueKey] length]) {
//            NSLog(@"Error!! Travel with no identifier");
//        } else {
//            [cache setObject:object forKey:[object valueForKey:uniqueKey]];
//        }
//    }

    for (NSDictionary* itemJSON in data) {
        id item = nil;//cache[itemJSON[@"id"]];
        if (!item) {
            item = [self.dataStore createObjectOfType:NSStringFromClass(type)];
        }
        
        [self fillObject:item
                fromData:itemJSON];
        
//        [cache setObject:travel forKey:travel.identifier];
        [newItems addObject:item];
    }
    NSRelationshipDescription* property = ((NSManagedObject*)object).entity.propertiesByName[key];
    Class collectionType = (property.ordered)?NSOrderedSet.class:NSSet.class;
    [object setValue:[[collectionType alloc] initWithArray:newItems] forKey:key];
}



//- (void) fillObject:(id)object keyPath:(NSString*)keypath fromData:(id)data withMapping:(RDSMapping*) mapping uniqieKey:(NSString*)uniqueKey
//{
//    NSArray* array = data;
//    NSArray* currentItems = [(NSOrderedSet*)[object valueForKeyPath:keypath] array];
//    NSMutableArray* newItems = [NSMutableArray array];
//    [newItems addObjectsFromArray:newItems];
//    NSMutableDictionary* cache = [NSMutableDictionary dictionary];
//
//    for (id object in newItems) {
//        if (![[object valueForKey:uniqueKey] length]) {
//            NSLog(@"Error!! Travel with no identifier");
//        } else {
//            [cache setObject:object forKey:[object valueForKey:uniqueKey]];
//        }
//    }
//    
//    for (NSDictionary* itemJSON in array) {
//        id item = cache[itemJSON[@"id"]];
//        if (!item) {
//            item = [self.dataStore createObjectOfType:@"Travel"];
//        }
//        [[RDSObjectFactory sharedFactory] fillObject:travel
//                                            fromData:travelJson
//                                         withMapping:[RDSMapping mappingWithDictionary:@{@"id":@"identifier"}]];
//        [cache setObject:travel forKey:travel.identifier];
//        [newTravels addObject:travel];
//    }
//    [user setValue:[[NSOrderedSet alloc] initWithArray:newTravels]
//        forKeyPath:keypath];
//}

@end
