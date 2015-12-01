//
//  ObjectFactoryMapping.h
//  Synchora
//
//  Created by Anton Remizov on 3/26/15.
//  Copyright (c) 2015 synchora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RDSMappingItem.h"

@interface RDSMapping : NSObject

@property (nonatomic, strong) NSString* baseKeyPath;
@property (nonatomic, strong) NSDictionary* mappingItems;

+ (RDSMapping*) mappingWithDictionary:(NSDictionary*)dictionary;

@end
