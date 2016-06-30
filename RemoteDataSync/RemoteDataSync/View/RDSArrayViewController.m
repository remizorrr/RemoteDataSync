//
//  RDSArrayViewController.m
//  Tella
//
//  Created by Anton Remizov on 6/22/16.
//  Copyright © 2016 PocketStoic. All rights reserved.
//

#import "RDSArrayViewController.h"
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
        _arrayController = [ACController new];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self reloadViewModel];
    [self fetchDataAndReload];
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
    id data = self.object;
    if(self.keyPath) {
        data = [self.object valueForKeyPath:self.keyPath];
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

- (NSArray*) viewModelWithContent:(NSArray*) content {
    NSMutableArray* viewModel = [NSMutableArray arrayWithCapacity:content.count];
    for (id object in content) {
            [viewModel addObject:[NSDictionary itemWithCell:RDSArrayViewControllerCellKey
                                                     height:100.0]];
    }
    return viewModel.copy;
}

- (void)reloadViewModel {
    _arrayController.viewModel = [self viewModelWithContent:[self content]];
}

- (void)fetchDataAndReload {
    __weak typeof(self.view) weakView = self.view;
    __weak typeof(self) weakSelf = self;
    [self.object fetch:self.keyPath
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

@end
