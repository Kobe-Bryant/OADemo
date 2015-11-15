//
//  FileInfoViewController.m
//  NingBoOA
//
//  Created by 熊熙 on 13-10-21.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FileInfoViewController.h"
#import "DocInfoViewController.h"
#import "UICustomButton.h"
#import "ServiceUrlString.h"
#import "SystemConfigContext.h"
#import "PDJsonkit.h"
@interface FileInfoViewController ()

@end

@implementation FileInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)requestWebData {
   
    SystemConfigContext *context = [SystemConfigContext sharedInstance];
    NSDictionary *loginUsr = [context getUserInfo];
    NSString *user = [loginUsr objectForKey:@"userId"];
    
    NSString *strUrl = [ServiceUrlString generateOAWebServiceUrl];
    NSString *params = [WebServiceHelper createParametersWithKey:@"Hy_userid" value:user,@"Hy_fileid",self.fileid,@"Hy_ts", ONE_PAGE_SIZE, @"Hy_start", @"1", @"Hy_modid",self.modId,nil];
    
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:@"ArchivesInformation" nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
    [self.webServiceHelper runAndShowWaitingView:self.view withTipInfo:@"正在加载案卷目录，请稍候..." andTag:0];
}

- (void)setControlValue{
    
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"案卷详情";
    
    self.titleTxtView.layer.borderColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0].CGColor;
    
    self.titleTxtView.layer.borderWidth =1.5;
    
    self.titleTxtView.layer.cornerRadius =6.0;
    
    UIBarButtonItem *backItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"返回"];
    self.navigationItem.leftBarButtonItem = backItem;
    UIButton *backButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
    [backButton addTarget:self action:@selector(goBackAction:) forControlEvents:UIControlEventTouchUpInside];
  
    [self requestWebData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Handle Event
- (void)goBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.docList count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"卷内目录";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 108.0f;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 35.0;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UILabel *tmpheaderView = [[UILabel alloc] initWithFrame:CGRectZero];
//    tmpheaderView.font = [UIFont systemFontOfSize:17.0];
//    tmpheaderView.backgroundColor = [UIColor colorWithRed:159.0/255 green:215.0/255 blue:230.0/255 alpha:1.0];
//    tmpheaderView.textColor = [UIColor blackColor];
//    tmpheaderView.text = @"卷内目录";
//    return tmpheaderView;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"DocList";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nibTableCells = [[NSBundle mainBundle] loadNibNamed:@"ArchiveListCell"owner:nil options:nil];
        cell = [nibTableCells objectAtIndex:3];
        
        
    }
    
    NSDictionary *docDict = [self.docList objectAtIndex:indexPath.row];
    
    UILabel *xhLabel = (UILabel *)[cell viewWithTag:101];
    xhLabel.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:102];
    titleLabel.text = [docDict objectForKey:@"title"];
    
    UILabel *whLabel = (UILabel *)[cell viewWithTag:103];
    whLabel.text = [docDict objectForKey:@"wh"];
    
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:104];
    dateLabel.text =[docDict objectForKey:@"date"];
    
    UILabel *responLabel = (UILabel *)[cell viewWithTag:105];
    responLabel.text = [docDict objectForKey:@"responsible"];
    
    UILabel *pagesLabel = (UILabel *)[cell viewWithTag:106];
    pagesLabel.text = [docDict objectForKey:@"pageNumber"];
    
    UILabel *remarkLabel = (UILabel *)[cell viewWithTag:107];
    remarkLabel.text = [docDict objectForKey:@"remark"];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - 
#pragma mark UITableView Delegate 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *docDict = [self.docList objectAtIndex:indexPath.row];
    
    DocInfoViewController *docInfoViewController = [[DocInfoViewController alloc] initWithNibName:@"DocInfoViewController" bundle:nil];
    docInfoViewController.docid = [docDict objectForKey:@"docid"];
    docInfoViewController.modid = self.modId;
    [self.navigationController pushViewController:docInfoViewController animated:YES];
}


#pragma mark - Handle Network Request

// -------------------------------------------------------------------------------
//	实现NSURLConnHelperDelegate委托方法
//  处理网络请求的NSData数据
// -------------------------------------------------------------------------------
- (void)processWebData:(NSData *)webData andTag:(NSInteger)tag
{
    if([webData length] <=0)
    {
        [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
    }
    
    WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:@"ArchivesInformationReturn" andWithJSONDelegate:self];
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

- (void)parseJSONString:(NSString *)jsonStr andTag:(NSInteger)tag
{
    NSDictionary *tmpParsedJsonDict = [jsonStr objectFromJSONString];
    BOOL bParseError = NO;
    if (tmpParsedJsonDict && jsonStr.length > 0)
    {
        
        self.titleTxtView.text = [tmpParsedJsonDict objectForKey:@"title"];
        self.bhTxt.text = [tmpParsedJsonDict objectForKey:@"bh"];
        self.deadlineTxt.text = [tmpParsedJsonDict objectForKey:@"deadline"];
        self.yearTxt.text = [tmpParsedJsonDict objectForKey:@"year"];
        self.timeTxt.text = [tmpParsedJsonDict objectForKey:@"time"];
        self.beginDate.text = [tmpParsedJsonDict objectForKey:@"beginDate"];
        self.endDate.text = [tmpParsedJsonDict objectForKey:@"endDate"];
        self.pagesTxt.text = [tmpParsedJsonDict objectForKey:@"pages"];
        self.libraryTxt.text = [tmpParsedJsonDict objectForKey:@"repositoryid"];
        
        self.docList = [tmpParsedJsonDict objectForKey:@"listinfo"];
        if ([self.docList count] >0) {
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

@end
