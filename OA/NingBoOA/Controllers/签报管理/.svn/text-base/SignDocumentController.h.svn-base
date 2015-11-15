//
//  SignDocumentController.h
//  NingBoOA
//
//  Created by 张仁松 on 13-9-26.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "WebDataParserHelper.h"
#import "FileManagerListController.h"
#import "SignListParser.h"
#import "PopupDateViewController.h"
#import "CommenWordsViewController.h"

#define kServiceName_Handling @"GetHandleSignReportList" //在办
#define kServiceName_Done @"GetDoneSignReportList" //已办
#define kServiceName_Search @"QuerySignReportList" //查询

@interface SignDocumentController : BaseViewController<FileManagerDelegate,HandleSignDocDetail,PopupDateDelegate,WordsDelegate,UITextFieldDelegate>
{
    IBOutlet UITextField* ngrqField;//拟稿日期
    IBOutlet UITextField* fwbhField;//发文编号
    IBOutlet UITextField* zbbmField;//主办部门
    IBOutlet UITextField* jzrqField;//截止日期
    IBOutlet UITextField* hjField;//缓急
    IBOutlet UITextField* btField;//标题
}

@property (strong,nonatomic) NSString *fileServiceName;
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
@property (strong,nonatomic) UIBarButtonItem *createFileOutIem;
@property (strong,nonatomic) SignListParser *signListParser;
@property (strong,nonatomic) NSDictionary *signDocInfo;
@property (strong,nonatomic) NSString *processName;
@property (strong,nonatomic) NSString *docid;


-(IBAction)touchFromDate:(id)sender;
- (IBAction)selectCommenWords:(id)sender;
- (IBAction)querySignDocResult:(id)sender;

@end
