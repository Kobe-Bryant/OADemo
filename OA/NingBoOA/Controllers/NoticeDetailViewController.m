//
//  NoticeDetailViewController.m
//  NingBoOA
//
//  Created by PowerData on 13-10-16.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "NoticeDetailViewController.h"

@interface NoticeDetailViewController ()

@end

@implementation NoticeDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)loadHtml
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"detail" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    [self.detailWebView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadHtml];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setDetailWebView:nil];
    [super viewDidUnload];
}
@end
