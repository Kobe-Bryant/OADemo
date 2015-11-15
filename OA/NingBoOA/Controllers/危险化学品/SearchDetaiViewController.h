//
//  SearchDetaiViewController.h
//  handbook
//
//  Created by chen on 11-4-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchViewController;

@interface SearchDetaiViewController : UIViewController <UIWebViewDelegate>
{
	IBOutlet UIWebView *webView;
	NSDictionary *titleDic; //理化参数
    NSArray *tableColumn;
}

@property(nonatomic,strong) UIWebView *webView;
@property(nonatomic,strong) NSDictionary *titleDic;

@end
