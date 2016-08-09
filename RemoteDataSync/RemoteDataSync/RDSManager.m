//
//  RDSManager.m
//  PhotoKeeper
//
//  Created by Anton Remizov on 12/2/15.
//  Copyright © 2015 PhotoKeeper. All rights reserved.
//

#import "RDSManager.h"
#import "RDSCoreDataStore.h"
#import "RDSAFNetworkConnector.h"
#import "RDSDictionaryRequestConfigurator.h"
#import "RDSObjectFactoryCache.h"

@implementation RDSManager

+ (instancetype) defaultManager {
    static id manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class Type = self;
        manager = [Type new];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setDefaults];
    }
    return self;
}

- (void)setDefaults {
    self.dataStore = [RDSCoreDataStore new];
    self.networkConnector = [RDSAFNetworkConnector new];
    self.configurator = [RDSDictionaryRequestConfigurator new];
    self.mappingProvider = [RDSMappingStore new];
    self.objectFactory = [RDSObjectFactory new];
    self.objectCache = [RDSObjectFactoryCache new];
    self.objectFactory.mappingProvider = self.mappingProvider;
    self.objectFactory.dataStore = self.dataStore;
    self.objectFactory.objectCache = self.objectCache;
    self.dataStore.objectCache = self.objectCache;
    self.dataStore.mappingProvider = self.mappingProvider;
}
@end
