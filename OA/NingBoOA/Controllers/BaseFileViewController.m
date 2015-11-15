//
//  BaseFileViewController.m
//  NingBoOA
//
//  Created by Alex Jean on 13-8-5.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "BaseFileViewController.h"
#import "ServiceUrlString.h"
#import "WebServiceHelper.h"
#import "PDJsonkit.h"
#import "UITableViewCell+Custom.h"

@interface BaseFileViewController ()

@end

@implementation BaseFileViewController

@synthesize fileServiceName;

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
    
    self.listDataArray = [[NSMutableArray alloc] init];
    
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
    NSString *timeStr = [tmpDict objectForKey:@"时间"];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [df stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    NSString *subTitle = [NSString stringWithFormat:@"时间:%@", dateStr];
    if([timeStr length] > 0)
    {
        subTitle = [NSString stringWithFormat:@"时间:%@", [tmpDict objectForKey:@"时间"]];
    }
    
    int num = [[tmpDict objectForKey:@"序号"] intValue];
    UITableViewCell *cell = [UITableViewCell makeSubCell:self.listTableView withTitle:title andSubTitle:subTitle andNoteCount:num];
    if([[tmpDict objectForKey:@"是否在办"] intValue] == 0)
        cell.imageView.image = [UIImage imageNamed:@"readed_notice.png"];
    else
        cell.imageView.image = [UIImage imageNamed:@"unreaded_notice.png"];
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
        return;
    }
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 850)
    {
        self.currentPage++;
        self.strUrl = [ServiceUrlString generateOAWebServiceUrl];
        NSString *pageStart = [NSString stringWithFormat:@"%d", (self.currentPage*14)+1];
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
        //NSArray *arr = self.listDataArray;
        //[self.listDataArray removeAllObjects];//文档ID
        NSArray *tmpAry = [tmpParsedJsonDict objectForKey:@"listinfo"];
        for(NSDictionary *tmpDict in tmpAry)
        {
            if([tmpDict objectForKey:@"标题"] != nil && [[tmpDict objectForKey:@"标题"] length] > 0)
            {
                [self.listDataArray addObject:tmpDict];
            }
        }
        
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
