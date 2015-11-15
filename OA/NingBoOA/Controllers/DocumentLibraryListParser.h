//
//  DocumentLibraryListParser.h
//  NingBoOA
//
//  Created by 熊熙 on 13-11-11.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceHelper.h"
#import "HandleGWProtocol.h"
@protocol DocumentLibraryDetailDelegate <NSObject>

- (void)didSelectDocumentLibraryListInfo:(NSDictionary *)infoDict;
- (void)loadMoreList;
@end

@interface DocumentLibraryListParser : NSObject<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,weak)   UIView *showView;
@property(nonatomic,strong) NSMutableArray *aryItems;
@property(nonatomic,strong) NSString *type;
@property(nonatomic,strong) WebServiceHelper *webServiceHelper;
@property(nonatomic,strong) NSString *serviceName;
@property(nonatomic,strong) NSString *user;
@property(nonatomic,strong) UITableView *listTableView;
@property(weak,  nonatomic) id<DocumentLibraryDetailDelegate> delegate;
@property(nonatomic,strong) NSDictionary *paramDict;
@property(assign,nonatomic) NSInteger start;
@property(strong,nonatomic) NSString *total;
@property(assign,nonatomic) BOOL notSearch;
@property(nonatomic,assign) BOOL isRefresh;
@property(nonatomic,assign) BOOL isLoading;

-(void)requestData;
-(void)cancelRequest;

@end
