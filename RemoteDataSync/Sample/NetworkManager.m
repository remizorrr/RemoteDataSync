//
//  NetworkManager.m
//  RemoteDataSync
//
//  Created by Anton Remizov on 12/15/15.
//  Copyright © 2015 Anton Remizov. All rights reserved.
//

#import "NetworkManager.h"

@implementation NetworkManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupMapping];
        [self setupConfiguration];
    }
    return self;
}

- (Login*) loginObject {
    Login* object = [[[RDSManager defaultManager].dataStore objectsOfType:@"Login"] firstObject];
    if (!object) {
        object = [[RDSManager defaultManager].dataStore createObjectOfType:@"Login"];
    }
    return object;
}

- (void) setupMapping {
    [[RDSManager defaultManager].mappingProvider addMapping:[RDSMapping mappingWithDictionary:@{@"id":@"serverID",
                                                                                                @"full_name":@"fullName"
                                                                                                }  primaryKey:@"serverID"] forType:Login.class];
}

- (void) setupConfiguration {
    
}

- (void) setupLoginConfiguration {
    RDSRequestConfiguration* configuration = [RDSRequestConfiguration new];
    configuration.method = @"GET";
    configuration.pathBlock = ^NSString* (Login* object) {
        NSString* serverID = @"";
        return [NSString stringWithFormat:@"/user/%@/media",serverID];
    };
    configuration.baseKeyPath = @"media_list";
    [[RDSManager defaultManager].configurator addConfiguration:configuration forType:Login.class keyPath:@"medias" sheme:RDSRequestSchemeFetch];
}

- (void) setupLoginPostConfiguration {
    RDSRequestConfiguration* configuration = [RDSRequestConfiguration new];
    configuration.method = @"POST";
    configuration.pathBlock = ^NSString* (Login* object) {
        NSString* serverID = @"";
        return [NSString stringWithFormat:@"/user/%@/media",serverID];
    };
    configuration.posting = [RDSMapping mappingWithDictionary:@{@"from0":@"to0",
                                                                @"from1":@"to1"}];
    
    configuration.baseKeyPath = @"media_list";
    [[RDSManager defaultManager].configurator addConfiguration:configuration forType:Login.class keyPath:@"medias" sheme:RDSRequestSchemeCreate];
}

@end
