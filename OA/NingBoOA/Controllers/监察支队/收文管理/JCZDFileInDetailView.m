//
//  FileInDetailView.m
//  NingBoOA
//
//  Created by 熊熙 on 13-9-17.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "JCZDFileInDetailView.h"
#import "UIView+ZXQuartz.h"
@implementation JCZDFileInDetailView

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
    
    [self drawFrameRectangele:CGRectMake(20, 70, 728, 810)];
    
    [self drawFillRectangel:CGRectMake(21, 71, 140, 809)];
    [self drawFillRectangel:CGRectMake(385, 151, 140, 230)];
    [self drawFillRectangel:CGRectMake(385, 611, 140, 120)];
    
    
    [self drawLineFrom:CGPointMake(20, 220) to:CGPointMake(748, 220)];
    
    [self drawLineFrom:CGPointMake(20, 260) to:CGPointMake(748, 260)];
    
    [self drawLineFrom:CGPointMake(20, 300) to:CGPointMake(748, 300)];
    
    [self drawLineFrom:CGPointMake(20, 340) to:CGPointMake(748, 340)];
    
    [self drawLineFrom:CGPointMake(20, 380) to:CGPointMake(748, 380)];
    
    
    [self drawLineFrom:CGPointMake(20, 530) to:CGPointMake(748, 530)];
    
    
    [self drawLineFrom:CGPointMake(20, 570) to:CGPointMake(748, 570)];
    
    [self drawLineFrom:CGPointMake(20, 610) to:CGPointMake(748, 610)];
    
    [self drawLineFrom:CGPointMake(20, 650) to:CGPointMake(748, 650)];
    
    [self drawLineFrom:CGPointMake(20, 690) to:CGPointMake(748, 690)];
    
    [self drawLineFrom:CGPointMake(20, 730) to:CGPointMake(748, 730)];
    
    [self drawLineFrom:CGPointMake(161, 70) to:CGPointMake(161, 880)];
    [self drawLineFrom:CGPointMake(384, 150) to:CGPointMake(384, 380)];
    [self drawLineFrom:CGPointMake(524, 150) to:CGPointMake(524, 380)];
    [self drawLineFrom:CGPointMake(384, 610) to:CGPointMake(384, 730)];
    [self drawLineFrom:CGPointMake(524, 610) to:CGPointMake(524, 730)];
}


@end
