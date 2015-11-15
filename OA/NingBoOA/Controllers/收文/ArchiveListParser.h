//
//  InListParser.h
//  NingBoOA
//
//  Created by 熊熙 on 13-9-25.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceHelper.h"
#import "HandleGWProtocol.h"
@protocol ArchiveFileDetailDelegate <NSObject>

- (void)didSelectArchiveListInfo:(NSDictionary *)infoDict Type:(NSString *)type;
- (void)loadMoreList;
@end

@interface ArchiveListParser : NSObject<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,weak)   UIView *showView;
@property(nonatomic,strong) NSMutableArray *aryItems;
@property(nonatomic,strong) NSString *type;
@property(nonatomic,strong) WebServiceHelper *webServiceHelper;
@property(nonatomic,strong) NSString *serviceName;
@property(nonatomic,strong) NSString *user;
@property(nonatomic,strong) UITableView *listTableView;
@property(weak,  nonatomic) id<ArchiveFileDetailDelegate> delegate;
@property(nonatomic,strong) NSArray *paramAry;
@property(nonatomic,assign) NSInteger start;
@property(assign,nonatomic) BOOL notSearch;
@property(nonatomic,assign) BOOL isRefresh;
@property(nonatomic,assign) BOOL isLoading;

-(void)requestData;
-(void)cancelRequest;

@end
