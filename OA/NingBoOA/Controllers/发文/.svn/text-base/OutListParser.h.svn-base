//
//  OutListParser.h
//  NingBoOA
//
//  Created by 张仁松 on 13-9-18.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceHelper.h"

@protocol HandleFileOutDetail <NSObject>

- (void)didSelectFileOutListItem:(NSString *)docid process:(NSString *)name;
- (void)loadMoreList;
@end

@interface OutListParser : NSObject<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>


@property(nonatomic,weak)   UIView *showView;
@property(nonatomic,strong) NSMutableArray *aryItems;
@property(nonatomic,strong) NSDictionary *paramDict;
@property(nonatomic,strong) NSString *type;
@property(nonatomic,strong) WebServiceHelper *webServiceHelper;
@property(nonatomic,strong) NSString *serviceName;
@property(nonatomic,strong) NSString *user;
@property(nonatomic,strong) UITableView *listTableView;
@property(nonatomic,weak)   id<HandleFileOutDetail> delegate;
@property(nonatomic,assign) NSInteger start;
@property(assign,nonatomic) BOOL notSearch;
@property(nonatomic,assign) BOOL isRefresh;
@property(nonatomic,assign) BOOL isLoading;

-(void)requestData;
-(void)cancelRequest;

@end
