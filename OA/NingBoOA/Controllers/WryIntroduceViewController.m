//
//  WryIntroduceViewController.m
//  NingBoOA
//
//  Created by zengjing on 13-10-19.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "WryIntroduceViewController.h"
#import "NSStringUtil.h"
#import "UITableViewCell+Custom.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "WebDataParserHelper.h"
#import "UICustomButton.h"

@interface WryIntroduceViewController ()
@property (nonatomic, strong) UIWebView *detailWebView;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic,assign) BOOL isLoading;
@property (nonatomic,strong) NSDictionary *detailDataDict;
@property (nonatomic,strong) UISegmentedControl *myTitleSegmentCtrl;
@property (nonatomic,strong) LightMenuBar *myLightMenuBar;
@property (nonatomic,strong) NSArray *titleAry;
@end

@implementation WryIntroduceViewController
@synthesize myLightMenuBar;

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
    
    self.title = self.wrybh;
    UIBarButtonItem *backItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"返回"];
    self.navigationItem.leftBarButtonItem = backItem;
    UIButton *backButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
    [backButton addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    self.titleAry = [[NSArray alloc] initWithObjects:@"企业概况", @"主要产品", @"原辅材料", @"废水污染物", @"废气污染物", @"工商数据", nil];

    self.myLightMenuBar = [[LightMenuBar alloc] initWithFrame:CGRectMake(0, 0, 768, 74) andStyle:LightMenuBarStyleItem];
    myLightMenuBar.delegate = self;
    myLightMenuBar.selectedItemIndex = 0;
    [self.view addSubview:self.myLightMenuBar];
    
    self.detailWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 74, 768, 960-74)];
    self.detailWebView.delegate = self;
    [self.view addSubview:self.detailWebView];
    
    [self requestIntroduceData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark LightMenuBarDelegate

- (NSUInteger)itemCountInMenuBar:(LightMenuBar *)menuBar
{
    return [self.titleAry count];
}

- (NSString *)itemTitleAtIndex:(NSUInteger)index inMenuBar:(LightMenuBar *)menuBar
{
    return [self.titleAry objectAtIndex:index];
}

- (void)itemSelectedAtIndex:(NSUInteger)index inMenuBar:(LightMenuBar *)menuBar
{
    switch (index) {
        case 0:
            [self requestIntroduceData];
            break;
        case 1:
            [self requestProductsData];
            break;
        case 2:
            [self requestMaterialsData];
            break;
        case 3:
            [self requestWaterPollutionsData];
            break;
        case 4:
            [self requestAirPollutionsData];
            break;
        case 5:
            [self requestGSXXData];
            break;
        default:
            break;
    }
}

#pragma mark - Network Handler Methods
//返回
- (void)goBackAction{
    [self.navigationController popViewControllerAnimated:YES];
}

//获取企业概况数据
- (void)requestIntroduceData
{
    self.urlString = [ServiceUrlString generateMobileLawServiceUrl:@"TWryService.asmx"];
    NSString *params = [WebServiceHelper createParametersWithKey:@"mc" value:self.wrybh, nil];
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:self.urlString method:@"QueryWry" nameSpace:@"http://tempuri.org/" parameters:params delegate:self];
    self.isLoading = YES;
    [self.webServiceHelper runAndShowWaitingView:self.view withTipInfo:@"正在加载，请稍候..."];
}

//获取产品数据
- (void)requestProductsData
{
    self.urlString = [ServiceUrlString generateMobileLawServiceUrl:@"TWryService.asmx"];
    NSString *params = [WebServiceHelper createParametersWithKey:@"pageSize" value:@"1000", @"mc", self.wrybh, nil];
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:self.urlString method:@"QueryWryCpList" nameSpace:@"http://tempuri.org/" parameters:params delegate:self];
    self.isLoading = YES;
    [self.webServiceHelper runAndShowWaitingView:self.view withTipInfo:@"正在加载，请稍候..."];
}

//获取原辅料数据
- (void)requestMaterialsData
{
    //QueryWryYfclList
    self.urlString = [ServiceUrlString generateMobileLawServiceUrl:@"TWryService.asmx"];
    NSString *params = [WebServiceHelper createParametersWithKey:@"mc" value:self.wrybh, nil];
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:self.urlString method:@"QueryWryYfclList" nameSpace:@"http://tempuri.org/" parameters:params delegate:self];
    self.isLoading = YES;
    [self.webServiceHelper runAndShowWaitingView:self.view withTipInfo:@"正在加载，请稍候..."];
    [self.detailWebView loadHTMLString:@"<br/><br/><br/><br/><center>暂无相关数据</center>" baseURL:nil];
}

//获取污染物排放汇总数据
- (void)requestPollutionsData
{
    //QueryWryHz
    self.urlString = [ServiceUrlString generateMobileLawServiceUrl:@"TWryService.asmx"];
    NSString *params = [WebServiceHelper createParametersWithKey:@"mc" value:self.wrybh, nil];
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:self.urlString method:@"QueryWryHz" nameSpace:@"http://tempuri.org/" parameters:params delegate:self];
    self.isLoading = YES;
    [self.webServiceHelper runAndShowWaitingView:self.view withTipInfo:@"正在加载，请稍候..."];
}

//获取废水污染物排放
- (void)requestWaterPollutionsData
{
    //QueryWryHz
    self.urlString = [ServiceUrlString generateMobileLawServiceUrl:@"TWryService.asmx"];
    NSString *params = [WebServiceHelper createParametersWithKey:@"mc" value:self.wrybh, nil];
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:self.urlString method:@"QueryFswryList" nameSpace:@"http://tempuri.org/" parameters:params delegate:self];
    self.isLoading = YES;
    [self.webServiceHelper runAndShowWaitingView:self.view withTipInfo:@"正在加载，请稍候..."];
}

//获取废气污染物排放
- (void)requestAirPollutionsData
{
    //QueryFqwryList
    self.urlString = [ServiceUrlString generateMobileLawServiceUrl:@"TWryService.asmx"];
    NSString *params = [WebServiceHelper createParametersWithKey:@"mc" value:self.wrybh, nil];
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:self.urlString method:@"QueryFqwryList" nameSpace:@"http://tempuri.org/" parameters:params delegate:self];
    self.isLoading = YES;
    [self.webServiceHelper runAndShowWaitingView:self.view withTipInfo:@"正在加载，请稍候..."];
}

//获取工商数据
- (void)requestGSXXData
{
    self.urlString = [ServiceUrlString generateMobileLawServiceUrl:@"TWryService.asmx"];
    NSString *params = [WebServiceHelper createParametersWithKey:@"mc" value:self.wrybh, nil];
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:self.urlString method:@"QueryWryGsxx" nameSpace:@"http://tempuri.org/" parameters:params delegate:self];
    self.isLoading = YES;
    [self.webServiceHelper runAndShowWaitingView:self.view withTipInfo:@"正在加载，请稍候..."];
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
    int index = self.myLightMenuBar.selectedItemIndex;
    switch (index) {
        case 0:
            [self loadIntroduceHtml:jsonStr];
            break;
        case 1:
            [self loadProductsHtml:jsonStr];
            break;
        case 2:
            [self loadMaterialsHtml:jsonStr];
            break;
        case 3:
            [self loadWaterPollutionsHtml:jsonStr];
            break;
        case 4:
            [self loadAirPollutionsHtml:jsonStr];
            break;
        case 5:
            [self loadGSXXHtml:jsonStr];
            break;
        default:
            break;
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

#pragma mark - Private Methods

//加载企业概况
- (void)loadIntroduceHtml:(NSString *)jsonStr
{
    self.isLoading = NO;
    NSDictionary *tmpParsedJsonDict = [jsonStr objectFromJSONString];
    BOOL bParseError = NO;
    if (tmpParsedJsonDict && jsonStr.length > 0)
    {
        self.detailDataDict = tmpParsedJsonDict;
        
        //替换HTML中的占位符
        NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"cc" ofType:@"html"];
        NSMutableString *html = [[NSMutableString alloc] initWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
        for(NSString *key in [self.detailDataDict allKeys])
        {
            NSString *oldValue;
            if([self.detailDataDict objectForKey:key] != nil)
            {
                oldValue = [NSString stringWithFormat:@"%@", [self.detailDataDict objectForKey:key]];
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
        bParseError = YES;
    }
    if (bParseError)
    {
        [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
    }
}

//加载主要产品
- (void)loadProductsHtml:(NSString *)jsonStr
{
    self.isLoading = NO;
    NSDictionary *tmpParsedJsonDict = [jsonStr objectFromJSONString];
    BOOL bParseError = NO;
    if (tmpParsedJsonDict && jsonStr.length > 0)
    {
        NSArray *listDataArray = [tmpParsedJsonDict objectForKey:@"rows"];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"aa" ofType:@"html"];
        NSMutableString *content = [[NSMutableString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        [content replaceOccurrencesOfString:@"t_WRYMC_t" withString:self.wrybh options:NSCaseInsensitiveSearch range:NSMakeRange(0, content.length)];
        if(listDataArray != nil && listDataArray.count > 0)
        {
            NSMutableString *dataStr = [[NSMutableString alloc] init];
            for (int i = 0; i < listDataArray.count; i++)
            {
                NSDictionary *dict = [listDataArray objectAtIndex:i];
                [dataStr appendFormat:@"%@", @"<tr height=\"30\">"];
                [dataStr appendFormat:@"<td>&nbsp;%@</td>", [dict objectForKey:@"SJNF"]];//年份
                [dataStr appendFormat:@"<td>&nbsp;%@</td>", [dict objectForKey:@"SJLY"]];//数据来源
                [dataStr appendFormat:@"<td>&nbsp;%@</td>", [dict objectForKey:@"CPMC"]];//产品名称
                [dataStr appendFormat:@"<td>&nbsp;%@</td>", [dict objectForKey:@"DWCPNHL"]];//生产能力
                [dataStr appendFormat:@"<td>&nbsp;%@</td>", [dict objectForKey:@"SHIJINCL"]];//实际产量
                [dataStr appendFormat:@"<td>&nbsp;%@</td>", [dict objectForKey:@"DW"]];//计量单位
                [dataStr appendFormat:@"%@", @"</tr>"];
            }
            [content replaceOccurrencesOfString:@"t_LIST_t" withString:dataStr options:NSCaseInsensitiveSearch range:NSMakeRange(0, content.length)];
            [self.detailWebView loadHTMLString:content baseURL:nil];
        }
        else
        {
            NSString *dataStr = @"<tr align=\"center\" height=\"30\"><td colspan=\"6\">暂无数据</td></tr>";
            [content replaceOccurrencesOfString:@"t_LIST_t" withString:dataStr options:NSCaseInsensitiveSearch range:NSMakeRange(0, content.length)];
            [self.detailWebView loadHTMLString:content baseURL:nil];
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

//加载原辅材料
- (void)loadMaterialsHtml:(NSString *)jsonStr
{
    self.isLoading = NO;
    NSDictionary *tmpParsedJsonDict = [jsonStr objectFromJSONString];
    BOOL bParseError = NO;
    if (tmpParsedJsonDict && jsonStr.length > 0)
    {
        NSArray *listDataArray = [tmpParsedJsonDict objectForKey:@"rows"];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"bb" ofType:@"html"];
        NSMutableString *content = [[NSMutableString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        [content replaceOccurrencesOfString:@"t_WRYMC_t" withString:self.wrybh options:NSCaseInsensitiveSearch range:NSMakeRange(0, content.length)];
        if(listDataArray != nil && listDataArray.count > 0)
        {
            NSMutableString *dataStr = [[NSMutableString alloc] init];
            for (int i = 0; i < listDataArray.count; i++)
            {
                NSDictionary *dict = [listDataArray objectAtIndex:i];
                [dataStr appendFormat:@"%@", @"<tr height=30>"];
                [dataStr appendFormat:@"<td>&nbsp;%@</td>", [dict objectForKey:@"SJNF"]];
                [dataStr appendFormat:@"<td>&nbsp;%@</td>", [dict objectForKey:@"SJLY"]];
                [dataStr appendFormat:@"<td>&nbsp;%@</td>", [dict objectForKey:@"YCLMC"]];
                [dataStr appendFormat:@"<td>&nbsp;%@</td>", [dict objectForKey:@"YL"]];
                [dataStr appendFormat:@"<td>&nbsp;%@</td>", [dict objectForKey:@"DW"]];
                [dataStr appendFormat:@"%@", @"</tr>"];
            }
            [content replaceOccurrencesOfString:@"t_LIST_t" withString:dataStr options:NSCaseInsensitiveSearch range:NSMakeRange(0, content.length)];
            [self.detailWebView loadHTMLString:content baseURL:nil];
        }
        else
        {
            NSString *dataStr = @"<tr align=\"center\" height=\"30\"><td colspan=\"5\">暂无数据</td></tr>";
            [content replaceOccurrencesOfString:@"t_LIST_t" withString:dataStr options:NSCaseInsensitiveSearch range:NSMakeRange(0, content.length)];
            [self.detailWebView loadHTMLString:content baseURL:nil];
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

//加载废水污染源物排放
- (void)loadWaterPollutionsHtml:(NSString *)jsonStr
{
    self.isLoading = NO;
    NSDictionary *tmpParsedJsonDict = [jsonStr objectFromJSONString];
    BOOL bParseError = NO;
    if (tmpParsedJsonDict && jsonStr.length > 0)
    {
        NSArray *listDataArray = [tmpParsedJsonDict objectForKey:@"rows"];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"yy" ofType:@"html"];
        NSMutableString *content = [[NSMutableString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        [content replaceOccurrencesOfString:@"t_WRWNAME_T" withString:@"废水" options:NSCaseInsensitiveSearch range:NSMakeRange(0, content.length)];
        [content replaceOccurrencesOfString:@"t_TITLE_t" withString:self.wrybh options:NSCaseInsensitiveSearch range:NSMakeRange(0, content.length)];
        if(listDataArray != nil && listDataArray.count > 0)
        {
            NSMutableString *dataStr = [[NSMutableString alloc] init];
            for (int i = 0; i < listDataArray.count; i++)
            {
                NSDictionary *dict = [listDataArray objectAtIndex:i];
                [dataStr appendFormat:@"%@", @"<tr>"];
                [dataStr appendFormat:@"<td>%@</td>", [dict objectForKey:@"WRWMC"]];
                [dataStr appendFormat:@"<td>%@</td>", [dict objectForKey:@"ND"]];
                [dataStr appendFormat:@"<td>%@</td>", [dict objectForKey:@"HJYXPJ"]];
                [dataStr appendFormat:@"<td>%@</td>", [dict objectForKey:@"STSYS"]];
                [dataStr appendFormat:@"<td>%@</td>", [dict objectForKey:@"PWXKZHD"]];
                [dataStr appendFormat:@"<td>%@</td>", [dict objectForKey:@"PCSJ"]];
                [dataStr appendFormat:@"<td>%@</td>", [dict objectForKey:@"HTSJ"]];
                [dataStr appendFormat:@"<td>%@</td>", [dict objectForKey:@"PWSJ"]];
                 [dataStr appendFormat:@"%@", @"</tr>"];
            }
            [content replaceOccurrencesOfString:@"t_LIST_t" withString:dataStr options:NSCaseInsensitiveSearch range:NSMakeRange(0, content.length)];
            [self.detailWebView loadHTMLString:content baseURL:nil];
        }
        else
        {
            NSString *dataStr = @"<tr align=\"center\" height=\"30\"><td colspan=\"8\">暂无数据</td></tr>";
            [content replaceOccurrencesOfString:@"t_LIST_t" withString:dataStr options:NSCaseInsensitiveSearch range:NSMakeRange(0, content.length)];
            [self.detailWebView loadHTMLString:content baseURL:nil];
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

//加载污染物排放汇总
- (void)loadPollutionsHtml:(NSString *)jsonStr
{
    //QueryWryHz
    self.isLoading = NO;
    NSDictionary *tmpParsedJsonDict = [jsonStr objectFromJSONString];
    BOOL bParseError = NO;
    if (tmpParsedJsonDict && jsonStr.length > 0)
    {
        NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"xx" ofType:@"html"];
        NSMutableString *html = [[NSMutableString alloc] initWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
        for(NSString *key in [tmpParsedJsonDict allKeys])
        {
            NSString *oldValue;
            if([tmpParsedJsonDict objectForKey:key] != nil)
            {
                oldValue = [NSString stringWithFormat:@"%@", [tmpParsedJsonDict objectForKey:key]];
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
        bParseError = YES;
    }
    if (bParseError)
    {
        [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
    }
}

//加载废气污染物排放
- (void)loadAirPollutionsHtml:(NSString *)jsonStr
{
    self.isLoading = NO;
    NSDictionary *tmpParsedJsonDict = [jsonStr objectFromJSONString];
    BOOL bParseError = NO;
    if (tmpParsedJsonDict && jsonStr.length > 0)
    {
        NSArray *listDataArray = [tmpParsedJsonDict objectForKey:@"rows"];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"yy" ofType:@"html"];
        NSMutableString *content = [[NSMutableString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        [content replaceOccurrencesOfString:@"t_WRWNAME_T" withString:@"废气" options:NSCaseInsensitiveSearch range:NSMakeRange(0, content.length)];
        [content replaceOccurrencesOfString:@"t_TITLE_t" withString:self.wrybh options:NSCaseInsensitiveSearch range:NSMakeRange(0, content.length)];
        if(listDataArray != nil && listDataArray.count > 0)
        {
            NSMutableString *dataStr = [[NSMutableString alloc] init];
            for (int i = 0; i < listDataArray.count; i++)
            {
                NSDictionary *dict = [listDataArray objectAtIndex:i];
                [dataStr appendFormat:@"%@", @"<tr>"];
                [dataStr appendFormat:@"<td>%@</td>", [dict objectForKey:@"WRWMC"]];
                [dataStr appendFormat:@"<td>%@</td>", [dict objectForKey:@"ND"]];
                [dataStr appendFormat:@"<td>%@</td>", [dict objectForKey:@"HJYXPJ"]];
                [dataStr appendFormat:@"<td>%@</td>", [dict objectForKey:@"STSYS"]];
                [dataStr appendFormat:@"<td>%@</td>", [dict objectForKey:@"PWXKZHD"]];
                [dataStr appendFormat:@"<td>%@</td>", [dict objectForKey:@"PCSJ"]];
                [dataStr appendFormat:@"<td>%@</td>", [dict objectForKey:@"HTSJ"]];
                [dataStr appendFormat:@"<td>%@</td>", [dict objectForKey:@"PWSJ"]];
                [dataStr appendFormat:@"%@", @"</tr>"];
            }
            [content replaceOccurrencesOfString:@"t_LIST_t" withString:dataStr options:NSCaseInsensitiveSearch range:NSMakeRange(0, content.length)];
            [self.detailWebView loadHTMLString:content baseURL:nil];
        }
        else
        {
            NSString *dataStr = @"<tr align=\"center\" height=\"30\"><td colspan=\"8\">暂无数据</td></tr>";
            [content replaceOccurrencesOfString:@"t_LIST_t" withString:dataStr options:NSCaseInsensitiveSearch range:NSMakeRange(0, content.length)];
            [self.detailWebView loadHTMLString:content baseURL:nil];
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

//加载工商数据
- (void)loadGSXXHtml:(NSString *)jsonStr
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

@end
