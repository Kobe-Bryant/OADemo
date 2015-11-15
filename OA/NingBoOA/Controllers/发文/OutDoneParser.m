//
//  OutHandleByProcessParser.m
//  NingBoOA
//
//  Created by 张仁松 on 13-9-18.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "OutDoneParser.h"
#import "ServiceUrlString.h"

@implementation OutDoneParser

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
    NSString *params = [WebServiceHelper createParametersWithKey:@"HY_USERID" value:self.user, @"HY_TS", ONE_PAGE_SIZE, @"HY_START", [NSString stringWithFormat:@"%d",self.start],@"HY_TYPE",self.type,nil];
    
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:self.serviceName nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
    
    [self.webServiceHelper runAndShowWaitingView:self.showView withTipInfo:message];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier=nil;
    UITableViewCell  *cell = nil;
    
    if([self.type isEqualToString:@"date"])
    {
        /*{"文档ID":"010B21A57A557D9148257BDD002B2736","序号":"1","登记日期":"2013-09-05","发文文号":"〔2013〕号","主办部门":"办公室","标题":"fsdfaf","是否归档":"已归档"}*/
        NSDictionary *tmpDict = [self.aryItems objectAtIndex:indexPath.row];
        CellIdentifier = @"DoneToDate";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            NSArray *nibTableCells = [[NSBundle mainBundle] loadNibNamed:@"FileOutListCell"owner:nil options:nil];
            cell = [nibTableCells objectAtIndex:3];
        }
        UILabel *numberLabel = (UILabel *)[cell viewWithTag:101];
        numberLabel.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
        
        UILabel *dateLabel = (UILabel *)[cell viewWithTag:102];
        dateLabel.text = [tmpDict objectForKey:@"djrq"];
        
        UILabel *docLabel = (UILabel *)[cell viewWithTag:103];
        docLabel.text = [tmpDict objectForKey:@"fwwh"];
        
        UILabel *hostLabel = (UILabel *)[cell viewWithTag:104];
        hostLabel.text = [tmpDict objectForKey:@"zbbm"];
        
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:105];
        titleLabel.text = [tmpDict objectForKey:@"bt"];
        
        UILabel *archiveLabel = (UILabel *)[cell viewWithTag:106];
        archiveLabel.text = [tmpDict objectForKey:@"sfgd"];
    }
    else if([self.type isEqualToString:@"wh"])
    {
        CellIdentifier = @"DoneToDoc";
        NSDictionary *tmpDict = [self.aryItems objectAtIndex:indexPath.row];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            NSArray *nibTableCells = [[NSBundle mainBundle] loadNibNamed:@"FileOutListCell"owner:nil options:nil];
            cell = [nibTableCells objectAtIndex:4];
        }
        UILabel *numberLabel = (UILabel *)[cell viewWithTag:101];
        numberLabel.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
        
        UILabel *dateLabel = (UILabel *)[cell viewWithTag:102];
        dateLabel.text = [tmpDict objectForKey:@"djrq"];
        
        UILabel *docLabel = (UILabel *)[cell viewWithTag:103];
        docLabel.text = [tmpDict objectForKey:@"fwwh"];
        
        UILabel *hostLabel = (UILabel *)[cell viewWithTag:104];
        hostLabel.text = [tmpDict objectForKey:@"zbbm"];
        
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:105];
        titleLabel.text = [tmpDict objectForKey:@"bt"];
        
        UILabel *archiveLabel = (UILabel *)[cell viewWithTag:106];
        archiveLabel.text = [tmpDict objectForKey:@"sfgd"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 99.0f;
}

@end
