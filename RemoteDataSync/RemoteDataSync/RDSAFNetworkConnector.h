//
//  RDSAFNetworkConnector.h
//  PhotoKeeper
//
//  Created by Anton Remizov on 12/2/15.
//  Copyright © 2015 PhotoKeeper. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "RDSNetworkConnector.h"

@interface RDSAFNetworkConnector : AFHTTPRequestOperationManager <RDSNetworkConnector>

@end
