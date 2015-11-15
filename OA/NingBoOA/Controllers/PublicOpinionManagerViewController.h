//
//  PublicOpinionManagerViewController.h
//  NingBoOA
//
//  Created by PowerData on 13-10-15.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "PopupDateViewController.h"
#import "HandleGWProtocol.h"
#import "FileManagerListController.h"
#import "PublicOpinionListParser.h"
#import "HandleGWProtocol.h"

@interface PublicOpinionManagerViewController : BaseViewController <FileManagerDelegate,PopupDateDelegate,UITextFieldDelegate,HandleGWDelegate,HandlePublicOpinionDetail>

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
@property (strong,nonatomic) NSString *docid;
@property (strong,nonatomic) NSString *processName;
@property (strong,nonatomic) NSDictionary *opinionInfo;

@property (strong, nonatomic) IBOutlet UITextField *startDateField;
@property (strong, nonatomic) IBOutlet UITextField *endDateField;
@property (strong, nonatomic) IBOutlet UITextField *codeField;
@property (strong, nonatomic) IBOutlet UITextField *nfField;
@property (strong, nonatomic) IBOutlet UITextField *btField;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;

-(IBAction)touchFromDate:(id)sender;
- (IBAction)queryPublicOpinionResult:(id)sender;

@end
