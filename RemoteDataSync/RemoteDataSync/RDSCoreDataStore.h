//
//  RDSCoreDataStore.h
//  Synchora
//
//  Created by Anton Remizov on 3/25/15.
//  Copyright (c) 2015 synchora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "RDSDataStore.h"
#import "NSManagedObject+RDS.h"

@interface RDSCoreDataStore : NSObject <RDSDataStore>

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSString* coreDataModelName;
@property (nonatomic, assign) BOOL cleanupOnMergeError;

@end
