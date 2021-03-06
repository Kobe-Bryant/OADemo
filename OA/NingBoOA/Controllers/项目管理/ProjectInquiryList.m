//
//  OutInquiryList.m
//  NingBoOA
//
//  Created by 熊熙 on 13-10-25.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "ProjectInquiryList.h"
#import "ServiceUrlString.h"

@implementation ProjectInquiryList

- (void)requestData{
    self.isLoading = YES;
    NSString *beginDate = [self.paramDict objectForKey:@"begin"];
    NSString *endDate  = [self.paramDict objectForKey:@"end"];
    NSString *fwbh     = [self.paramDict objectForKey:@"fwbh"];
    NSString *depart = [self.paramDict objectForKey:@"dept"];
    NSString *title = [self.paramDict objectForKey:@"title"];
    NSString *urgent = [self.paramDict objectForKey:@"urgent"];
    
    NSString *strUrl = [ServiceUrlString generateOAWebServiceUrl];
    NSString *params = [WebServiceHelper createParametersWithKey:@"Hy_userid" value:self.user,@"HY_TS",ONE_PAGE_SIZE,@"HY_START",[NSString stringWithFormat:@"%d",self.start],@"HY_QSSJ",beginDate,@"Hy_JZSJ",endDate,@"Hy_bh",fwbh,@"Hy_DEPART",depart,@"Hy_TITLE",title,@"Hy_urgent",urgent,nil];
    
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:self.serviceName nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
   
    if (self.isRefresh) {
         [self.webServiceHelper runAndShowWaitingView:self.showView withTipInfo:@"正在查询，请稍候..."];
    }
    else {
        [self.webServiceHelper runAndShowWaitingView:self.showView withTipInfo:@"正在加载更多列表，请稍候..."];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 99.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier=nil;
    UITableViewCell  *cell = nil;
    if([self.type isEqualToString:@"InquiryList"])
    {
        NSDictionary *tmpDict = [self.aryItems objectAtIndex:indexPath.row];
        CellIdentifier = @"InquiryList";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            NSArray *nibTableCells = [[NSBundle mainBundle] loadNibNamed:@"FileOutListCell"owner:nil options:nil];
            cell = [nibTableCells objectAtIndex:6];
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
        hostLabel.text = [tmpDict objectForKey:@"zbbm"];
        
        UILabel *urgentLabel = (UILabel *)[cell viewWithTag:106];
        urgentLabel.text = [tmpDict objectForKey:@"hj"];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    return cell;
}

@end

