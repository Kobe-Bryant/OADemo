//
//  SignListParser.h
//  NingBoOA
//
//  Created by PowerData on 13-10-10.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceHelper.h"
#import "WebDataParserHelper.h"

#define kServiceType_HandlingToDate @"date" //在办-按日期 date
#define kServiceType_HandlingToProcess @"process" //在办-环节 process
#define kServiceType_DoneToDate @"date" //已办-按日期 date
#define kServiceType_DoneToCode @"wh" //已办-按文号 wh

@protocol HandleSignDocDetail <NSObject>

- (void)didSelectSignDocListItem:(NSString *)docid process:(NSString *)name;
@optional
- (void)loadMoreList;
@end

@interface SignListParser : NSObject <UITableViewDataSource, UITableViewDelegate>


@property (nonatomic,  weak) UIView *showView;
@property (nonatomic,strong) NSMutableArray *aryItems;
@property(nonatomic,strong) NSDictionary *paramDict;
@property (nonatomic,strong) NSString *type;//类型
@property (nonatomic,strong) WebServiceHelper *webServiceHelper;
@property (nonatomic,strong) NSString *serviceName;
@property (nonatomic,strong) NSString *user;
@property (nonatomic,strong) UITableView *listTableView;
@property (weak,  nonatomic) id<HandleSignDocDetail> delegate;
@property (nonatomic,strong) NSDictionary *queryDict;
@property (assign,nonatomic) NSInteger start;
@property (assign,nonatomic) BOOL notSearch;
@property (assign,nonatomic) BOOL isRefresh;
@property (nonatomic,assign) BOOL isLoading;

-(void)requestData;
-(void)cancelRequest;
-(void)showAlertMessage:(NSString*)msg;

@end
