//
//  RDSAFNetworkConnector.m
//  PhotoKeeper
//
//  Created by Anton Remizov on 12/2/15.
//  Copyright © 2015 PhotoKeeper. All rights reserved.
//

#import "RDSAFNetworkConnector.h"

@interface RDSAFNetworkConnector ()

@end

@implementation RDSAFNetworkConnector
@synthesize responsePreprocess;
@synthesize errorProcess;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    return self;
}

- (NSURLSessionDataTask *)dataTaskForObject:(id) object
                          withConfiguration:(RDSRequestConfiguration*) configuration
                       additionalParameters:(id)parameters
                                    success:(void (^)(NSURLSessionDataTask *, id)) success
                                    failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;
{
   NSURLSessionDataTask * task = [self dataTaskWithHTTPMethod:configuration.method
                                                    URLString:configuration.pathBlock?configuration.pathBlock(object):configuration.path
                                                   parameters:parameters
                                                      success:^(NSURLSessionDataTask *task, id response) {
                                                          if (success) {
                                                              success(task, configuration.baseKeyPath.length?[response valueForKeyPath:configuration.baseKeyPath]:response);
                                                          }
                                                      } failure: failure];
    return task;
}

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:&serializationError];
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
#pragma clang diagnostic pop
        }
        
        return nil;
    }
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            if (self.errorProcess) {
                self.errorProcess(responseObject, error);
            }
            if (failure) {
                failure(dataTask, error);
            }
        } else {
            if (self.responsePreprocess) {
                if (!self.responsePreprocess(&responseObject, response)) {
                    return;
                }
            }
            if (success) {
                success(dataTask, responseObject);
            }
        }
    }];
    
    return dataTask;
}

@end
