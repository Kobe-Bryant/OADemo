//
//  SearchViewController.h
//  handbook
//
//  Created by chen on 11-4-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//查询的结果

#import <UIKit/UIKit.h>
#import "HBSCHelper.h"

@interface SearchViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
	IBOutlet UITableView *resultTableView;
	NSMutableArray *dataResultArray;
    sqlite3 *data_db;
    NSArray *tableColumn;
}

@property (nonatomic, strong) UITableView *resultTableView;
@property (nonatomic, strong) NSMutableArray *dataResultArray;

@end
