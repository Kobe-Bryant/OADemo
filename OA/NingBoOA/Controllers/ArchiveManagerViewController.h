//
//  ToDoFileViewController.h
//  NingBoOA
//
//  Created by ZHONGWEN on 13-9-15.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "WebDataParserHelper.h"
#import "FileManagerListController.h"
#import "HistoryArchiveViewController.h"
#import "PopupDateViewController.h"
#import "CommenWordsViewController.h"
#import "ArchiveListParser.h"

@interface ArchiveManagerViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,FileManagerDelegate,WebDataParserDelegate,ArchiveFileDetailDelegate,selectYearDirectoryDelegate,PopupDateDelegate,WordsDelegate>

@property (nonatomic,strong) NSString *fileServiceName;
@property (strong,nonatomic) IBOutlet UITableView *listTableView;
@property (strong,nonatomic) IBOutlet UIView *queryView;
@property (strong,nonatomic) NSMutableArray *listDataArray;
@property (assign,nonatomic) int currentPage;
@property (strong,nonatomic) NSString *fileOutType;
@property (strong,nonatomic) NSMutableString *curParsedData;
@property (strong,nonatomic) ArchiveListParser *archiveListParser;
@property (assign,nonatomic) NSInteger currentTag;
@property (strong,nonatomic) NSString  *processName;
@property (strong,nonatomic) NSString  *docid;
@property (strong,nonatomic) NSString  *modid;

@property (strong,nonatomic) IBOutlet UILabel *label1;
@property (strong,nonatomic) IBOutlet UILabel *label2;
@property (strong,nonatomic) IBOutlet UILabel *label3;
@property (strong,nonatomic) IBOutlet UILabel *label4;

@property (strong,nonatomic) IBOutlet UITextField *text1;
@property (strong,nonatomic) IBOutlet UITextField *text2;
@property (strong,nonatomic) IBOutlet UITextField *text3;
@property (strong,nonatomic) IBOutlet UITextField *text4;

- (IBAction)inquiryArchiveDirectory:(id)sender;

@end
