//
//  WrySearchViewController.h
//  NingBoOA
//
//  Created by PowerData on 13-10-16.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "PopupDateViewController.h"
#import "CommenWordsViewController.h"

@interface WrySearchViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, PopupDateDelegate, UITextFieldDelegate,WordsDelegate>

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UITextField *addressField;
@property (strong, nonatomic) IBOutlet UILabel *startDateLabel;
@property (strong, nonatomic) IBOutlet UITextField *startDateField;
@property (strong, nonatomic) IBOutlet UILabel *endDateLabel;
@property (strong, nonatomic) IBOutlet UITextField *endDateField;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UITextField *jgjbTextField;
@property (strong, nonatomic) IBOutlet UITableView *listTableView;

@end
