//
//  FileInDetailView.m
//  NingBoOA
//
//  Created by 熊熙 on 13-9-17.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "ApplicationDetailView.h"
#import "UIView+ZXQuartz.h"
@implementation ApplicationDetailView

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
    
    [self drawFrameRectangele:CGRectMake(20, 70, 728, 1440)];
    
    [self drawFillRectangel:CGRectMake(21, 71, 140, 1438)];
    [self drawFillRectangel:CGRectMake(385, 111, 140, 118)];
//    [self drawFillRectangel:CGRectMake(385, 301, 140, 230)];
//    [self drawFillRectangel:CGRectMake(385, 611, 140, 120)];
    
    [self drawLineFrom:CGPointMake(20, 110) to:CGPointMake(748, 110)];
    
    [self drawLineFrom:CGPointMake(20, 150) to:CGPointMake(748, 150)];

    
    [self drawLineFrom:CGPointMake(20, 190) to:CGPointMake(748, 190)];
    
    [self drawLineFrom:CGPointMake(20, 230) to:CGPointMake(748, 230)];
    
    
    [self drawLineFrom:CGPointMake(20, 310) to:CGPointMake(748, 310)];
    
    [self drawLineFrom:CGPointMake(20, 460) to:CGPointMake(748, 460)];
    
    [self drawLineFrom:CGPointMake(20, 610) to:CGPointMake(748, 610)];
    
    [self drawLineFrom:CGPointMake(20, 760) to:CGPointMake(748, 760)];
    
    [self drawLineFrom:CGPointMake(20, 910) to:CGPointMake(748, 910)];
    
    [self drawLineFrom:CGPointMake(20, 1060) to:CGPointMake(748, 1060)];
    
    [self drawLineFrom:CGPointMake(20, 1210) to:CGPointMake(748, 1210)];
    
    [self drawLineFrom:CGPointMake(20, 1360) to:CGPointMake(748, 1360)];
    
    [self drawLineFrom:CGPointMake(20, 1510) to:CGPointMake(748, 1510)];
    
    [self drawLineFrom:CGPointMake(161, 70) to:CGPointMake(161, 1510)];
    [self drawLineFrom:CGPointMake(384, 110) to:CGPointMake(384, 230)];
    [self drawLineFrom:CGPointMake(524, 110) to:CGPointMake(524, 230)];
//    [self drawLineFrom:CGPointMake(384, 300) to:CGPointMake(384, 530)];
//    [self drawLineFrom:CGPointMake(524, 300) to:CGPointMake(524, 530)];
//    [self drawLineFrom:CGPointMake(384, 610) to:CGPointMake(384, 730)];
//    [self drawLineFrom:CGPointMake(524, 610) to:CGPointMake(524, 730)];
}


@end
