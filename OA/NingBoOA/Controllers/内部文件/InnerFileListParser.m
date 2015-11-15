//
//  InnerFileListParser.h
//  内部文件管理 在办-按日期数据解析 查询
//
//  Created by 曾静 on 13-9-27.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "InnerFileListParser.h"
#import "SystemConfigContext.h"
#import "PDJsonkit.h"
#import "InnerFileDetailViewController.h"

@implementation InnerFileListParser

@synthesize showView,aryItems;
@synthesize type,webServiceHelper,serviceName,listTableView;

-(id)init
{
    self = [super init];
    if(self)
    {
        self.isRefresh = YES;
        self.start = 1;
        SystemConfigContext *context = [SystemConfigContext sharedInstance];
        NSDictionary *loginUsr = [context getUserInfo];
        self.user = [loginUsr objectForKey:@"userId"];
        self.aryItems = [NSMutableArray arrayWithCapacity:10];
    }
    return self;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.isLoading) return;
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 850 ) {
        self.isLoading = YES;
        self.isRefresh = NO;
        [self.delegate loadMoreList];
    }
}

#pragma mark - Network Handle Request

// -------------------------------------------------------------------------------
//	请求数据
// -------------------------------------------------------------------------------

-(void)requestData
{
    
}

// -------------------------------------------------------------------------------
//	取消网络请求
// -------------------------------------------------------------------------------

-(void)cancelRequest
{
    [webServiceHelper cancel];
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
    WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:[NSString stringWithFormat:@"%@Return",self.serviceName] andWithJSONDelegate:self];
    [webDataHelper parseXMLData:webData];
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
    if(jsonStr.length == 0)
        return;
    NSDictionary *tmpParsedJsonDict = [jsonStr objectFromJSONString];
    BOOL bParseError = NO;
    if (tmpParsedJsonDict && jsonStr.length > 0)
    {
        self.isLoading = NO;
        NSArray *tmpAry = [tmpParsedJsonDict objectForKey:@"listinfo"];
        
        
        if([tmpAry count] > 0){
            self.notSearch = NO;
            self.start = [tmpAry count] +self.start;
            if (self.isRefresh) {
                [aryItems removeAllObjects];
                [aryItems addObjectsFromArray:tmpAry];
            }
            else {
                [aryItems addObjectsFromArray:tmpAry];
            }
        }
        else if (self.isRefresh) {
            self.notSearch = NO;
            if ([self.type isEqualToString:@"InquiryList"] ) {
                self.notSearch = YES;
            }
            [aryItems removeAllObjects];
        }
        
        else{
            [self showAlertMessage:@"已经显示最后一条数据!"];
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

// -------------------------------------------------------------------------------
//	实现WebDataParserDelegate委托方法
//  解析json字符串发生错误
// -------------------------------------------------------------------------------

- (void)parseWithError:(NSString *)errorString
{
    [self showAlertMessage:errorString];
}

#pragma mark - UITableView Delegate & DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.notSearch) return 1;
    return [self.aryItems count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.notSearch) return;
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *tmpheaderView = [[UILabel alloc] initWithFrame:CGRectZero];
    tmpheaderView.font = [UIFont systemFontOfSize:17.0];
    tmpheaderView.backgroundColor = [UIColor colorWithRed:159.0/255 green:215.0/255 blue:230.0/255 alpha:1.0];
    tmpheaderView.textColor = [UIColor blackColor];
    return tmpheaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *tmpDict = [self.aryItems objectAtIndex:indexPath.row];
    NSString *process = [tmpDict objectForKey:@"dqhj"];
    NSString *docid = [tmpDict objectForKey:@"docid"];
    [self.delegate didSelectInnerFileListItem:docid process:process];
}

#pragma mark - Private Methods

// -------------------------------------------------------------------------------
//	弹出对话框
// -------------------------------------------------------------------------------

- (void) showAlertMessage:(NSString*)msg
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message:msg
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];
    return;
}

@end
