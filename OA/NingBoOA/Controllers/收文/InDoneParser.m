//
//  InDoneParser.m
//  NingBoOA
//
//  Created by 熊熙 on 13-9-25.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "InDoneParser.h"
#import "ServiceUrlString.h"
#import "FileOutDetailViewController.h"

@implementation InDoneParser

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
    /*{"文档ID":"B331FFBEB415A9A248257BEA0004BAB8","序号":"1","登记日期":"2013-09-18","标题":"宁波生态环境治理","主办部门":"办公室","缓急":"一般","当前环节":"办公室编号、正式发文","当前处理人":"郑春盛"},{"文档ID":"AF3A1501D9C43C0448257BE90033E438","序号":"2","登记日期":"2013-09-17","标题":"fsdfsdf","主办部门":"办公室","缓急":"一般","当前环节":"处室负责人把关","当前处理人":"翁劲草"}*/
    CellIdentifier = @"InHaveDone";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nibTableCells = [[NSBundle mainBundle] loadNibNamed:@"FileInListCell"owner:nil options:nil];
        cell = [nibTableCells objectAtIndex:3];
    }
    
    UILabel *numberLabel = (UILabel *)[cell viewWithTag:101];
    numberLabel.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:102];
    titleLabel.text = [tmpDict objectForKey:@"bt"];
    
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:103];
    dateLabel.text = [tmpDict objectForKey:@"djrq"];
    
    UILabel *resourceLabel = (UILabel *)[cell viewWithTag:104];
    resourceLabel.text = [tmpDict objectForKey:@"ly"];
    
    UILabel *bhLable = (UILabel *)[cell viewWithTag:105];
    bhLable.text = [tmpDict objectForKey:@"swh"];
    
    UILabel *urgentLabel = (UILabel *)[cell viewWithTag:106];
    urgentLabel.text = [tmpDict objectForKey:@"hj"];
    
   
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 108.0f;
}
@end
