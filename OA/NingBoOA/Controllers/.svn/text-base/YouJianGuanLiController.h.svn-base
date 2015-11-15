//
//  YouJianGuanLiController.h
//  GuangXiOA
//
//  Created by  on 11-12-21.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURLConnHelper.h"
#define nWebDataForContent 1//附件
#define nWebDataForEmailList  2//邮件列表
#import "BaseViewController.h"
#import "WebDataParserHelper.h"
#import "CustomSegmentedControl.h"

@interface YouJianGuanLiController : BaseViewController<UITableViewDataSource,UITableViewDelegate,NSURLConnHelperDelegate,CustomSegmentedControlDelegate,WebDataParserDelegate>
@property (nonatomic,strong) NSMutableArray *parsedInBoxItemAry;//收件箱
@property (nonatomic,strong) IBOutlet UITableView* listTableView;
@property (nonatomic,strong) NSMutableArray *parsedOutBoxItemAry;//发件箱

@property (nonatomic,assign) NSInteger listDataType;
@property (nonatomic,strong) IBOutlet UITableView* fileTableView;
@property (nonatomic,assign) NSInteger nWebDataType;

@property (nonatomic,strong) NSArray *parsedFileItemAry;//附件
@property (nonatomic,strong) NSDictionary *curEmaiJBXXDic; //当前文件的基本信息
@property (nonatomic,strong) IBOutlet UILabel *titleLabel;
@property (nonatomic,strong) IBOutlet UILabel *fromLabel;
@property (nonatomic,strong) IBOutlet UILabel *sendTimeLabel;
@property (nonatomic,strong) IBOutlet UITextView *mainTextView;
@property (nonatomic,assign) BOOL isLoading;
@property (nonatomic,assign) NSInteger curPageOfSend;//收文当前页数
@property (nonatomic,assign) NSInteger pagesumOfSend;//收文总页数
@property (nonatomic,assign) NSInteger curPageOfRecv;//发文当前页数
@property (nonatomic,assign) NSInteger pagesumOfRecv;//发文总页数
@property(nonatomic,strong) NSURLConnHelper *webHelper;
@property(nonatomic,strong) NSString *urlSend;
@property(nonatomic,strong) NSString * urlRecv;
@property (nonatomic,strong) NSMutableSet *readedSet;
@property (nonatomic,strong) NSArray* segmentControlTitles;

@property (nonatomic,assign) BOOL choosed;//判断是否选中邮件，选中才能转发,回复,编写


@end
