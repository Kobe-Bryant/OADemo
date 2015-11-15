//
//  RebackViewController.m
//  NingBoOA
//
//  Created by PowerData on 13-10-11.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "RebackViewController.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "SystemConfigContext.h"

@interface RebackViewController ()


@end

@implementation RebackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self requestData];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Handle Network Request

- (void)requestData
{
    SystemConfigContext *context = [SystemConfigContext sharedInstance];
    NSDictionary *loginUsr = [context getUserInfo];
    NSString *user = [loginUsr objectForKey:@"userId"];
    
    NSString *strUrl = [ServiceUrlString generateOAWebServiceUrl];
    NSString *params = [WebServiceHelper createParametersWithKey:@"HY_USERID" value:user, @"Hy_mdid", self.mdID,@"docid",self.docID, nil];
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:@"REBACK" nameSpace:WEBSERVICE_NAMESPACE parameters:params delegate:self];
    [self.webServiceHelper run];
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
    WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:@"REBACKReturn" andWithJSONDelegate:self];
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

#pragma mark - UIAlertView Delegate Method

// -------------------------------------------------------------------------------
//	实现UIAlertView Delegate委托方法
//  如果办理成功实现点击按钮后跳转到列表页面
// -------------------------------------------------------------------------------

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.message isEqualToString:@"办理成功!"])
    {
        [self.navigationController popViewControllerAnimated:YES];
        [self.delegate HandleGWResult:TRUE];
    }
}

@end
