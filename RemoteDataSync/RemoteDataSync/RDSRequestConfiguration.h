//
//  RDSRequestConfiguration.h
//  PhotoKeeper
//
//  Created by Anton Remizov on 12/2/15.
//  Copyright © 2015 PhotoKeeper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RDSMapping.h"

extern NSString * const RDSRequestSchemeFetch;
extern NSString * const RDSRequestSchemeCreate;
extern NSString * const RDSRequestSchemeUpdate;
extern NSString * const RDSRequestSchemeRemove;

@interface RDSRequestConfiguration : NSObject

@property (nonatomic, strong) NSString* method;
@property (nonatomic, strong) RDSMapping* mapping;
@property (nonatomic, strong) NSDictionary* parameters;
@property (nonatomic, copy)   NSDictionary* (^parametersBlock)(id object);
@property (nonatomic, copy)   NSString* (^pathBlock)(id object);
@property (nonatomic, copy)   NSString* path;
@property (nonatomic, copy)   NSString* baseKeyPath;
@property (nonatomic, assign) BOOL replace;

@end
