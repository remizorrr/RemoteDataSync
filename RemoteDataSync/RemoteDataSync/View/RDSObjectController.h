//
//  RDSObjectController.h
//  Vacarious
//
//  Created by Anton Remizov on 8/5/16.
//  Copyright © 2016 Appcoming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RDSManager;
@class NSManagedObject;
@class RDSObjectControllerConfiguration;

@interface RDSObjectController : NSObject

@property (nonatomic, strong) RDSManager* _Nonnull rdsManager;
@property (nonatomic, strong, readonly) NSArray<RDSObjectControllerConfiguration*>* _Nonnull configurations;
@property (nonatomic, strong) UIViewController * _Nullable containigViewController;

- (instancetype _Nullable)initWithContainingViewController:(UIViewController * _Nullable)viewController;

- (void) addConfigurationWithObject:(NSManagedObject* _Nonnull )object keyPath:( NSString* _Nullable )keypath;

/**
 * Removes configuration.
 */
- (void) removeConfigurationWithObject:(NSManagedObject* _Nonnull )object keyPath:( NSString* _Nullable )keypath;

/**
 * Removes all configurations.
 */
- (void) removeAllConfigurations;


@end
