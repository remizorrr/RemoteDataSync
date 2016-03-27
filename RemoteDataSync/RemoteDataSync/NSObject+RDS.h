//
//  NSObject+RDS.h
//  Vacarious
//
//  Created by Anton Remizov on 3/23/16.
//  Copyright © 2016 Appcoming. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, RDSManagedObjectState) {
    RDSManagedObjectUnkown,
    RDSManagedObjectSynced,
    RDSManagedObjectChanged,
    RDSManagedObjectNew,
    RDSManagedObjectRemoved
};

@interface NSObject (RDS)

@property (nonatomic, assign) RDSManagedObjectState state;

- (void) markState:(RDSManagedObjectState)state;

@end
