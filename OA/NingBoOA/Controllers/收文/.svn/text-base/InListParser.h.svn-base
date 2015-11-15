//
//  InListParser.h
//  NingBoOA
//
//  Created by 熊熙 on 13-9-25.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceHelper.h"

@protocol HandleFileInDetail <NSObject>

- (void)didSelectFileInListItem:(NSString *)docid process:(NSString *)name;

@optional
- (void)loadMoreList;

@end

@interface InListParser : NSObject<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property(nonatomic,weak)   UIView *showView;
@property(nonatomic,strong) NSMutableArray *aryItems;
@property(nonatomic,strong) NSDictionary *paramDict;
@property(nonatomic,strong) NSString *type;
@property(nonatomic,strong) WebServiceHelper *webServiceHelper;
@property(nonatomic,strong) NSString *serviceName;
@property(nonatomic,strong) NSString *user;
@property(nonatomic,strong) UITableView *listTableView;
@property(weak,  nonatomic) id<HandleFileInDetail> delegate;
@property(nonatomic,assign) NSInteger start;
@property(nonatomic,assign) BOOL notSearch;
@property(nonatomic,assign) BOOL isRefresh;
@property(nonatomic,assign) BOOL isLoading;

-(void)requestData;
-(void)cancelRequest;

@end
