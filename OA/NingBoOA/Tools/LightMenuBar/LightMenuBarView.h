//
//  LightMenuBarView.h
//  LightMenuBar
//
//  Created by Haoxiang on 6/10/11.
//  Copyright 2011 DEV. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LightMenuBar;
@protocol LightMenuBarDelegate;

@interface LightMenuBarView : UIView {

    __weak id<LightMenuBarDelegate> _delegate;
    NSUInteger _selectedItemIndex;
    
    __weak  LightMenuBar *_menuBar; //< Weak Reference
    
    //< Parameters
    NSUInteger itemCount;
    
    CGFloat vPadding;
    CGFloat hPadding;
    CGFloat backgroundRad;
    CGFloat buttonRad;
    CGFloat sepWidth;
    CGFloat sepHeightRate;
    
    UIColor *backgoundColor;
    UIColor *buttonHighlightColor;
    UIColor *titleHighlightColor;
    UIColor *titleNormalColor;
    UIColor *sepColor;
    
    UIFont *titleFont;
    
    BOOL autoWidth;
    CGFloat averWidth;
    CGRect bkgrdRect;
    
//    int barAnimation;
}

@property (nonatomic, weak) LightMenuBar *menuBar;
@property (nonatomic, assign) NSUInteger selectedItemIndex;
@property (nonatomic, weak) id<LightMenuBarDelegate> delegate;

- (CGFloat)barLength;
- (void)fillParams;
- (void)render;
- (void)blink;

@end
