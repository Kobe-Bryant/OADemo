//
//  BaseFileToDoViewController.h
//  NingBoOA
//
//  Created by Alex Jean on 13-8-7.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "WebDataParserHelper.h"

@interface BaseFileToDoViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource,WebDataParserDelegate>

@property (nonatomic, strong) NSString *fileServiceName;
@property (strong, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) NSArray *listDataArray;
@property (strong, nonatomic) NSString *strUrl;
@property (assign, nonatomic) BOOL isLoading;
@property (assign, nonatomic) int currentPage;
@property (assign, nonatomic) BOOL isGotJsonString;
@property (strong, nonatomic) NSMutableString *curParsedData;

@end
