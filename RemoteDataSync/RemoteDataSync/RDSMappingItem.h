//
//  RDSMapping.h
//  Synchora
//
//  Created by Anton Remizov on 4/20/15.
//  Copyright (c) 2015 synchora. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDSMappingItem : NSObject

@property (nonatomic, strong) NSString* fromKeyPath;
@property (nonatomic, strong) NSString* toKeyPath;
@property (nonatomic, assign) BOOL ignoreType;
@property (nonatomic, assign) BOOL ignore;

@end
