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

- (RDSRequestConfiguration*) configurationForObject:(id)object key:(NSString*)key {
    NSDictionary* configurationsForObject = configurationsByType[NSStringFromClass([object class])];
    return configurationsForObject[key];
}

- (void) loadPLIST {
    NSMutableDictionary* mutableConfigurations = [NSMutableDictionary dictionary];
    NSDictionary* plistDictionary = [NSDictionary dictionaryWithContentsOfFile:self.plistFilePath];
    for (NSString* type in plistDictionary) {
        
    }
    configurationsByType = mutableConfigurations.copy;
}

@end
