//
//  RebackViewController.h
//  收回
//
//  Created by PowerData on 13-10-11.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HandleGWProtocol.h"
#import "WebServiceHelper.h"
#import "WebDataParserHelper.h"
#import "BaseViewController.h"

@interface RebackViewController : BaseViewController <UIAlertViewDelegate>

@property (nonatomic, copy) NSString *docID;//文档ID
@property (nonatomic, copy) NSString *mdID;//模块ID

@property (nonatomic,assign) id<HandleGWDelegate> delegate;
@property (nonatomic,assign) NSInteger webServiceType; // 0 请求流转步骤 1 流转命令
@property (nonatomic,strong) WebServiceHelper *webServiceHelper;

@end
