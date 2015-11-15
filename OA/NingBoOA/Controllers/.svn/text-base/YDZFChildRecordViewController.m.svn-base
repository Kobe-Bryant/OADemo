//
//  YDZFChildRecordViewController.m
//  NingBoOA
//
//  Created by PowerData on 13-10-18.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "YDZFChildRecordViewController.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "UICustomButton.h"

#define kService_Normal_Action 1 //获取子表的数据
#define kService_KYT_Action 2    //获取勘验图数据
#define kService_CYDZB_Action 3    //获取采样单子表数据
#define kService_BLWDBF_Action 4    //获取笔录问答部分数据
#define kService_JCYZ_Action 5   //获取监测因子数据

/*
 QueryDcxwbl       调查询问笔录            √
 QueryDcxwblZb     调查询问笔录问答部分
 QueryKybl         勘验笔录               √
 QueryKyt          勘验图
 QuerySqwts        授权委托书             √
 QueryWryfscy      采样单                 √
 QueryWryfscyZb    采样单子表
 QueryXcgztzs      限期行为改正通知书      √
 QueryXcjcd        现场监察单             √
 QueryXzjgNewInfo  移动新监察表信息
 */

@interface YDZFChildRecordViewController ()
@property (nonatomic, assign) int currentServiceTag;
@property (nonatomic, copy) NSString* kytImageURL;
@property (nonatomic, strong) NSDictionary *detailDict;
@property (nonatomic, strong) NSArray *qaAry;//询问笔录问答部分
@property (nonatomic, strong) NSArray *sampleAry;//样本
@end

@implementation YDZFChildRecordViewController

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
    
    self.title = self.DWMC;
    UIBarButtonItem *backItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"返回"];
    self.navigationItem.leftBarButtonItem = backItem;
    UIButton *backButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
    [backButton addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    [self requestData:self.serviceName];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    
    [self setDetailWebView:nil];
    [super viewDidUnload];
}

#pragma mark - Private Methods

- (void)goBackAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadContentWithType:(NSString *)type andWithContent:(NSDictionary *)contentDict
{
    NSString *htmlPath;
    if([type isEqualToString:@"QueryWryfscy"])
    {
        //现场采样单
        htmlPath = [[NSBundle mainBundle] pathForResource:@"xccy" ofType:@"html"];
    }
    else if([type isEqualToString:@"QuerySqwts"])
    {
        //委托书
        htmlPath = [[NSBundle mainBundle] pathForResource:@"wts" ofType:@"html"];
    }
    else if([type isEqualToString:@"QueryXcjcd"])
    {
        //现场监察单
        htmlPath = [[NSBundle mainBundle] pathForResource:@"jcd" ofType:@"html"];
    }
    else if([type isEqualToString:@"QueryDcxwbl"])
    {
        //询问笔录
        htmlPath = [[NSBundle mainBundle] pathForResource:@"xwbl" ofType:@"html"];
    }
    else if([type isEqualToString:@"QueryXcgztzs"])
    {
        //限期行为改正通知书
        htmlPath = [[NSBundle mainBundle] pathForResource:@"tzs" ofType:@"html"];
    }
    else if([type isEqualToString:@"QueryKybl"])
    {
        //现场勘验笔录
        htmlPath = [[NSBundle mainBundle] pathForResource:@"kcbl" ofType:@"html"];
    }
    else if([type isEqualToString:@"QueryXzjgNewInfo"])
    {
        htmlPath = [[NSBundle mainBundle] pathForResource:@"xcjcjlb" ofType:@"html"];
    }
    else
    {
        return;
    }
    
    //替换HTML中的占位符
    NSMutableString *html = [[NSMutableString alloc] initWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    for(NSString *key in [contentDict allKeys])
    {
        NSString *oldValue = [contentDict objectForKey:key];
        NSRange range = [html rangeOfString:[NSString stringWithFormat:@"t_%@_t", key]];
        if (range.location != NSNotFound)
        {
            [html replaceCharactersInRange:range withString:oldValue];
        }
    }
    [self.detailWebView loadHTMLString:html baseURL:nil];
}

- (NSString *)getQuestionAndAnswerHtml:(NSArray *)ary
{
    NSMutableString *html = [[NSMutableString alloc] initWithCapacity:0];
    for (int i = 0; i < ary.count; i++)
    {
        NSDictionary *item = [ary objectAtIndex:i];
        NSString *XWNR = [item objectForKey:@"XWNR"];
        NSString *WTDA = [item objectForKey:@"WTDA"];
        [html appendFormat:@"%@", @"<tr>"];
        [html appendFormat:@"<td colspan=\"7\">问题%d:%@</td>", i+1,XWNR];
        [html appendFormat:@"%@", @"</tr>"];
        [html appendFormat:@"%@", @"<tr>"];
        [html appendFormat:@"<td colspan=\"7\">回答%d:%@</td>", i+1, WTDA];
        [html appendFormat:@"%@", @"</tr>"];
    }
    
    return html;
}

- (NSString *)getJcyzStr:(NSString *)s
{
    if(s.length == 0 || s == nil)
    {
        return @"";
    }
    NSMutableString *str = [[NSMutableString alloc] init];
    NSArray *ary = [s componentsSeparatedByString:@","];
    for(int i = 0; i < ary.count; i++)
    {
        NSString *code =  [ary objectAtIndex:i];
        if(i <= ary.count-1 && i > 0)
        {
            [str appendFormat:@",%@", [self getJcyzStrWithCode:code]];
        }
        else
        {
            [str appendFormat:@"%@", [self getJcyzStrWithCode:code]];
        }
    }
    return str;
}

- (NSString *)getJcyzStrWithCode:(NSString *)code
{
    NSString *str = @"";
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ydzf_jcyz" ofType:@"plist"];
    NSArray *ary = [[NSArray alloc] initWithContentsOfFile:path];
    for(NSDictionary *dict in ary)
    {
        NSString *dm = [dict objectForKey:@"DM"];
        if([dm isEqualToString:code])
        {
            str = [dict objectForKey:@"DMNR"];
            if(str == nil || str.length == 0)
            {
                str = @"";
            }
            break;
        }
    }
    return str;
}

//采样单的具体采样情况
- (NSString *)getSampleListHtml:(NSArray *)ary
{
    NSMutableString *html = [[NSMutableString alloc] initWithCapacity:0];
    for (int i = 0; i < ary.count; i++)
    {
        NSDictionary *item = [ary objectAtIndex:i];
        [html appendFormat:@"%@", @"<tr>"];
        [html appendFormat:@"%@", @"<td></td>"];
        [html appendFormat:@"<td>%@</td>", [item objectForKey:@"YPBH"]];
        [html appendFormat:@"<td>%@</td>", [item objectForKey:@"CYDMC"]];
        [html appendFormat:@"<td>%@</td>", [self getSampleTime:[item objectForKey:@"CYSJ"]]];
        [html appendFormat:@"<td colspan=\"12\">%@</td>", [self getJcyzStr:[item objectForKey:@"JCXM1"]]];
        [html appendFormat:@"<td>%@</td>", [item objectForKey:@"LS"]];
        [html appendFormat:@"<td>%@</td>", [item objectForKey:@"KS"]];
        [html appendFormat:@"<td>%@</td>", [item objectForKey:@"SD"]];
        [html appendFormat:@"<td>%@</td>", [item objectForKey:@"LL"]];
        [html appendFormat:@"<td>%@</td>", [item objectForKey:@"PFL"]];
        [html appendFormat:@"%@", @"</tr>"];
    }
    return html; 
}

- (NSString *)getSampleTime:(NSString *)longDate
{
    if(longDate.length > 15)
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [df dateFromString:longDate];
        [df setDateFormat:@"HH:mm"];
        NSString *str = [df stringFromDate:date];
        return str;
    }
    else
    {
        return @"";
    }
}

#pragma mark - Network Request Handler

- (void)requestJcyzData
{
    //获取监测因子数据
    self.currentServiceTag = kService_JCYZ_Action;
    NSString *strURL = [ServiceUrlString generateMobileLawServiceUrl:@"TYdzfService.asmx"];
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strURL method:@"QueryWryfscyYzb" nameSpace:@"http://tempuri.org/" delegate:self];
    [self.webServiceHelper runAndShowWaitingView:self.view];
}

- (void)requestData:(NSString *)type
{
    self.currentServiceTag = kService_Normal_Action;
    NSString *strURL = [ServiceUrlString generateMobileLawServiceUrl:@"TYdzfService.asmx"];
    NSString *params = [WebServiceHelper createParametersWithKey:@"xczfbh" value:self.XCZFBH, nil];
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strURL method:type nameSpace:@"http://tempuri.org/" parameters:params delegate:self];
    [self.webServiceHelper runAndShowWaitingView:self.view];
}

- (void)requestXwblwdbfData
{
    if([self.serviceName isEqualToString:@"QueryDcxwbl"])
    {
        //获取询问笔录问答部分
        self.currentServiceTag = kService_BLWDBF_Action;
        NSString *strURL = [ServiceUrlString generateMobileLawServiceUrl:@"TYdzfService.asmx"];
        NSString *params = [WebServiceHelper createParametersWithKey:@"xczfbh" value:self.XCZFBH, nil];
        self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strURL method:@"QueryDcxwblZb" nameSpace:@"http://tempuri.org/" parameters:params delegate:self];
        [self.webServiceHelper runAndShowWaitingView:self.view];
    }
}

- (void)requestKytData
{
    if([self.serviceName isEqualToString:@"QueryKybl"])
    {
        //获取勘验图数据
        self.currentServiceTag = kService_KYT_Action;
        NSString *strURL = [ServiceUrlString generateMobileLawServiceUrl:@"TYdzfService.asmx"];
        NSString *params = [WebServiceHelper createParametersWithKey:@"xczfbh" value:self.XCZFBH, nil];
        self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strURL method:@"QueryKyt" nameSpace:@"http://tempuri.org/" parameters:params delegate:self];
        [self.webServiceHelper runAndShowWaitingView:self.view];
    }
}

- (void)requestCydzbData
{
    if([self.serviceName isEqualToString:@"QueryWryfscy"])
    {
        //获取采样单子表数据
        self.currentServiceTag = kService_CYDZB_Action;
        NSString *strURL = [ServiceUrlString generateMobileLawServiceUrl:@"TYdzfService.asmx"];
        NSString *params = [WebServiceHelper createParametersWithKey:@"xczfbh" value:self.XCZFBH, nil];
        self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strURL method:@"QueryWryfscyZb" nameSpace:@"http://tempuri.org/" parameters:params delegate:self];
        [self.webServiceHelper runAndShowWaitingView:self.view];
    }
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
    WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithJSONDelegate:self];
    [webDataHelper parseJSONData:webData];
}

// -------------------------------------------------------------------------------
//	实现NSURLConnHelperDelegate委托方法
//  处理网络请求失败
// -------------------------------------------------------------------------------

-(void)processError:(NSError *)error
{
    [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
}

// -------------------------------------------------------------------------------
//	实现WebDataParserDelegate委托方法
//  解析json字符串
// -------------------------------------------------------------------------------

- (void)parseJSONString:(NSString *)jsonStr
{
    NSDictionary *tmpParsedJsonDict = [jsonStr objectFromJSONString];
    BOOL bParseError = NO;
    if (tmpParsedJsonDict && jsonStr.length > 0)
    {
        if(self.currentServiceTag == kService_Normal_Action)
        {
            self.detailDict = tmpParsedJsonDict;
            
            //去掉日期数据后面的时分秒
            if([self.serviceName isEqualToString:@"QueryKybl"])
            {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:tmpParsedJsonDict];
                [dict setObject:@"" forKey:@"KYTIMG"];
                self.detailDict = dict;
            }
            if([self.serviceName isEqualToString:@"QueryXcjcd"])
            {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:tmpParsedJsonDict];
                [dict setObject:self.DWMC forKey:@"DWMC"];
                [dict setObject:self.DWFZR forKey:@"DWFZR"];
                [dict setObject:self.DWDZ forKey:@"DWDZ"];
                [dict setObject:self.DWLXDH forKey:@"DWLXDH"];
                self.detailDict = dict;
            }
            if ([self.serviceName isEqualToString:@"QueryDcxwbl"])
            {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:tmpParsedJsonDict];
                [dict setObject:@"" forKey:@"QTWDBF"];
                self.detailDict = dict;
            }
            
            //获取勘验图数据
            [self requestKytData];
            
            //获取询问笔录子表
            [self requestXwblwdbfData];
            
            //获取采样单子表数据
            [self requestCydzbData];
            
            //获取监测因子数据
            //[self requestJcyzData];
            
            //在主线程中刷新界面
            dispatch_async(dispatch_get_main_queue(), ^{
                [self loadContentWithType:self.serviceName andWithContent:self.detailDict];
            });
        }
        else if (self.currentServiceTag == kService_KYT_Action)
        {
            //勘验图
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:self.detailDict];
            if([tmpParsedJsonDict objectForKey:@"URL"] != nil)
            {
                NSString *image = [NSString stringWithFormat:@"<img src=\"%@\" style=\"width:600px;height:450px; border-width:0px;margin:2px auto;\"/>", [tmpParsedJsonDict objectForKey:@"URL"]];
                [dict setObject:image forKey:@"KYTIMG"];
            }
            else
            {
                [dict setObject:@"" forKey:@"KYTIMG"];
            }
            self.detailDict = dict;
            //在主线程中刷新界面
            dispatch_async(dispatch_get_main_queue(), ^{
                [self loadContentWithType:self.serviceName andWithContent:self.detailDict];
            });
        }
        else if (self.currentServiceTag == kService_BLWDBF_Action)
        {
            int total = [[tmpParsedJsonDict objectForKey:@"total"] intValue];
            if(total <= 0)
            {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:self.detailDict];
                [dict setObject:@"" forKey:@"QTWDBF"];
                self.detailDict = dict;
            }
            else
            {
                self.qaAry = [tmpParsedJsonDict objectForKey:@"rows"];
                NSString *str = [self getQuestionAndAnswerHtml:self.qaAry];
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:self.detailDict];
                [dict setObject:str forKey:@"QTWDBF"];
                self.detailDict = dict;
            }
            //在主线程中刷新界面
            dispatch_async(dispatch_get_main_queue(), ^{
                [self loadContentWithType:self.serviceName andWithContent:self.detailDict];
            });
        }
        else if (self.currentServiceTag == kService_CYDZB_Action)
        {
            int total = [[tmpParsedJsonDict objectForKey:@"total"] intValue];
            if(total <= 0)
            {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:self.detailDict];
                [dict setObject:@"" forKey:@"SAMPLELIST"];
                [dict setObject:@"" forKey:@"DWMC"];
                [dict setObject:@"" forKey:@"DWFZR"];
                [dict setObject:@"" forKey:@"DWDZ"];
                [dict setObject:@"" forKey:@"DWLXDH"];
                self.detailDict = dict;
            }
            else
            {
                self.sampleAry = [tmpParsedJsonDict objectForKey:@"rows"];
                NSString *str = [self getSampleListHtml:self.sampleAry];
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:self.detailDict];
                [dict setObject:self.DWMC forKey:@"DWMC"];
                [dict setObject:self.DWFZR forKey:@"DWFZR"];
                [dict setObject:self.DWDZ forKey:@"DWDZ"];
                [dict setObject:self.DWLXDH forKey:@"DWLXDH"];
                [dict setObject:str forKey:@"SAMPLELIST"];
                self.detailDict = dict;
            }
            //在主线程中刷新界面
            dispatch_async(dispatch_get_main_queue(), ^{
                [self loadContentWithType:self.serviceName andWithContent:self.detailDict];
            });
        }
        /*else if (self.currentServiceTag == kService_JCYZ_Action)
        {
            NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSLog(@"%@", docPath);
            NSString *filePath = [docPath stringByAppendingPathComponent:@"ydzf_jcyz.plist"];
            NSArray *ary = [tmpParsedJsonDict objectForKey:@"rows"];
            [ary writeToFile:filePath atomically:YES];
        }*/
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

// -------------------------------------------------------------------------------
//	实现WebDataParserDelegate委托方法
//  解析数据出错处理
// -------------------------------------------------------------------------------

- (void)parseWithError:(NSString *)errorString
{
    [self showAlertMessage:errorString];
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
