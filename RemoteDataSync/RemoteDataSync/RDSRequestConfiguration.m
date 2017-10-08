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

- (void) performWithObject:(id)object
            withParameters:(nullable NSDictionary*)parameters
                   success:(nullable void (^)(id __nonnull responseObject, NSInteger newObjects))success
                   failure:(nullable void (^)(NSError* __nullable error))failure {
    NSLog(@"This is an abstract class. This method should be implemented in ancestors");
}

@end
