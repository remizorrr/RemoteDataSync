//
//  RDSMappingProvider.h
//  PhotoKeeper
//
//  Created by Anton Remizov on 12/3/15.
//  Copyright © 2015 PhotoKeeper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RDSMapping.h"

@protocol RDSMappingProvider <NSObject>

- (void) addMapping:(RDSMapping*)mapping forType:(Class)type;
- (RDSMapping*) mappingForType:(Class)type;
- (NSDictionary*) mappingsByType;

@end
