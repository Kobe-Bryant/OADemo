//
//  EmergencyExpertViewController.m
//  NingBoOA
//
//  Created by PowerData on 13-11-6.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "EmergencyExpertViewController.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "UICustomButton.h"
#import "WebServiceHelper.h"
#import "WebDataParserHelper.h"

@interface EmergencyExpertViewController ()
@property (nonatomic, strong) UIWebView *detailWebView;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) UISearchBar *searchBar;
@end

@implementation EmergencyExpertViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"环境事故应急专家库";
    UIBarButtonItem *backItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"返回"];
    self.navigationItem.leftBarButtonItem = backItem;
    UIButton *backButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
    [backButton addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    self.detailWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)];
    self.detailWebView.delegate = self;
    [self.view addSubview:self.detailWebView];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 0.0)];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"请输入专家的名字";
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:_searchBar];
    self.navigationItem.rightBarButtonItem = searchItem;
    
    [self requestEmergencyExpertData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获取污染物排放汇总数据
- (void)requestEmergencyExpertData
{
    self.urlString = [ServiceUrlString generateMobileLawServiceUrl:@"TWryService.asmx"];
    NSString *params = [WebServiceHelper createParametersWithKey:@"pageSize" value:@"1000", nil];
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:self.urlString method:@"GetHjyjZjkList" nameSpace:@"http://tempuri.org/" parameters:params delegate:self];
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
    [self loadEmergencyHtml:jsonStr];
}

- (void)goBackAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadEmergencyHtml:(NSString *)jsonStr
{
    self.isLoading = NO;
    NSDictionary *tmpParsedJsonDict = [jsonStr objectFromJSONString];
    BOOL bParseError = NO;
    if (tmpParsedJsonDict && jsonStr.length > 0)
    {
        if([[tmpParsedJsonDict objectForKey:@"total"] intValue] <= 0)
        {
            //没有数据的情况
            NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"emergency" ofType:@"html"];
            NSMutableString *html = [[NSMutableString alloc] initWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
            [html replaceOccurrencesOfString:@"t_LIST_t" withString:@"<tr><td colspan=\"8\">暂无数据</td></tr>" options:NSCaseInsensitiveSearch range:NSMakeRange(0, html.length)];
            [self.detailWebView loadHTMLString:html baseURL:nil];
            return;
        }
        else
        {
            //替换HTML中的占位符
            NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"emergency" ofType:@"html"];
            NSMutableString *html = [[NSMutableString alloc] initWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
            
            NSMutableString *content = [[NSMutableString alloc] init];
            NSArray *ary = [tmpParsedJsonDict objectForKey:@"rows"];
            if(ary.count > 0)
            {
                for (int i = 0; i < ary.count; i++)
                {
                    NSDictionary *tt = [ary objectAtIndex:i];
                    [content appendFormat:@"%@", @"<tr>"];
                    [content appendFormat:@"<td>%@</td>", [tt objectForKey:@"MC"]];
                    [content appendFormat:@"<td>%@</td>", [tt objectForKey:@"DANWEI"]];
                    [content appendFormat:@"<td>%@</td>", [tt objectForKey:@"WORK"]];
                    [content appendFormat:@"<td>%@</td>", [tt objectForKey:@"SHANCHANG"]];
                    [content appendFormat:@"<td>%@</td>", [tt objectForKey:@"POSITION"]];
                    [content appendFormat:@"<td>%@</td>", [tt objectForKey:@"WORK_PHONE"]];
                    [content appendFormat:@"<td>%@</td>", [tt objectForKey:@"TELEPHONE"]];
                    [content appendFormat:@"%@", @"</tr>"];
                }
            }
            else
            {
                [content appendFormat:@"%@", @"<tr><td colspan=\"8\">暂无数据</td></tr>"];
            }
            
            [html replaceOccurrencesOfString:@"t_LIST_t" withString:content options:NSCaseInsensitiveSearch range:NSMakeRange(0, html.length)];
            [self.detailWebView loadHTMLString:html baseURL:nil];
        }
    }
    else
    {
        bParseError = YES;
    }
    if (bParseError)
    {
        //替换HTML中的占位符
        NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"emergency" ofType:@"html"];
        NSMutableString *html = [[NSMutableString alloc] initWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
        [html replaceOccurrencesOfString:@"t_LIST_t" withString:@"<tr><td colspan=\"8\">暂无数据</td></tr>" options:NSCaseInsensitiveSearch range:NSMakeRange(0, html.length)];
        [self.detailWebView loadHTMLString:html baseURL:nil];
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

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //查询数据
    NSString *key = searchText;
    self.urlString = [ServiceUrlString generateMobileLawServiceUrl:@"TWryService.asmx"];
    NSString *params = [WebServiceHelper createParametersWithKey:@"pageSize" value:@"99999", @"zjmc", key, nil];
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:self.urlString method:@"GetHjyjZjkList" nameSpace:@"http://tempuri.org/" parameters:params delegate:self];
    self.isLoading = YES;
    [self.webServiceHelper runAndShowWaitingView:self.view];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
}

@end
