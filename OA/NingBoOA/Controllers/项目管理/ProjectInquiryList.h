//
//  OutInquiryList.h
//  NingBoOA
//
//  Created by 熊熙 on 13-10-25.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProjectListParser.h"
@interface ProjectInquiryList : ProjectListParser

@property (strong, nonatomic) NSString *beginDate;
@property (strong, nonatomic) NSString *endDate;
@property (strong, nonatomic) NSString *fwbh;
@property (strong, nonatomic) NSString *dept;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *urgent;

@end
