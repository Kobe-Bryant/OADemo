//
//  ShowWebViewController.h
//  NingBoOA
//
//  Created by ZHONGWEN on 13-11-25.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaoBaoWebView.h"
#import "ChromeProgressBar.h"
#import "MBProgressHUD.h"
@interface ShowWebViewController : UIViewController<TaoBaoWebViewProgressDelegate> {
    TaoBaoWebView  *_webView;
    ChromeProgressBar *_chromeBar;
    MBProgressHUD *HUD;
    NSString *_urlString;
}

@property (strong, nonatomic) NSString *urlString;

- (id)initWithURLString:(NSString *)url Title:(NSString *)title;

@end
