//
//  RDSObjectController.m
//  Vacarious
//
//  Created by Anton Remizov on 8/5/16.
//  Copyright © 2016 Appcoming. All rights reserved.
//

#import "RDSObjectController.h"
#import "RemoteDataSync.h"

@interface RDSObjectController ()
{
    NSMutableArray<RDSObjectControllerConfiguration*>* _configurations;
}
@end

@implementation RDSObjectController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithContainingViewController:(UIViewController *)viewController
{
    self = [self init];
    if (self) {
        self.containigViewController = viewController;
    }
    return self;
}

- (void) setup {
    self.rdsManager = [RDSManager defaultManager];
    _configurations = [NSMutableArray array];
}

- (void) addConfigurationWithObject:(NSManagedObject* _Nonnull )object keyPath:( NSString* _Nullable )keypath {
    RDSObjectControllerConfiguration* configuration = [RDSObjectControllerConfiguration new];
    configuration.object = object;
    configuration.keyPath = keypath;
    [_configurations addObject:configuration];
}

- (void) removePaginatedConfigurationWithObject:(NSManagedObject* _Nonnull )object keyPath:( NSString* _Nullable )keypath {
    [_configurations enumerateObjectsUsingBlock:^(RDSObjectControllerConfiguration * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.object == object && [obj.keyPath isEqualToString:keypath]) {
            [_configurations removeObject:obj];
            *stop = YES;
        }
    }];
}

- (void) removeAllPaginatedConfigurations {
    [_configurations removeAllObjects];
}
@end
