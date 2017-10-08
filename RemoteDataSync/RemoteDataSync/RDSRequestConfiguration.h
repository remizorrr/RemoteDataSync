//
//  RDSRequestConfiguration.h
//  PhotoKeeper
//
//  Created by Anton Remizov on 12/2/15.
//  Copyright © 2015 PhotoKeeper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RDSMapping.h"

extern NSString * const RDSRequestSchemeFetch;
extern NSString * const RDSRequestSchemeCreate;
extern NSString * const RDSRequestSchemeUpdate;
extern NSString * const RDSRequestSchemeRemove;

@interface RDSRequestConfiguration : NSObject

@property (nonatomic, strong) NSString* method;
@property (nonatomic, assign) BOOL replace;

- (void) performWithObject:(id)object
                   keyName:(NSString*)keyName
            withParameters:(nullable NSDictionary*)parameters
                   success:(nullable void (^)(id __nonnull responseObject, NSInteger newObjects))success
                   failure:(nullable void (^)(NSError* __nullable error))failure;

@end
