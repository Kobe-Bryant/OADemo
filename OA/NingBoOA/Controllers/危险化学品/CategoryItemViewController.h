//
//  CategoryItemViewController.h
//  handbook
//
//  Created by chen on 11-4-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBSCHelper.h"

@interface CategoryItemViewController : UITableViewController<UISearchBarDelegate>
{
    IBOutlet UITableView *myTableView;
    NSMutableArray *dataNameArray;
    UISearchBar *_searchBar;
    BOOL isSelect;
    sqlite3 *data_db;
    NSArray *tableColumn;
}

@property (nonatomic, strong) NSMutableArray *dataResultArray;
@property (nonatomic, assign) int kindcode;

@end
