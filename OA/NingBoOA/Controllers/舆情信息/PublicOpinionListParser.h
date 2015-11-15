//
//  PublicOpinionListParser.h
//  NingBoOA
//
//  Created by PowerData on 13-10-15.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceHelper.h"
#import "WebDataParserHelper.h"
#import "ServiceUrlString.h"

/*
 GETPUBLICOPINIONLOCATION
 GETPUBLICOPINIONSITE
 PUBLICOPINIONSAVEPROCESS
 PUBLICOPINIONCONTINUTEPROCESS
 */

#define kServiceName_Handling  @"GETHANDLEPUBLICOPINIONLIST"   //在办-按日期
#define kServiceName_Done      @"GETDONEPUBLICOPINIONLIST"     //已办按日期
#define kServiceName_ALLByDate @"GETALLDATEPUBLICOPINIONLIST"  //所有舆情信息按日期
#define kServiceName_ALLByType @"GETPUBLICOPINIONTYPE"         //所有舆情信息按类别
#define kServiceName_Search    @"QUERYPUBLICOPINIONLIST"       //查询
#define kServiceName_Detail    @"GETPUBLICOPINIONDETAIL"       //详细信息

@protocol HandlePublicOpinionDetail <NSObject>

- (void)didSelectOpinionListItem:(NSString *)docid process:(NSString *)name;
- (void)loadMoreList;
@end


@interface PublicOpinionListParser : NSObject<UITableViewDataSource,UITableViewDelegate>


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

@property (weak,  nonatomic) id<HandlePublicOpinionDetail> delegate;

-(void)requestData;

-(void)cancelRequest;

@end
