//
//  RDSArrayViewController.m
//  Tella
//
//  Created by Anton Remizov on 6/22/16.
//  Copyright © 2016 Appcoming. All rights reserved.
//

#import "RDSObjectViewController.h"
#import "RemoteDataSync.h"

@interface RDSObjectViewController ()
{
    NSMutableArray<RDSObjectControllerConfiguration*>* _configurations;
}
@end

@implementation RDSObjectViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) setup {
    self.rdsManager = [RDSManager defaultManager];
    _configurations = [NSMutableArray array];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) addConfigurationWithObject:(NSManagedObject* _Nonnull )object keyPath:( NSString* _Nullable )keypath {
    RDSObjectControllerConfiguration* configuration = [RDSObjectControllerConfiguration new];
    configuration.object = object;
    configuration.keyPath = keypath;
    [_configurations addObject:configuration];
}

@end
