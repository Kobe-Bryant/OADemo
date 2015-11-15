//
//  EnNameViewController.h
//  handbook
//
//  Created by chen on 11-4-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
// 英文字母查询

#import <UIKit/UIKit.h>
#import "HBSCHelper.h"

@interface EnNameViewController : UIViewController<UITableViewDelegate,UITableViewDataSource> {
	NSMutableArray *dataResultArray;
	IBOutlet UITableView *mytableview;
    sqlite3 *data_db;
    NSArray *tableColumn;
}

-(IBAction)buttonPressed:(id)sender;
@property(nonatomic,retain)NSMutableArray *dataResultArray;
@property(nonatomic,retain)UITableView *mytableview;
@end
