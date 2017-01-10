//
//  RDSPLISTRequestConfigurator.m
//  PhotoKeeper
//
//  Created by Anton Remizov on 12/2/15.
//  Copyright © 2015 PhotoKeeper. All rights reserved.
//

#import "RDSPLISTRequestConfigurator.h"

@interface RDSPLISTRequestConfigurator ()
{
    NSDictionary* configurationsByType;
}
@end

@implementation RDSPLISTRequestConfigurator

- (RDSRequestConfiguration*) configurationForObject:(id)object keyPath:(NSString*)keyPath scheme:(NSString*)scheme {
    NSDictionary* configurationsForObject = configurationsByType[NSStringFromClass([object class])];
    return configurationsForObject[keyPath];
}

- (void) loadPLIST {
    NSMutableDictionary* mutableConfigurations = [NSMutableDictionary dictionary];
    configurationsByType = mutableConfigurations.copy;
}

- (void) addConfiguration:(RDSRequestConfiguration*)configuration forType:(Class)type keyPath:(NSString*)keyPath sheme:(NSString*)scheme {
}

@end
