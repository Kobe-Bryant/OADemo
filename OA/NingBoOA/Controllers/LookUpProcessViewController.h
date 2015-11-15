//
//  LookUpProcessViewController.h
//  NingBoOA
//
//  Created by 熊熙 on 13-10-25.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface LookUpProcessViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSString *modid;
@property (strong, nonatomic) NSString *docid;

@property (strong, nonatomic) NSArray *historyProcessAry;
@property (strong, nonatomic) IBOutlet UITableView *historyTableView;
@end
