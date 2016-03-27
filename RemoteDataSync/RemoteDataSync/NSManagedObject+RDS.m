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
#import <objc/runtime.h>

@implementation NSManagedObject (RDS)

- (void) fetchWithSuccess:(nullable void (^)(id __nonnull responseObject))success
                  failure:(nullable void (^)(NSError* __nullable error))failure {
    [self fetch:nil
    withSuccess:^(id  _Nonnull responseObject, NSInteger newObjects) { if(success) success(responseObject);}
        failure:failure];
}

- (void) fetchWithParameters:(nullable NSDictionary*)parameters
                     success:(nullable void (^)(id __nonnull responseObject))success
                     failure:(nullable void (^)(NSError* __nullable error))failure {
    [self remoteCallWithScheme:RDSRequestSchemeFetch forKey:nil withParameters:parameters
        success:^(id  _Nonnull responseObject, NSInteger newObjects) { if(success) success(responseObject);}
        failure:failure];
}


- (void) fetch:(nullable NSString*)keyName
   withSuccess:(nullable void (^)(id __nonnull responseObject, NSInteger newObjects))success
       failure:(nullable void (^)(NSError* __nullable error))failure
{
    [self remoteCallWithScheme:RDSRequestSchemeFetch forKey:keyName withParameters:nil success:success failure:failure];
}

- (void) remoteCallWithScheme:(nonnull  NSString*)scheme
                       forKey:(nullable NSString*)keyName
               withParameters:(nullable NSDictionary*)parameters
                      success:(nullable void (^)(id __nonnull responseObject, NSInteger newObjects))success
                      failure:(nullable void (^)(NSError* __nullable error))failure {
    if(![NSThread isMainThread]) {
        @throw [NSException exceptionWithName:@"RDS Error" reason:@"method can be used from main thread only" userInfo:nil];
    }
    RDSRequestConfiguration* configuration = [[RDSManager defaultManager].configurator configurationForObject:self
                                                             keyPath:keyName
                                                              scheme:scheme];
    NSURLSessionDataTask* task =
    [[RDSManager defaultManager].networkConnector dataTaskForObject:self
                                                  withConfiguration:configuration
                                               additionalParameters:parameters
                                                            success:^(id response) {
                                                                NSInteger newObjects = 0;
                                                                if (keyName) {
                                                                    newObjects = [[RDSManager defaultManager].objectFactory fillRelationshipOnManagedObject:self withKey:keyName fromData:response byReplacingData:configuration.replace];
                                                                } else {
                                                                    [[RDSManager defaultManager].objectFactory fillObject:self
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

- (void) remoteSyncWithSuccess:(nullable void (^)(id __nonnull responseObject, NSInteger newObjects))success
                       failure:(nullable void (^)(NSError* __nullable error))failure {
    NSString* scheme = nil;
    switch (self.state) {
        case RDSManagedObjectChanged:
            scheme = RDSRequestSchemeUpdate;
            break;
        case RDSManagedObjectNew:
            scheme = RDSRequestSchemeCreate;
            break;
        case RDSManagedObjectRemoved:
            scheme = RDSRequestSchemeRemove;
            break;
        case RDSManagedObjectUnkown:
        case RDSManagedObjectSynced:
            success(@{},0);
            return;
            break;
    }

    [self remoteCallWithScheme:scheme
                        forKey:nil
                withParameters:nil
                       success:success failure:failure];
}

- (RDSManagedObjectState)state {
    NSNumber* number = (NSNumber *)objc_getAssociatedObject(self, @selector(state));
    return number?(RDSManagedObjectState)[number integerValue]:RDSManagedObjectUnkown;
}

- (void) markState:(RDSManagedObjectState)state {
    if (self.state == RDSManagedObjectRemoved) {
        return;
    }
    if (state == RDSManagedObjectNew && self.state != RDSManagedObjectUnkown) {
        return;
    }
    if (self.state == RDSManagedObjectNew && state == RDSManagedObjectChanged) {
        return;
    }
    self.state = state;
}

- (void) setState:(RDSManagedObjectState)state {
    objc_setAssociatedObject(self, @selector(state), @(state), OBJC_ASSOCIATION_ASSIGN);
}

@end
