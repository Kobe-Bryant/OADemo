//
//  YDZFSearchViewController.h
//  NingBoOA
//
//  Created by PowerData on 13-10-18.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "PopupDateViewController.h"
#import "WebServiceHelper.h"
#import "WebDataParserHelper.h"

@interface YDZFSearchViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate,WebDataParserDelegate, PopupDateDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel *qyxxLabel;
@property (strong, nonatomic) IBOutlet UITextField *qyxxField;
@property (strong, nonatomic) IBOutlet UILabel *kssjLabel;
@property (strong, nonatomic) IBOutlet UITextField *kssjField;
@property (strong, nonatomic) IBOutlet UILabel *jssjLabel;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UITextField *jssjField;
@property (strong, nonatomic) IBOutlet UITableView *listTableView;

- (IBAction)touchForDate:(id)sender;

- (IBAction)searchButtonClick:(id)sender;

@end
