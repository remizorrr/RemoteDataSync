//
//  RDSBlockRequestConfiguration.m
//  PocketStoic
//
//  Created by Anton Remizov on 5/15/17.
//  Copyright © 2017 PocketStoic. All rights reserved.
//

#import "RDSBlockRequestConfiguration.h"

@implementation RDSBlockRequestConfiguration

- (void) performWithObject:(id)object
                   keyName:(NSString*)keyName
            withParameters:(nullable NSDictionary*)parameters
                   success:(nullable void (^)(id __nonnull responseObject, NSInteger newObjects))success
                   failure:(nullable void (^)(NSError* __nullable error))failure {
    self.block(object, keyName, parameters, success, failure);
}

@end
