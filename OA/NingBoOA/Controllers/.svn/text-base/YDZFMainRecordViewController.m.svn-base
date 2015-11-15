//
//  YDZFMainRecordViewController.m
//  NingBoOA
//
//  Created by PowerData on 13-10-18.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "YDZFMainRecordViewController.h"
#import "HtmlTableGenerator.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "UICustomButton.h"
#import "UITableViewCell+Custom.h"
#import "YDZFChildRecordViewController.h"

#define kService_MainRecord_Action 1  //获取主表数据
#define kService_ChildRecord_Action 2 //获取关联子表数据

@interface YDZFMainRecordViewController ()
@property (nonatomic,strong) UIPopoverController *wordsPopover;
@property (nonatomic,strong) CommenWordsViewController *wordSelectCtrl;
@property (nonatomic,strong) UIWebView *myWebView;
@property (nonatomic,strong) NSString *urlString;
@property (nonatomic,assign) BOOL isLoading;
@property (nonatomic,assign) int currentTag;
@property (nonatomic,strong) WebServiceHelper *webServiceHelper;
@property (nonatomic,strong) NSArray *childRecordAry;
@property (nonatomic,strong) NSDictionary *mainRecordDict;
@end

@implementation YDZFMainRecordViewController

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
    
    //导航栏左边按钮
    UIBarButtonItem *backItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"返回"];
    self.navigationItem.leftBarButtonItem = backItem;
    UIButton *backButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
    [backButton addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    
    //导航栏右边按钮
    
    UIBarButtonItem *rightItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"关联笔录子表"];
    self.navigationItem.rightBarButtonItem = rightItem;
    UIButton *rightButton = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
    [rightButton addTarget:self action:@selector(selectChildTable:) forControlEvents:UIControlEventTouchUpInside];
    
    self.title = self.DWMC;
    [self initPopverController];
    self.myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)];
    self.myWebView.delegate = self;
    [self.view addSubview:self.myWebView];
    [self requestData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    if(self.wordsPopover)
    {
        [self.wordsPopover dismissPopoverAnimated:YES];
    }
    [super viewWillDisappear:animated];
}

- (void)goBackAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectChildTable:(id)sender
{
    UIButton *button = (UIButton*)sender;
    if(self.childRecordAry == nil)
        return;
    if (self.wordsPopover)
    {
        [self.wordsPopover dismissPopoverAnimated:YES];
    }
    NSMutableArray *ary = [[NSMutableArray alloc] init];
    for(int i = 0; i < self.childRecordAry.count; i++)
    {
        NSDictionary *item = [self.childRecordAry objectAtIndex:i];
        [ary addObject:[item objectForKey:@"Name"]];
    }
    self.wordSelectCtrl.wordsAry = ary;
    [self.wordSelectCtrl.tableView reloadData];
    [self.wordsPopover presentPopoverFromRect:button.bounds inView:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)requestData
{
    self.currentTag = kService_MainRecord_Action;
    self.urlString = [ServiceUrlString generateMobileLawServiceUrl:@"TYdzfService.asmx"];
    NSString *params = [WebServiceHelper createParametersWithKey:@"xczfbh" value:self.XCZFBH, nil];
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:self.urlString method:@"QueryXzjgInfo" nameSpace:@"http://tempuri.org/" parameters:params delegate:self];
    [self.webServiceHelper runAndShowWaitingView:self.view];
}

- (void)requestChildRecordData
{
    self.currentTag = kService_ChildRecord_Action;
    NSString *strURL = [ServiceUrlString generateMobileLawServiceUrl:@"TYdzfService.asmx"];
    NSString *params = [WebServiceHelper createParametersWithKey:@"xczfbh" value:self.XCZFBH, nil];
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strURL method:@"QueryTabs" nameSpace:@"http://tempuri.org/" parameters:params delegate:self];
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
    if(self.currentTag == kService_MainRecord_Action)
    {
        NSDictionary *tmpParsedJsonDict = [jsonStr objectFromJSONString];
        BOOL bParseError = NO;
        if (tmpParsedJsonDict && jsonStr.length > 0)
        {
            self.mainRecordDict = tmpParsedJsonDict;
            //替换HTML中的占位符
            NSString *path = [[NSBundle mainBundle] pathForResource:@"xcjc" ofType:@"html"];
            NSMutableString *html = [[NSMutableString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
            for(NSString *key in [tmpParsedJsonDict allKeys])
            {
                NSString *oldValue = [tmpParsedJsonDict objectForKey:key];
                NSRange range = [html rangeOfString:[NSString stringWithFormat:@"t_%@_t", key]];
                if (range.location != NSNotFound)
                {
                    [html replaceCharactersInRange:range withString:oldValue];
                }
            }
            [self.myWebView loadHTMLString:html baseURL:[[NSBundle mainBundle] bundleURL]];
            [self requestChildRecordData];
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
    else if (self.currentTag == kService_ChildRecord_Action)
    {
        NSArray *tmpParsedJSONAry = [jsonStr objectFromJSONString];
        BOOL bParseError = NO;
        if (tmpParsedJSONAry.count > 0 && jsonStr.length > 0)
        {
            NSDictionary *tmpParsedJsonDict = [tmpParsedJSONAry objectAtIndex:0];
            
//            int JBXXNEW = [[tmpParsedJsonDict objectForKey:@"JBXXNEW"] intValue];
            int XCJCD = [[tmpParsedJsonDict objectForKey:@"XCJCD"] intValue];
            int KYBL = [[tmpParsedJsonDict objectForKey:@"KYBL"] intValue];
            int WTS = [[tmpParsedJsonDict objectForKey:@"WTS"] intValue];
            int CYD = [[tmpParsedJsonDict objectForKey:@"CYD"] intValue];
            int TZS = [[tmpParsedJsonDict objectForKey:@"TZS"] intValue];
            int XWBL = [[tmpParsedJsonDict objectForKey:@"XWBL"] intValue];
            NSMutableArray *ary = [[NSMutableArray alloc] initWithCapacity:7];
            /*if(JBXXNEW == 1)
            {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setObject:@"QueryXzjgNewInfo" forKey:@"ServiceName"];
                [dict setObject:@"污染源现场监察记录表" forKey:@"Name"];
                [dict setObject:self.XCZFBH forKey:@"XCZFBH"];
                [ary addObject:dict];
            }*/
            if(XCJCD == 1)
            {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setObject:@"QueryXcjcd" forKey:@"ServiceName"];
                [dict setObject:@"现场监察单" forKey:@"Name"];
                [dict setObject:self.XCZFBH forKey:@"XCZFBH"];
                [ary addObject:dict];
            }
            if(KYBL == 1)
            {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setObject:@"QueryKybl" forKey:@"ServiceName"];
                [dict setObject:@"现场勘察笔录" forKey:@"Name"];
                [dict setObject:self.XCZFBH forKey:@"XCZFBH"];
                [ary addObject:dict];
            }
            if(WTS == 1)
            {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setObject:@"QuerySqwts" forKey:@"ServiceName"];
                [dict setObject:@"授权委托书" forKey:@"Name"];
                [dict setObject:self.XCZFBH forKey:@"XCZFBH"];
                [ary addObject:dict];
            }
            if(CYD == 1)
            {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setObject:@"QueryWryfscy" forKey:@"ServiceName"];
                [dict setObject:@"现场采样" forKey:@"Name"];
                [dict setObject:self.XCZFBH forKey:@"XCZFBH"];
                [ary addObject:dict];
            }
            if(TZS == 1)
            {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setObject:@"QueryXcgztzs" forKey:@"ServiceName"];
                [dict setObject:@"环境违法行为限期改正决定书" forKey:@"Name"];
                [dict setObject:self.XCZFBH forKey:@"XCZFBH"];
                [ary addObject:dict];
            }
            if(XWBL == 1)
            {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setObject:@"QueryDcxwbl" forKey:@"ServiceName"];
                [dict setObject:@"现场询问笔录" forKey:@"Name"];
                [dict setObject:self.XCZFBH forKey:@"XCZFBH"];
                [ary addObject:dict];
            }
            self.childRecordAry = ary;
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)initPopverController
{
    CommenWordsViewController *wordCtrl = [[CommenWordsViewController alloc] initWithStyle:UITableViewStylePlain];
    [wordCtrl setContentSizeForViewInPopover:CGSizeMake(200, 320)];
    self.wordSelectCtrl = wordCtrl;
    self.wordSelectCtrl.delegate = self;
    UIPopoverController *popCtrl = [[UIPopoverController alloc] initWithContentViewController:self.wordSelectCtrl];
    self.wordsPopover = popCtrl;
}

- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row
{
    /*
     QueryDcxwbl    根据现场执法编号获取调查询问笔录信息
     QueryDcxwblZb  根据现场执法编号获取调查询问笔录问答部分信息
     QueryKybl      根据现场执法编号获取勘验笔录信息
     QueryKyt       根据现场执法编号获取勘验图信息
     QuerySqwts     根据现场执法编号获取授权委托书信息
     QueryWryfscy   根据现场执法编号获取采样单信息
     QueryWryfscyZb 根据现场执法编号获取采样单子表信息
     QueryXcgztzs   根据现场执法编号获取限期行为改正通知书信息
     QueryXcjcd     根据现场执法编号获取现场监察单信息
     QueryXzjgNewInfo  根据现场执法编号获取移动新监察表信息
     */
    if(self.wordsPopover)
    {
        [self.wordsPopover dismissPopoverAnimated:YES];
    }
    
    NSDictionary *item = [self.childRecordAry objectAtIndex:row];
    YDZFChildRecordViewController *detail = [[YDZFChildRecordViewController alloc] initWithNibName:@"YDZFChildRecordViewController" bundle:nil];
    detail.XCZFBH = [item objectForKey:@"XCZFBH"];
    detail.recordTitle = [item objectForKey:@"Name"];
    detail.serviceName = [item objectForKey:@"ServiceName"];
    detail.DWMC = self.DWMC;
    detail.DWDZ = [self.mainRecordDict objectForKey:@"DWDZ"];
    detail.DWFZR = [self.mainRecordDict objectForKey:@"DWFZR"];
    detail.DWLXDH = [self.mainRecordDict objectForKey:@"DWLXDH"];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)theWebView
{
    //UIDataDetectorTypeNone表示不偵測</pre>
    theWebView.dataDetectorTypes = UIDataDetectorTypeNone;
}

@end
