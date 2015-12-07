//
//  NSManagedObject+RDS.m
//  PhotoKeeper
//
//  Created by Anton Remizov on 12/1/15.
//  Copyright © 2015 PhotoKeeper. All rights reserved.
//

#import "NSManagedObject+RDS.h"
#import "RDSManager.h"
#import "RDSObjectFactory.h"

@implementation NSManagedObject (RDS)

- (void) fetchWithSuccess:(nullable void (^)(id __nonnull responseObject))success
                  failure:(nullable void (^)(NSError* __nullable error))failure {
    [self fetch:nil withSuccess:success failure:failure];
}

- (void) fetchWithParameters:(nullable NSDictionary*)parameters
                     success:(nullable void (^)(id __nonnull responseObject))success
                     failure:(nullable void (^)(NSError* __nullable error))failure {
    [self fetch:nil withParameters:parameters success:success failure:failure];
}

- (void) fetch:(nullable NSString*)keyName
   withSuccess:(nullable void (^)(id __nonnull responseObject))success
       failure:(nullable void (^)(NSError* __nullable error))failure
{
    [self fetch:keyName withParameters:nil success:success failure:failure];
}

- (void) fetch:(nullable NSString*)keyName
withParameters:(nullable NSDictionary*)parameters
       success:(nullable void (^)(id __nonnull responseObject))success
       failure:(nullable void (^)(NSError* __nullable error))failure {
    RDSRequestConfiguration* configuration = [[RDSManager defaultManager].configurator configurationForObject:self
                                                             keyPath:keyName
                                                              scheme:RDSRequestSchemeFetch];
    NSURLSessionDataTask* task =
    [[RDSManager defaultManager].networkConnector dataTaskForObject:self
                                                  withConfiguration:configuration
                                               additionalParameters:parameters
                                                            success:^(NSURLSessionDataTask *task, id response) {
                                                                if (keyName) {
                                                                    [[RDSManager defaultManager].objectFactory fillRelationshipOnManagedObject:self withKey:keyName fromData:response byReplacingData:configuration.replace];
                                                                } else {
                                                                    [[RDSManager defaultManager].objectFactory fillObject:self
                                                                                                        fromData:response];
                                                                }
                                                                [[RDSManager defaultManager].dataStore save];
                                                                if(success) {
                                                                    success(response);
                                                                }
                                                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                                if(failure) {
                                                                    failure(error);
                                                                }
                                                            }];
    [task resume];
}


@end
