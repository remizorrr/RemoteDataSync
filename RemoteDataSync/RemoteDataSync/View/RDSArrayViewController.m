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
    ACCollectionController* _collectionArrayController;
    NSMutableArray<RDSObjectControllerConfiguration*>* _paginatedConfigurations;
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
    _collectionArrayController = [ACCollectionController new];
    _paginatedConfigurations = [NSMutableArray array];
    _arrayController.didScrollBlock = ^(UIScrollView* scrollView) {
        if (scrollView.contentOffset.y > scrollView.contentSize.height - 2.0 * scrollView.frame.size.height) {
            [self fetchNewPage];
        }
    };
    _collectionArrayController.didScrollBlock = ^(UIScrollView* scrollView) {
        if (scrollView.contentOffset.y > scrollView.contentSize.height - 2.0 * scrollView.frame.size.height) {
            [self fetchNewPage];
        }
    };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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

#pragma mark - Public Methods

- (void) addPaginatedConfigurationWithObject:(NSManagedObject* _Nonnull )object keyPath:( NSString* _Nullable )keypath {
    RDSObjectControllerConfiguration* configuration = [RDSObjectControllerConfiguration new];
    configuration.object = object;
    configuration.keyPath = keypath;
    [_paginatedConfigurations addObject:configuration];
}

- (NSArray*) viewModel {
    NSArray* content = [self content];
    NSMutableArray* viewModel = [NSMutableArray arrayWithCapacity:content.count];
    for (__unused id object in content) {
        [viewModel addObject:[NSDictionary itemWithCell:RDSArrayViewControllerCellKey
                                                 size:CGSizeMake(0, 100.0)]];
    }
    return viewModel.copy;
}

- (void)reloadViewModel {
    if (self.tableView) {
        _arrayController.viewModel = [self viewModel];
    } else if (self.collectionView) {
        _collectionArrayController.viewModel = [self viewModel];
    }
}

- (void)fetchDataAndReloadViewModel {
    __weak typeof(self) weakSelf = self;
    for (RDSObjectControllerConfiguration* configuration in self.configurations) {
        [configuration.object remoteCallWithScheme:RDSRequestSchemeFetch
                                            forKey:configuration.keyPath
                                    withParameters:nil
                                   byReplacingData:YES
                                           success:^(id  _Nonnull responseObject, NSInteger newObjects) {
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
    for (RDSObjectControllerConfiguration* configuration in _paginatedConfigurations) {
        [configuration.object remoteCallWithScheme:RDSRequestSchemeFetch
                                            forKey:configuration.keyPath
                                    withParameters:nil
                                   byReplacingData:YES
                                           success:^(id  _Nonnull responseObject, NSInteger newObjects) {
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

- (void) fetchNewPage {
    __weak typeof(self) weakSelf = self;
    for (RDSObjectControllerConfiguration* configuration in _paginatedConfigurations) {
        [configuration.object remoteCallWithScheme:RDSRequestSchemeFetch
                                            forKey:configuration.keyPath
                                    withParameters:nil
                                   byReplacingData:NO
                                           success:^(id  _Nonnull responseObject, NSInteger newObjects) {
                                               [weakSelf reloadViewModel];
                                           } failure:^(NSError * _Nullable error) {
                                               [RDSToastNotification showToastInViewController:weakSelf
                                                                                       message:@"Fetching new page failed."
                                                                               backgroundColor:UIColorFromHex(0xF0B67F)
                                                                                      duration:3.0
                                                                                      tapBlock:^{
                                                                                          
                                                                                      }];
                                           }];
    }
}

#pragma mark -

- (NSArray<RDSObjectControllerConfiguration*>*) allConfigurations {
    return [self.configurations arrayByAddingObjectsFromArray:_paginatedConfigurations];
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

- (void)setCollectionView:(UICollectionView *)collectionView {
    _collectionView = collectionView;
    _collectionArrayController.collection = _collectionView;
    _collectionView.dataSource = _collectionArrayController;
    _collectionView.delegate = _collectionArrayController;
}

- (void)setStaticCellHeight:(BOOL)staticCellHeight {
    _arrayController.staticCellHeight = staticCellHeight;
}

- (BOOL)staticCellHeight {
    return _arrayController.staticCellHeight;
}

@end
