//
//  DocumentFileInListParser.m
//  NingBoOA
//
//  Created by 熊熙 on 13-11-12.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "DocumentFileInListParser.h"
#import "ServiceUrlString.h"

@implementation DocumentFileInListParser

//初始化请求数据
-(void)requestData
{
    self.isLoading = YES;
    NSString *kssj = [self.paramDict objectForKey:@"kssj"];
    NSString *jzsj = [self.paramDict objectForKey:@"jzsj"];
    NSString *gwbh = [self.paramDict objectForKey:@"gwbh"];
    NSString *title= [self.paramDict objectForKey:@"gwbt"];
    
    NSString *strUrl = [ServiceUrlString generateOAWebServiceUrl];
    NSString *params = [WebServiceHelper createParametersWithKey:@"HY_KSSJ" value:kssj,@"HY_JZSJ",jzsj,@"HY_BH",gwbh,@"HY_TYPE",self.type,@"HY_BT",title,@"HY_TS",ONE_PAGE_SIZE, @"HY_START", [NSString stringWithFormat:@"%d",self.start],nil];

    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:self.serviceName nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
    
    if (self.isRefresh) {
        [self.webServiceHelper runAndShowWaitingView:self.showView withTipInfo:@"正在查询，请稍候..."];
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
    
    CellIdentifier = @"DocumentFileIn";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nibTableCells = [[NSBundle mainBundle] loadNibNamed:@"DocumentLibraryListCell"owner:nil options:nil];
        cell = [nibTableCells objectAtIndex:1];
    }
    
    UILabel *numberLabel = (UILabel *)[cell viewWithTag:101];
    numberLabel.text = [tmpDict objectForKey:@"xh"];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:102];
    titleLabel.text = [tmpDict objectForKey:@"bt"];
    
    UILabel *typeLabel = (UILabel *)[cell viewWithTag:103];
    typeLabel.text = [tmpDict objectForKey:@"swlb"];
    
    UILabel *swhLabel = (UILabel *)[cell viewWithTag:104];
    swhLabel.text = [tmpDict objectForKey:@"swh"];
    
    UILabel *mjLabel = (UILabel *)[cell viewWithTag:105];
    mjLabel.text = [tmpDict objectForKey:@"mj"];
    
    UILabel *swrqLabel = (UILabel *)[cell viewWithTag:106];
    swrqLabel.text = [tmpDict objectForKey:@"swrq"];
    
    UILabel *lwhLabel = (UILabel *)[cell viewWithTag:107];
    lwhLabel.text = [tmpDict objectForKey:@"lwh"];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.notSearch) {
        return 60.0;
    }
    return 108.0f;
}

@end
