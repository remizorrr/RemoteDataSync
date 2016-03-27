//
//  NSManagedObject+RDS.h
//  PhotoKeeper
//
//  Created by Anton Remizov on 12/1/15.
//  Copyright © 2015 PhotoKeeper. All rights reserved.
//

#import <CoreData/CoreData.h>

typedef NS_ENUM(NSUInteger, RDSManagedObjectState) {
    RDSManagedObjectUnkown,
    RDSManagedObjectNew,
    RDSManagedObjectSynced,
    RDSManagedObjectChanged,
    RDSManagedObjectRemoved
};
@interface NSManagedObject (RDS)

@property (nonatomic, assign) RDSManagedObjectState state;

- (void) markState:(RDSManagedObjectState)state;

- (void) fetchWithSuccess:(nullable void (^)(id __nonnull responseObject))success
                  failure:(nullable void (^)(NSError* __nullable error))failure;

- (void) fetchWithParameters:(nullable NSDictionary*)parameters
                     success:(nullable void (^)(id __nonnull responseObject))success
                  failure:(nullable void (^)(NSError* __nullable error))failure;

- (void) fetch:(nullable NSString*)keyName
   withSuccess:(nullable void (^)(id __nonnull responseObject, NSInteger newObjects))success
       failure:(nullable void (^)(NSError* __nullable error))failure;

- (void) fetch:(nullable NSString*)keyName
withParameters:(nullable NSDictionary*)parameters
byReplacingData:(BOOL)replace
       success:(nullable void (^)(id __nonnull responseObject, NSInteger newObjects))success
       failure:(nullable void (^)(NSError* __nullable error))failure;

- (void) remoteCallWithScheme:(nonnull  NSString*)scheme
                       forKey:(nullable NSString*)keyName
               withParameters:(nullable NSDictionary*)parameters
                      success:(nullable void (^)(id __nonnull responseObject, NSInteger newObjects))success
                      failure:(nullable void (^)(NSError* __nullable error))failure;

- (void) remoteCallWithScheme:(nonnull  NSString*)scheme
                       forKey:(nullable NSString*)keyName
               withParameters:(nullable NSDictionary*)parameters
              byReplacingData:(BOOL)replace
                      success:(nullable void (^)(id __nonnull responseObject, NSInteger newObjects))success
                      failure:(nullable void (^)(NSError* __nullable error))failure;

- (void) remoteSyncWithSuccess:(nullable void (^)(id __nonnull responseObject, NSInteger newObjects))success
                       failure:(nullable void (^)(NSError* __nullable error))failure;

@end
