//
//  NSManagedObject+RDS_Fetch.m
//  Tella
//
//  Created by Anton Remizov on 6/27/16.
//  Copyright © 2016 Appcoming. All rights reserved.
//

#import "NSManagedObject+RDS+Fetch.h"

@implementation NSManagedObject (RDS_Fetch)

- (void) fetch {
    [self fetchWithSuccess:nil failure:nil];
}

- (void) fetchWithSuccess:(nullable void (^)(id __nonnull responseObject))success
                  failure:(nullable void (^)(NSError* __nullable error))failure {
    [self fetch:nil
    withSuccess:^(id  _Nonnull responseObject, NSInteger newObjects) { if(success) success(responseObject);}
        failure:failure];
}

- (void) fetchWithParameters:(nullable NSDictionary*)parameters
                     success:(nullable void (^)(id __nonnull responseObject))success
                     failure:(nullable void (^)(NSError* __nullable error))failure {
    [self fetch:nil withParameters:parameters success:^(id  _Nonnull responseObject, NSInteger newObjects) {
        success(responseObject);
    } failure:failure];
}


- (void) fetch:(nullable NSString*)keyName
   withSuccess:(nullable void (^)(id __nonnull responseObject, NSInteger newObjects))success
       failure:(nullable void (^)(NSError* __nullable error))failure
{
    [self fetch:keyName withParameters:nil success:success failure:failure];
}

- (void) fetch:(nullable NSString*)keyName
withParameters:(nullable NSDictionary*)parameters
       success:(nullable void (^)(id __nonnull responseObject, NSInteger newObjects))success
       failure:(nullable void (^)(NSError* __nullable error))failure {
    [self remoteCallWithScheme:RDSRequestSchemeFetch forKey:keyName withParameters:parameters success:success failure:failure];
}

- (void) fetch:(nullable NSString*)keyName
withParameters:(nullable NSDictionary*)parameters
byReplacingData:(BOOL)replace
       success:(nullable void (^)(id __nonnull responseObject, NSInteger newObjects))success
       failure:(nullable void (^)(NSError* __nullable error))failure {
    [self remoteCallWithScheme:RDSRequestSchemeFetch forKey:keyName withParameters:parameters byReplacingData:replace success:success failure:failure];
}

@end
