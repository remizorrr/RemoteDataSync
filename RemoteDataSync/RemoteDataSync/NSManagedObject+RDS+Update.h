//
//  NSManagedObject+RDS_Posting.h
//  Tella
//
//  Created by Anton Remizov on 6/27/16.
//  Copyright © 2016 Appcoming. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (RDS_Posting)

- (void) update;

- (void) updateWithSuccess:(nullable void (^)(id __nonnull responseObject))success
                   failure:(nullable void (^)(NSError* __nullable error))failure;

- (void) updateWithParameters:(nullable NSDictionary*)parameters
                      success:(nullable void (^)(id __nonnull responseObject))success
                      failure:(nullable void (^)(NSError* __nullable error))failure;

- (void) updateForKey:(nullable NSString*)keyName
          withSuccess:(nullable void (^)(id __nonnull responseObject, NSInteger newObjects))success
              failure:(nullable void (^)(NSError* __nullable error))failure;

- (void) updateForKey:(nullable NSString*)keyName
       withParameters:(nullable NSDictionary*)parameters
      byReplacingData:(BOOL)replace
              success:(nullable void (^)(id __nonnull responseObject, NSInteger newObjects))success
              failure:(nullable void (^)(NSError* __nullable error))failure;

@end
