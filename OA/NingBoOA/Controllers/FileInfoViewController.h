//
//  FileInfoViewController.h
//  NingBoOA
//
//  Created by 熊熙 on 13-10-21.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "WebDataParserHelper.h"
@interface FileInfoViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSString *modId;
@property (strong, nonatomic) NSString *fileid;
@property (strong, nonatomic) NSArray  *docList;
@property (strong, nonatomic) IBOutlet UITableView *listTableView;

@property (strong, nonatomic) IBOutlet UITextView  *titleTxtView;
@property (strong, nonatomic) IBOutlet UITextField *yearTxt;
@property (strong, nonatomic) IBOutlet UITextField *bhTxt;
@property (strong, nonatomic) IBOutlet UITextField *deadlineTxt;
@property (strong, nonatomic) IBOutlet UITextField *beginDate;
@property (strong, nonatomic) IBOutlet UITextField *endDate;
@property (strong, nonatomic) IBOutlet UITextField *timeTxt;
@property (strong, nonatomic) IBOutlet UITextField *dateTxt;
@property (strong, nonatomic) IBOutlet UITextField *pagesTxt;
@property (strong, nonatomic) IBOutlet UITextField *libraryTxt;





@end
