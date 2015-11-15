//
//  LookUpProcessViewController.m
//  NingBoOA
//
//  Created by 熊熙 on 13-10-25.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "LookUpProcessViewController.h"
#import "WebDataParserHelper.h"
#import "UICustomButton.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "NSStringUtil.h"
@interface LookUpProcessViewController ()

@end

@implementation LookUpProcessViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)requestWebData{
    NSString *strUrl = [ServiceUrlString generateOAWebServiceUrl];
    NSString *params = [WebServiceHelper createParametersWithKey:@"HY_MDID" value:self.modid, @"DOCID", self.docid, nil];
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:@"gethistoryclry" nameSpace:WEBSERVICE_NAMESPACE parameters:params delegate:self];
    
    [self.webServiceHelper runAndShowWaitingView:self.view withTipInfo:@"正在返回历史流程，请稍候..."];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"历史流程";
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *backItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"返回"];
    self.navigationItem.leftBarButtonItem = backItem;
    UIButton *backButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
    [backButton addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self requestWebData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
#pragma mark Handle Event
- (void)goBackAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.historyProcessAry count];;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *tmpheaderView = [[UILabel alloc] initWithFrame:CGRectZero];
    tmpheaderView.font = [UIFont systemFontOfSize:17.0];
    tmpheaderView.backgroundColor = [UIColor colorWithRed:159.0/255 green:215.0/255 blue:230.0/255 alpha:1.0];
    tmpheaderView.textColor = [UIColor blackColor];
    return tmpheaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *processDict = [self.historyProcessAry objectAtIndex:indexPath.row];
    NSString *passerName  = [processDict objectForKey:@"TachPasserName"];
    
    CGFloat txtHeight = [NSStringUtil calculateTextHeight:passerName byFont:[UIFont systemFontOfSize:17.0] andWidth:240];
    
    if (txtHeight < 21.0) {
        txtHeight = 21.0;
    }
    
  return  82.0+ (txtHeight - 21.0);
    
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"HistoryProcessList";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        NSArray *nibTableCells = [[NSBundle mainBundle] loadNibNamed:@"HistoryProcessList"owner:nil options:nil];
        cell = [nibTableCells objectAtIndex:0];
    }
    
    NSDictionary *processDict = [self.historyProcessAry objectAtIndex:indexPath.row];
    
    UILabel *processNameValue = (UILabel *)[cell viewWithTag:101];
    processNameValue.text = [processDict objectForKey:@"TacheName"];
    
    UILabel *processHandlerValue = (UILabel *)[cell viewWithTag:102];
    processHandlerValue.text = [processDict objectForKey:@"TacheTransactorName"];
    
    UILabel *handleTimeValue = (UILabel *)[cell viewWithTag:103];
    handleTimeValue.text = [processDict objectForKey:@"TacheTime"];
    
    UILabel *processPasserValue = (UILabel *)[cell viewWithTag:104];
    processPasserValue.text = [processDict objectForKey:@"TachPasserName"];
    
    
    return cell;
}

#pragma mark - Handle Network Request

// -------------------------------------------------------------------------------
//	实现NSURLConnHelperDelegate委托方法
//  处理网络请求的NSData数据
// -------------------------------------------------------------------------------
- (void)processWebData:(NSData *)webData
{
    if([webData length] <=0)
    {
        [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
    }
    WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:@"gethistoryclryReturn" andWithJSONDelegate:self];
    [webDataHelper parseXMLData:webData];
}

// -------------------------------------------------------------------------------
//	实现NSURLConnHelperDelegate委托方法
//  处理网络请求失败
// -------------------------------------------------------------------------------
- (void)processError:(NSError *)error
{
    [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
}

#pragma mark - Parser Network Data

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
        NSString *status = [tmpParsedJsonDict objectForKey:@"status"];
        if([status isEqualToString:@"1"]){
            
        }
        else {
        self.historyProcessAry = [tmpParsedJsonDict objectForKey:@"HistoryTacheList"];
        [self.historyTableView reloadData];
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

// -------------------------------------------------------------------------------
//	实现WebDataParserDelegate委托方法
//  解析json字符串发生错误
// -------------------------------------------------------------------------------

- (void)parseWithError:(NSString *)errorString
{
    
    [self showAlertMessage:errorString];
}

@end
