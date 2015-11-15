//
//  SQSearchViewController.h
//  NingBoOA
//
//  Created by PowerData on 14-3-10.
//  Copyright (c) 2014年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "HandleGWProtocol.h"

@interface SQSearchViewController : BaseViewController<HandleGWDelegate>
@property (strong, nonatomic) IBOutlet UITextField *sqrTextField;
@property (strong, nonatomic) IBOutlet UITextField *sqbmTextField;
@property (strong, nonatomic) IBOutlet UITextField *sqrqTextField;
@property (strong, nonatomic) IBOutlet UITextField *jzrqTextField;
@property (strong, nonatomic) IBOutlet UITextField *ytTextField;
@property (strong, nonatomic) IBOutlet UILabel *ytLabel;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
