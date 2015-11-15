//
//  YDZFMainRecordViewController.h
//  NingBoOA
//
//  Created by PowerData on 13-10-18.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "WebServiceHelper.h"
#import "WebDataParserHelper.h"
#import "CommenWordsViewController.h"

@interface YDZFMainRecordViewController : BaseViewController <WordsDelegate,UIWebViewDelegate>

@property (nonatomic, copy) NSString *XCZFBH;
@property (nonatomic, copy) NSString *DWMC;

@end
