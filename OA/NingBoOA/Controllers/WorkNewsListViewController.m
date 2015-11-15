//
//  WorkNewsListViewController.m
//  NingBoOA
//
//  Created by PowerData on 13-10-16.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "WorkNewsListViewController.h"
#import "NoticeDetailViewController.h"
#import "ShowWebViewController.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "UICustomButton.h"
#import "PopupDateViewController.h"

@interface WorkNewsListViewController ()<UITextFieldDelegate,PopupDateDelegate>
@property (nonatomic,strong) UIPopoverController *poverController;
@property (nonatomic,assign) NSInteger saveTag;
@end

@implementation WorkNewsListViewController

- (void)requestWebData {
    NSString *strUrl= [ServiceUrlString generateNewsWebServiceUrl];
    NSString *params = [WebServiceHelper createParametersWithKey:@"IdentifyCode" value:@"NBEPB", @"ClassGuid",@"9d6f8e70-afab-4827-a9ff-5e6a0cf7505a",@"SearchKey",self.searchKey,@"PageSize",@"10",@"PageSizeSpecified",@"true",@"PageIndex",[NSString stringWithFormat:@"%d",self.start],@"PageIndexSpecified",@"true",nil];
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:@"Json_Article_List" nameSpace:@"http://tempuri.org/IWcfArticle"  parameters:params delegate:self];
    [self.webServiceHelper runAndShowWaitingView:self.view withTipInfo:@"正在加载列表，请稍候..."];
}

- (IBAction)queryNoticeLisr:(id)sender{
    [self.titleField resignFirstResponder];
    self.searchKey = self.titleField.text;
    [self requestWebData];
}
- (IBAction)textFieldTouchDonw:(UITextField *)sender {
    self.saveTag = sender.tag;
    PopupDateViewController *dateViewController = [[PopupDateViewController alloc]initWithPickerMode:UIDatePickerModeDate];
    dateViewController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:dateViewController];
    self.poverController = [[UIPopoverController alloc]initWithContentViewController:navigationController];
    [self.poverController presentPopoverFromRect:sender.bounds inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - PopupDateDelegate

-(void)PopupDateController:(PopupDateViewController *)controller Saved:(BOOL)bSaved selectedDate:(NSDate *)date{
    if (bSaved) {
        NSDateFormatter *matter = [[NSDateFormatter alloc]init];
        [matter setDateFormat:@"yyyy-MM-dd"];
        NSString *time = [matter stringFromDate:date];
        if (self.saveTag == 1) {
            self.startDateField.text = time;
        }
        else{
            self.endDateField.text = time;
        }
    }
    [self.poverController dismissPopoverAnimated:YES];
}

#pragma mark - UITextField

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}

#pragma mark - Handle Network Request

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
    WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:@"Json_Article_ListResult" andWithJSONDelegate:self];
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

- (void)parseJSONString:(NSString *)jsonStr andTag:(NSInteger)tag
{
    NSDictionary *tmpParsedJsonDict = [jsonStr objectFromJSONString];
    BOOL bParseError = NO;
    if (tmpParsedJsonDict && jsonStr.length > 0)
    {
        self.infoArray = [tmpParsedJsonDict objectForKey:@"Table"];
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



#pragma mark - tableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.infoArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *tmpheaderView = [[UILabel alloc] initWithFrame:CGRectZero];
    tmpheaderView.font = [UIFont systemFontOfSize:17.0];
    tmpheaderView.backgroundColor = [UIColor colorWithRed:159.0/255 green:215.0/255 blue:230.0/255 alpha:1.0];
    tmpheaderView.textColor = [UIColor blackColor];
    tmpheaderView.text = @"  工作动态";
    return tmpheaderView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Notice_Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 600, 30)];
        detailLabel.textAlignment = UITextAlignmentLeft;
        detailLabel.textColor = [UIColor grayColor];
        detailLabel.font = [UIFont systemFontOfSize:16];
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.tag = 101;
        
        [cell.contentView addSubview:detailLabel];
    }
    
    NSDictionary *infoDict = [self.infoArray objectAtIndex:indexPath.row];
    NSString *title = [infoDict objectForKey:@"Title"];;
    NSString *from = [infoDict objectForKey:@"CopyFrom"];
    NSString *time  = [infoDict objectForKey:@"CreateTime"];
    
    NSString *backgroundImagePath = [[NSBundle mainBundle] pathForResource:(indexPath.row%2 == 0) ? @"lightblue" : @"white" ofType:@"png"];
    UIImage *backgroundImage = [[UIImage imageWithContentsOfFile:backgroundImagePath] stretchableImageWithLeftCapWidth:0.0 topCapHeight:1.0];
    cell.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage] ;
    cell.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    cell.backgroundView.frame = cell.bounds;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    cell.textLabel.font  = [UIFont systemFontOfSize:20];
    
    cell.textLabel.text = title;
    
    
    UILabel *detailLabel = (UILabel *)[cell.contentView viewWithTag:101];
    
    NSString *detailStr = [NSString stringWithFormat:@"[%@,%@]",from,time];
    detailLabel.text = detailStr;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark -
#pragma mark tableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NoticeDetailViewController *detail = [[NoticeDetailViewController alloc] initWithNibName:@"NoticeDetailViewController" bundle:nil];
    //    detail.title = @"通知公告详细信息";
    //    detail.noticeID = @"";
    //    [self.navigationController pushViewController:detail animated:YES];
    NSDictionary *infoDict = [self.infoArray objectAtIndex:indexPath.row];
    NSString *Guid_Class = [infoDict objectForKey:@"Guid_Class"];
    NSString *Guid_Info  = [infoDict objectForKey:@"Guid_Info"];
    NSString *strURL = [NSString stringWithFormat:@"http://10.33.2.14/Info_Show.aspx?ClassID=%@&InfoID=%@&SearchKey=&CopyFrom=",Guid_Class,Guid_Info];
    
    ShowWebViewController *webViewController = [[ShowWebViewController alloc] initWithURLString:strURL Title:@"通知公告详细信息"];
    [self.navigationController pushViewController:webViewController animated:YES];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"工作动态查询";
        self.searchKey = @"";
        self.start = 1;
    }
    return self;
}

-(void)goBackAction:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *backItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"返回"];
    UIButton *backButton = (UIButton*)backItem.customView;
    [backButton addTarget:self action:@selector(goBackAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = backItem;
    
    [self requestWebData];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setTitleLabel:nil];
    [self setTitleField:nil];
    [self setStartDateLabel:nil];
    [self setStartDateField:nil];
    [self setEndDateLabel:nil];
    [self setEndDateField:nil];
    [self setSearchButton:nil];
    [self setListTableView:nil];
    [super viewDidUnload];
}

@end
