//
//  FileInDetailView.m
//  NingBoOA
//
//  Created by 熊熙 on 13-9-17.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "InnerFileDetailView.h"
#import "UIView+ZXQuartz.h"
@implementation InnerFileDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)awakeFromNib {
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
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
    
    [self drawFrameRectangele:CGRectMake(20, 70, 728, 670)];
    
    [self drawFillRectangel:CGRectMake(21, 71, 138, 668)];
    [self drawFillRectangel:CGRectMake(385, 71, 138, 118)];
    [self drawFillRectangel:CGRectMake(385, 470, 138, 38)];
    [self drawFillRectangel:CGRectMake(385, 550, 138, 38)];
    
    
    
    [self drawLineFrom:CGPointMake(20, 110) to:CGPointMake(748, 110)];
    
    [self drawLineFrom:CGPointMake(20, 150) to:CGPointMake(748, 150)];
    
    [self drawLineFrom:CGPointMake(20, 190) to:CGPointMake(748, 190)];
    
    //    [self drawLineFrom:CGPointMake(20, 410) to:CGPointMake(748, 410)];
    //
    //    [self drawLineFrom:CGPointMake(20, 460) to:CGPointMake(748, 460)];
    //
    //    [self drawLineFrom:CGPointMake(20, 510) to:CGPointMake(748, 510)];
    
    [self drawLineFrom:CGPointMake(20, 350) to:CGPointMake(748, 350)];
    
    [self drawLineFrom:CGPointMake(20, 390) to:CGPointMake(748, 390)];
    
//    [self drawLineFrom:CGPointMake(20, 590) to:CGPointMake(748, 590)];
    
    [self drawLineFrom:CGPointMake(20, 470) to:CGPointMake(748, 470)];
    
    [self drawLineFrom:CGPointMake(20, 510) to:CGPointMake(748, 510)];
    
    [self drawLineFrom:CGPointMake(20, 550) to:CGPointMake(748, 550)];
    
    [self drawLineFrom:CGPointMake(20, 590) to:CGPointMake(748, 590)];
    
    
    [self drawLineFrom:CGPointMake(160, 70) to:CGPointMake(160, 740)];
    [self drawLineFrom:CGPointMake(384, 70) to:CGPointMake(384, 190)];
    [self drawLineFrom:CGPointMake(524, 70) to:CGPointMake(524, 190)];
    [self drawLineFrom:CGPointMake(384, 470) to:CGPointMake(384, 510)];
    [self drawLineFrom:CGPointMake(524, 470) to:CGPointMake(524, 510)];
    [self drawLineFrom:CGPointMake(384, 550) to:CGPointMake(384, 590)];
    [self drawLineFrom:CGPointMake(524, 550) to:CGPointMake(524, 590)];
}


@end
