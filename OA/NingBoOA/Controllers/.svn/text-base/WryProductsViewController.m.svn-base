//
//  WryProductsViewController.m
//  NingBoOA
//
//  Created by zengjing on 13-10-19.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "WryProductsViewController.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "WebDataParserHelper.h"

@interface WryProductsViewController ()
@property (nonatomic, strong) UIWebView *detailWebView;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) NSArray *listDataArray;
@end

@implementation WryProductsViewController

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
    
    self.title = @"主要产品情况";
    
    self.detailWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)];
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
    NSString *params = [WebServiceHelper createParametersWithKey:@"pageSize" value:@"1000", @"mc", self.wrybh, nil];
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:self.urlString method:@"QueryWryCpList" nameSpace:@"http://tempuri.org/" parameters:params delegate:self];
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
        //self.detailDataDict = tmpParsedJsonDict;
        self.listDataArray = [tmpParsedJsonDict objectForKey:@"rows"];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"aa" ofType:@"html"];
        NSMutableString *content = [[NSMutableString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        [content replaceOccurrencesOfString:@"t_WRYMC_t" withString:self.wrymc options:NSCaseInsensitiveSearch range:NSMakeRange(0, content.length)];
        if(self.listDataArray != nil && self.listDataArray.count > 0)
        {
            //默认加载
           
            /*
             <td>&nbsp;2005</td>
             <td>&nbsp;排污申报</td>
             <td>&nbsp;印染布</td>
             <td>&nbsp;7000</td>
             <td>&nbsp;5836</td>
             <td>&nbsp;万米</td>
             */
            NSMutableString *dataStr = [[NSMutableString alloc] init];
            for (int i = 0; i < self.listDataArray.count; i++)
            {
                NSDictionary *dict = [self.listDataArray objectAtIndex:i];
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

@end
