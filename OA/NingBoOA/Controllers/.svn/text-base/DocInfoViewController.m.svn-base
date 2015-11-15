//
//  DocInfoViewController.m
//  NingBoOA
//
//  Created by 熊熙 on 13-10-22.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DocInfoViewController.h"
#import "DisplayAttachFileController.h"
#import "SystemConfigContext.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "UICustomButton.h"
@interface DocInfoViewController ()

@end

@implementation DocInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)requestWebData{
       
    SystemConfigContext *context = [SystemConfigContext sharedInstance];
    NSDictionary *loginUsr = [context getUserInfo];
    NSString *user = [loginUsr objectForKey:@"userId"];
    
    NSString *strUrl = [ServiceUrlString generateOAWebServiceUrl];
    NSString *params = [WebServiceHelper createParametersWithKey:@"Hy_userid" value:user,@"Hy_docid",self.docid, @"Hy_modid",@"da2012",nil];
    
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:@"PagesInformation" nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
    
    [self.webServiceHelper runAndShowWaitingView:self.view withTipInfo:@"正在加载卷内详情，请稍候..."];

}

- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"卷内详情";
    
    UIBarButtonItem *backItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"返回"];
    self.navigationItem.leftBarButtonItem = backItem;
    UIButton *backButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
    [backButton addTarget:self action:@selector(goBackAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self requestWebData];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)setControlValue{
    self.titleView.layer.borderColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0].CGColor;
    
    self.titleView.layer.borderWidth =1.5;
    
    self.titleView.layer.cornerRadius =6.0;
    
    self.fwgzLabel.text = [self.infoDict objectForKey:@"Hy_FWGZ"];
    self.titleView.text = [self.infoDict objectForKey:@"Hy_FWBT"];
    self.ngdwTxt.text = [self.infoDict objectForKey:@"Hy_NGDW"];
    self.ngrTxt.text  = [self.infoDict objectForKey:@"Hy_NGR"];
    self.fwbhTxt.text = [self.infoDict objectForKey:@"Hy_FWBH"];
    self.ngsjTxt.text = [self.infoDict objectForKey:@"Hy_NGSJ"];
    self.zrzTxt.text  = [self.infoDict objectForKey:@"Hy_ZRZ"];
    self.yhTxt.text   = [self.infoDict objectForKey:@"Hy_YH"];
    self.zsdwTxt.text = [self.infoDict objectForKey:@"Hy_ZSDW"];
    self.csdwTxt.text = [self.infoDict objectForKey:@"Hy_CSDW"];
    self.mjTxt.text   = [self.infoDict objectForKey:@"Hy_MJ"];
    self.hjTxt.text   = [self.infoDict objectForKey:@"Hy_HJ"];
    self.fsTxt.text   = [self.infoDict objectForKey:@"Hy_FS"];
    self.jdTxt.text   = [self.infoDict objectForKey:@"Hy_JD"];
    self.ztcTxt.text  = [self.infoDict objectForKey:@"Hy_ZTC"];
}

#pragma mark -
#pragma mark Handle Event
- (void)goBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Handle Network Request

// -------------------------------------------------------------------------------
//	实现NSURLConnHelperDelegate委托方法
//  处理网络请求的NSData数据
// -------------------------------------------------------------------------------
- (void)processWebData:(NSData *)webData andTag:(NSInteger)tag
{
    if([webData length] <=0)
    {
        [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
    }
    
    WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:@"PagesInformationReturn" andWithJSONDelegate:self];
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
        self.infoDict = tmpParsedJsonDict;
        [self setControlValue];
        
        self.attachArray = [tmpParsedJsonDict objectForKey:@"Hy_Attach"];
        [self.attachTableView reloadData];
        [self setExtraCellLineHidden:self.attachTableView];
        
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

#pragma mark -
#pragma mark tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.attachArray count] < 1) {
        return 1;
    }
    return [self.attachArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectZero];
    headerView.font = [UIFont systemFontOfSize:19.0];
    headerView.backgroundColor = [UIColor colorWithRed:214.f/255.f green:234.f/255.f blue:254.f/255.f alpha:1.0];
    headerView.textColor = [UIColor blackColor];

    headerView.text = @"  正式文件";
    return headerView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        static NSString *CellIdentifier = @"attach_Cell";
    
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        NSArray *attachAry = [self.infoDict objectForKey:@"Hy_Attach"];
        if(attachAry == nil || [attachAry count] < 1 )
        {
            cell.textLabel.text = @"没有上传正式发文";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else
        {
            //cell.textLabel.text = [doc objectForKey:@"filename"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark -
#pragma mark tableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //查看文件
    NSArray *attachAry = [self.infoDict objectForKey:@"Hy_Attach"];
    if ([attachAry count] > 0) {
        NSDictionary *attachDict = [attachAry objectAtIndex:indexPath.row];
        if(attachDict != nil && [attachDict objectForKey:@"name"] != nil)
        {
            NSString *fileName = [attachDict objectForKey:@"name"];
            NSString *fileUrl = [attachDict objectForKey:@"url"];
            
            DisplayAttachFileController *display = [[DisplayAttachFileController alloc] initWithNibName:@"DisplayAttachFileController" fileURL:fileUrl andFileName:fileName];
            [self.navigationController pushViewController:display animated:YES];
        }
    }

}


@end
