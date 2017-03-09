//
//  NSManagedObject+RDS_Create.m
//  Vacarious
//
//  Created by Anton Remizov on 3/1/17.
//  Copyright © 2017 Appcoming. All rights reserved.
//

#import "NSManagedObject+RDS+Create.h"
#import "NSManagedObject+RDS.h"
#import "RDSRequestConfiguration.h"

@implementation NSManagedObject (RDS_Create)

- (void) create {
    [self createWithSuccess:nil failure:nil];
}

- (void) createWithSuccess:(nullable void (^)(id __nonnull responseObject))success
                   failure:(nullable void (^)(NSError* __nullable error))failure {
    [self createWithParameters:nil success:success failure:failure];
}

- (void) createWithParameters:(nullable NSDictionary*)parameters
                      success:(nullable void (^)(id __nonnull responseObject))success
                      failure:(nullable void (^)(NSError* __nullable error))failure {
    [self createForKey:nil withParameters:parameters success:^(id  _Nonnull responseObject, NSInteger newObjects) {
        if (success) {
            success(responseObject);
        }
    } failure:failure];
}

- (void) createForKey:(nullable NSString*)keyName
          withSuccess:(nullable void (^)(id __nonnull responseObject, NSInteger newObjects))success
              failure:(nullable void (^)(NSError* __nullable error))failure {
    [self createForKey:keyName withParameters:nil success:success failure:failure];
}

- (void) createForKey:(nullable NSString*)keyName
       withParameters:(nullable NSDictionary*)parameters
      byReplacingData:(BOOL)replace
              success:(nullable void (^)(id __nonnull responseObject, NSInteger newObjects))success
              failure:(nullable void (^)(NSError* __nullable error))failure {
    [self remoteCallWithScheme:RDSRequestSchemeCreate forKey:keyName withParameters:parameters byReplacingData:replace success:success failure:failure];
}

- (void) createForKey:(nullable NSString*)keyName
       withParameters:(nullable NSDictionary*)parameters
              success:(nullable void (^)(id __nonnull responseObject, NSInteger newObjects))success
              failure:(nullable void (^)(NSError* __nullable error))failure {
    [self remoteCallWithScheme:RDSRequestSchemeCreate forKey:keyName withParameters:parameters success:success failure:failure];
}
@end
