//
//  RDSKeypathRequestConfiguration.h
//  PocketStoic
//
//  Created by Anton Remizov on 5/15/17.
//  Copyright © 2017 PocketStoic. All rights reserved.
//

#import "RDSRequestConfiguration.h"

@interface RDSKeypathRequestConfiguration : RDSRequestConfiguration

@property (nonatomic, strong) RDSMapping* mapping;
@property (nonatomic, strong) RDSMapping* posting;
@property (nonatomic, strong) NSDictionary* parameters;
@property (nonatomic, copy)   NSDictionary* (^parametersBlock)(id object);
@property (nonatomic, copy)   NSString* (^pathBlock)(id object);
@property (nonatomic, copy)   NSString* path;
@property (nonatomic, copy)   NSString* baseKeyPath;

@end
