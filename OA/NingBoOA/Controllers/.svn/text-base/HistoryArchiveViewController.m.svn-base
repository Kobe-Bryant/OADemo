//
//  HistoryArchiveViewController.m
//  NingBoOA
//
//  Created by 熊熙 on 13-10-22.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "HistoryArchiveViewController.h"
#import "SystemConfigContext.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
@interface HistoryArchiveViewController ()

@end

@implementation HistoryArchiveViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)requestWebData{
    NSString *strUrl = [ServiceUrlString generateOAWebServiceUrl];
    NSString *method = @"HistoryArchives";
    NSString *params = nil;
    
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:method nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
    [self.webServiceHelper runAndShowWaitingView:self.view];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contentSizeForViewInPopover = CGSizeMake(240, 44*6);

    [self requestWebData];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:@"HistoryArchivesReturn"  andWithJSONDelegate:self];
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
        self.listArray = [tmpParsedJsonDict objectForKey:@"listinfo"];
        if ([self.listArray count] >= 1) {
            [self.listTableView reloadData];
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


#pragma mark -
#pragma mark tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  [self.listArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifer  = @"MyCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    
    NSDictionary *dirInfo = [self.listArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text =[dirInfo objectForKey:@"year"];
    
    return cell;
}

#pragma mark -
#pragma mark tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dirInfo = [self.listArray objectAtIndex:indexPath.row];
    
    NSString *year = [dirInfo objectForKey:@"year"];
    NSString *modid = [dirInfo objectForKey:@"modid"];
    
    [self.delegate returnYearDirectoryWithYear:year Modid:modid];
}

@end
