//
//  DocumentLibraryListParser.m
//  NingBoOA
//
//  Created by 熊熙 on 13-11-11.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "DocumentLibraryListParser.h"
#import "SystemConfigContext.h"
#import "WebDataParserHelper.h"
#import "PDJsonkit.h"

@interface DocumentLibraryListParser()

@end

@implementation DocumentLibraryListParser
@synthesize showView,aryItems;
@synthesize type,webServiceHelper,serviceName,listTableView;

#pragma mark - Table view data source
-(id)init{
    self = [super init];
    if(self){
        self.isRefresh = YES;
        self.start = 1;
        SystemConfigContext *context = [SystemConfigContext sharedInstance];
        NSDictionary *loginUsr = [context getUserInfo];
        self.user = [loginUsr objectForKey:@"userId"];
        self.aryItems = [NSMutableArray arrayWithCapacity:10];
    }
    return self;
}

#pragma mark -
#pragma mark UIScrollView Delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.notSearch) return;
    if (self.isLoading) return;
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 850 ) {
        self.isLoading = YES;
        self.isRefresh = NO;
        [self.delegate loadMoreList];
    }
}

-(void)requestData{
    
}

-(void)cancelRequest{
    [webServiceHelper cancel];
}

-(void)showAlertMessage:(NSString*)msg{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message:msg
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];
    return;
}

-(void)processWebData:(NSData*)webData{
    //NSString *log = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", log);
    if([webData length] <=0)
    {
        [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
    }
    WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:[NSString stringWithFormat:@"%@Return",self.serviceName] andWithJSONDelegate:self];
    [webDataHelper parseXMLData:webData];
}

-(void)processError:(NSError *)error{
}


// -------------------------------------------------------------------------------
//	实现WebDataParserDelegate委托方法
//  解析json字符串
// -------------------------------------------------------------------------------

- (void)parseJSONString:(NSString *)jsonStr
{
    NSDictionary *tmpParsedJsonDict = [jsonStr objectFromJSONString];
    BOOL bParseError = NO;
    if (tmpParsedJsonDict && jsonStr.length > 0)
    {
        self.isLoading = NO;
        self.total = [tmpParsedJsonDict objectForKey:@"total"];
        NSArray *tmpAry = [tmpParsedJsonDict objectForKey:@"listinfo"];
        
        if([tmpAry count] > 0){
            self.notSearch = NO;
            self.start = [tmpAry count] +self.start;
            if (self.isRefresh) {
                [aryItems removeAllObjects];
                [aryItems addObjectsFromArray:tmpAry];
            }
            else {
                [aryItems removeAllObjects];
                [aryItems addObjectsFromArray:tmpAry];
            }
        }
        else {
            
            if (self.isRefresh) {
                self.notSearch = YES;
                [aryItems removeAllObjects];
            }
            else{
                [self showAlertMessage:@"已经显示最后一条数据!"];
            }
            
        }
    }
    else
    {
        bParseError = YES;
    }
    
    [self.listTableView reloadData];
    
    if (bParseError)
    {
        [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
    }
}

// -------------------------------------------------------------------------------
//	实现WebDataParserDelegate委托方法
//  解析json字符串发生错误
// -------------------------------------------------------------------------------

- (void)parseWithError:(NSString *)errorString
{
    [self showAlertMessage:errorString];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectZero];
    headerView.font = [UIFont systemFontOfSize:17.0];
    headerView.backgroundColor = [UIColor colorWithRed:159.0/255 green:215.0/255 blue:230.0/255 alpha:1.0];
    headerView.textColor = [UIColor blackColor];
    
    if ([self.aryItems count] < 1) {
        headerView.text = @"  查询结果";
    }
    else {
        headerView.text = [NSString stringWithFormat:@"  共有%@个符合条件的文档",self.total];
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.notSearch) {
        return 1;
    }
    return [aryItems count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.aryItems count] < 1) {
        return;
    }
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *infoDict = [self.aryItems objectAtIndex:indexPath.row];
    [self.delegate didSelectDocumentLibraryListInfo:infoDict];
}
@end
