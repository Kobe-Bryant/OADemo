//
//  MeetingRoomArrangeListParser.m
//  NingBoOA
//
//  Created by 熊熙 on 13-11-11.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "MeetingRoomArrangeListParser.h"
#import "ServiceUrlString.h"
#import "FileOutDetailViewController.h"

@implementation MeetingRoomArrangeListParser

//初始化请求数据
-(void)requestData
{
    self.isLoading = YES;
    NSString *strUrl = [ServiceUrlString generateOAWebServiceUrl];
    NSString *params = [WebServiceHelper createParametersWithKey:@"HY_TS" value:ONE_PAGE_SIZE, @"HY_START", [NSString stringWithFormat:@"%d",self.start],nil];
    
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
       
        CellIdentifier = @"MeetingRoomList";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            NSArray *nibTableCells = [[NSBundle mainBundle] loadNibNamed:@"MeetingRoomListCell"owner:nil options:nil];
            cell = [nibTableCells objectAtIndex:0];
        }
        UILabel *numberLabel = (UILabel *)[cell viewWithTag:101];
        numberLabel.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
        

        
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:102];
        titleLabel.text = [tmpDict objectForKey:@"title"];
        
        UILabel *meetingRoomLabel = (UILabel *)[cell viewWithTag:103];
        meetingRoomLabel.text = [tmpDict objectForKey:@"meetingRoom"];
        
        UILabel *timeLabel = (UILabel *)[cell viewWithTag:104];
        timeLabel.text = [tmpDict objectForKey:@"time"];
        
        UILabel *applicatnLabel = (UILabel *)[cell viewWithTag:105];
        applicatnLabel.text = [tmpDict objectForKey:@"applicant"];
        
        UILabel *departmentLabel = (UILabel *)[cell viewWithTag:106];
        departmentLabel.text = [tmpDict objectForKey:@"department"];
        
       
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tmpDict = [self.aryItems objectAtIndex:indexPath.row];
    NSString *meetid    = [tmpDict objectForKey:@"meetid"];
    
    [self.delegate didSelectMeetingRoomListItem:meetid ];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 108.0f;
}

@end
