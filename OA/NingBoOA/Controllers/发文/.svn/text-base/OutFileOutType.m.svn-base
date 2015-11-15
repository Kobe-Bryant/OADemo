//
//  OutHandleByProcessParser.m
//  NingBoOA
//
//  Created by 张仁松 on 13-9-18.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "OutFileOutType.h"
#import "ServiceUrlString.h"

@implementation OutFileOutType

//初始化请求数据
-(void)requestData
{
    self.isLoading = YES;
    NSString *strUrl = [ServiceUrlString generateOAWebServiceUrl];
    NSString *params = [WebServiceHelper createParametersWithKey:@"HY_TS" value:ONE_PAGE_SIZE, @"HY_START", [NSString stringWithFormat:@"%d",self.start],nil];
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:self.serviceName nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
    if (self.isRefresh) {
        [self.webServiceHelper runAndShowWaitingView:self.showView withTipInfo:@"正在加载列表，请稍候..."];
    }
    else {
        [self.webServiceHelper runAndShowWaitingView:self.showView withTipInfo:@"正在加载更多列表，请稍候..."];
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier=nil;
    UITableViewCell  *cell = nil;
    if([self.type isEqualToString:@"发文按类别"])
    {
        /*{"文档ID":"010B21A57A557D9148257BDD002B2736","序号":"1","登记日期":"2013-09-05","发文文号":"〔2013〕号","主办部门":"办公室","标题":"fsdfaf","是否归档":"已归档"}*/
        NSDictionary *tmpDict = [self.aryItems objectAtIndex:indexPath.row];
        CellIdentifier = @"FileOutType";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            NSArray *nibTableCells = [[NSBundle mainBundle] loadNibNamed:@"FileOutListCell"owner:nil options:nil];
            cell = [nibTableCells objectAtIndex:4];
        }
        UILabel *numberLabel = (UILabel *)[cell viewWithTag:101];
        numberLabel.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
        
        UILabel *typeLabel = (UILabel *)[cell viewWithTag:102];
        typeLabel.text = [tmpDict objectForKey:@"fwlb"];
    }

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

@end
