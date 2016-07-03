//
//  RDSArrayViewController.h
//  Tella
//
//  Created by Anton Remizov on 6/22/16.
//  Copyright © 2016 Appcoming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACController.h"
#import "RDSObjectViewController.h"

extern NSString* RDSArrayViewControllerCellKey;

@interface RDSArrayViewController : RDSObjectViewController <UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView* tableView;
@property (nonatomic, assign) BOOL staticCellHeight;

/**
 * The Default view model is a cell with a key RDSArrayViewControllerCellKey for each data item.
 * please override this method to return custom view model.
 */
- (NSArray*) viewModel;
- (void)fetchDataAndReloadViewModel;
- (void)reloadViewModel;

@end
