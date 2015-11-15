//
//  HandleProcessViewController.h
//  NingBoOA
//
//  Created by 熊熙 on 13-10-8.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "WebDataParserHelper.h"
#import "CommenWordsViewController.h"
@interface HandleProcessViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,WordsDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) NSDictionary *valueDict;
@property (strong, nonatomic) NSArray *processHandlerArray;
@property (strong, nonatomic) NSArray *nextProcessArray;
@property (strong, nonatomic) NSDictionary *nextProcess;
@property (strong, nonatomic) NSDictionary *processHandler;
@property (strong, nonatomic) NSMutableArray *selectReader;
@property (strong, nonatomic) NSMutableArray *selectHandler;
@property (nonatomic,retain)  NSMutableArray *aryName0Views;
@property (nonatomic,retain)  NSMutableArray *aryName1Views;
@property (strong, nonatomic) IBOutlet UITableView *handlerTableView;
@property (strong, nonatomic) IBOutlet UITableView *readerTableView;
@property (strong, nonatomic) IBOutlet UITextField *currentProcess;
@property (strong, nonatomic) IBOutlet UITextField *nextProcessTxt;

@property (strong, nonatomic) NSArray  *deptList;


@property (strong, nonatomic) IBOutlet UIScrollView *handlerScrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *readerScrollView;

@property (assign, nonatomic) BOOL isMulti;
@property (assign, nonatomic) BOOL isReader;
@property (strong, nonatomic) BaseViewController *sender;

- (IBAction)btnSelectProcess:(id)sender;
- (IBAction)btnTransferPressed:(id)sender;
@end
