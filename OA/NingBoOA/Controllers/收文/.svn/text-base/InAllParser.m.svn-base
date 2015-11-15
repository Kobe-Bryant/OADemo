//
//  InAllParser.m
//  NingBoOA
//
//  Created by 熊熙 on 13-9-25.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "InAllParser.h"
#import "ServiceUrlString.h"
#import "FileInDetailViewController.h"

@implementation InAllParser
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
    NSString *params = [WebServiceHelper createParametersWithKey:@"HY_USERID" value:self.user, @"HY_TS", ONE_PAGE_SIZE, @"HY_START", [NSString stringWithFormat:@"%d",self.start],nil];
    
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:self.serviceName nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
    
   
    [self.webServiceHelper runAndShowWaitingView:self.showView withTipInfo:message];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier=nil;
    UITableViewCell  *cell = nil;
    
    NSDictionary *tmpDict = [self.aryItems objectAtIndex:indexPath.row];
    
    CellIdentifier = @"InAllFile";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nibTableCells = [[NSBundle mainBundle] loadNibNamed:@"FileInListCell"owner:nil options:nil];
        cell = [nibTableCells objectAtIndex:4];
    }
    UILabel *numberLabel = (UILabel *)[cell viewWithTag:101];
    numberLabel.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:102];
    titleLabel.text = [tmpDict objectForKey:@"bt"];
    
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:103];
    dateLabel.text = [tmpDict objectForKey:@"djrq"];
    
    UILabel *swhLabel = (UILabel *)[cell viewWithTag:104];
    swhLabel.text = [tmpDict objectForKey:@"swh"];
    
    UILabel *resourceLabel = (UILabel *)[cell viewWithTag:105];
    resourceLabel.text = [tmpDict objectForKey:@"ly"];
    
    UILabel *urgentLabel = (UILabel *)[cell viewWithTag:106];
    urgentLabel.text = [tmpDict objectForKey:@"hj"];
    
    
    UILabel *lwhLabel = (UILabel *)[cell viewWithTag:107];
    lwhLabel.text = [tmpDict objectForKey:@"lwh"];
    
    UILabel *processLabel = (UILabel *)[cell viewWithTag:108];
    processLabel.text = [tmpDict objectForKey:@"dqhj"];
    
    UILabel *handlerLabel = (UILabel *)[cell viewWithTag:109];
    handlerLabel.text = [tmpDict objectForKey:@"dqclr"];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 108.0f;
}
@end
