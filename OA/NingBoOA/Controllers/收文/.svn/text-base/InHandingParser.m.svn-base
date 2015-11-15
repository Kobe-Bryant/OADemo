//
//  InHandingParser.m
//  NingBoOA
//
//  Created by 熊熙 on 13-9-25.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "InHandingParser.h"
#import "ServiceUrlString.h"
#import "FileInDetailViewController.h"
@implementation InHandingParser


//初始化请求数据
-(void)requestData
{
    self.isLoading = YES;
    NSString *message =@"正在加载更多,请稍候...";
    if (self.isRefresh) {
        self.start = 1;
        message =@"正在加载列表，请稍候...";
    }

    NSString *strUrl = [ServiceUrlString generateOAWebServiceUrl];
    NSString *params = [WebServiceHelper createParametersWithKey:@"HY_USERID" value:self.user, @"HY_TS", ONE_PAGE_SIZE, @"HY_START", [NSString stringWithFormat:@"%d",self.start],@"HY_TYPE",self.type,nil];
    
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:self.serviceName nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
    
    
    [self.webServiceHelper runAndShowWaitingView:self.showView withTipInfo:message];
 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier=nil;
    UITableViewCell  *cell = nil;
    if ([self.type isEqualToString:@"urgent"])
    {
        NSDictionary *tmpDict = [self.aryItems objectAtIndex:indexPath.row];
        CellIdentifier = @"HandleToUrgent";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            NSArray *nibTableCells = [[NSBundle mainBundle] loadNibNamed:@"FileInListCell"owner:nil options:nil];
            cell = [nibTableCells objectAtIndex:0];
        }
        
        UILabel *numberLabel = (UILabel *)[cell viewWithTag:101];
        numberLabel.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
        
        UILabel *dateLabel = (UILabel *)[cell viewWithTag:102];
        dateLabel.text = [tmpDict objectForKey:@"djrq"];
        
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:103];
        titleLabel.text = [tmpDict objectForKey:@"bt"];
        
        UILabel *resourceLabel = (UILabel *)[cell viewWithTag:104];
        resourceLabel.text = [tmpDict objectForKey:@"ly"];
        
        UILabel *urgentLabel = (UILabel *)[cell viewWithTag:105];
        urgentLabel.text = [tmpDict objectForKey:@"hj"];
        
        UILabel *bhLabel = (UILabel *)[cell viewWithTag:106];
        bhLabel.text = [tmpDict objectForKey:@"swh"];

        
        UILabel *processLabel = (UILabel *)[cell viewWithTag:107];
        processLabel.text = [tmpDict objectForKey:@"dqhj"];
        
        UILabel *handlerLabel = (UILabel *)[cell viewWithTag:108];
        handlerLabel.text = [tmpDict objectForKey:@"dqclr"];
    }
    else if([self.type isEqualToString:@"date"]){
        NSDictionary *tmpDict = [self.aryItems objectAtIndex:indexPath.row];
        CellIdentifier = @"HandleToDate";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            NSArray *nibTableCells = [[NSBundle mainBundle] loadNibNamed:@"FileInListCell"owner:nil options:nil];
            cell = [nibTableCells objectAtIndex:1];
        }
        
        UILabel *numberLabel = (UILabel *)[cell viewWithTag:101];
        numberLabel.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
        
        UILabel *dateLabel = (UILabel *)[cell viewWithTag:102];
        dateLabel.text = [tmpDict objectForKey:@"djrq"];
        
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:103];
        titleLabel.text = [tmpDict objectForKey:@"bt"];
        
        UILabel *resourceLabel = (UILabel *)[cell viewWithTag:104];
        resourceLabel.text = [tmpDict objectForKey:@"ly"];
        
        UILabel *urgentLabel = (UILabel *)[cell viewWithTag:105];
        urgentLabel.text = [tmpDict objectForKey:@"hj"];
        
        UILabel *bhLabel = (UILabel *)[cell viewWithTag:106];
        bhLabel.text = [tmpDict objectForKey:@"swh"];
        
        
        UILabel *processLabel = (UILabel *)[cell viewWithTag:107];
        processLabel.text = [tmpDict objectForKey:@"dqhj"];
        
        UILabel *handlerLabel = (UILabel *)[cell viewWithTag:108];
        handlerLabel.text = [tmpDict objectForKey:@"dqclr"];
    }
    
    else if([self.type isEqualToString:@"process"])
    {
        /*{"文档ID":"3D9030C92443138E48257B16001023A7","序号":"1","登记日期":"2013-02-18","标题":"宁波市环保模范单位创建活动指导委员会办公室关于征求2012年度宁波市环保模范（绿色）单位意见的通知","主办部门":"宣教信息中心","缓急":"一般","当前环节":"办公室编号、正式发文","当前处理人":"郑春盛"}*/
        NSDictionary *tmpDict = [self.aryItems objectAtIndex:indexPath.row];
        CellIdentifier = @"HandleToProcess";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            NSArray *nibTableCells = [[NSBundle mainBundle] loadNibNamed:@"FileInListCell"owner:nil options:nil];
            cell = [nibTableCells objectAtIndex:2];
        }
        UILabel *numberLabel = (UILabel *)[cell viewWithTag:101];
        numberLabel.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
        
        UILabel *dateLabel = (UILabel *)[cell viewWithTag:102];
        dateLabel.text = [tmpDict objectForKey:@"djrq"];
        
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:103];
        titleLabel.text = [tmpDict objectForKey:@"bt"];
        
        UILabel *resourceLabel = (UILabel *)[cell viewWithTag:104];
        resourceLabel.text = [tmpDict objectForKey:@"ly"];
        
        UILabel *urgentLabel = (UILabel *)[cell viewWithTag:105];
        urgentLabel.text = [tmpDict objectForKey:@"hj"];
        
        UILabel *bhLable = (UILabel *)[cell viewWithTag:106];
        bhLable.text = [tmpDict objectForKey:@"swh"];
        
        UILabel *processLabel = (UILabel *)[cell viewWithTag:107];
        processLabel.text = [tmpDict objectForKey:@"dqhj"];
        
        UILabel *handlerLabel = (UILabel *)[cell viewWithTag:108];
        handlerLabel.text = [tmpDict objectForKey:@"dqclr"];
        
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 108.0f;
}

@end
