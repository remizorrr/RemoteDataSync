//
//  RDSManager.h
//  PhotoKeeper
//
//  Created by Anton Remizov on 12/2/15.
//  Copyright © 2015 PhotoKeeper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RDSDataStore.h"
#import "RDSNetworkConnector.h"
#import "RDSRequestConfigurator.h"
#import "RDSMappingStore.h"
#import "RDSMappingProvider.h"
#import "RDSObjectFactory.h"

@interface RDSManager : NSObject

@property (nonatomic,strong) id<RDSDataStore> dataStore;
@property (nonatomic,strong) id<RDSNetworkConnector> networkConnector;
@property (nonatomic,strong) id<RDSRequestConfigurator> configurator;
@property (nonatomic,strong) id<RDSMappingProvider> mappingProvider;
@property (nonatomic,strong) RDSObjectFactory* objectFactory;

+ (instancetype) defaultManager;

@end
