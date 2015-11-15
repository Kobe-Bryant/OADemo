//
//  WryMaterialViewController.m
//  NingBoOA
//
//  Created by zengjing on 13-10-19.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "WryMaterialViewController.h"

@interface WryMaterialViewController ()
@property (nonatomic, strong) UIWebView *detailWebView;
@end

@implementation WryMaterialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"产品原辅料情况";
    
    self.detailWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)];
    [self.view addSubview:self.detailWebView];
    
    //默认加载
    NSString *path = [[NSBundle mainBundle] pathForResource:@"bb" ofType:@"html"];
    NSString *content = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self.detailWebView loadHTMLString:content baseURL:nil];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
