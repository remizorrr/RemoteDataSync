//
//  RDSArrayViewController.m
//  Tella
//
//  Created by Anton Remizov on 6/22/16.
//  Copyright © 2016 Appcoming. All rights reserved.
//

#import "RDSArrayViewController.h"
#import "RemoteDataSync.h"
#import "RDSToastNotification.h"
#import "UIColor+Hex.h"
NSString* RDSArrayViewControllerCellKey = @"RDSArrayViewControllerCellKey";

@interface RDSArrayViewController ()
{
    ACController* _arrayController;
}
@end

@implementation RDSArrayViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupInitialData];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupInitialData];
    }
    return self;
}

- (void) setupInitialData {
    _arrayController = [ACController new];
}

- (void)viewWillAppear:(BOOL)animated {
    [self reloadViewModel];
    [self fetchDataAndReloadViewModel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray * _Nonnull) content {
    if (self.configurations.count > 1) {
        return @[];
    }
    RDSObjectControllerConfiguration* configuration = self.configurations.firstObject;
    id data = configuration.object;
    if(configuration.keyPath) {
        data = [configuration.object valueForKeyPath:configuration.keyPath];
    }
    if ([data isKindOfClass:[NSSet class]]) {
        return [(NSSet*)data allObjects];
    } else if ([data isKindOfClass:[NSOrderedSet class]]) {
        return [(NSOrderedSet*)data array];
    } else if ([data isKindOfClass:[NSArray class]]) {
        return data;
    }
    return @[];
}

- (void)setTableView:(UITableView *)tableView {
    _tableView = tableView;
    _arrayController.collection = _tableView;
    _tableView.dataSource = _arrayController;
    _tableView.delegate = _arrayController;
}

- (NSArray*) viewModel {
    NSArray* content = [self content];
    NSMutableArray* viewModel = [NSMutableArray arrayWithCapacity:content.count];
    for (id object in content) {
            [viewModel addObject:[NSDictionary itemWithCell:RDSArrayViewControllerCellKey
                                                     height:100.0]];
    }
    return viewModel.copy;
}

- (void)reloadViewModel {
    _arrayController.viewModel = [self viewModel];
}

- (void)fetchDataAndReloadViewModel {
    __weak typeof(self.view) weakView = self.view;
    __weak typeof(self) weakSelf = self;
    for (RDSObjectControllerConfiguration* configuration in self.configurations) {
        [configuration.object fetch:configuration.keyPath
               withSuccess:^(id  _Nonnull responseObject, NSInteger newObjects) {
                   [weakSelf reloadViewModel];
               } failure:^(NSError * _Nullable error) {
                   [RDSToastNotification showToastInViewController:weakSelf
                                                           message:@"Refreshing data failed."
                                                   backgroundColor:UIColorFromHex(0xF0B67F)
                                                          duration:3.0
                                                          tapBlock:^{
                                                              
                                                          }];
               }];
    }
}

- (void)setStaticCellHeight:(BOOL)staticCellHeight {
    _arrayController.staticCellHeight = staticCellHeight;
}

- (BOOL)staticCellHeight {
    return _arrayController.staticCellHeight;
}
@end
