//
//  NSManagedObject+RDS_Create.h
//  Vacarious
//
//  Created by Anton Remizov on 3/1/17.
//  Copyright © 2017 Appcoming. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (RDS_Create)

- (void) create;

- (void) createWithSuccess:(nullable void (^)(id __nonnull responseObject))success
                   failure:(nullable void (^)(NSError* __nullable error))failure;

- (void) createWithParameters:(nullable NSDictionary*)parameters
                      success:(nullable void (^)(id __nonnull responseObject))success
                      failure:(nullable void (^)(NSError* __nullable error))failure;

- (void) createForKey:(nullable NSString*)keyName
          withSuccess:(nullable void (^)(id __nonnull responseObject, NSInteger newObjects))success
              failure:(nullable void (^)(NSError* __nullable error))failure;

- (void) createForKey:(nullable NSString*)keyName
       withParameters:(nullable NSDictionary*)parameters
      byReplacingData:(BOOL)replace
              success:(nullable void (^)(id __nonnull responseObject, NSInteger newObjects))success
              failure:(nullable void (^)(NSError* __nullable error))failure;

@end
