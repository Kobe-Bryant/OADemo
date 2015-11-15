//
//  PostDocManagerViewController.h
//  NingBoOA
//
//  Created by 熊熙 on 13-9-9.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//收文管理 

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "WebDataParserHelper.h"
#import "FileManagerListController.h"
#import "CommenWordsViewController.h"
#import "PopupDateViewController.h"
#import "OutListParser.h"
#import "BackProtocol.h"
@class XJZXViewController;

@interface XJZXPMDocumentController : BaseViewController<FileManagerDelegate,HandleFileOutDetail,UITextFieldDelegate,PopupDateDelegate,WordsDelegate>

@property (nonatomic, weak)  id<BackProtocol> delegate;
@property (nonatomic, strong) NSString *fileServiceName;
@property (strong,nonatomic) IBOutlet UITableView *listTableView;
@property (strong,nonatomic) IBOutlet UIView *queryView;
@property (strong,nonatomic) NSMutableArray *listDataArray;
@property (strong,nonatomic) NSString *strUrl;
@property (assign,nonatomic) BOOL isLoading;
@property (assign,nonatomic) BOOL bHaveShowed;
@property (assign,nonatomic) int currentPage;
@property (strong,nonatomic) NSString *fileOutType;
@property (assign,nonatomic) BOOL isGotJsonString;
@property (strong,nonatomic) NSMutableString *curParsedData;
@property (strong,nonatomic) OutListParser *outListParser;
@property (strong,nonatomic) NSDictionary *postDocInfo;
@property (strong,nonatomic) NSString *processName;
@property (strong,nonatomic) NSString *docid;
@property (assign,nonatomic) NSInteger currentTag;

@property (strong,nonatomic) IBOutlet UITextField *startDateTxt;
@property (strong,nonatomic) IBOutlet UITextField *endDateTxt;
@property (strong,nonatomic) IBOutlet UITextField *fwbhTxt;
@property (strong,nonatomic) IBOutlet UITextField *zbbmTxt;
@property (strong,nonatomic) IBOutlet UITextField *titleTxt;
@property (strong,nonatomic) IBOutlet UITextField *urgentTxt;

-(IBAction)touchFromDate:(id)sender;
- (IBAction)selectCommenWords:(id)sender;
- (IBAction)queryFileOutResult:(id)sender;

@end
