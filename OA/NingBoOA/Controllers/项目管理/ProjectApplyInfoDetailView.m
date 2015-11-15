//
//  FileInDetailView.m
//  NingBoOA
//
//  Created by 熊熙 on 13-9-17.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "ProjectApplyInfoDetailView.h"
#import "UIView+ZXQuartz.h"
@implementation ProjectApplyInfoDetailView

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
    
    [self drawFrameRectangele:CGRectMake(20, 0, 728, 400)];
    
    [self drawFillRectangel:CGRectMake(21, 1, 726, 38)];
    
    [self drawFillRectangel:CGRectMake(21, 41, 138, 398)];
    [self drawFillRectangel:CGRectMake(385, 121, 138, 38)];
//    [self drawFillRectangel:CGRectMake(21, 121, 726, 38)];
//    [self drawFillRectangel:CGRectMake(385, 161, 138, 38)];
    [self drawFillRectangel:CGRectMake(385, 201, 138, 38)];
//    [self drawFillRectangel:CGRectMake(21, 241, 726, 38)];
    
    
    [self drawLineFrom:CGPointMake(20, 40) to:CGPointMake(748, 40)];
    
    [self drawLineFrom:CGPointMake(20, 80) to:CGPointMake(748, 80)];
    
    [self drawLineFrom:CGPointMake(20, 120) to:CGPointMake(748, 120)];
    
    [self drawLineFrom:CGPointMake(20, 160) to:CGPointMake(748, 160)];
    
    [self drawLineFrom:CGPointMake(20, 200) to:CGPointMake(748, 200)];
    
    [self drawLineFrom:CGPointMake(20, 240) to:CGPointMake(748, 240)];
    
    [self drawLineFrom:CGPointMake(20, 400) to:CGPointMake(748, 400)];
    
    

//    
//    [self drawLineFrom:CGPointMake(20, 710) to:CGPointMake(748, 710)];
//    
//    [self drawLineFrom:CGPointMake(20, 860) to:CGPointMake(748, 860)];
//    
//    [self drawLineFrom:CGPointMake(20, 900) to:CGPointMake(748, 900)];
//    
//    [self drawLineFrom:CGPointMake(20, 940) to:CGPointMake(748, 940)];
    
    [self drawLineFrom:CGPointMake(160, 40) to:CGPointMake(160, 440)];
    [self drawLineFrom:CGPointMake(384, 120) to:CGPointMake(384, 160)];
    [self drawLineFrom:CGPointMake(524, 120) to:CGPointMake(524, 160)];
    [self drawLineFrom:CGPointMake(384, 200) to:CGPointMake(384, 240)];
    [self drawLineFrom:CGPointMake(524, 200) to:CGPointMake(524, 240)];

    
//    [self drawLineFrom:CGPointMake(160, 320) to:CGPointMake(160, 630)];
//    [self drawLineFrom:CGPointMake(384, 360) to:CGPointMake(384, 400)];
//    [self drawLineFrom:CGPointMake(524, 360) to:CGPointMake(524, 400)];
//    [self drawLineFrom:CGPointMake(384, 400) to:CGPointMake(384, 480)];
//    [self drawLineFrom:CGPointMake(524, 400) to:CGPointMake(524, 480)];
//    
//    [self drawLineFrom:CGPointMake(160, 670) to:CGPointMake(160, 1140)];
//    [self drawLineFrom:CGPointMake(384, 670) to:CGPointMake(384, 750)];
//    [self drawLineFrom:CGPointMake(524, 670) to:CGPointMake(524, 750)];
//    
//    [self drawLineFrom:CGPointMake(384, 790) to:CGPointMake(384, 990)];
//    [self drawLineFrom:CGPointMake(524, 790) to:CGPointMake(524, 990)];
//    [self drawLineFrom:CGPointMake(384, 590) to:CGPointMake(384, 710)];
//    [self drawLineFrom:CGPointMake(524, 590) to:CGPointMake(524, 710)];
//    [self drawLineFrom:CGPointMake(384, 860) to:CGPointMake(384, 940)];
//    [self drawLineFrom:CGPointMake(524, 860) to:CGPointMake(524, 940)];
}


@end
