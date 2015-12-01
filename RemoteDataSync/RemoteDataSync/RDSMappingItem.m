//
//  RDSMapping.m
//  Synchora
//
//  Created by Anton Remizov on 4/20/15.
//  Copyright (c) 2015 synchora. All rights reserved.
//

#import "RDSMappingItem.h"

@implementation RDSMappingItem
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.ignore = NO;
        self.ignoreType = YES;
    }
    return self;
}
@end
