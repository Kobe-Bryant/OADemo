//
//  FileInDetailView.m
//  NingBoOA
//
//  Created by 熊熙 on 13-9-17.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "ProjectTableDetailView.h"
#import "UIView+ZXQuartz.h"
@implementation ProjectTableDetailView

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
    
    [self drawFrameRectangele:CGRectMake(20, 70, 728, 890)];
    
    [self drawFillRectangel:CGRectMake(21, 71, 138, 888)];
    
    [self drawFillRectangel:CGRectMake(385, 71, 138, 118)];
    
    [self drawFillRectangel:CGRectMake(385, 461, 138, 38)];
    
    [self drawFillRectangel:CGRectMake(385, 541, 138, 38)];
    [self drawFillRectangel:CGRectMake(385, 731, 138, 78)];
    
    [self drawLineFrom:CGPointMake(20, 110) to:CGPointMake(748, 110)];
    
    [self drawLineFrom:CGPointMake(20, 150) to:CGPointMake(748, 150)];
    
    [self drawLineFrom:CGPointMake(20, 190) to:CGPointMake(748, 190)];
    
    [self drawLineFrom:CGPointMake(20, 340) to:CGPointMake(748, 340)];
    
    [self drawLineFrom:CGPointMake(20, 380) to:CGPointMake(748, 380)];
    
    [self drawLineFrom:CGPointMake(20, 460) to:CGPointMake(748, 460)];
    
    [self drawLineFrom:CGPointMake(20, 500) to:CGPointMake(748, 500)];
    
    [self drawLineFrom:CGPointMake(20, 540) to:CGPointMake(748, 540)];
    
    [self drawLineFrom:CGPointMake(20, 580) to:CGPointMake(748, 580)];
    
    [self drawLineFrom:CGPointMake(20, 730) to:CGPointMake(748, 730)];
    
    [self drawLineFrom:CGPointMake(20, 770) to:CGPointMake(748, 770)];
    
    [self drawLineFrom:CGPointMake(20, 810) to:CGPointMake(748, 810)];
    
    [self drawLineFrom:CGPointMake(160, 70) to:CGPointMake(160, 960)];
    
    [self drawLineFrom:CGPointMake(384, 70) to:CGPointMake(384, 190)];
    [self drawLineFrom:CGPointMake(524, 70) to:CGPointMake(524, 190)];
    
    [self drawLineFrom:CGPointMake(384, 460) to:CGPointMake(384, 500)];
    [self drawLineFrom:CGPointMake(524, 460) to:CGPointMake(524, 500)];
    
    [self drawLineFrom:CGPointMake(384, 540) to:CGPointMake(384, 580)];
    [self drawLineFrom:CGPointMake(524, 540) to:CGPointMake(524, 580)];

    [self drawLineFrom:CGPointMake(384, 730) to:CGPointMake(384, 810)];
    [self drawLineFrom:CGPointMake(524, 730) to:CGPointMake(524, 810)];
}


@end
