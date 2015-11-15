//
//  WryCategoryViewController.h
//  NingBoOA
//
//  Created by zengjing on 13-10-19.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "BaseViewController.h"

@interface WryCategoryViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) NSArray *listDataArray;
@property (nonatomic, strong) NSString *wrybh;
@property (nonatomic, strong) NSString *wrymc;

@end
