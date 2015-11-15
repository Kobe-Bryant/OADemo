//
//  NoticeListViewController.h
//  NingBoOA
//
//  Created by PowerData on 13-10-16.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "WebDataParserHelper.h"
@interface NoticeListViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate,WebDataParserDelegate>

@property (strong, nonatomic) NSArray  *infoArray;
@property (nonatomic,assign)  NSInteger start;
@property (nonatomic,strong)  NSString *searchKey;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextField *titleField;
@property (strong, nonatomic) IBOutlet UILabel *startDateLabel;
@property (strong, nonatomic) IBOutlet UITextField *startDateField;
@property (strong, nonatomic) IBOutlet UILabel *endDateLabel;
@property (strong, nonatomic) IBOutlet UITextField *endDateField;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UITableView *listTableView;
@property (assign, nonatomic) BOOL isLoading;
@property (assign, nonatomic) BOOL isRefresh;

@end
