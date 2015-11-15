//
//  MeetingRoomManagerViewController.m
//  NingBoOA
//
//  Created by 熊熙 on 13-11-11.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "MeetingRoomManagerViewController.h"
#import "UICustomButton.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "SystemConfigContext.h"
#import "MeetingRoomListParser.h"
#import "MeetingRoomArrangeListParser.h"
#import "MeetingRoomHistoryListParser.h"
#import "MeetingRoomPersonListParser.h"
#import "MeetingRoomAvaliableListParser.h"
#import "MeetingRoomUsingListParser.h"
#import "MeetingRoomDetailViewController.h"
@interface MeetingRoomManagerViewController ()
@property (strong, nonatomic) UIPopoverController *popController;
@end

@implementation MeetingRoomManagerViewController


#pragma mark -
#pragma mark viewlife cycle
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
    self.title = @"会议室管理";
    
    UIBarButtonItem *backItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"返回"];
    self.navigationItem.leftBarButtonItem = backItem;
    UIButton *backButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
    [backButton addTarget:self action:@selector(goBackAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *listItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"会议室管理"];
    self.navigationItem.leftBarButtonItem = listItem;
    
    UIButton *listButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
    [listButton addTarget:self action:@selector(docManagerList:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem,listItem, nil];
    
    UIBarButtonItem *historyItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"申请会议室"];
    self.navigationItem.rightBarButtonItem = historyItem;
    
    UIButton *historyButton = (UIButton *)self.navigationItem.rightBarButtonItem.customView;
    [historyButton addTarget:self action:@selector(showMeetingRoomDetailView:) forControlEvents:UIControlEventTouchUpInside];
    
    self.meetingroomListParser = [[MeetingRoomArrangeListParser alloc] init];
    self.meetingroomListParser.delegate = self;
    self.meetingroomListParser.serviceName = @"meetingPlanList";
    self.meetingroomListParser.showView = self.view;
    self.meetingroomListParser.listTableView = self.listTableView;
    self.listTableView.dataSource = self.meetingroomListParser;
    self.listTableView.delegate = self.meetingroomListParser;
    [self.meetingroomListParser requestData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Event Handle

- (void)goBackAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)docManagerList:(id)sender{
    UIButton *button = (UIButton *)sender;
    FileManagerListController *fileManagerListController = [[FileManagerListController alloc] initWithStyle:UITableViewStylePlain];
    fileManagerListController.fileOutList = @[@"会议安排",@"历史纪录",@"个人待办",@"空闲会议室",@"在用会议室"];
    fileManagerListController.delegate = self;
    
    UIPopoverController* tmpController = [[UIPopoverController alloc] initWithContentViewController:fileManagerListController];
    
    tmpController.popoverContentSize = CGSizeMake(240,44*5);
    self.popController = tmpController;
    [self.popController presentPopoverFromRect:button.bounds inView:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)showMeetingRoomDetailView:(id)sender {
    MeetingRoomDetailViewController *meetingRoomDetailViewController = [[MeetingRoomDetailViewController alloc] initWithNibName:@"MeetingRoomDetailViewController" bundle:nil];
    meetingRoomDetailViewController.isCurrent = YES;
    meetingRoomDetailViewController.delegate = self;
    [self.navigationController pushViewController:meetingRoomDetailViewController animated:YES];
}

#pragma mark - MeetingRoomDetailDelegate
- (void)didSelectMeetingRoomListItem:(NSString *)meetid {
    
    SystemConfigContext *context = [SystemConfigContext sharedInstance];
    NSDictionary *loginUsr = [context getUserInfo];
    NSString *user = [loginUsr objectForKey:@"userId"];
    NSString *strUrl = [ServiceUrlString generateOAWebServiceUrl];
    NSString *params = [WebServiceHelper createParametersWithKey:@"HY_userid" value:user, @"HY_meetid",meetid,nil];
    
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:@"MeetingRoomInformation" nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
   
    [self.webServiceHelper runAndShowWaitingView:self.view withTipInfo:@"正在加载会议详情，请稍候..."];
}

- (void)loadMoreList {
    self.meetingroomListParser.isRefresh = NO;
    [self.meetingroomListParser requestData];
}

- (void)loadDocumentLibarryDetailViewInfo:(NSDictionary *)meetingInfo{
    MeetingRoomDetailViewController *meetingRoomDetailViewController = [[MeetingRoomDetailViewController alloc] initWithNibName:@"MeetingRoomDetailViewController" bundle:nil];
    meetingRoomDetailViewController.meetngInfo = meetingInfo;
    meetingRoomDetailViewController.isCurrent  = NO;
    [self.navigationController pushViewController:meetingRoomDetailViewController animated:YES];
}

#pragma mark -
#pragma mark HandleGWDelegate
- (void)HandleGWResult:(BOOL)ret {
    self.meetingroomListParser.isRefresh = YES;
    [self.meetingroomListParser requestData];
}

#pragma mark - FileManager Delegate

// -------------------------------------------------------------------------------
//	实现FileManager Delegate委托方法
//  选中公文管理列表后调用此方法
// -------------------------------------------------------------------------------

- (void)returnSelectResult:(NSString *)type selected:(NSInteger)row
{
    [self.meetingroomListParser.aryItems removeAllObjects];
    [self.listTableView reloadData];
    [self.popController dismissPopoverAnimated:YES];
    
    switch (row) {
        case 0:
            self.title = @"会议安排";
            self.meetingroomListParser = [[MeetingRoomArrangeListParser alloc] init];
            self.meetingroomListParser.serviceName = @"meetingPlanList";
            self.meetingroomListParser.showView = self.view;
            self.meetingroomListParser.delegate = self;
            [self.meetingroomListParser requestData];
            break;
            
        case 1:
            self.title = @"历史纪录";
            self.meetingroomListParser = [[MeetingRoomHistoryListParser alloc] init];
            self.meetingroomListParser.serviceName = @"meetingRoomHistory";
            self.meetingroomListParser.showView = self.view;
            self.meetingroomListParser.delegate = self;
            [self.meetingroomListParser requestData];
            break;
            
        case 2:
            self.title = @"个人待办";
            self.meetingroomListParser = [[MeetingRoomPersonListParser alloc] init];
            self.meetingroomListParser.serviceName = @"personToDoList";
            self.meetingroomListParser.showView = self.view;
            self.meetingroomListParser.delegate = self;
            [self.meetingroomListParser requestData];
            break;
            
        case 3:
            self.title = @"空闲会议室";
            self.meetingroomListParser = [[MeetingRoomAvaliableListParser alloc] init];
            self.meetingroomListParser.type = @"limit";
            self.meetingroomListParser.serviceName = @"avaliableMeetingroom";
            self.meetingroomListParser.showView = self.view;
            self.meetingroomListParser.delegate = self;
            [self.meetingroomListParser requestData];
            break;
        case 4:
            self.title = @"在用会议室";
            self.meetingroomListParser = [[MeetingRoomUsingListParser alloc] init];
            self.meetingroomListParser.type = @"limit";
            self.meetingroomListParser.serviceName = @"usingMeetingroom";
            self.meetingroomListParser.showView = self.view;
            self.meetingroomListParser.delegate = self;
            [self.meetingroomListParser requestData];
            break;
            
        default:
            break;
    }
    
    self.meetingroomListParser.listTableView = self.listTableView;
    self.listTableView.dataSource = self.meetingroomListParser;
    self.listTableView.delegate = self.meetingroomListParser;
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
    WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:@"MeetingRoomInformationReturn" andWithJSONDelegate:self];
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
        
        [self loadDocumentLibarryDetailViewInfo:tmpParsedJsonDict];
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

@end
