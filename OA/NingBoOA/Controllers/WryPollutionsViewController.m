//
//  WryPollutionsViewController.m
//  NingBoOA
//
//  Created by zengjing on 13-10-19.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "WryPollutionsViewController.h"
#import "UITableViewCell+Custom.h"

@interface WryPollutionsViewController ()
@property (nonatomic, strong) UIWebView *detailWebView;
@end

@implementation WryPollutionsViewController

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
    
    NSArray *itemTitleArray = [[NSArray alloc] initWithObjects:@"数据汇总", @"废水污染物", @"废气污染物", nil];
    UISegmentedControl *titleSegment = [[UISegmentedControl alloc] initWithItems:itemTitleArray];
    titleSegment.segmentedControlStyle = UISegmentedControlStyleBar;
    titleSegment.selectedSegmentIndex = 0;
    [titleSegment addTarget:self action:@selector(onTitleClick:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = titleSegment;
    
    /*UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)];
    bgImageView.image = [UIImage imageNamed:@"bg.png"];
    [self.view addSubview:bgImageView];*/
    
    self.detailWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)];
    [self.view addSubview:self.detailWebView];
    
    //默认加载
    NSString *path = [[NSBundle mainBundle] pathForResource:@"xx" ofType:@"html"];
    NSString *content = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self.detailWebView loadHTMLString:content baseURL:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onTitleClick:(UISegmentedControl *)sender
{
    if(sender.selectedSegmentIndex == 0)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"xx" ofType:@"html"];
        NSString *content = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        [self.detailWebView loadHTMLString:content baseURL:nil];
    }
    else if(sender.selectedSegmentIndex == 1)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"yy" ofType:@"html"];
        NSMutableString *content = [[NSMutableString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        [content replaceOccurrencesOfString:@"t_TITLE_t" withString:@"废水污染物排放量（吨）" options:NSCaseInsensitiveSearch range:NSMakeRange(0, content.length)];
        [self.detailWebView loadHTMLString:content baseURL:nil];
    }
    else
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"yy" ofType:@"html"];
        NSMutableString *content = [[NSMutableString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        [content replaceOccurrencesOfString:@"t_TITLE_t" withString:@"废气污染物排放量（吨）" options:NSCaseInsensitiveSearch range:NSMakeRange(0, content.length)];
        [self.detailWebView loadHTMLString:content baseURL:nil];
    }
}

@end
