//
//  RDSRequestConfigurator.h
//  PhotoKeeper
//
//  Created by Anton Remizov on 12/2/15.
//  Copyright © 2015 PhotoKeeper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RDSRequestConfiguration.h"

@protocol RDSRequestConfigurator <NSObject>

- (RDSRequestConfiguration*) configurationForObject:(id)object keyPath:(NSString*)keyPath scheme:(NSString*)scheme;
- (void) addConfiguration:(RDSRequestConfiguration*)configuration forType:(Class)type keyPath:(NSString*)keyPath sheme:(NSString*)scheme;

@end
