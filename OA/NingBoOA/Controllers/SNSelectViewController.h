//
//  ViewController.h
//  NingBoOA
//
//  Created by ZHONGWEN on 13-11-20.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "WebDataParserHelper.h"

@protocol GetOfficeDocumentSNDelegate <NSObject>

- (void)returnOfficeDocumnetSave:(BOOL)isSave Type:(NSString *)lb Year:(NSString *)nf Serial:(NSString *)lsh;

@end
@interface SNSelectViewController : BaseViewController<WebDataParserDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property (strong,nonatomic) NSString *serviceName;
@property (strong,nonatomic) NSArray *listArray;
@property (strong,nonatomic) NSArray *typeArray;
@property (strong,nonatomic) NSArray *yearArray;
@property (strong,nonatomic) NSString *serial;
@property (strong,nonatomic) UIPickerView *SNPickerView;
@property (weak,nonatomic)   id<GetOfficeDocumentSNDelegate> delegate;

@end
