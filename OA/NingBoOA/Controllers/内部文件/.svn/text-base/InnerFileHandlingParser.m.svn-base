//
//  InnerFileHandlingParser.h
//  内部文件管理 已办-按日期数据解析
//
//  Created by 曾静 on 13-9-27.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "InnerFileHandlingParser.h"


@implementation InnerFileHandlingParser

//初始化请求数据
-(void)requestData
{
    self.isLoading = YES;
    NSString *message =@"正在加载更多列表，请稍候...";
    if (self.isRefresh) {
        self.start = 1;
        message =@"正在加载列表，请稍候...";
        
    }
    NSString *strUrl = [ServiceUrlString generateOAWebServiceUrl];
    NSString *params = [WebServiceHelper createParametersWithKey:@"HY_USERID" value:self.user, @"HY_TS", ONE_PAGE_SIZE, @"HY_START", [NSString stringWithFormat:@"%d",self.start],nil];
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:self.serviceName nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
    
    [self.webServiceHelper runAndShowWaitingView:self.showView withTipInfo:message];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier=nil;
    UITableViewCell  *cell = nil;
    if ([self.serviceName isEqualToString:kServiceName_Handling])
    {
        NSDictionary *tmpDict = [self.aryItems objectAtIndex:indexPath.row];
        CellIdentifier = @"HandleToDate";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            NSArray *nibTableCells = [[NSBundle mainBundle] loadNibNamed:@"InnerFileListCell"owner:nil options:nil];
            cell = [nibTableCells objectAtIndex:0];
        }
        UILabel *numberLabel = (UILabel *)[cell viewWithTag:101];
        numberLabel.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
        
        UILabel *dateLabel = (UILabel *)[cell viewWithTag:102];
        dateLabel.text = [tmpDict objectForKey:@"djrq"];
        
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:103];
        titleLabel.text = [tmpDict objectForKey:@"bt"];
        
        UILabel *hostLabel = (UILabel *)[cell viewWithTag:104];
        hostLabel.text = [tmpDict objectForKey:@"zbbm"];
        
        UILabel *urgentLabel = (UILabel *)[cell viewWithTag:105];
        urgentLabel.text = [tmpDict objectForKey:@"hj"];
        
        UILabel *processLabel = (UILabel *)[cell viewWithTag:106];
        processLabel.text = [tmpDict objectForKey:@"dqhj"];
        
        UILabel *handlerLabel = (UILabel *)[cell viewWithTag:107];
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
