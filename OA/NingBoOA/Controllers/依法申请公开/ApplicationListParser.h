//
//  ApplicationListParser.h
//  NingBoOA
//
//  Created by PowerData on 13-10-15.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceHelper.h"
#import "WebDataParserHelper.h"
#import "ServiceUrlString.h"

//APPLICATIONSAVEPROCESS
//APPLICATIONCONTINUTEPROCESS
#define kServiceName_Handling  @"GETHANDLEAPPLICATIONLIST"   //在办-按日期
#define kServiceName_Done      @"GETDONEAPPLICATIONLIST"     //已办按日期
#define kServiceName_ALLByDate @"GETALLDATEAPPLICATIONLIST"  //所有申请按日期
#define kServiceName_ALLByType @"GETAPPLICATIONTYPE"         //所有申请按类别
#define kServiceName_Search    @"QUERYAPPLICATIONLIST"       //查询
#define kServiceName_Detail    @"GETAPPLICATIONDETAIL"       //详细信息

@protocol HandleApplicationDetail <NSObject>

- (void)didSelectApplicationListItem:(NSString *)docid process:(NSString *)name;
- (void)loadMoreList;
@end

@interface ApplicationListParser : NSObject<UITableViewDataSource,UITableViewDelegate>
    

@property (nonatomic,  weak) UIView *showView;
@property (nonatomic,strong) NSMutableArray *aryItems;
@property (nonatomic,strong) NSDictionary *paramDict;
@property (nonatomic,strong) WebServiceHelper *webServiceHelper;
@property (nonatomic,strong) NSString *serviceName;
@property (nonatomic,strong) NSString *user;
@property (nonatomic,strong) UITableView *listTableView;
@property (nonatomic,strong) NSDictionary *queryDict;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,assign) NSInteger start;
@property (nonatomic,assign) BOOL notSearch;
@property (assign,nonatomic) BOOL isRefresh;
@property (nonatomic,assign) BOOL isLoading;
@property (weak,  nonatomic) id<HandleApplicationDetail> delegate;

-(void)requestData;

-(void)cancelRequest;

@end