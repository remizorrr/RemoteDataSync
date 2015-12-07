//
//  RDSNetworkConnector.h
//  PhotoKeeper
//
//  Created by Anton Remizov on 12/2/15.
//  Copyright © 2015 PhotoKeeper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RDSRequestConfiguration.h"
@protocol RDSNetworkConnector <NSObject>

@property (nonatomic, strong) NSURL* baseURL;
@property (nonatomic, strong) BOOL(^responsePreprocess)(id* data, NSURLResponse* response);
@property (nonatomic, strong) void(^errorProcess)(id response, NSError* error);

- (NSURLSessionDataTask *)dataTaskForObject:(id) object
                          withConfiguration:(RDSRequestConfiguration*) configuration
                       additionalParameters:(id)parameters
                                    success:(void (^)(NSURLSessionDataTask *, id))success
                                    failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;

@end
