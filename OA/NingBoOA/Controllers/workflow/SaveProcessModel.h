//
//  SaveProcessModel.h
//  NingBoOA
//
//  Created by PowerData on 13-10-11.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceHelper.h"
#import "WebDataParserHelper.h"

@interface SaveProcessModel : NSObject <UIAlertViewDelegate,NSURLConnHelperDelegate,WebDataParserDelegate>

@property (nonatomic, copy) NSString *serviceName;
@property (nonatomic, copy) NSArray *saveKeys;
@property (nonatomic, copy) NSDictionary *saveValues;

@property (nonatomic, strong) WebServiceHelper *webServiceHelper;
@property (nonatomic, strong) UIViewController *parentViewController;

- (void)save;

- (void)cancel;

@end
