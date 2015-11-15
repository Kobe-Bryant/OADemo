//
//  BaseFileToDoViewController.m
//  NingBoOA
//
//  Created by Alex Jean on 13-8-7.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "BaseFileToDoViewController.h"
#import "ServiceUrlString.h"
#import "WebServiceHelper.h"
#import "PDJsonkit.h"
#import "UITableViewCell+Custom.h"

@interface BaseFileToDoViewController ()

@end

@implementation BaseFileToDoViewController

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
    
    //初始化请求数据
    self.currentPage = 1;
    self.strUrl = [ServiceUrlString generateOAWebServiceUrl];
    NSString *params = [WebServiceHelper createParametersWithKey:@"Hy_mdid" value:self.fileServiceName, @"Hy_ts", ONE_PAGE_SIZE, @"Hy_start", @"1",nil];
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:self.strUrl method:@"listinfo" nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
    [self.webServiceHelper runAndShowWaitingView:self.view];
    self.isLoading = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - UITableView Delegae & DataSource Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tmpDict = [self.listDataArray objectAtIndex:indexPath.row];
    NSString *title = [NSString stringWithFormat:@"%@", [tmpDict objectForKey:@"标题"]];
    NSString *subTitle = [NSString stringWithFormat:@"时间:%@", [tmpDict objectForKey:@"时间"]];
    int num = [[tmpDict objectForKey:@"序号"] intValue];
    UITableViewCell *cell = [UITableViewCell makeSubCell:self.listTableView withTitle:title andSubTitle:subTitle andNoteCount:num];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 72;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectZero];
    headerView.font = [UIFont systemFontOfSize:19.0];
    headerView.backgroundColor = [UIColor colorWithRed:170.0/255 green:223.0/255 blue:234.0/255 alpha:1.0];
    headerView.textColor = [UIColor blackColor];
    if([self.fileServiceName isEqualToString:@"filein"])
    {
        headerView.text = [NSString stringWithFormat:@"  %@", @"收文列表"];
    }
    else if ([self.fileServiceName isEqualToString:@"fileout"])
    {
        headerView.text = [NSString stringWithFormat:@"  %@", @"发文列表"];
    }
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	
	if (self.isLoading)
    {
        //如果当前正在加载数据，什么也不做
        return;
    }
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 850)
    {
		self.currentPage++;
        self.strUrl = [ServiceUrlString generateOAWebServiceUrl];
        NSString *pageStart = [NSString stringWithFormat:@"%d", self.currentPage];
        NSString *params = [WebServiceHelper createParametersWithKey:@"Hy_mdid" value:self.fileServiceName, @"Hy_ts", ONE_PAGE_SIZE, @"Hy_start", pageStart,nil];
        self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:self.strUrl method:@"listinfo" nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
        [self.webServiceHelper runAndShowWaitingView:self.view];
        self.isLoading = YES;
    }
}

#pragma mark - Network Handle Method

- (void)processWebData:(NSData *)webData
{
    if([webData length] <=0)
    {
        [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
    }
    WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:@"listinfoReturn" andWithJSONDelegate:self];
    [webDataHelper parseXMLData:webData];
}

- (void)processError:(NSError *)error
{
    [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
}

#pragma mark - 网络数据解析

- (void)parseJSONString:(NSString *)jsonStr andTag:(NSInteger)tag
{
    self.isLoading = NO;
    NSDictionary *tmpParsedJsonDict = [jsonStr objectFromJSONString];
    BOOL bParseError = NO;
    if (tmpParsedJsonDict && jsonStr.length > 0)
    {
        //0:在办 1:已办
        NSArray *tempListArray = [tmpParsedJsonDict objectForKey:@"listinfo"];
        NSMutableArray *tmpAry = [[NSMutableArray alloc] init];
        for (NSDictionary *obj in tempListArray)
        {
            if([[obj objectForKey:@"是否在办"] isEqualToString:@"0"])
            {
                [tmpAry addObject:obj];
            }
        }
        self.listDataArray = tmpAry;
    }
    else
    {
        bParseError = YES;
    }
    
    [self.listTableView reloadData];
    
    if (bParseError)
    {
        [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
    }
}

- (void)parseWithError:(NSString *)errorString
{
    self.isLoading = NO;
    [self showAlertMessage:errorString];
}

@end
