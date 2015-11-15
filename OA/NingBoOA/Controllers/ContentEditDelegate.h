//
//  ContentEditDelegate.h
//  NingBoOA
//
//  Created by 曾静 on 13-9-30.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


#define KEditor_Type_GWGZ 1 //公文稿纸
#define kEditor_Type_Dept 2 //主送单位 抄送单位
#define kEditor_Type_ZTC  3 //主题词
#define KEditor_Type_SRYJ 4 //输入意见
#define kEditor_Type_FBWZ 5 //发布网站
#define kEditor_Type_SSQY 6 //所属区域

#define kEditor_Type_UITextView 16   //只有一个UITextView
#define kEditor_Type_UITextField 17  //只有一个UITextField


@protocol ContentEditDelegate <NSObject>

@optional
- (void)passWithNewValue:(NSString *)newValue Type:(NSString *)type;

@optional
- (void)passWithNewValue:(NSString *)newValue andWithRow:(int)aRow andWithIndex:(int)aIndex andWithKey:(NSString *)aKey;

@end
