//
//  WryGsxxDetailViewController.m
//  NingBoOA
//
//  Created by PowerData on 13-10-28.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "WryGsxxDetailViewController.h"
#import "NSStringUtil.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "WebDataParserHelper.h"

@interface WryGsxxDetailViewController ()
@property (nonatomic, strong) UIWebView *detailWebView;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic,assign) BOOL isLoading;
@property (nonatomic,strong) NSDictionary *detailDataDict;
@end

@implementation WryGsxxDetailViewController

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
    
    self.title = @"工商数据";
    
    self.detailWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)];
    self.detailWebView.delegate = self;
    [self.view addSubview:self.detailWebView];
    
    [self requestData];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData
{
    self.urlString = [ServiceUrlString generateMobileLawServiceUrl:@"TWryService.asmx"];
    NSString *params = [WebServiceHelper createParametersWithKey:@"mc" value:self.wrymc, nil];
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:self.urlString method:@"QueryWryGsxx" nameSpace:@"http://tempuri.org/" parameters:params delegate:self];
    self.isLoading = YES;
    [self.webServiceHelper runAndShowWaitingView:self.view];
}

// -------------------------------------------------------------------------------
//	实现NSURLConnHelperDelegate委托方法
//  处理网络请求的NSData数据
// -------------------------------------------------------------------------------

-(void)processWebData:(NSData*)webData
{
    if([webData length] <=0)
    {
        [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
    }
    WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:@"string" andWithJSONDelegate:self];
    [webDataHelper parseJSONData:webData];
}

// -------------------------------------------------------------------------------
//	实现NSURLConnHelperDelegate委托方法
//  处理网络请求失败
// -------------------------------------------------------------------------------

-(void)processError:(NSError *)error
{
    self.isLoading = NO;
    [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
}

// -------------------------------------------------------------------------------
//	实现WebDataParserDelegate委托方法
//  解析json字符串
// -------------------------------------------------------------------------------

- (void)parseJSONString:(NSString *)jsonStr
{
    self.isLoading = NO;
    NSDictionary *tmpParsedJsonDict = [jsonStr objectFromJSONString];
    
    BOOL bParseError = NO;
    if (tmpParsedJsonDict && jsonStr.length > 0)
    {
        self.detailDataDict = tmpParsedJsonDict;
        
        if([tmpParsedJsonDict allKeys].count > 0)
        {
            //替换HTML中的占位符
            NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"dd" ofType:@"html"];
            NSMutableString *html = [[NSMutableString alloc] initWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
            for(NSString *key in [self.detailDataDict allKeys])
            {
                NSString *oldValue;
                if([self.detailDataDict objectForKey:key] != nil)
                {
                    oldValue = [NSString stringWithFormat:@"%@", [self.detailDataDict objectForKey:key]];
                    if(oldValue.length > 10)
                    {
                        if ([key isEqualToString:@"CLRQ"] || [key isEqualToString:@"HZRQ"] || [key isEqualToString:@"JYQSRQ"] || [key isEqualToString:@"JYJZRQ"])
                        {
                            oldValue = [oldValue substringToIndex:10];
                        }
                    }
                }
                else
                {
                    oldValue = @"";
                }
                NSString *newKey = [NSString stringWithFormat:@"t_%@_t", key];
                NSRange range = [html rangeOfString:newKey];
                if (range.location != NSNotFound)
                {
                    [html replaceOccurrencesOfString:newKey withString:oldValue options:NSCaseInsensitiveSearch range:NSMakeRange(0, html.length)];
                }
            }
            [self.detailWebView loadHTMLString:html baseURL:nil];
        }
        else
        {
            [self.detailWebView loadHTMLString:@"<br/><br/><br/><br/><center>暂无相关数据</center>" baseURL:nil];
        }
    }
    else
    {
        bParseError = YES;
    }
    
    if (bParseError)
    {
        [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
    }
}

#pragma mark - UIWebView Delegate Method

// -------------------------------------------------------------------------------
//	实现UIWebView Delegate委托方法
//  实现UIWebView展示数据的时候不会在数字网址下面加上下划线
// -------------------------------------------------------------------------------

- (void)webViewDidStartLoad:(UIWebView *)theWebView
{
    theWebView.dataDetectorTypes = UIDataDetectorTypeNone;
}

@end
