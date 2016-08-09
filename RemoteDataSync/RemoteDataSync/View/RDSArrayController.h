//
//  RDSArrayController.h
//  Vacarious
//
//  Created by Anton Remizov on 8/5/16.
//  Copyright © 2016 Appcoming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDSObjectController.h"

@interface RDSArrayController : RDSObjectController

@property (nonatomic, strong) IBOutlet  UICollectionView* _Nullable  collectionView;
@property (nonatomic, strong) IBOutlet UITableView* _Nullable tableView;
@property (nonatomic, assign) BOOL staticCellHeight;
@property (nonatomic, assign) BOOL horizontalScrolling;
@property (nonatomic, assign) BOOL noFetchNeeded;

/**
 * The Default view model is a cell with a key RDSArrayViewControllerCellKey for each data item.
 * please override this method to return custom view model.
 */
- (NSArray* _Nonnull) viewModel;
- (void)fetchDataAndReloadViewModel;
- (void)reloadViewModel;

/**
 * if a paginatedConfiguration is added, on reaching the end of a tableview
 * the paginated configuration request will be triggered and on completion,
 * the view model will be requested.
 */
- (void) addPaginatedConfigurationWithObject:(NSManagedObject* _Nonnull )object keyPath:( NSString* _Nullable )keypath nextPageParametersBlock:(NSDictionary*_Nonnull(^_Nonnull)())nextPageParametersBlock;

/**
 * Removes paginatedConfiguration.
 */
- (void) removePaginatedConfigurationWithObject:(NSManagedObject* _Nonnull )object keyPath:( NSString* _Nullable )keypath;

/**
 * Removes all paginatedConfiguration.
 */
- (void) removeAllPaginatedConfigurations;


@end
