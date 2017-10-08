//
//  RemoteDataSync.h
//  RemoteDataSync
//
//  Created by Anton Remizov on 12/1/15.
//  Copyright © 2015 Anton Remizov. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for RemoteDataSync.
FOUNDATION_EXPORT double RemoteDataSyncVersionNumber;

//! Project version string for RemoteDataSync.
FOUNDATION_EXPORT const unsigned char RemoteDataSyncVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <RemoteDataSync/PublicHeader.h>

#import "RDSManager.h"
#import "NSManagedObject+RDS.h"
#import "NSManagedObject+RDS+Fetch.h"
#import "NSManagedObject+RDS+Update.h"
#import "RDSMapping.h"
#import "RDSObjectFactory.h"
#import "RDSCoreDataStore.h"
#import "RDSAFNetworkConnector.h"
#import "RDSDummyDataHelpers.h"
#import "RDSArrayViewController.h"
#import "RDSObjectControllerConfiguration.h"
#import "RDSArrayController.h"
#import "RDSBlockRequestConfiguration.h"
