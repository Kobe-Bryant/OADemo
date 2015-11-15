//
//  PublicOpinionManagerViewController.m
//  NingBoOA
//
//  Created by PowerData on 13-10-15.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "PublicOpinionManagerViewController.h"
#import "UICustomButton.h"
#import "SystemConfigContext.h"
#import "PDJsonkit.h"
#import "PublicOpinionDetailViewController.h"
#import "PublicOpinionHandlingParser.h"
#import "PublicOpinionDoneParser.h"
#import "PublicOpinionAllByDateParser.h"
#import "QueryPublicOpinionParser.h"

#define kTag_StartDate_Field 1001 //拟稿日期
#define kTag_EndDate_Field 1002 //截止日期
#define kTag_Year_Field 1003 //年份

@interface PublicOpinionManagerViewController ()
@property (nonatomic,strong) UIPopoverController *popController;
@property (nonatomic,strong) UIPopoverController *datePopController;
@property (nonatomic,strong) PopupDateViewController *dateController;
@property (nonatomic,strong) PublicOpinionListParser *publicOpinionListParser;
@property (nonatomic,assign) int currentTag;
@end

@implementation PublicOpinionManagerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initQueryView
{
    [self.searchButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.startDateField.tag = kTag_StartDate_Field;
    self.endDateField.tag = kTag_EndDate_Field;
    self.startDateField.delegate = self;
    self.endDateField.delegate = self;
    [self.startDateField addTarget:self action:@selector(touchForDate:) forControlEvents:UIControlEventTouchDown];
    [self.endDateField addTarget:self action:@selector(touchForDate:) forControlEvents:UIControlEventTouchDown];
    [self.searchButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"在办舆情";
    
    //导航栏上面的按钮初始化
    UIBarButtonItem *backItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"返回"];
    self.navigationItem.leftBarButtonItem = backItem;
    UIButton *backButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
    [backButton addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *listItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"舆情信息"];
    self.navigationItem.leftBarButtonItem = listItem;
    UIButton *listButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
    [listButton addTarget:self action:@selector(docManagerList:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem,listItem, nil];
    
    //初始化请求数据
    self.publicOpinionListParser = [[PublicOpinionHandlingParser alloc] init];
    self.publicOpinionListParser.serviceName = @"GETHANDLEPUBLICOPINIONLIST";
    self.publicOpinionListParser.showView = self.view;
    self.publicOpinionListParser.delegate = self;
    self.publicOpinionListParser.listTableView = self.listTableView;
    self.listTableView.delegate = self.publicOpinionListParser;
    self.listTableView.dataSource = self.publicOpinionListParser;
    [self.publicOpinionListParser requestData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark HandleGWDelegate

- (void)HandleGWResult:(BOOL)ret {
    self.publicOpinionListParser.isRefresh = YES;
    [self.publicOpinionListParser requestData];
}


#pragma mark -
#pragma mark FileManager Delegate

// -------------------------------------------------------------------------------
//	实现FileManager Delegate委托方法
//  选中公文管理列表后调用此方法
// -------------------------------------------------------------------------------

- (void)returnSelectResult:(NSString *)type selected:(NSInteger)row
{
    BOOL isShow=NO;
    [self.popController dismissPopoverAnimated:YES];
    [self.publicOpinionListParser.aryItems removeAllObjects];
    [self.listTableView reloadData];
    
    switch (row)
    {
        case 0:
            isShow = NO;
            self.title = @"在办舆情";
            self.publicOpinionListParser = [[PublicOpinionHandlingParser alloc] init];
            self.publicOpinionListParser.serviceName = @"GETHANDLEPUBLICOPINIONLIST";
            self.publicOpinionListParser.showView = self.view;
            self.publicOpinionListParser.delegate = self;
            [self.publicOpinionListParser requestData];
            break;
            
        case 1:
            isShow = NO;
            self.title = @"已办舆情";
            self.publicOpinionListParser = [[PublicOpinionDoneParser alloc] init];
            self.publicOpinionListParser.serviceName = @"GETDONEPUBLICOPINIONLIST";
            self.publicOpinionListParser.showView = self.view;
            self.publicOpinionListParser.delegate = self;
            [self.publicOpinionListParser requestData];
            break;
            
        case 2:
            isShow = NO;
            self.title = @"所有舆情";
            self.publicOpinionListParser = [[PublicOpinionAllByDateParser alloc] init];
            self.publicOpinionListParser.showView = self.view;
            self.publicOpinionListParser.serviceName = @"GETALLDATEPUBLICOPINIONLIST";
            self.publicOpinionListParser.delegate = self;
            [self.publicOpinionListParser requestData];
            break;
            
        case 3:
            isShow = YES;
            self.title = @"查询";
            self.publicOpinionListParser = [[QueryPublicOpinionParser alloc] init];
            self.publicOpinionListParser.type = @"InquiryList";
            self.publicOpinionListParser.showView = self.view;
            self.publicOpinionListParser.serviceName = @"QueryPublicOpinionList";
            self.publicOpinionListParser.delegate = self;
            break;
            
        default:
            break;
    }
    
    self.publicOpinionListParser.listTableView = self.listTableView;
    self.listTableView.delegate = self.publicOpinionListParser;
    self.listTableView.dataSource = self.publicOpinionListParser;
    [self QueryViewAnimation:isShow];
}

#pragma mark -
#pragma mark HandlePublicOpinionDetail
- (void)didSelectOpinionListItem:(NSString *)docid process:(NSString *)name {
    self.docid = docid;
    self.processName = name;
    SystemConfigContext *context = [SystemConfigContext sharedInstance];
    NSDictionary *loginUsr = [context getUserInfo];
    NSString *user = [loginUsr objectForKey:@"userId"];
    
    NSString *strUrl= [ServiceUrlString generateOAWebServiceUrl];
    NSString *params = [WebServiceHelper createParametersWithKey:@"Hy_docid" value:self.docid, @"Hy_userid",user,@"Hy_year",@"",nil];
    
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:@"GetPublicOpinionDetail" nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
    [self.webServiceHelper runAndShowWaitingView:self.view withTipInfo:@"正在载入详情, 请稍候..."];
}

- (void)loadMoreList{
    self.publicOpinionListParser.isRefresh = NO;
    [self.publicOpinionListParser requestData];
}

- (void)loadDeptFileDetailViewProcess:(NSString *)name competence:(NSString *)status {
    PublicOpinionDetailViewController *detailViewController =[[PublicOpinionDetailViewController alloc] initWithNibName:@"PublicOpinionDetailViewController" bundle:nil];
    detailViewController.process = self.processName;
    detailViewController.docid = self.docid;
    detailViewController.infoDict = self.opinionInfo;
    detailViewController.delegate = self;
    detailViewController.responder = self;
    detailViewController.competence = status;
    [self.navigationController pushViewController:detailViewController
                                         animated:YES];
}


#pragma mark - Handle Event

- (void)goBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)docManagerList:(id)sender
{
    UIButton *button = (UIButton *)sender;
    FileManagerListController *fileManagerListController = [[FileManagerListController alloc] initWithStyle:UITableViewStylePlain];
    fileManagerListController.fileOutList = @[@"在办舆情",@"已办舆情",@"所有舆情",@"查询"];
    fileManagerListController.fileType = @"FileOut";
    fileManagerListController.delegate = self;
    
    UIPopoverController*popController = [[UIPopoverController alloc] initWithContentViewController:fileManagerListController];
    
    popController.popoverContentSize = CGSizeMake(240,44*4);
    
    self.popController = popController;
    [self.popController presentPopoverFromRect:button.bounds inView:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}

- (void)QueryViewAnimation:(BOOL)isShow
{
    if(isShow)
    {
        self.queryView.hidden = NO;
        
        CGRect frame = self.listTableView.frame;
        [UIView beginAnimations:@"ShowListTable" context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        CGFloat x = CGRectGetMinX(frame);
        CGFloat width = CGRectGetWidth(frame);
        CGFloat height = CGRectGetHeight(frame);
        
        self.listTableView.frame = CGRectMake(x, 260, width, height-236);
        [UIView commitAnimations];
    }
    else
    {
        self.queryView.hidden = YES;
        
        CGRect frame = self.listTableView.frame;
        [UIView beginAnimations:@"HIdeListTable" context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        CGFloat x = CGRectGetMinX(frame);
        CGFloat width = CGRectGetWidth(frame);
        CGFloat height = CGRectGetHeight(frame);
        if (height < 916) {
            height = height +236;
        }
        self.listTableView.frame = CGRectMake(x, 20, width, height);
        [UIView commitAnimations];
    }
}

-(IBAction)touchFromDate:(id)sender{
    self.currentTag = [sender tag];
    UITextField *txtField = (UITextField*)sender;
    
    PopupDateViewController *dateController = [[PopupDateViewController alloc] initWithPickerMode:UIDatePickerModeDate];
    dateController.delegate = self;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dateController];
    
    
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
    
    self.popController = popover;
    
    [self.popController presentPopoverFromRect:txtField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)queryPublicOpinionResult:(id)sender{
    NSString *errMsg = @"";
    if([self.startDateField.text length] <= 0 &&
       [self.endDateField.text length] <= 0 &&
       [self.codeField.text length] <= 0 &&
       [self.btField.text length] <= 0 &&
       [self.nfField.text length] <= 0){
        errMsg = @"请输入查询条件";
    }
    
    if ([errMsg length] > 0) {
        [self showAlertMessage:errMsg];
        return;
    }
    
    NSMutableDictionary *dicValues = [NSMutableDictionary dictionaryWithCapacity:6];
    [dicValues setValue:self.startDateField.text forKey:@"begin"];
    [dicValues setValue:self.endDateField.text forKey:@"end"];
    [dicValues setValue:self.codeField.text forKey:@"bh"];
    [dicValues setValue:self.nfField.text forKey:@"year"];
    [dicValues setValue:self.btField.text forKey:@"title"];
    
    self.publicOpinionListParser.paramDict = dicValues;
    self.publicOpinionListParser.isRefresh = YES;
    [self.publicOpinionListParser requestData];

}

//搜索按钮点击处理
- (void)searchButtonClick:(id)sender
{
    //开始日期
    NSString *startDate = @"";
    if(self.startDateField.text != nil && self.startDateField.text.length > 0)
    {
        startDate = self.startDateField.text;
    }
    //截止日期
    NSString *endDate = @"";
    if(self.endDateField.text != nil && self.endDateField.text.length > 0)
    {
        endDate = self.endDateField.text;
    }
    //年份
    NSString *nf = @"";
    if(self.nfField.text != nil && self.nfField.text.length > 0)
    {
        nf = self.nfField.text;
    }
    //标题
    NSString *bt = @"";
    if(self.btField.text != nil && self.btField.text.length > 0)
    {
        bt = self.btField.text;
    }
    //舆情编号
    NSString *code = @"";
    if(self.codeField.text != nil && self.codeField.text.length > 0)
    {
        code = self.codeField.text;
    }

    if(sender == nil)
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd"];
        startDate = [df stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    }
    
    if(startDate.length == 0 && endDate.length == 0 && code.length == 0 && nf.length == 0 && bt.length == 0)
    {
        [self showAlertMessage:@"搜索条件不能为空"];
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:5];
    [params setObject:startDate forKey:@"HY_STARTDATE"];
    [params setObject:endDate forKey:@"HY_ENDDATE"];
    [params setObject:code forKey:@"HY_CODE"];
    [params setObject:bt forKey:@"HY_BT"];
    [params setObject:nf forKey:@"HY_NF"];
    
    self.publicOpinionListParser = [[QueryPublicOpinionParser alloc] init];
    self.publicOpinionListParser.serviceName = kServiceName_Search;
    self.publicOpinionListParser.listTableView = self.listTableView;
    self.listTableView.delegate = self.publicOpinionListParser;
    self.listTableView.dataSource = self.publicOpinionListParser;
    self.publicOpinionListParser.queryDict = params;
    [self.publicOpinionListParser requestData];
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
    
    WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:@"GetPublicOpinionDetailReturn" andWithJSONDelegate:self];
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
        NSDictionary *tmpDataDict = [tmpParsedJsonDict objectForKey:@"postDocInfo"] ;
        self.opinionInfo = tmpDataDict;
        NSString *status = [self.opinionInfo   objectForKey:@"competence"];
        
        [self loadDeptFileDetailViewProcess:self.processName competence:status];
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


#pragma mark - PopupDateController Delegate Method

// -------------------------------------------------------------------------------
//	实现PopupDateController Delegate委托方法
//  选中日期弹出框的时间后调用此方法
// -------------------------------------------------------------------------------

- (void)PopupDateController:(PopupDateViewController *)controller Saved:(BOOL)Saved selectedDate:(NSDate*)date{
	[self.popController dismissPopoverAnimated:YES];
	if (Saved) {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd"];
		NSString *dateString = [dateFormatter stringFromDate:date];
		
        if (self.currentTag == 101) {
            self.startDateField.text =  dateString;
        }
        if (self.currentTag == 102) {
            self.endDateField.text =  dateString;
            if (([self.startDateField.text compare:self.endDateField.text] == NSOrderedDescending)||
                [self.startDateField.text compare:self.endDateField.text] == NSOrderedSame)
            {
                
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"提示"
                                      message:@"截止时间不能早于等于开始时间"
                                      delegate:nil
                                      cancelButtonTitle:@"确定"
                                      otherButtonTitles:nil];
                [alert show];
                
                [self.endDateField becomeFirstResponder];
                self.endDateField.text=@"";
                
            }
        }
	}
    
}

#pragma mark- UITextField Delegate Method

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.popController dismissPopoverAnimated:YES];
}

@end
