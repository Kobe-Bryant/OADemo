//
//  YDZFChildRecordViewController.h
//  NingBoOA
//
//  Created by PowerData on 13-10-18.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "WebServiceHelper.h"
#import "WebDataParserHelper.h"

@interface YDZFChildRecordViewController : BaseViewController <UIWebViewDelegate,WebDataParserDelegate, NSURLConnHelperDelegate,UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *detailWebView;
@property (nonatomic, copy) NSString *DWMC;
@property (nonatomic, copy) NSString *DWDZ;
@property (nonatomic, copy) NSString *DWFZR;
@property (nonatomic, copy) NSString *DWLXDH;
@property (nonatomic, copy) NSString *recordTitle;
@property (nonatomic, copy) NSString *serviceName;
@property (nonatomic, copy) NSString *XCZFBH;

@end
