//
//  FileInDetailView.m
//  NingBoOA
//
//  Created by 熊熙 on 13-9-17.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "FileOutDetailView.h"
#import "UIView+ZXQuartz.h"
@implementation FileOutDetailView

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
    
    [self drawFrameRectangele:CGRectMake(20, 70, 728, 830)];
    
    [self drawFillRectangel:CGRectMake(21, 71, 138, 828)];
    [self drawFillRectangel:CGRectMake(385, 71, 138, 478)];
    [self drawFillRectangel:CGRectMake(385, 631, 138, 38)];
    [self drawFillRectangel:CGRectMake(385, 711, 138, 38)];
    
    
    [self drawLineFrom:CGPointMake(20, 230) to:CGPointMake(748, 230)];
    
    [self drawLineFrom:CGPointMake(20, 270) to:CGPointMake(748, 270)];
    
    [self drawLineFrom:CGPointMake(20, 310) to:CGPointMake(748, 310)];
    
    [self drawLineFrom:CGPointMake(20, 350) to:CGPointMake(748, 350)];
    
    //    [self drawLineFrom:CGPointMake(20, 410) to:CGPointMake(748, 410)];
    //
    //    [self drawLineFrom:CGPointMake(20, 460) to:CGPointMake(748, 460)];
    //
    //    [self drawLineFrom:CGPointMake(20, 510) to:CGPointMake(748, 510)];
    
    [self drawLineFrom:CGPointMake(20, 510) to:CGPointMake(748, 510)];
    
    [self drawLineFrom:CGPointMake(20, 550) to:CGPointMake(748, 550)];
    
//    [self drawLineFrom:CGPointMake(20, 590) to:CGPointMake(748, 590)];
    
    [self drawLineFrom:CGPointMake(20, 630) to:CGPointMake(748, 630)];
    
    [self drawLineFrom:CGPointMake(20, 670) to:CGPointMake(748, 670)];
    
    [self drawLineFrom:CGPointMake(20, 710) to:CGPointMake(748, 710)];
    
    [self drawLineFrom:CGPointMake(20, 750) to:CGPointMake(748, 750)];
    
    
    [self drawLineFrom:CGPointMake(160, 70) to:CGPointMake(160, 900)];
    [self drawLineFrom:CGPointMake(384, 70) to:CGPointMake(384, 550)];
    [self drawLineFrom:CGPointMake(524, 70) to:CGPointMake(524, 550)];
    [self drawLineFrom:CGPointMake(384, 630) to:CGPointMake(384, 670)];
    [self drawLineFrom:CGPointMake(524, 630) to:CGPointMake(524, 670)];
    [self drawLineFrom:CGPointMake(384, 710) to:CGPointMake(384, 750)];
    [self drawLineFrom:CGPointMake(524, 710) to:CGPointMake(524, 750)];
}


@end
