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
@synthesize parametersPreprocess;
@synthesize requestPreprocess;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    return self;
}

- (AFHTTPRequestOperation *)dataTaskForObject:(id) object
                          withConfiguration:(RDSRequestConfiguration*) configuration
                       additionalParameters:(NSDictionary*)parameters
                                    success:(void (^)(id)) success
                                    failure:(void (^)(NSError *))failure
{
    if (!configuration) {
        @throw [NSException exceptionWithName:@"RDSAFNetworkConnector Error" reason:@"Can't fetch data with nil configuration" userInfo:nil];
    }
    NSString* urlString = configuration.pathBlock?configuration.pathBlock(object):configuration.path;
    NSMutableDictionary* mParameters = parameters?parameters.mutableCopy:[NSMutableDictionary dictionary];
    NSDictionary* addedParameters = configuration.parametersBlock?configuration.parametersBlock(object):configuration.parameters;
    if (addedParameters) {
        [mParameters addEntriesFromDictionary:addedParameters];
    }
    
    AFHTTPRequestOperation * task = [self dataTaskWithHTTPMethod:configuration.method
                                                     URLString:urlString
                                                    parameters:mParameters.copy
                                                       success:^(AFHTTPRequestOperation *task, id response) {
                                                           if (success) {
                                                               if (configuration.baseKeyPath.length) {
                                                                   response = [response valueForKeyPath:configuration.baseKeyPath];
                                                                   if (!response) {
                                                                       NSLog(@"RDSAFNetworkingConnector Warning: No data found for baseKeyPath(%@) for response to the url %@",configuration.baseKeyPath, urlString);
                                                                   }
                                                               }
                                                               success(response);
                                                           }
                                                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                           failure(error);
                                                       }];
    return task;
}

- (AFHTTPRequestOperation *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                         success:(void (^)(AFHTTPRequestOperation *, id))success
                                         failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    if (!URLString.length) {
        @throw [NSException exceptionWithName:@"RDSAFNetworkConnector Error" reason:@"Can't fetch data with empty url" userInfo:nil];
    }

    NSError *serializationError = nil;
    if (self.parametersPreprocess) {
        parameters = self.parametersPreprocess(method, URLString, parameters);
    }
    NSURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:&serializationError];
    
    if (self.requestPreprocess) {
        request = self.requestPreprocess(request);
    }
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
    
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@ - %@",operation, [[NSString alloc]initWithData:operation.responseData encoding:NSUTF8StringEncoding]);
        if (self.responsePreprocess) {
            if (!self.responsePreprocess(&responseObject, operation.response)) {
                return;
            }
        }
        if (success) {
            success(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@ - %@",operation, [[NSString alloc]initWithData:operation.responseData encoding:NSUTF8StringEncoding]);

        if (self.errorProcess) {
            self.errorProcess(operation.responseData, error);
        }
        if (failure) {
            failure(operation, error);
        }
    }];
    NSLog(@"%@ - %@ - %@",operation, method, [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:parameters
                                                                                            options:0
                                                                                              error:nil]
                                                   encoding:NSUTF8StringEncoding]);

    [self.operationQueue addOperation:operation];
    
    return operation;
}


@end
