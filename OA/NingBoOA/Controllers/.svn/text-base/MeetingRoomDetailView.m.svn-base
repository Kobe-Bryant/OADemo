//
//  MeetingRoomDetailView.m
//  NingBoOA
//
//  Created by 熊熙 on 13-11-11.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "MeetingRoomDetailView.h"
#import "UIView+ZXQuartz.h"

@implementation MeetingRoomDetailView

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
    
    [self drawFrameRectangele:CGRectMake(20, 70, 728, 500)];
    
    [self drawFillRectangel:CGRectMake(21, 71, 140, 498)];
    [self drawFillRectangel:CGRectMake(385, 71, 140, 78)];
    
    [self drawFillRectangel:CGRectMake(385, 191, 140, 38)];
    
    
    [self drawLineFrom:CGPointMake(20, 110) to:CGPointMake(748, 110)];
    
    [self drawLineFrom:CGPointMake(20, 150) to:CGPointMake(748, 150)];
    
    [self drawLineFrom:CGPointMake(20, 190) to:CGPointMake(748, 190)];
    
    [self drawLineFrom:CGPointMake(20, 230) to:CGPointMake(748, 230)];
    
    [self drawLineFrom:CGPointMake(20, 270) to:CGPointMake(748, 270)];
    
    [self drawLineFrom:CGPointMake(20, 420) to:CGPointMake(748, 420)];
    
    [self drawLineFrom:CGPointMake(161, 70) to:CGPointMake(161, 570)];
    
    [self drawLineFrom:CGPointMake(384, 70) to:CGPointMake(384, 150)];
    [self drawLineFrom:CGPointMake(524, 70) to:CGPointMake(524, 150)];
    [self drawLineFrom:CGPointMake(384, 190) to:CGPointMake(384, 230)];
    [self drawLineFrom:CGPointMake(524, 190) to:CGPointMake(524, 230)];
    
}
@end
