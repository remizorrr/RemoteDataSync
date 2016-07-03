//
//  NSManagedObject+RDS_Posting.m
//  Tella
//
//  Created by Anton Remizov on 6/27/16.
//  Copyright © 2016 Appcoming. All rights reserved.
//

#import "NSManagedObject+RDS+Update.h"
#import "NSManagedObject+RDS.h"
#import "RDSRequestConfiguration.h"

@implementation NSManagedObject (RDS_Posting)

- (void) update {
    [self updateWithSuccess:nil failure:nil];
}

- (void) updateWithSuccess:(nullable void (^)(id __nonnull responseObject))success
                   failure:(nullable void (^)(NSError* __nullable error))failure {
    [self updateWithParameters:nil success:success failure:failure];
}

- (void) updateWithParameters:(nullable NSDictionary*)parameters
                      success:(nullable void (^)(id __nonnull responseObject))success
                      failure:(nullable void (^)(NSError* __nullable error))failure {
    [self updateForKey:nil withParameters:parameters success:^(id  _Nonnull responseObject, NSInteger newObjects) {
        if (success) {
            success(responseObject);
        }
    } failure:failure];
}

- (void) updateForKey:(nullable NSString*)keyName
          withSuccess:(nullable void (^)(id __nonnull responseObject, NSInteger newObjects))success
              failure:(nullable void (^)(NSError* __nullable error))failure {
    [self updateForKey:keyName withParameters:nil success:success failure:failure];
}

- (void) updateForKey:(nullable NSString*)keyName
withParameters:(nullable NSDictionary*)parameters
       success:(nullable void (^)(id __nonnull responseObject, NSInteger newObjects))success
       failure:(nullable void (^)(NSError* __nullable error))failure {
    [self remoteCallWithScheme:RDSRequestSchemeUpdate forKey:keyName withParameters:parameters success:success failure:failure];
}
- (void) updateForKey:(nullable NSString*)keyName
       withParameters:(nullable NSDictionary*)parameters
      byReplacingData:(BOOL)replace
              success:(nullable void (^)(id __nonnull responseObject, NSInteger newObjects))success
              failure:(nullable void (^)(NSError* __nullable error))failure {
    [self remoteCallWithScheme:RDSRequestSchemeUpdate forKey:keyName withParameters:parameters byReplacingData:replace success:success failure:failure];

}

@end
