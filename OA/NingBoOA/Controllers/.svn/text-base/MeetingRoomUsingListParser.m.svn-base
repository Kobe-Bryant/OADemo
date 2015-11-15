//
//  MeetingRoomUsingListParser.m
//  NingBoOA
//
//  Created by 熊熙 on 13-11-11.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "MeetingRoomUsingListParser.h"
#import "ServiceUrlString.h"
#import "FileOutDetailViewController.h"

@implementation MeetingRoomUsingListParser

//初始化请求数据
-(void)requestData
{
    self.isLoading = YES;
    NSString *strUrl = [ServiceUrlString generateOAWebServiceUrl];
    NSString *params = nil;
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:self.serviceName nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
    if (self.isRefresh) {
        [self.webServiceHelper runAndShowWaitingView:self.showView withTipInfo:@"正在加载列表，请稍候..."];
    }
    else {
        [self.webServiceHelper runAndShowWaitingView:self.showView withTipInfo:@"正在加载更多列表，请稍候..."];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier=nil;
    UITableViewCell  *cell = nil;
    
    
    NSDictionary *tmpDict = [self.aryItems objectAtIndex:indexPath.row];
    /*{"文档ID":"B331FFBEB415A9A248257BEA0004BAB8","序号":"1","登记日期":"2013-09-18","标题":"宁波生态环境治理","主办部门":"办公室","缓急":"一般","当前环节":"办公室编号、正式发文","当前处理人":"郑春盛"},{"文档ID":"AF3A1501D9C43C0448257BE90033E438","序号":"2","登记日期":"2013-09-17","标题":"fsdfsdf","主办部门":"办公室","缓急":"一般","当前环节":"处室负责人把关","当前处理人":"翁劲草"}*/
    CellIdentifier = @"UsingMeetingRoom";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nibTableCells = [[NSBundle mainBundle] loadNibNamed:@"MeetingRoomListCell"owner:nil options:nil];
        cell = [nibTableCells objectAtIndex:2];
    }
    
    UILabel *numberLabel = (UILabel *)[cell viewWithTag:101];
    numberLabel.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
    
    UILabel *meetingRoomLabel = (UILabel *)[cell viewWithTag:102];
    meetingRoomLabel.text = [tmpDict objectForKey:@"name"];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:103];
    titleLabel.text = [tmpDict objectForKey:@"title"];
    
    UILabel *endTimeLabel = (UILabel *)[cell viewWithTag:104];
    endTimeLabel.text = [tmpDict objectForKey:@"endtime"];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 99.0f;
}

@end
