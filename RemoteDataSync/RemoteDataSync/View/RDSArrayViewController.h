//
//  RDSArrayViewController.h
//  Tella
//
//  Created by Anton Remizov on 6/22/16.
//  Copyright © 2016 Appcoming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACController.h"
#import "ACCollectionController.h"
#import "RDSObjectViewController.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString* RDSArrayViewControllerCellKey;

@interface RDSArrayViewController : RDSObjectViewController

@property (nonatomic, strong) IBOutlet UICollectionView* collectionView;
@property (nonatomic, strong) IBOutlet UITableView* tableView;
@property (nonatomic, assign) BOOL staticCellHeight;
@property (nonatomic, copy) void(^didScrollBlock)(UIScrollView* scrollView) ;
@property (nonatomic, readonly) ACCollectionController* collectionArrayController;
;

/**
 * The Default view model is a cell with a key RDSArrayViewControllerCellKey for each data item.
 * please override this method to return custom view model.
 */
- (NSArray*) viewModel;
- (void)fetchDataAndReloadViewModel;
- (void)reloadViewModel;

/**
 * if a paginatedConfiguration is added, on reaching the end of a tableview 
 * the paginated configuration request will be triggered and on completion,
 * the view model will be requested.
 */
- (void) addPaginatedConfigurationWithObject:(NSManagedObject* _Nonnull )object keyPath:( NSString* _Nullable )keypath;

@end

NS_ASSUME_NONNULL_END
