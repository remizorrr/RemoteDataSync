//
//  ObjectFactory.h
//  Synchora
//
//  Created by Anton Remizov on 3/26/15.
//  Copyright (c) 2015 synchora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RDSMappingProvider.h"
#import "RDSDataStore.h"
#import <CoreData/CoreData.h>

@interface RDSObjectFactory : NSObject

@property (nonatomic, strong) id<RDSMappingProvider> mappingProvider;
@property (nonatomic, strong) id<RDSDataStore> dataStore;

- (void) prefillCache;
- (void) fillObject:(id)object fromData:(id<NSObject>)data;
- (void) fillObject:(id)object fromData:(id<NSObject>)data withMapping:(RDSMapping*)mapping;
- (NSInteger) fillRelationshipOnObject:(id)object withKey:(NSString*)key itemsType:(Class)type fromData:(NSArray*)data byReplacingData:(BOOL)replace;
- (NSInteger) fillRelationshipOnManagedObject:(NSManagedObject*)object withKey:(NSString*)key fromData:(NSArray*)data;
- (NSInteger) fillRelationshipOnManagedObject:(NSManagedObject*)object withKey:(NSString*)key fromData:(NSArray*)data byReplacingData:(BOOL)replace;

@end
