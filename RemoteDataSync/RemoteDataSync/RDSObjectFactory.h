//
//  ObjectFactory.h
//  Synchora
//
//  Created by Anton Remizov on 3/26/15.
//  Copyright (c) 2015 synchora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RDSMapping.h"

@interface RDSObjectFactory : NSObject

+ (RDSObjectFactory*) sharedFactory;
- (void) fillObject:(id)object fromData:(id)data withMapping:(RDSMapping*) mapping;

@end
