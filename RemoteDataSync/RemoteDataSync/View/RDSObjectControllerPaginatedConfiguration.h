//
//  RDSObjectControllerPaginatedConfiguration.h
//  Vacarious
//
//  Created by Anton Remizov on 8/5/16.
//  Copyright © 2016 Appcoming. All rights reserved.
//

#import "RDSObjectControllerConfiguration.h"

@interface RDSObjectControllerPaginatedConfiguration : RDSObjectControllerConfiguration

@property (nonatomic, copy) NSDictionary*(^nextPageParametersBlock)();

@end
