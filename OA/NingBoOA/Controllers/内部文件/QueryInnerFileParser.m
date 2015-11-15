//
//  QueryInnerFileParser.m
//  NingBoOA
//
//  Created by ZHONGWEN on 13-11-27.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "QueryInnerFileParser.h"
#import "ServiceUrlString.h"

@implementation QueryInnerFileParser

- (void)requestData{
    self.isLoading = YES;
    NSString *message =@"正在加载更多列表，请稍候...";
    if (self.isRefresh) {
        self.start = 1;
        message =@"正在查询，请稍候...";
        
    }
    
    NSString *beginDate = [self.paramDict objectForKey:@"begin"];
    NSString *endDate  = [self.paramDict objectForKey:@"end"];
    NSString *bh     = [self.paramDict objectForKey:@"bh"];
    NSString *depart = [self.paramDict objectForKey:@"dept"];
    NSString *title = [self.paramDict objectForKey:@"title"];
    NSString *urgent = [self.paramDict objectForKey:@"urgent"];
    
    NSString *strUrl = [ServiceUrlString generateOAWebServiceUrl];
    NSString *params = [WebServiceHelper createParametersWithKey:@"Hy_userid" value:self.user,@"HY_startDate",beginDate,@"Hy_endDate",endDate,@"Hy_code",bh,@"Hy_BT",title,@"Hy_hj",urgent,@"Hy_department",depart,@"HY_TS",ONE_PAGE_SIZE,@"HY_START",[NSString stringWithFormat:@"%d",self.start],nil];
    
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:self.serviceName nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
    
    [self.webServiceHelper runAndShowWaitingView:self.showView withTipInfo:message];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.notSearch) {
        return 60.0;
    }
    return 99.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier=nil;
    UITableViewCell  *cell = nil;
    if (self.notSearch) {
        static NSString *tipCell = @"Tip";
        
        cell = [tableView dequeueReusableCellWithIdentifier:tipCell];
        
        if (cell == nil) {
            NSArray *nibTableCells = [[NSBundle mainBundle] loadNibNamed:@"ToDoListCell" owner:nil options:nil];
            cell = [nibTableCells objectAtIndex:1];
        }
        
        UILabel *textlabel = (UILabel *)[cell viewWithTag:101];
        
        textlabel.text = @"没有找到符合查询条件的数据";
        return cell;
        
    }
    
    NSDictionary *tmpDict = [self.aryItems objectAtIndex:indexPath.row];
    CellIdentifier = @"InquiryList";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nibTableCells = [[NSBundle mainBundle] loadNibNamed:@"InnerFileListCell"owner:nil options:nil];
        cell = [nibTableCells objectAtIndex:2];
    }
    
    UILabel *numberLabel = (UILabel *)[cell viewWithTag:101];
    numberLabel.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:102];
    titleLabel.text = [tmpDict objectForKey:@"bt"];
    
    
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:103];
    dateLabel.text = [tmpDict objectForKey:@"ngrq"];
    
    UILabel *fwwhLabel = (UILabel *)[cell viewWithTag:104];
    fwwhLabel.text = [tmpDict objectForKey:@"fwwh"];
    
    UILabel *hostLabel = (UILabel *)[cell viewWithTag:105];
    hostLabel.text = [tmpDict objectForKey:@"zbdw"];
    
    UILabel *urgentLabel = (UILabel *)[cell viewWithTag:106];
    urgentLabel.text = [tmpDict objectForKey:@"hj"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

@end
