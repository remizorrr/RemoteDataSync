//
//  RDSArrayViewController.h
//  Tella
//
//  Created by Anton Remizov on 6/22/16.
//  Copyright © 2016 Appcoming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RDSManager;
@class NSManagedObject;
@class RDSObjectControllerConfiguration;

@interface RDSObjectViewController : UIViewController

@property (nonatomic, strong) RDSManager* _Nonnull rdsManager;
@property (nonatomic, strong, readonly) NSArray<RDSObjectControllerConfiguration*>* _Nonnull configurations;

- (void) addConfigurationWithObject:(NSManagedObject* _Nonnull )object keyPath:( NSString* _Nullable )keypath;

@end
