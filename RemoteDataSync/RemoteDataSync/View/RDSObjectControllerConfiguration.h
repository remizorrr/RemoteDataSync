//
//  RDSObjectControllerConfiguration.h
//  Tella
//
//  Created by Anton Remizov on 7/17/16.
//  Copyright © 2016 Appcoming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface RDSObjectControllerConfiguration : NSObject
@property (nonatomic, strong) NSManagedObject* _Nonnull object;
@property (nonatomic, strong) NSString* _Nonnull keyPath;
@end
