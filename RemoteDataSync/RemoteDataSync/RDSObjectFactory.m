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
                    if (![value isKindOfClass:[NSDictionary class]]) {
                        continue;
                    }
                    id originalObject = [object valueForKey:finalKey];
                    if (!originalObject) {
                        NSString* type = [(NSRelationshipDescription*)property destinationEntity].name;
                        originalObject = [self.dataStore createObjectOfType:type];
                        [object setValue:originalObject forKey:finalKey];
                    }
                    [self fillObject:originalObject fromData:value];
                } else {
                    value = [RDSTypeConverter convert:value toEntity:((NSManagedObject*)object).entity key:finalKey];
                }
            } else {
                [object setValue:value forKey:finalKey];
            }
        }
    }
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
