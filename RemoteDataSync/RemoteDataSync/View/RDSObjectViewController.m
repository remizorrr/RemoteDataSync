//
//  RDSArrayViewController.m
//  Tella
//
//  Created by Anton Remizov on 6/22/16.
//  Copyright © 2016 PocketStoic. All rights reserved.
//

#import "RDSObjectViewController.h"

@interface RDSObjectViewController ()
{
    
}
@end

@implementation RDSObjectViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.rdsManager = [RDSManager defaultManager];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) configureWithObject:(_Nonnull id)object keyPath:( NSString* _Nullable )keypath {
    _object = object;
    _keyPath = keypath;
}

@end
