//
//  FileInDetailView.m
//  NingBoOA
//
//  Created by 熊熙 on 13-9-17.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "ProjectCheckInfoDetailView.h"
#import "UIView+ZXQuartz.h"
@implementation ProjectCheckInfoDetailView

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
    
    [self drawFrameRectangele:CGRectMake(20, 0, 728, 1380)];
    
    [self drawFillRectangel:CGRectMake(21, 1, 726, 38)];
    [self drawFillRectangel:CGRectMake(21, 41, 148, 518)];
    [self drawFillRectangel:CGRectMake(385, 161, 148, 78)];
    [self drawFillRectangel:CGRectMake(21, 561, 148, 818)];
    [self drawFillRectangel:CGRectMake(385, 561, 148, 38)];
    [self drawFillRectangel:CGRectMake(385, 641, 148, 38)];
    [self drawFillRectangel:CGRectMake(385, 721, 148, 38)];
    [self drawFillRectangel:CGRectMake(385, 801, 148, 78)];
    [self drawFillRectangel:CGRectMake(385, 1041, 148, 38)];
    [self drawFillRectangel:CGRectMake(385, 1121, 148, 38)];
    [self drawFillRectangel:CGRectMake(385, 1201, 148, 118)];


    [self drawLineFrom:CGPointMake(20, 40) to:CGPointMake(748, 40)];
    
    [self drawLineFrom:CGPointMake(20, 80) to:CGPointMake(748, 80)];
    
    [self drawLineFrom:CGPointMake(20, 120) to:CGPointMake(748, 120)];
    
    [self drawLineFrom:CGPointMake(20, 160) to:CGPointMake(748, 160)];
    
    [self drawLineFrom:CGPointMake(20, 200) to:CGPointMake(748, 200)];
    
    [self drawLineFrom:CGPointMake(20, 240) to:CGPointMake(748, 240)];
    
    [self drawLineFrom:CGPointMake(20, 400) to:CGPointMake(748, 400)];
    
    [self drawLineFrom:CGPointMake(20, 560) to:CGPointMake(748, 560)];
    
    [self drawLineFrom:CGPointMake(20, 600) to:CGPointMake(748, 600)];
    
    [self drawLineFrom:CGPointMake(20, 640) to:CGPointMake(748, 640)];
    
    [self drawLineFrom:CGPointMake(20, 680) to:CGPointMake(748, 680)];
    
    [self drawLineFrom:CGPointMake(20, 720) to:CGPointMake(748, 720)];
    [self drawLineFrom:CGPointMake(20, 760) to:CGPointMake(748, 760)];
    [self drawLineFrom:CGPointMake(20, 800) to:CGPointMake(748, 800)];
    [self drawLineFrom:CGPointMake(20, 840) to:CGPointMake(748, 840)];
    [self drawLineFrom:CGPointMake(20, 880) to:CGPointMake(748, 880)];
    [self drawLineFrom:CGPointMake(20, 920) to:CGPointMake(748, 920)];
    [self drawLineFrom:CGPointMake(20, 960) to:CGPointMake(748, 960)];
    [self drawLineFrom:CGPointMake(20, 1000) to:CGPointMake(748, 1000)];
    [self drawLineFrom:CGPointMake(20, 1040) to:CGPointMake(748, 1040)];
    [self drawLineFrom:CGPointMake(20, 1080) to:CGPointMake(748, 1080)];
    [self drawLineFrom:CGPointMake(20, 1120) to:CGPointMake(748, 1120)];
    [self drawLineFrom:CGPointMake(20, 1160) to:CGPointMake(748, 1160)];
    [self drawLineFrom:CGPointMake(20, 1200) to:CGPointMake(748, 1200)];
    [self drawLineFrom:CGPointMake(20, 1240) to:CGPointMake(748, 1240)];
    [self drawLineFrom:CGPointMake(20, 1280) to:CGPointMake(748, 1280)];
    [self drawLineFrom:CGPointMake(20, 1320) to:CGPointMake(748, 1320)];
    
    [self drawLineFrom:CGPointMake(170, 40) to:CGPointMake(170, 560)];
    
    [self drawLineFrom:CGPointMake(170, 560) to:CGPointMake(170, 1380)];
    [self drawLineFrom:CGPointMake(384, 560) to:CGPointMake(384, 600)];
    [self drawLineFrom:CGPointMake(534, 560) to:CGPointMake(534, 600)];
    [self drawLineFrom:CGPointMake(384, 160) to:CGPointMake(384, 240)];
    [self drawLineFrom:CGPointMake(534, 160) to:CGPointMake(534, 240)];
    [self drawLineFrom:CGPointMake(384, 640) to:CGPointMake(384, 680)];
    [self drawLineFrom:CGPointMake(534, 640) to:CGPointMake(534, 680)];
    [self drawLineFrom:CGPointMake(384, 720) to:CGPointMake(384, 760)];
    [self drawLineFrom:CGPointMake(534, 720) to:CGPointMake(534, 760)];
    [self drawLineFrom:CGPointMake(384, 800) to:CGPointMake(384, 880)];
    [self drawLineFrom:CGPointMake(534, 800) to:CGPointMake(534, 880)];
    [self drawLineFrom:CGPointMake(384, 1040) to:CGPointMake(384, 1080)];
    [self drawLineFrom:CGPointMake(534, 1040) to:CGPointMake(534, 1080)];
    [self drawLineFrom:CGPointMake(384, 1120) to:CGPointMake(384, 1160)];
    [self drawLineFrom:CGPointMake(534, 1120) to:CGPointMake(534, 1160)];
    [self drawLineFrom:CGPointMake(384, 1200) to:CGPointMake(384, 1320)];
    [self drawLineFrom:CGPointMake(534, 1200) to:CGPointMake(534, 1320)];
}


@end
