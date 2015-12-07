//
//  RDSRequestConfiguration.m
//  PhotoKeeper
//
//  Created by Anton Remizov on 12/2/15.
//  Copyright © 2015 PhotoKeeper. All rights reserved.
//

#import "RDSRequestConfiguration.h"

NSString * const RDSRequestSchemeFetch = @"RDSRequestSchemeFetch";
NSString * const RDSRequestSchemeCreate = @"RDSRequestSchemeCreate";
NSString * const RDSRequestSchemeUpdate = @"RDSRequestSchemeUpdate";
NSString * const RDSRequestSchemeRemove = @"RDSRequestSchemeRemove";

@implementation RDSRequestConfiguration

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.replace = YES;
    }
    return self;
}

@end
