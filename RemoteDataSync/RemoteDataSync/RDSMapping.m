//
//  ObjectFactoryMapping.m
//  Synchora
//
//  Created by Anton Remizov on 3/26/15.
//  Copyright (c) 2015 synchora. All rights reserved.
//

#import "RDSMapping.h"

@implementation RDSMapping

+ (RDSMapping*) mappingWithDictionary:(NSDictionary*)dictionary
{
    RDSMapping* mapping = [RDSMapping new];
    
    NSMutableDictionary * items = [NSMutableDictionary dictionary];
    for (NSString* fromKeyPath in dictionary) {
        RDSMappingItem* item = [RDSMappingItem new];
        item.fromKeyPath = fromKeyPath;
        id value = dictionary[fromKeyPath];
        if ([value isKindOfClass:[NSNumber class]] && [value boolValue]==NO) {
            item.ignore = YES;
        } else {
            item.toKeyPath = value;
            item.ignoreType = YES;
        }
        [items setObject:item forKey:fromKeyPath];
    }
    mapping.mappingItems = [items copy];
    return mapping;
}

@end
