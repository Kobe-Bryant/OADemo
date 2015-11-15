//
//  IMTWebView.h
//  webkittest
//
//  Created by Petr Dvorak on 11/23/11.
//  Copyright (c) 2011 Inmite. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TaoBaoWebView;

@protocol TaoBaoWebViewProgressDelegate <NSObject>
@optional
- (void) webView:(TaoBaoWebView*)webView didReceiveResourceNumber:(int)resourceNumber totalResources:(int)totalResources;
@end

@interface TaoBaoWebView : UIWebView {

}

@property (nonatomic, assign) BOOL isFinished;
@property (nonatomic, assign) int resourceCount;
@property (nonatomic, assign) int resourceCompletedCount;

@property (nonatomic, assign) id<TaoBaoWebViewProgressDelegate> progressDelegate;

@end
