//
//  ContentEditViewController.h
//  NingBoOA
//
//  Created by 曾静 on 13-9-30.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentEditDelegate.h"
#import "BaseViewController.h"
#import "WebDataParserHelper.h"
@interface ContentEditViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) int row; //行
@property (nonatomic, assign) int index;//列
@property (nonatomic, assign) int editorType;//编辑的类型
@property (nonatomic, copy) NSString *key;//要修改的字段的对应的Key
@property (nonatomic, copy) NSString *editorTitle;//要修改的字段的对应的Title
@property (nonatomic, copy) NSString *oldValue;//要修改的字段的原始值
@property (nonatomic, weak) id<ContentEditDelegate> delegate;
@property (nonatomic, strong) NSString *serviceName;
@property (nonatomic, strong) NSArray *commonAry;

@property (nonatomic, strong) NSArray *customAry;

@end
