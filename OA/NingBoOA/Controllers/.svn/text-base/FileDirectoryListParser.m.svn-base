//
//  FileDirectoryListParser.m
//  NingBoOA
//
//  Created by 熊熙 on 13-10-20.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "FileDirectoryListParser.h"
#import "ServiceUrlString.h"
@implementation FileDirectoryListParser

//初始化请求数据
-(void)requestData
{
    self.isLoading = YES;
    NSString *modid = [self.paramAry objectAtIndex:1];
    if (modid == nil) {
        modid = @"";
    }

    NSString *strUrl = [ServiceUrlString generateOAWebServiceUrl];
    NSString *params = [WebServiceHelper createParametersWithKey:@"Hy_userid" value:self.user,@"Hy_ts", ONE_PAGE_SIZE, @"Hy_start", [NSString stringWithFormat:@"%d",self.start], @"Hy_modid",modid,nil];
    
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:self.serviceName nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
    
    if (self.isRefresh) {
        [self.webServiceHelper runAndShowWaitingView:self.showView withTipInfo:@"正在加载列表，请稍候..."];
    }
    else {
        [self.webServiceHelper runAndShowWaitingView:self.showView withTipInfo:@"正在加载更多列表，请稍候..."];
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    NSString *title = [self.paramAry objectAtIndex:0];
    UILabel *tmpheaderView = [[UILabel alloc] initWithFrame:CGRectZero];
    tmpheaderView.font = [UIFont systemFontOfSize:17.0];
    tmpheaderView.backgroundColor = [UIColor colorWithRed:159.0/255 green:215.0/255 blue:230.0/255 alpha:1.0];
    tmpheaderView.textColor = [UIColor blackColor];
    tmpheaderView.text = [NSString stringWithFormat:@"  %@",title];
    if ([title length] <= 0) {
        tmpheaderView.text = @"  最新档案";
    }
    return tmpheaderView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier=nil;
    UITableViewCell  *cell = nil;
    
        NSDictionary *tmpDict = [self.aryItems objectAtIndex:indexPath.row];
        
        CellIdentifier = @"FileDirectory";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            NSArray *nibTableCells = [[NSBundle mainBundle] loadNibNamed:@"ArchiveListCell"owner:nil options:nil];
            cell = [nibTableCells objectAtIndex:2];
        }
        
        UILabel *numberLabel = (UILabel *)[cell viewWithTag:101];
        numberLabel.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
        
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:102];
        titleLabel.text = [tmpDict objectForKey:@"title"];
        
        UILabel *dateLabel = (UILabel *)[cell viewWithTag:103];
        dateLabel.text = [tmpDict objectForKey:@"time"];
        
        UILabel *archiveLabel = (UILabel *)[cell viewWithTag:104];
        archiveLabel.text = [tmpDict objectForKey:@"bh"];
        
        UILabel *pagesLabel = (UILabel *)[cell viewWithTag:105];
        pagesLabel.text = [tmpDict objectForKey:@"pages"];
        
        UILabel *deadlineLabel = (UILabel *)[cell viewWithTag:106];
        deadlineLabel.text = [tmpDict objectForKey:@"deadline"];
        
        UILabel *yearLabel = (UILabel *)[cell viewWithTag:107];
        yearLabel.text = [tmpDict objectForKey:@"year"];
        
        UILabel *libraryLabel = (UILabel *)[cell viewWithTag:108];
        libraryLabel.text = [tmpDict objectForKey:@"repositoryid"];
        
        UILabel *remarkLabel = (UILabel *)[cell viewWithTag:109];
        remarkLabel.text = [tmpDict objectForKey:@"remark"];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tmpDict = [self.aryItems objectAtIndex:indexPath.row];
    [self.delegate didSelectArchiveListInfo:tmpDict Type:@"file"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 108.0f;
}

@end
