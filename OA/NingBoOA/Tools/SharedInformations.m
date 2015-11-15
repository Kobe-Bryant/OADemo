//
//  SharedInformations.m
//  GMEPS_HZ
//
//  Created by chen on 11-10-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SharedInformations.h"



@implementation SharedInformations

+(NSString*)getJJCDFromInt:(NSInteger) num{
    if (num == 0) return @"一般";
    else if (num == 1) return @"紧急";
    else  return @"特急";
}

+(NSString*)getAJLYFromInt:(NSInteger) num{

    if (num == 1) return @"现场发现";
    else if (num == 2) return @"投诉转办";
    else if (num == 3) return @"信访";
    else if (num == 4) return @"上级交办";
    else if (num == 5) return @"领导批示";
    else if (num == 6) return @"公众举报";
    else if (num == 7) return @"媒体曝光";
    else  return @"其它";
}


+(NSString*)getBMJBFromInt:(NSInteger) num{
    if (num == 2) return @"秘密";
    else if (num == 3) return @"机密";
    else  if (num == 4) return @"绝密";
    else return @"无密";
        
}

+(NSString*)getGKLXFromInt:(NSInteger) num{
    if (num == 1) return @"主动公开";
    else if (num == 2) return @"依申请公开";
    else  if (num == 3) return @"不予公开";
    else return @"内部公开";
    
}


+(NSString*)getFWLXFromStr:(NSString*) type{//发文类型
    NSArray * itemAry = [NSArray arrayWithObjects:@"阳环函",@"办公室下行文",@"办公室上行文",@"环保局下行文",@"环保局上行文", nil];
    
    
    NSArray *typeAry = [NSArray arrayWithObjects:@"10",@"15",@"20",@"25",@"30",nil];
    int index = 0;
    for(NSString *str in typeAry){
        if ([str isEqualToString:type]) {
            return [itemAry objectAtIndex:index];
        }
        index++;
    }
    return @"";
}



+(NSString*)getLWLXFromStr:(NSString*) type{//来文类型
    NSArray *itemAry = [NSArray arrayWithObjects:@"急件",@"呈阅件",@"传阅件",@"电话记录",@"会议",@"信访件",nil];
    
    NSArray *typeAry = [NSArray arrayWithObjects:@"10",@"20",@"30",@"40",@"50",@"60", 
                    nil];
    int index = 0;
    for(NSString *str in typeAry){
        if ([str isEqualToString:type]) {
            return [itemAry objectAtIndex:index];
        }
        index++;
    }
    return @"";
}

@end
