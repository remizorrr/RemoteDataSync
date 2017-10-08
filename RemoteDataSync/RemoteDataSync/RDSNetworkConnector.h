//
//  RDSNetworkConnector.h
//  PhotoKeeper
//
//  Created by Anton Remizov on 12/2/15.
//  Copyright © 2015 PhotoKeeper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RDSKeypathRequestConfiguration.h"

@protocol RDSNetworkConnector <NSObject>

@property (nonatomic, strong) NSURL* baseURL;
@property (nonatomic, copy) id (^parametersPreprocess)(NSString* method, NSString * url, NSDictionary* parameters);
@property (nonatomic, copy) NSURLRequest* (^requestPreprocess)(NSURLRequest* request);
@property (nonatomic, copy) BOOL(^responsePreprocess)(id* data, NSURLResponse* response);
@property (nonatomic, copy) void(^errorProcess)(id response, NSError* error);

- (id)dataTaskForObject:(id) object
                          withConfiguration:(RDSKeypathRequestConfiguration*) configuration
                       additionalParameters:(NSDictionary*)parameters
                                    success:(void (^)(id))success
                                    failure:(void (^)(NSError *))failure;

@end
