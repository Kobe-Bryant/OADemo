//
//  InquiryDocDiretory.m
//  NingBoOA
//
//  Created by 熊熙 on 13-10-20.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "InquiryDocListParser.h"
#import "ServiceUrlString.h"
@implementation InquiryDocListParser

//初始化请求数据
-(void)requestData
{
    self.isLoading = YES;
    NSString *qsjStr = [self.paramAry objectAtIndex:0];
    NSString *jzsjStr = [self.paramAry objectAtIndex:1];
    NSString *whStr = [self.paramAry objectAtIndex:2];
    NSString *btjStr = [self.paramAry objectAtIndex:3];
    
    NSString *modid = [self.paramAry objectAtIndex:4];
    
    NSString *strUrl = [ServiceUrlString generateOAWebServiceUrl];
    NSString *params = [WebServiceHelper createParametersWithKey:@"Hy_userid" value:self.user,@"Hy_qssj",qsjStr,@"Hy_jzsj",jzsjStr,@"Hy_bt",btjStr,@"Hy_wh",whStr,@"Hy_ts", ONE_PAGE_SIZE, @"Hy_start", [NSString stringWithFormat:@"%d",self.start], @"Hy_modid",modid,nil];
    
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:self.serviceName nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
    
    if (self.isRefresh) {
        [self.webServiceHelper runAndShowWaitingView:self.showView withTipInfo:@"正在查询卷内，请稍候..."];
    }
    else {
        [self.webServiceHelper runAndShowWaitingView:self.showView withTipInfo:@"正在加载更多列表，请稍候..."];
    }


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
        
        textlabel.text = @"没有找到符合查询条件的文档";
        return cell;
    }
    
    NSDictionary *tmpDict = [self.aryItems objectAtIndex:indexPath.row];
    
    CellIdentifier = @"InquieryFile";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nibTableCells = [[NSBundle mainBundle] loadNibNamed:@"ArchiveListCell"owner:nil options:nil];
        cell = [nibTableCells objectAtIndex:1];
    }
    
    UILabel *numberLabel = (UILabel *)[cell viewWithTag:101];
    numberLabel.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:102];
    titleLabel.text = [tmpDict objectForKey:@"title"];
    
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:103];
    dateLabel.text = [tmpDict objectForKey:@"date"];
    
    UILabel *whLabel = (UILabel *)[cell viewWithTag:104];
    whLabel.text = [tmpDict objectForKey:@"wh"];
    
    
    UILabel *jhLabel = (UILabel *)[cell viewWithTag:105];
    jhLabel.text = [tmpDict objectForKey:@"jh"];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tmpDict = [self.aryItems objectAtIndex:indexPath.row];
    [self.delegate didSelectArchiveListInfo:tmpDict Type:@"doc"];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.aryItems count] < 1) {
        return 60.0;
    }
    return 88.0f;
}


@end
