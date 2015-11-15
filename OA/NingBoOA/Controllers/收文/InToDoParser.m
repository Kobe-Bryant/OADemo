//
//  InToDoParser.m
//  NingBoOA
//
//  Created by 熊熙 on 13-9-25.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "InToDoParser.h"
#import "ServiceUrlString.h"
#import "FileInDetailViewController.h"

@implementation InToDoParser

//初始化请求数据
-(void)requestData
{
    NSString *strUrl = [ServiceUrlString generateWebServiceUrl];
    NSString *params = [WebServiceHelper createParametersWithKey:@"HY_USERID" value:self.user, @"HY_TS", ONE_PAGE_SIZE, @"HY_START", [NSString stringWithFormat:@"%d",self.start],nil];
    
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:self.serviceName nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
    [self.webServiceHelper runAndShowWaitingView:self.showView];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier=nil;
    UITableViewCell  *cell = nil;
        
        NSDictionary *tmpDict = [self.aryItems objectAtIndex:indexPath.row];
        
        CellIdentifier = @"FileInToDo";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            NSArray *nibTableCells = [[NSBundle mainBundle] loadNibNamed:@"FileInListCell"owner:nil options:nil];
            cell = [nibTableCells objectAtIndex:0];
        }
        UILabel *numberLabel = (UILabel *)[cell viewWithTag:101];
        numberLabel.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
        
        UILabel *dateLabel = (UILabel *)[cell viewWithTag:102];
        dateLabel.text = [tmpDict objectForKey:@"rq"];
    
    
    UILabel *typeLabel = (UILabel *)[cell viewWithTag:103];
    typeLabel.text = [tmpDict objectForKey:@"lb"];
    
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:104];
        titleLabel.text = [tmpDict objectForKey:@"bt"];
        
        
        UILabel *urgentLabel = (UILabel *)[cell viewWithTag:105];
        urgentLabel.text = [tmpDict objectForKey:@"hj"];
        
        UILabel *handlerLabel = (UILabel *)[cell viewWithTag:106];
        handlerLabel.text = [tmpDict objectForKey:@"dqclr"];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tmpDict = [self.aryItems objectAtIndex:indexPath.row];
    NSString *process = [tmpDict objectForKey:@"dqhj"];
    NSString *docid   = [tmpDict objectForKey:@"docid"];
    [self.delegate didSelectFileInListItem:docid process:process];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 108.0f;
}

@end
