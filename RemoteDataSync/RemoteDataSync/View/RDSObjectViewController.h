//
//  RDSArrayViewController.h
//  Tella
//
//  Created by Anton Remizov on 6/22/16.
//  Copyright © 2016 PocketStoic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemoteDataSync.h"

@interface RDSObjectViewController : UIViewController

@property (nonatomic, strong) RDSManager* _Nonnull rdsManager;

@property (nonatomic, readonly) NSManagedObject* _Nonnull object;
@property (nonatomic, readonly) NSString* _Nullable keyPath;

- (void) configureWithObject:(NSManagedObject* _Nonnull )object keyPath:( NSString* _Nullable )keypath;

@end
