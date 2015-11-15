//
//  RealTimeViewController.h
//  NingBoOA
//
//  Created by PowerData on 14-3-12.
//  Copyright (c) 2014年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface RealTimeViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UIView *BgView;
@property (strong, nonatomic) IBOutlet UITableView *YZTableView;
@property (strong, nonatomic) IBOutlet UITextField *PKMCTextField;
@property (nonatomic,strong) NSArray *siteArray;
@property (nonatomic,copy) NSString *qyid;
@property (nonatomic,copy) NSString *wrymc;
@end
