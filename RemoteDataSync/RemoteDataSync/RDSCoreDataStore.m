//
//  RDSCoreDataStore.m
//  Synchora
//
//  Created by Anton Remizov on 3/25/15.
//  Copyright (c) 2015 synchora. All rights reserved.
//

#import "RDSCoreDataStore.h"
#import "RDSObjectFactoryCache.h"

@interface RDSCoreDataStore ()
{
    NSManagedObjectContext * _managedObjectContext;
    NSManagedObjectModel* _managedObjectModel;
    NSPersistentStoreCoordinator* _persistentStoreCoordinator;
    RDSObjectFactoryCache* _objectCache;
    NSMutableArray<NSManagedObject*>* _scheduledForDeletion;
}
@end

@implementation RDSCoreDataStore

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cleanupOnMergeError = YES;
        _objectCache = [RDSObjectFactoryCache new];
        _scheduledForDeletion = [NSMutableArray array];
    }
    return self;
}
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    if (self.persistentStoreCoordinator) {
        NSManagedObjectContext *tmpManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        
        [tmpManagedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];

        _managedObjectContext = tmpManagedObjectContext;
        _managedObjectContext.mergePolicy = [[NSMergePolicy alloc]
                                             initWithMergeType:NSMergeByPropertyObjectTrumpMergePolicyType];
        
    }
    return _managedObjectContext;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    NSURL *tmpModelURL = [[NSBundle mainBundle] URLForResource:self.coreDataModelName?:@"Model"
                                                 withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:tmpModelURL];
    return _managedObjectModel;
}

- (NSURL*) storeURL
{
    NSString *tmpDataFileName = @"Model.sqlite";
    
    return [[self applicationDocumentsDirectory] URLByAppendingPathComponent:tmpDataFileName];
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    NSURL *tmpStoreURL = [self storeURL];
    
    NSError *tmpError = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:tmpStoreURL
                                                         options:@{
                                                                   NSMigratePersistentStoresAutomaticallyOption	: @YES,
                                                                   NSInferMappingModelAutomaticallyOption		: @YES
                                                                   }
                                                           error:&tmpError])
    {
        if (self.cleanupOnMergeError)
        {
            NSLog(@"FZCDS Merging error, cleaning up persistent store: %@, %@", tmpError, [tmpError userInfo]);
            NSError* fileError = nil;
            if (![[NSFileManager defaultManager] removeItemAtURL:tmpStoreURL error:&fileError]) {
                NSLog(@"FZCDS Merging error, Can't delete persistent store: %@", fileError);
            }
            _persistentStoreCoordinator = nil;
            return [self persistentStoreCoordinator];
        }else
        {
            NSLog(@"FZCDS Merging error: %@, %@", tmpError, [tmpError userInfo]);
            exit(0);
        }
    }
    
    return _persistentStoreCoordinator;
}

- (id) createObjectOfType:(NSString*)type
{
    NSManagedObject* object = [NSEntityDescription insertNewObjectForEntityForName:type inManagedObjectContext:self.managedObjectContext];
    object.state = RDSManagedObjectNew;
    return object;
}

- (id) createUniqueObjectOfType:(NSString*)type
{
    id object = [[self objectsOfType:type] firstObject];
    if (!object) {
        object = [self createObjectOfType:type];
    }
    return  object;
}

- (NSArray*) objectsOfType:(NSString*)type
{
    return [self objectsOfType:type forPredicate:nil];
}

- (NSArray*) objectsOfType:(NSString*)type forPredicate:(NSPredicate*) predicate
{
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [NSFetchRequest new];
    if (type) {
        [fetchRequest setEntity:[NSEntityDescription entityForName:type inManagedObjectContext:self.managedObjectContext]];
    }
    if (predicate) {
        fetchRequest.predicate = predicate;
    }
    NSArray* objects =
    [self.managedObjectContext executeFetchRequest:fetchRequest
                                             error:&error];
    if (error) {
        NSLog(@"Error fetching objects of type %@ from CoreData store",type);
        return @[];
    }
    return objects;
}

- (void) deleteObject:(id)object {
    [self.managedObjectContext deleteObject:object];
}

- (NSArray*) objectsOfType:(NSString*)type withValue:(id<NSCopying>)value forKey:(NSString*)key {
    id object = [_objectCache cachedObjectOfType:type withValue:value forKey:key];
    if (object) {
        return object;
    }
    return [self objectsOfType:type forPredicate:[NSPredicate predicateWithFormat:@"%K = %@",key,value]];
}


- (void) save
{
    NSError* error = nil;
    @try {
        for (NSManagedObject* obj in _scheduledForDeletion) {
            [self deleteObject:obj];
        }
        if(![self.managedObjectContext save:&error])
        {
            NSLog(@"Error Saving Context: %@",error.description);
        }
        [_scheduledForDeletion removeAllObjects];
    }
    @catch (NSException *exception) {
        [self wipeStorage];
    }
}

- (void) revert {
    @try {
        [self.managedObjectContext rollback];
        [_scheduledForDeletion removeAllObjects];
    }
    @catch (NSException *exception) {
        [self wipeStorage];
    }
}


- (void) wipeStorage
{
    // Destroy the persistent store
    [_managedObjectContext performBlockAndWait:^{
        [_scheduledForDeletion removeAllObjects];
        __autoreleasing NSError* error = nil;
        [_managedObjectContext reset];
        if ([_persistentStoreCoordinator removePersistentStore:_persistentStoreCoordinator.persistentStores.lastObject
                                                         error:&error])
        {
            [[NSFileManager defaultManager] removeItemAtURL:[self storeURL] error:&error];;
            [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self storeURL]	options:nil error:&error];
        }
        if (error)
            NSLog(@"Error removing item at path %@: %@", [self storeURL], error.description);
    }];
}

- (void) scheduleObjectDeletion:(id)object;
{
    [_scheduledForDeletion  addObject:object];
    [object markState:RDSManagedObjectRemoved];
}

- (NSArray*) objectsScheduledForDeletion {
    return _scheduledForDeletion.copy;
}

- (BOOL) object:(id)object hasProperty:(NSString*)property {
    if (![object isKindOfClass:[NSManagedObject class]]) {
        @throw [NSException exceptionWithName:@"Not Supported Type" reason:@"RDSCoreDataStore supports only NSManagedObject type" userInfo:nil];
    }
    NSPropertyDescription* propertyDescription = ((NSManagedObject*)object).entity.propertiesByName[property];
    return (BOOL)propertyDescription;
}


@end
