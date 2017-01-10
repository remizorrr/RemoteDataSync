//
//  RDSArrayController.m
//  Vacarious
//
//  Created by Anton Remizov on 8/5/16.
//  Copyright © 2016 Appcoming. All rights reserved.
//

#import "RDSArrayController.h"
#import "RemoteDataSync.h"
#import "RDSToastNotification.h"
#import "UIColor+Hex.h"
#import "RDSObjectControllerPaginatedConfiguration.h"

NSString* RDSArrayControllerCellKey = @"RDSArrayControllerCellKey";

@interface RDSArrayController ()
{
    ACController* _arrayController;
    ACCollectionController* _collectionArrayController;
    NSMutableArray<RDSObjectControllerPaginatedConfiguration*>* _paginatedConfigurations;
    BOOL fetching;
}
@end

@implementation RDSArrayController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupInitialData];
    }
    return self;
}

- (void) setupInitialData {
    self.noFetchNeeded = NO;
    fetching = NO;
    _arrayController = [ACController new];
    _collectionArrayController = [ACCollectionController new];
    _paginatedConfigurations = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    _arrayController.didScrollBlock = ^(UIScrollView* scrollView) {
        if (scrollView.contentOffset.y > scrollView.contentSize.height - 2.0 * scrollView.frame.size.height) {
            [weakSelf fetchNewPage];
        }
    };
    _collectionArrayController.didScrollBlock = ^(UIScrollView* scrollView) {
        if (weakSelf.horizontalScrolling) {
            if (scrollView.contentOffset.x > scrollView.contentSize.width - 2.0 * scrollView.frame.size.width) {
                [weakSelf fetchNewPage];
            }
        } else {
            if (scrollView.contentOffset.y > scrollView.contentSize.height - 2.0 * scrollView.frame.size.height) {
                [weakSelf fetchNewPage];
            }
        }
    };
}

#pragma mark - Public Methods

- (void) addPaginatedConfigurationWithObject:(NSManagedObject* _Nonnull )object keyPath:( NSString* _Nullable )keypath nextPageParametersBlock:(NSDictionary*(^_Nonnull)())nextPageParametersBlock {
    RDSObjectControllerPaginatedConfiguration* configuration = [RDSObjectControllerPaginatedConfiguration new];
    configuration.object = object;
    configuration.keyPath = keypath;
    configuration.nextPageParametersBlock = nextPageParametersBlock;
    [_paginatedConfigurations addObject:configuration];
}

- (void) removePaginatedConfigurationWithObject:(NSManagedObject* _Nonnull )object keyPath:( NSString* _Nullable )keypath {
    [_paginatedConfigurations enumerateObjectsUsingBlock:^(RDSObjectControllerPaginatedConfiguration * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.object == object && [obj.keyPath isEqualToString:keypath]) {
            [_paginatedConfigurations removeObject:obj];
            *stop = YES;
        }
    }];
}

- (void) removeAllPaginatedConfigurations {
    [_paginatedConfigurations removeAllObjects];
}

#pragma mark -

- (NSArray*) viewModel {
    NSArray* content = [self content];
    NSMutableArray* viewModel = [NSMutableArray arrayWithCapacity:content.count];
    for (__unused id object in content) {
        [viewModel addObject:[NSDictionary itemWithCell:RDSArrayControllerCellKey
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
                                               [[RDSManager defaultManager].dataStore save];
                                               [weakSelf reloadViewModel];
                                           } failure:^(NSError * _Nullable error) {
                                               if (self.containigViewController) {
                                                   [RDSToastNotification showToastInViewController:weakSelf.containigViewController
                                                                                           message:@"Refreshing data failed."
                                                                                   backgroundColor:UIColorFromHex(0xF0B67F)
                                                                                          duration:3.0
                                                                                          tapBlock:^{
                                                                                              
                                                                                          }];
                                               }
                                           }];
    }
    for (RDSObjectControllerPaginatedConfiguration* configuration in _paginatedConfigurations) {
        [configuration.object remoteCallWithScheme:RDSRequestSchemeFetch
                                            forKey:configuration.keyPath
                                    withParameters:nil
                                   byReplacingData:YES
                                           success:^(id  _Nonnull responseObject, NSInteger newObjects) {
                                               [[RDSManager defaultManager].dataStore save];
                                               [weakSelf reloadViewModel];
                                           } failure:^(NSError * _Nullable error) {
                                               if (self.containigViewController) {
                                                   [RDSToastNotification showToastInViewController:weakSelf.containigViewController
                                                                                           message:@"Refreshing data failed."
                                                                                   backgroundColor:UIColorFromHex(0xF0B67F)
                                                                                          duration:3.0
                                                                                          tapBlock:^{
                                                                                              
                                                                                          }];
                                               }
                                           }];
    }
}

- (void) fetchNewPage {
    if (self.noFetchNeeded) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    if (fetching) {
        return;
    }
    if (!_paginatedConfigurations.count) {
        return;
    }
    fetching = YES;
    __block NSInteger fetchCount = 0;
    for (RDSObjectControllerPaginatedConfiguration* configuration in _paginatedConfigurations) {
        ++fetchCount;
        NSInteger originalCount = [[configuration.object valueForKeyPath:configuration.keyPath] count];
        [configuration.object remoteCallWithScheme:RDSRequestSchemeFetch
                                            forKey:configuration.keyPath
                                    withParameters:configuration.nextPageParametersBlock()
                                   byReplacingData:NO
                                           success:^(id  _Nonnull responseObject, NSInteger newObjects) {
                                               [[RDSManager defaultManager].dataStore save];
                                               NSInteger newCount = [[configuration.object valueForKeyPath:configuration.keyPath] count];
                                               if (newCount != originalCount) {
                                                   [weakSelf reloadViewModel];
                                               } else {
                                                   self.noFetchNeeded = YES;
                                               }
                                               --fetchCount;
                                               if (fetchCount == 0) {
                                                   fetching = NO;
                                               }
                                           } failure:^(NSError * _Nullable error) {
                                               if (self.containigViewController) {
                                                   [RDSToastNotification showToastInViewController:weakSelf.containigViewController
                                                                                           message:@"Fetching new page failed."
                                                                                   backgroundColor:UIColorFromHex(0xF0B67F)
                                                                                          duration:3.0
                                                                                          tapBlock:^{
                                                                                              
                                                                                          }];
                                               }
                                               --fetchCount;
                                               if (fetchCount == 0) {
                                                   fetching = NO;
                                               }
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
