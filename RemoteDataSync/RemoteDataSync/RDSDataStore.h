//
//  RDSDataStore.h
//  Synchora
//
//  Created by Anton Remizov on 3/25/15.
//  Copyright (c) 2015 synchora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RDSObjectCache.h"
#import "RDSMappingProvider.h"

@protocol RDSDataStore <NSObject>

@property (nonatomic, strong) id<RDSObjectCache> objectCache;
@property (nonatomic, strong) id<RDSMappingProvider> mappingProvider;

- (id) createUniqueObjectOfType:(NSString*)type;
- (id) createObjectOfType:(NSString*)type;
- (void) deleteObject:(id)object;
- (NSArray*) objectsOfType:(NSString*)type;
- (NSArray*) objectsOfType:(NSString*)type withValue:(NSString*)value forKey:(NSString*)key;
- (NSArray*) objectsOfType:(NSString*)type forPredicate:(NSPredicate*) predicate;
- (void) save;
- (void) revert;
- (void) wipeStorage;
- (void) scheduleObjectDeletion:(id)object;
- (NSArray*) objectsScheduledForDeletion;
- (BOOL) object:(id)object hasProperty:(NSString*)property;
- (BOOL) canStoreObject:(id)object;

@end
