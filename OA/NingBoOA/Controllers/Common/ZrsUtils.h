//
//  ZrsUtils.h
//  GuangXiOA
//
//  Created by 张 仁松 on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZrsUtils : NSObject
+(CGFloat)calculateTextHeight:(NSString*) text byFont:(UIFont*)font
                     andWidth:(CGFloat)width;

+(CGFloat)calculateTextWidth:(NSString*) text byFont:(UIFont*)font
                     andHeight:(CGFloat)height;
+(CGFloat)getTextHeight:(NSString*) text byFont:(UIFont*)font
                     andWidth:(CGFloat)width;
+(BOOL)compareDepartment:(NSString*)dep1 withAnotherDep:(NSString*)dep2;

@end
