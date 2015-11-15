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
#import "CustomSegmentedControl.h"
#import "HandleGWProtocol.h"
#import "FileManagerListController.h"
@interface ToDoFileViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,WebDataParserDelegate,CustomSegmentedControlDelegate,HandleGWDelegate,FileManagerDelegate>

@property (nonatomic, strong) NSString *fileServiceName;
@property (strong, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) NSDictionary *infoDict;
@property (strong, nonatomic) NSString *requestType;
@property (strong, nonatomic) NSMutableArray *aryItems;
@property (strong, nonatomic) NSString *strUrl;
@property (assign, nonatomic) BOOL isRefresh;
@property (assign, nonatomic) BOOL isLoading;
@property (assign, nonatomic) NSInteger start;
@property (assign, nonatomic) BOOL bHaveShowed;
@property (assign, nonatomic) int currentPage;
@property (assign, nonatomic) BOOL isGotJsonString;
@property (assign, nonatomic) BOOL isEmpty;
@property (strong, nonatomic) NSMutableString *curParsedData;
@property (strong, nonatomic) NSArray *segmentControlTitles;
@property (strong, nonatomic) NSString *docid;
@property (strong, nonatomic) NSString *process;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSString *categoryName;


@end
