//
//  ApplicationAllListParser.m
//  NingBoOA
//
//  Created by 熊熙 on 13-11-7.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "ApplicationAllListParser.h"

@implementation ApplicationAllListParser

//初始化请求数据
-(void)requestData
{
    self.isLoading = YES;
    NSString *strUrl = [ServiceUrlString generateOAWebServiceUrl];
    NSString *params = [WebServiceHelper createParametersWithKey:@"HY_USERID" value:self.user, @"HY_TS", ONE_PAGE_SIZE, @"HY_START", [NSString stringWithFormat:@"%d",self.start],nil];
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
    if ([self.serviceName isEqualToString:kServiceName_ALLByDate])
    {
        NSDictionary *tmpDict = [self.aryItems objectAtIndex:indexPath.row];
        CellIdentifier = @"ToDo";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            NSArray *nibTableCells = [[NSBundle mainBundle] loadNibNamed:@"ApplicationListCell"owner:nil options:nil];
            cell = [nibTableCells objectAtIndex:0];
        }
        
        UILabel *numberLabel = (UILabel *)[cell viewWithTag:101];
        numberLabel.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:102];
        titleLabel.text = [tmpDict objectForKey:@"bt"];
        
        UILabel *dateLabel = (UILabel *)[cell viewWithTag:103];
        dateLabel.text = [tmpDict objectForKey:@"djrq"];
        
        UILabel *typeLabel = (UILabel *)[cell viewWithTag:104];
        typeLabel.text = [tmpDict objectForKey:@"lb"];
        
        UILabel *urgentLabel = (UILabel *)[cell viewWithTag:105];
        urgentLabel.text = [tmpDict objectForKey:@"hj"];
        
        UILabel *bhLabel = (UILabel *)[cell viewWithTag:106];
        bhLabel.text = [tmpDict objectForKey:@"bh"];
        
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
