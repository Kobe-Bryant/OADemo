//
//  FileInDetailView.m
//  NingBoOA
//
//  Created by 熊熙 on 13-9-17.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "FileDetailView.h"
#import "UIView+ZXQuartz.h"
@implementation FileDetailView

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
    
    [self drawFrameRectangele:CGRectMake(20, 20, 728, 240)];
    
    [self drawFillRectangel:CGRectMake(21, 21, 140, 238)];
    [self drawFillRectangel:CGRectMake(385, 101, 140, 158)];
    
    
    [self drawLineFrom:CGPointMake(20, 100) to:CGPointMake(748, 100)];
    
    [self drawLineFrom:CGPointMake(20, 140) to:CGPointMake(748, 140)];
    
    [self drawLineFrom:CGPointMake(20, 180) to:CGPointMake(748, 180)];
    
    [self drawLineFrom:CGPointMake(20, 220) to:CGPointMake(748, 220)];
    
    
    
    [self drawLineFrom:CGPointMake(161, 20) to:CGPointMake(161, 260)];
    
    [self drawLineFrom:CGPointMake(384, 100) to:CGPointMake(384, 260)];
    [self drawLineFrom:CGPointMake(524, 100) to:CGPointMake(524, 260)];

}

@end
