//
//  RemindersViewController.m
//  NingBoOA
//
//  Created by PowerData on 13-10-11.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "RemindersViewController.h"
#import "WebDataParserHelper.h"
#import "PDJsonkit.h"
#import "SystemConfigContext.h"
#import "ServiceUrlString.h"
#import "UICustomButton.h"
@interface RemindersViewController ()

@end

@implementation RemindersViewController

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
    UIBarButtonItem *backItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"返回"];
    self.navigationItem.leftBarButtonItem = backItem;
    UIButton *backButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
    [backButton addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    if(self.webServiceHelper)
    {
        [self.webServiceHelper cancel];
    }
    [super viewWillDisappear:animated];
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
    NSString *retField = [NSString stringWithFormat:@"%@Return", @"REMINDERS"];
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

#pragma mark -
#pragma mark Handle Event

- (void)goBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
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

// -------------------------------------------------------------------------------
//	弹出框
// -------------------------------------------------------------------------------

- (void)showAlertMessage:(NSString *)errorString
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:errorString delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [alert show];
}

- (void)viewDidUnload
{
    [self setOpinionTextView:nil];
    [super viewDidUnload];
}

- (IBAction)reminderButton:(id)sender
{
    if(self.opinionTextView.text == nil || self.opinionTextView.text.length == 0)
    {
        [self showAlertMessage:@"请输入您的催办意见!"];
    }
    SystemConfigContext *context = [SystemConfigContext sharedInstance];
    NSDictionary *loginUsr = [context getUserInfo];
    NSString *user = [loginUsr objectForKey:@"userId"];
    
    NSString *strUrl= [ServiceUrlString generateOAWebServiceUrl];
    NSString *params = [WebServiceHelper createParametersWithKey:@"HY_USERID" value:user, @"HY_MDID", self.modID, @"DOCID", self.docID, @"HY_OPINION", self.opinionTextView.text,nil];
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:@"REMINDERS" nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
    [self.webServiceHelper runAndShowWaitingView:self.parentViewController.view];
}

#pragma mark - UIAlertView Delegate Method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.message isEqualToString:@"办理成功!"])
    {
        BaseViewController *documentListController = (BaseViewController *)self.delegate;
        [self.navigationController popToViewController:documentListController animated:YES];
    }
}

@end
