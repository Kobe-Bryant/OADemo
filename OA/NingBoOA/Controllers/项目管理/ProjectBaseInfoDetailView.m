//
//  FileInDetailView.m
//  NingBoOA
//
//  Created by 熊熙 on 13-9-17.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "ProjectBaseInfoDetailView.h"
#import "UIView+ZXQuartz.h"
@implementation ProjectBaseInfoDetailView

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
    
    [self drawFrameRectangele:CGRectMake(20, 0, 728, 1140)];
    
    [self drawFillRectangel:CGRectMake(21, 1, 726, 38)];
    [self drawFillRectangel:CGRectMake(21, 41, 138, 1098)];
    [self drawFillRectangel:CGRectMake(385, 81, 138, 158)];
    //[self drawFillRectangel:CGRectMake(385, 591, 138, 118)];
    //[self drawFillRectangel:CGRectMake(385, 861, 138, 78)];
    [self drawFillRectangel:CGRectMake(21, 281, 726, 38)];
    [self drawFillRectangel:CGRectMake(385, 361, 138, 38)];
    [self drawFillRectangel:CGRectMake(385, 401, 138, 78)];
    [self drawFillRectangel:CGRectMake(21, 631, 726, 38)];
    [self drawFillRectangel:CGRectMake(385, 671, 138, 78)];
    [self drawFillRectangel:CGRectMake(385, 791, 138, 198)];
    
    
    
    [self drawLineFrom:CGPointMake(20, 40) to:CGPointMake(748, 40)];
    
    [self drawLineFrom:CGPointMake(20, 80) to:CGPointMake(748, 80)];
    
    [self drawLineFrom:CGPointMake(20, 120) to:CGPointMake(748, 120)];
    
    [self drawLineFrom:CGPointMake(20, 160) to:CGPointMake(748, 160)];
    
    [self drawLineFrom:CGPointMake(20, 200) to:CGPointMake(748, 200)];
    
    [self drawLineFrom:CGPointMake(20, 240) to:CGPointMake(748, 240)];
    
    [self drawLineFrom:CGPointMake(20, 280) to:CGPointMake(748, 280)];
    
    [self drawLineFrom:CGPointMake(20, 320) to:CGPointMake(748, 320)];
    
    [self drawLineFrom:CGPointMake(20, 360) to:CGPointMake(748, 360)];
    
    [self drawLineFrom:CGPointMake(20, 400) to:CGPointMake(748, 400)];
    
    [self drawLineFrom:CGPointMake(20, 440) to:CGPointMake(748, 440)];
    
    [self drawLineFrom:CGPointMake(20, 480) to:CGPointMake(748, 480)];
    
    [self drawLineFrom:CGPointMake(20, 630) to:CGPointMake(748, 630)];
    
    [self drawLineFrom:CGPointMake(20, 670) to:CGPointMake(748, 670)];
    
    [self drawLineFrom:CGPointMake(20, 710) to:CGPointMake(748, 710)];
    
    [self drawLineFrom:CGPointMake(20, 750) to:CGPointMake(748, 750)];
    
    [self drawLineFrom:CGPointMake(20, 790) to:CGPointMake(748, 790)];
    
    [self drawLineFrom:CGPointMake(20, 830) to:CGPointMake(748, 830)];
    
    [self drawLineFrom:CGPointMake(20, 870) to:CGPointMake(748, 870)];
    
    [self drawLineFrom:CGPointMake(20, 910) to:CGPointMake(748, 910)];
    
    [self drawLineFrom:CGPointMake(20, 950) to:CGPointMake(748, 950)];
    
    [self drawLineFrom:CGPointMake(20, 990) to:CGPointMake(748, 990)];
//    
//    [self drawLineFrom:CGPointMake(20, 710) to:CGPointMake(748, 710)];
//    
//    [self drawLineFrom:CGPointMake(20, 860) to:CGPointMake(748, 860)];
//    
//    [self drawLineFrom:CGPointMake(20, 900) to:CGPointMake(748, 900)];
//    
//    [self drawLineFrom:CGPointMake(20, 940) to:CGPointMake(748, 940)];
    
    [self drawLineFrom:CGPointMake(160, 40) to:CGPointMake(160, 280)];
    [self drawLineFrom:CGPointMake(384, 80) to:CGPointMake(384, 240)];
    [self drawLineFrom:CGPointMake(524, 80) to:CGPointMake(524, 240)];
    [self drawLineFrom:CGPointMake(160, 320) to:CGPointMake(160, 630)];
    [self drawLineFrom:CGPointMake(384, 360) to:CGPointMake(384, 400)];
    [self drawLineFrom:CGPointMake(524, 360) to:CGPointMake(524, 400)];
    [self drawLineFrom:CGPointMake(384, 400) to:CGPointMake(384, 480)];
    [self drawLineFrom:CGPointMake(524, 400) to:CGPointMake(524, 480)];
    
    [self drawLineFrom:CGPointMake(160, 670) to:CGPointMake(160, 1140)];
    [self drawLineFrom:CGPointMake(384, 670) to:CGPointMake(384, 750)];
    [self drawLineFrom:CGPointMake(524, 670) to:CGPointMake(524, 750)];
    
    [self drawLineFrom:CGPointMake(384, 790) to:CGPointMake(384, 990)];
    [self drawLineFrom:CGPointMake(524, 790) to:CGPointMake(524, 990)];
//    [self drawLineFrom:CGPointMake(384, 590) to:CGPointMake(384, 710)];
//    [self drawLineFrom:CGPointMake(524, 590) to:CGPointMake(524, 710)];
//    [self drawLineFrom:CGPointMake(384, 860) to:CGPointMake(384, 940)];
//    [self drawLineFrom:CGPointMake(524, 860) to:CGPointMake(524, 940)];
}


@end
