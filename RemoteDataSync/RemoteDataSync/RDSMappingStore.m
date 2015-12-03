//
//  RDSMappingStore.m
//  PhotoKeeper
//
//  Created by Anton Remizov on 12/2/15.
//  Copyright © 2015 PhotoKeeper. All rights reserved.
//

#import "RDSMappingStore.h"

@interface RDSMappingStore ()
{
    NSMutableDictionary* mappings;
}
@end
@implementation RDSMappingStore

- (instancetype)init
{
    self = [super init];
    if (self) {
        mappings = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void) addMapping:(RDSMapping*)mapping forType:(Class)type {
    mappings[NSStringFromClass(type)] = mapping;
}

- (RDSMapping*) mappingForType:(Class)type {
    return mappings[NSStringFromClass(type)];
}

@end
