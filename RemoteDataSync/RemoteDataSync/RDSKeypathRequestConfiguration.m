//
//  RDSKeypathRequestConfiguration.m
//  PocketStoic
//
//  Created by Anton Remizov on 5/15/17.
//  Copyright © 2017 PocketStoic. All rights reserved.
//

#import "RDSKeypathRequestConfiguration.h"
#import "RDSManager.h"
#import "RDSObjectFactory.h"

@implementation RDSKeypathRequestConfiguration

- (void) performWithObject:(id)object
                   keyName:(NSString*)keyName
            withParameters:(nullable NSDictionary*)parameters
                   success:(nullable void (^)(id __nonnull responseObject, NSInteger newObjects))success
                   failure:(nullable void (^)(NSError* __nullable error))failure {
    NSURLSessionDataTask* task =
    [[RDSManager defaultManager].networkConnector dataTaskForObject:object
                                                  withConfiguration:self
                                               additionalParameters:parameters
                                                            success:^(id response) {
                                                                NSInteger newObjects = 0;
                                                                if (keyName) {
                                                                    newObjects = [[RDSManager defaultManager].objectFactory fillRelationshipOnManagedObject:object withKey:keyName fromData:response byReplacingData:self.replace];
                                                                } else {
                                                                    [[RDSManager defaultManager].objectFactory fillObject:object
                                                                                                                 fromData:response];
                                                                }
                                                                if(success) {
                                                                    success(response, newObjects);
                                                                }
                                                            } failure:^(NSError *error) {
                                                                if(failure) {
                                                                    failure(error);
                                                                }
                                                            }];
    [task resume];
   
}

@end
