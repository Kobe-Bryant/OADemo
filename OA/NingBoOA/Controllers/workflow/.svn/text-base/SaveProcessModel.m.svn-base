//
//  SaveProcessModel.m
//  NingBoOA
//
//  Created by PowerData on 13-10-11.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "SaveProcessModel.h"
#import "WebDataParserHelper.h"
#import "PDJsonkit.h"
#import "SystemConfigContext.h"
#import "ServiceUrlString.h"

@implementation SaveProcessModel

#pragma mark - Handle Network Request

- (void)save
{
    NSString *strUrl= [ServiceUrlString generateOAWebServiceUrl];
    NSString *params = [WebServiceHelper createParametersWithKeys:self.saveKeys andValues:self.saveValues];
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:self.serviceName nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
    [self.webServiceHelper runAndShowWaitingView:self.parentViewController.view];
}

- (void)cancel
{
    if(self.webServiceHelper)
    {
        [self.webServiceHelper cancel];
    }
}

// -------------------------------------------------------------------------------
//	实现NSURLConnHelperDelegate委托方法
//  处理网络请求的NSData数据
// -------------------------------------------------------------------------------
- (void)processWebData:(NSData *)webData
{
    if([webData length] <=0)
    {
        [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
    }
    NSString *retField = [NSString stringWithFormat:@"%@Return", self.serviceName];
    WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:retField andWithJSONDelegate:self];
    [webDataHelper parseXMLData:webData];
}

// -------------------------------------------------------------------------------
//	实现NSURLConnHelperDelegate委托方法
//  处理网络请求失败
// -------------------------------------------------------------------------------

- (void)processError:(NSError *)error
{
    [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
}

#pragma mark - Parser Network Data

// -------------------------------------------------------------------------------
//	实现WebDataParserDelegate委托方法
//  解析json字符串
// -------------------------------------------------------------------------------

- (void)parseJSONString:(NSString *)jsonStr
{
    NSLog(@"%@", jsonStr);
    NSDictionary *tmpParsedJsonDict = [jsonStr objectFromJSONString];
    BOOL bParseError = NO;
    if (tmpParsedJsonDict && jsonStr.length > 0)
    {
        int status = [[tmpParsedJsonDict objectForKey:@"status"] intValue];
        if(status == 0)
        {
            [self showAlertMessage:@"办理成功!"];
        }
        else
        {
            NSString *msg = [tmpParsedJsonDict objectForKey:@"reason"];
            [self showAlertMessage:msg];
        }
    }
    else
    {
        bParseError = YES;
    }
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

- (void)showAlertMessage:(NSString *)errorString
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:errorString delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

@end
