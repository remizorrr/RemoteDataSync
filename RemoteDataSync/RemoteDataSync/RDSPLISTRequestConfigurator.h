//
//  RDSPLISTRequestConfigurator.h
//  PhotoKeeper
//
//  Created by Anton Remizov on 12/2/15.
//  Copyright © 2015 PhotoKeeper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RDSRequestConfigurator.h"

@interface RDSPLISTRequestConfigurator : NSObject <RDSRequestConfigurator>

@property (nonatomic, strong) NSString* plistFilePath;

@end
