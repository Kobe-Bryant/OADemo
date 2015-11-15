//
//  OutHandleByProcessParser.m
//  NingBoOA
//
//  Created by 张仁松 on 13-9-18.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "OutBackPercent.h"
#import "ServiceUrlString.h"

@implementation OutBackPercent

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
    NSString *params = [WebServiceHelper createParametersWithKey:@"HY_TS" value:ONE_PAGE_SIZE, @"HY_START", [NSString stringWithFormat:@"%d",self.start],nil];
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:self.serviceName nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
    
    [self.webServiceHelper runAndShowWaitingView:self.showView withTipInfo:message];
   
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier=nil;
    UITableViewCell  *cell = nil;
    

    
    if([self.type isEqualToString:@"BackPrecent"])
    {
        NSDictionary *tmpDict = [self.aryItems objectAtIndex:indexPath.row];
        CellIdentifier = @"BackPrecent";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            NSArray *nibTableCells = [[NSBundle mainBundle] loadNibNamed:@"FileOutListCell"owner:nil options:nil];
            cell = [nibTableCells objectAtIndex:5];
        }
        UILabel *numberLabel = (UILabel *)[cell viewWithTag:101];
        numberLabel.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
        
        
        UILabel *hostLabel = (UILabel *)[cell viewWithTag:102];
        hostLabel.text = [tmpDict objectForKey:@"ngbm"];
        
        
        UILabel *backLabel = (UILabel *)[cell viewWithTag:103];
        backLabel.text = [tmpDict objectForKey:@"thwds"];
        
        UILabel *draftLabel = (UILabel *)[cell viewWithTag:104];
        draftLabel.text = [tmpDict objectForKey:@"ngwds"];
        
        UILabel *precentLabel = (UILabel *)[cell viewWithTag:105];
        precentLabel.text = [tmpDict objectForKey:@"thl"];
        
        UILabel *remarkLabel = (UILabel *)[cell viewWithTag:106];
        remarkLabel.text = [tmpDict objectForKey:@"bz"];
    }

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"FileOutHeaderView" owner:nil options:nil];
    UIView *headerView = [nibViews objectAtIndex:5];
    
    return headerView;
}

@end
