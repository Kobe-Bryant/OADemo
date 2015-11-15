//
//  SiteInfoViewController.h
//  NingBoOA
//
//  Created by PowerData on 14-3-12.
//  Copyright (c) 2014年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SiteInfoViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *siteArray;
@property (nonatomic,copy) NSString *qyid;
@end
