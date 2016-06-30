//
//  RDSArrayViewController.h
//  Tella
//
//  Created by Anton Remizov on 6/22/16.
//  Copyright © 2016 PocketStoic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDSObjectViewController.h"
#import "ACController.h"

extern NSString* RDSArrayViewControllerCellKey;

@interface RDSArrayViewController : RDSObjectViewController <UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView* tableView;

@end
