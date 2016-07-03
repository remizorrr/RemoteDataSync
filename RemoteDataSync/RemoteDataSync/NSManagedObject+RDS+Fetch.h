//
//  NSManagedObject+RDS_Fetch.h
//  Tella
//
//  Created by Anton Remizov on 6/27/16.
//  Copyright © 2016 Appcoming. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "NSManagedObject+RDS.h"
#import "RDSRequestConfiguration.h"

@interface NSManagedObject (RDS_Fetch)

- (void) fetch;

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

@end
