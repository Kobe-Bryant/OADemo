//
//  InnerFileManagerViewController.h
//  内部文件管理（在办-按日期、已办-按日期、查询）
//
//  Created by 曾静 on 13-9-27.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "FileManagerListController.h"
#import "InnerFileListParser.h"
#import "PopupDateViewController.h"
#import "CommenWordsViewController.h"

@interface InnerFileManagerViewController : BaseViewController <FileManagerDelegate,PopupDateDelegate,UITextFieldDelegate,HandleInnerFileDetail,WordsDelegate>

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
@property (strong,nonatomic) NSDictionary *innerInfo;
@property (strong,nonatomic) NSString *processName;
@property (strong,nonatomic) NSString *docid;

@property (strong, nonatomic) IBOutlet UITextField *ngrqField;
@property (strong, nonatomic) IBOutlet UITextField *wjbhField;
@property (strong, nonatomic) IBOutlet UITextField *btField;
@property (strong, nonatomic) IBOutlet UITextField *jzrqField;
@property (strong, nonatomic) IBOutlet UITextField *zbbmField;
@property (strong, nonatomic) IBOutlet UITextField *hjField;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;

-(IBAction)touchFromDate:(id)sender;
- (IBAction)selectCommenWords:(id)sender;
- (IBAction)queryInnerFileResult:(id)sender;

@end
