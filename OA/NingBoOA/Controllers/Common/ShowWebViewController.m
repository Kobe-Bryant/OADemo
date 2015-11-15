//
//  ShowWebViewController.m
//  NingBoOA
//
//  Created by ZHONGWEN on 13-11-25.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "ShowWebViewController.h"

#import "PrettyKit.h"
#import "UICustomButton.h"
#import "MBProgressHUD.h"
@interface ShowWebViewController ()

@end

@implementation ShowWebViewController
@synthesize urlString = _urlString;

- (id)initWithURLString:(NSString *)url Title:(NSString *)title {

    self = [super init];
    if (self) {
        _urlString = url;
        self.title = title;
    }
    
    return self;
    
}

- (void)onBackClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UIWebViewDelegate methods
//网页中返回上一页
- (void)goBack:(UIBarButtonItem *)sender {
    if (_webView.canGoBack) {
        [_webView goBack];
    }
}

- (void)goForward:(UIBarButtonItem *)sender  {
    if (_webView.canGoForward) {
        [_webView goForward];
    }
}

- (void)webView:(TaoBaoWebView *)webView didReceiveResourceNumber:(int)resourceNumber totalResources:(int)totalResources {
    //Set progress value
    
    if (totalResources != 1 ) {
        [_chromeBar setProgress:((float)resourceNumber) / ((float)totalResources) animated:NO];
        //Reset resource count after finished
        if (resourceNumber == totalResources  ) {
            //请求结束状态栏隐藏网络活动标志：
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            if (HUD) {
                [HUD hide:YES];
            }
            webView.resourceCount = 0;
            webView.resourceCompletedCount = 0;
        }
        
    }
}

- (void)startRequest{
    
    //在向服务端发送请求状态栏显示网络活动标志：
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    if (_chromeBar) {
        UIView* subview = (UIView*)_chromeBar;
        [subview removeFromSuperview];
    }
    
    _chromeBar = [[ChromeProgressBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 4.0f)];
    
    [self.view addSubview:_chromeBar];
    
    NSString *urlAddress = _urlString;
    
    NSURL *url = [NSURL URLWithString:urlAddress];
    
    NSURLRequest *resquestobj=[NSURLRequest requestWithURL:url];
    
    [_webView loadRequest:resquestobj];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText = @"正在加载";
    [HUD show:YES];
    [self.view addSubview:HUD];
}


- (NSURLRequest *)requestCache:(NSString *)url {
    if ([url length] == 0) {
        NSLog(@"Nil or empty URL is given");
    }
    //NSLog(@"url:%@", url);
    NSURLCache *urlCache = [NSURLCache sharedURLCache];
    
    //设置缓存的大小为1M
    [urlCache setMemoryCapacity:1*1024*1024];
    
    //创建一个请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.f];
    
    //从请求中获取缓存输出
    NSCachedURLResponse *response = [urlCache cachedResponseForRequest:request];
    
    //判断是否有缓存
    if (response != nil) {
        NSLog(@"如果有缓存输出, 从缓存获取数据");
        [request setCachePolicy:NSURLRequestReturnCacheDataDontLoad];
    }
    return request;
    
}

- (void)loadView{
    
    [super loadView];
    UIBarButtonItem *backItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"返回"];
    self.navigationItem.leftBarButtonItem = backItem;
    UIButton *backButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
    [backButton addTarget:self action:@selector(onBackClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat height = self.view.bounds.size.height;
    
    _webView = [[TaoBaoWebView alloc] initWithFrame:CGRectMake(0.0, 0.0, 768.0, height -44.0)];
    _webView.progressDelegate = self;
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
    
    
    PrettyToolbar *bottomTool = [[PrettyToolbar alloc] initWithFrame:CGRectMake(0.0, height -44.0, 768, 44.0)];
    
    UIButton *backwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backwardButton setImage:[UIImage imageNamed:@"backward_Tool"] forState:UIControlStateNormal];
    [backwardButton setFrame:CGRectMake(0.0, 0.0, 24.0, 22.0)];
    [backwardButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIButton *forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [forwardButton setImage:[UIImage imageNamed:@"forward_Tool"] forState:UIControlStateNormal];
    [forwardButton setFrame:CGRectMake(0.0, 0.0, 24.0, 22.0)];
    [forwardButton addTarget:self action:@selector(goForward:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backwardItem = [[UIBarButtonItem alloc] initWithCustomView:backwardButton];
    
    UIBarButtonItem *forwardItem = [[UIBarButtonItem alloc] initWithCustomView:forwardButton];
    
    [bottomTool setItems:[NSArray arrayWithObjects:backwardItem, spaceItem, forwardItem, nil]];
    
    [self.view addSubview:bottomTool];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    //删除滚动条和阴影
    _webView.backgroundColor = [UIColor clearColor];
    for (UIView *aView in [_webView subviews])
    {
        if ([aView isKindOfClass:[UIScrollView class]]) {
            [(UIScrollView *)aView setShowsVerticalScrollIndicator:NO];
            for(UIView *shadowView in aView.subviews)
            {
                if ([shadowView isKindOfClass:[UIImageView class]]) {
                    shadowView.hidden = YES;
                }
            }
        }
    }
    [self startRequest];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)onDoneClick:(id)sender {
    
    
    
    [self dismissModalViewControllerAnimated:YES];
	  
}

@end
