//
//  CapitalView.m
//  NingBoOA
//
//  Created by PowerData on 14-3-28.
//  Copyright (c) 2014年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "CapitalView.h"
#import "UIView+ZXQuartz.h"

@implementation CapitalView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIColor *white = [UIColor colorWithRed:1
                                     green:1
                                      blue:1
                                     alpha:1];
    
    UIColor *lightGray = [UIColor lightGrayColor];
    //    UIColor *green = [UIColor colorWithRed:41.f/255.f
    //                                     green:199.f/255.f
    //                                      blue:165.f/255.f
    //                                     alpha:1];
    [lightGray setStroke];//设置线条颜色
    [white setFill]; //设置填充颜色
    
    //画背景矩形框
    
    [self drawFrameRectangele:CGRectMake(20, 70, 728, 780)];
    
    [self drawFillRectangel:CGRectMake(21, 71, 140, 778)];
    [self drawFillRectangel:CGRectMake(385, 71, 140, 38)];
    [self drawFillRectangel:CGRectMake(385, 231, 140, 38)];
    
    [self drawLineFrom:CGPointMake(20, 110) to:CGPointMake(748, 110)];
    [self drawLineFrom:CGPointMake(20, 150) to:CGPointMake(748, 150)];
    [self drawLineFrom:CGPointMake(20, 190) to:CGPointMake(748, 190)];
    [self drawLineFrom:CGPointMake(20, 230) to:CGPointMake(748, 230)];
    [self drawLineFrom:CGPointMake(20, 270) to:CGPointMake(748, 270)];
    [self drawLineFrom:CGPointMake(20, 310) to:CGPointMake(748, 310)];
    [self drawLineFrom:CGPointMake(20, 400) to:CGPointMake(748, 400)];
    [self drawLineFrom:CGPointMake(20, 490) to:CGPointMake(748, 490)];
    [self drawLineFrom:CGPointMake(20, 580) to:CGPointMake(748, 580)];
    [self drawLineFrom:CGPointMake(20, 670) to:CGPointMake(748, 670)];
    [self drawLineFrom:CGPointMake(20, 760) to:CGPointMake(748, 760)];
    
    [self drawLineFrom:CGPointMake(161, 70) to:CGPointMake(161, 850)];
    [self drawLineFrom:CGPointMake(384, 70) to:CGPointMake(384, 110)];
    [self drawLineFrom:CGPointMake(524, 70) to:CGPointMake(524, 110)];
    [self drawLineFrom:CGPointMake(384, 230) to:CGPointMake(384, 310)];
    [self drawLineFrom:CGPointMake(524, 230) to:CGPointMake(524, 270)];
  
}

@end
