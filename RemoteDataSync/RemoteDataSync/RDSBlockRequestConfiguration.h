//
//  RDSBlockRequestConfiguration.h
//  PocketStoic
//
//  Created by Anton Remizov on 5/15/17.
//  Copyright © 2017 PocketStoic. All rights reserved.
//

#import "RDSRequestConfiguration.h"

@interface RDSBlockRequestConfiguration : RDSRequestConfiguration

@property (nonatomic, copy) void(^block)(id object, NSString* keyName, NSDictionary* parameters, void(^success)(id __nonnull responseObject, NSInteger newObjects), void(^failure)(NSError* __nullable error) );

@end
