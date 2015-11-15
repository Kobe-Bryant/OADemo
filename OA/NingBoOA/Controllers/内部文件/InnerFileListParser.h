//
//  InnerFileListParser.h
//  内部文件管理 数据解析
//
//  Created by 曾静 on 13-9-27.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceHelper.h"
#import "WebDataParserHelper.h"
#import "ServiceUrlString.h"

#define kServiceName_Handling @"GETHANDLEFILEINSIDELIST" //在办-按日期
#define kServiceName_Done @"GETDONEFILEINSIDELIST" //已办按日期
#define kServiceName_Search @"QUERYFILEINSIDELIST" //查询

@protocol HandleInnerFileDetail <NSObject>

- (void)didSelectInnerFileListItem:(NSString *)docid process:(NSString *)name;
@optional
- (void)loadMoreList;
@end

@interface InnerFileListParser : NSObject<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic,  weak) UIView *showView;
@property (nonatomic,strong) NSMutableArray *aryItems;
@property (nonatomic,strong) NSDictionary *paramDict;
@property (nonatomic,strong) NSString *type;//类型
@property (nonatomic,strong) WebServiceHelper *webServiceHelper;
@property (nonatomic,strong) NSString *serviceName;
@property (nonatomic,strong) NSString *user;
@property (weak,  nonatomic) id<HandleInnerFileDetail> delegate;
@property (nonatomic,strong) UITableView *listTableView;
@property (nonatomic,strong) NSDictionary *queryDict;
@property (assign,nonatomic) NSInteger start;
@property (assign,nonatomic) BOOL notSearch;
@property (assign,nonatomic) BOOL isRefresh;
@property (nonatomic,assign) BOOL isLoading;

-(void)requestData;
-(void)cancelRequest;

@end
