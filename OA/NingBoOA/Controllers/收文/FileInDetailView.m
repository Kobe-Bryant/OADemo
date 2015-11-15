//
//  FileInDetailView.m
//  NingBoOA
//
//  Created by 熊熙 on 13-9-17.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "FileInDetailView.h"
#import "UIView+ZXQuartz.h"
@implementation FileInDetailView

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
    
    [self drawFrameRectangele:CGRectMake(20, 70, 728, 960)];
    
    [self drawFillRectangel:CGRectMake(21, 71, 140, 959)];
    [self drawFillRectangel:CGRectMake(385, 151, 140, 230)];
    [self drawFillRectangel:CGRectMake(385, 761, 140, 120)];
    
    
    [self drawLineFrom:CGPointMake(20, 110) to:CGPointMake(748, 110)];
    
    [self drawLineFrom:CGPointMake(20, 150) to:CGPointMake(748, 150)];
    
    [self drawLineFrom:CGPointMake(20, 190) to:CGPointMake(748, 190)];
    
    [self drawLineFrom:CGPointMake(20, 230) to:CGPointMake(748, 230)];
    
    [self drawLineFrom:CGPointMake(20, 380) to:CGPointMake(748, 380)];
    
    [self drawLineFrom:CGPointMake(20, 530) to:CGPointMake(748, 530)];
    
    [self drawLineFrom:CGPointMake(20, 680) to:CGPointMake(748, 680)];
    
    [self drawLineFrom:CGPointMake(20, 720) to:CGPointMake(748, 720)];
    
    [self drawLineFrom:CGPointMake(20, 760) to:CGPointMake(748, 760)];
    
    [self drawLineFrom:CGPointMake(20, 800) to:CGPointMake(748, 800)];
    
    [self drawLineFrom:CGPointMake(20, 840) to:CGPointMake(748, 840)];
    
    [self drawLineFrom:CGPointMake(20, 880) to:CGPointMake(748, 880)];
    
    [self drawLineFrom:CGPointMake(161, 70) to:CGPointMake(161, 1030)];
    [self drawLineFrom:CGPointMake(384, 150) to:CGPointMake(384, 380)];
    [self drawLineFrom:CGPointMake(524, 150) to:CGPointMake(524, 380)];
    [self drawLineFrom:CGPointMake(384, 760) to:CGPointMake(384, 880)];
    [self drawLineFrom:CGPointMake(524, 760) to:CGPointMake(524, 880)];
}


@end
