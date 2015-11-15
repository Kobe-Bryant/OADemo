//
//  ApplicationManagerViewController.m
//  NingBoOA
//
//  Created by PowerData on 13-10-15.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "ApplicationManagerViewController.h"
#import "UICustomButton.h"
#import "SystemConfigContext.h"
#import "PDJsonkit.h"
#import "ApplicationDetailViewController.h"
#import "ApplicationHandlingParser.h"
#import "ApplicationDoneParser.h"
#import "ApplicationAllListParser.h"
#import "QueryApplicationParser.h"

#define kTag_StartDate_Field 1001 //拟稿日期
#define kTag_EndDate_Field 1002 //截止日期
#define kTag_Year_Field 1003 //年份

@interface ApplicationManagerViewController ()
@property (nonatomic,strong) UIPopoverController *popController;
@property (nonatomic,strong) PopupDateViewController *dateController;
@property (nonatomic,strong) ApplicationListParser *applicationListParser;
@property (nonatomic,assign) int currentTag;
@end

@implementation ApplicationManagerViewController

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
    self.title = @"在办申请";
    //导航栏上面的按钮初始化
    UIBarButtonItem *backItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"返回"];
    self.navigationItem.leftBarButtonItem = backItem;
    UIButton *backButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
    [backButton addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *listItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"依法申请公开"];
    self.navigationItem.leftBarButtonItem = listItem;
    UIButton *listButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
    [listButton addTarget:self action:@selector(docManagerList:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem,listItem, nil];
    
    //初始化请求数据
    self.applicationListParser = [[ApplicationHandlingParser alloc] init];
    self.applicationListParser.serviceName = @"GETHANDLEAPPLICATIONLIST";
    self.applicationListParser.showView = self.view;
    self.applicationListParser.delegate = self;
    self.applicationListParser.listTableView = self.listTableView;
    self.listTableView.delegate = self.applicationListParser;
    self.listTableView.dataSource = self.applicationListParser;
    [self.applicationListParser requestData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark HandleGWDelegate

- (void)HandleGWResult:(BOOL)ret {
    self.applicationListParser.isRefresh = YES;
    [self.applicationListParser requestData];
}


#pragma mark -
#pragma mark HandlePublicOpinionDetail
- (void)didSelectApplicationListItem:(NSString *)docid process:(NSString *)name {
    self.docid = docid;
    self.processName = name;
    SystemConfigContext *context = [SystemConfigContext sharedInstance];
    NSDictionary *loginUsr = [context getUserInfo];
    NSString *user = [loginUsr objectForKey:@"userId"];
    
    NSString *strUrl= [ServiceUrlString generateOAWebServiceUrl];
    NSString *params = [WebServiceHelper createParametersWithKey:@"Hy_docid" value:self.docid, @"Hy_userid",user,@"Hy_year",@"",nil];
    
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:@"GETAPPLICATIONDETAIL" nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
    [self.webServiceHelper runAndShowWaitingView:self.view withTipInfo:@"正在载入详情, 请稍候..."];
}

#pragma mark FileManager Delegate

// -------------------------------------------------------------------------------
//	实现FileManager Delegate委托方法
//  选中公文管理列表后调用此方法
// -------------------------------------------------------------------------------

- (void)returnSelectResult:(NSString *)type selected:(NSInteger)row
{
    BOOL isShow=NO;
    [self.popController dismissPopoverAnimated:YES];
    [self.applicationListParser.aryItems removeAllObjects];
    [self.listTableView reloadData];

    switch (row)
    {
        case 0:
            isShow = NO;
            self.title = @"在办申请";
            self.applicationListParser = [[ApplicationHandlingParser alloc] init];
            self.applicationListParser.serviceName = @"GETHANDLEAPPLICATIONLIST";
            self.applicationListParser.showView = self.view;
            self.applicationListParser.delegate = self;
            [self.applicationListParser requestData];
            break;
            
        case 1:
            isShow = NO;
            self.title = @"已办申请";
            self.applicationListParser = [[ApplicationDoneParser alloc] init];
            self.applicationListParser.serviceName = @"GETDONEAPPLICATIONLIST";
            self.applicationListParser.showView = self.view;
            self.applicationListParser.delegate = self;
            [self.applicationListParser requestData];
            break;
            
        case 2:
            isShow = NO;
            self.title = @"所有申请";
            self.applicationListParser = [[ApplicationAllListParser alloc] init];
            self.applicationListParser.serviceName = @"GETALLDATEAPPLICATIONLIST";
            self.applicationListParser.showView = self.view;
            self.applicationListParser.delegate = self;
            [self.applicationListParser requestData];
            break;
            
        case 3:
            isShow = YES;
            self.title = @"查询";
            self.applicationListParser = [[QueryApplicationParser alloc] init];
            self.applicationListParser.type = @"InquryList";
            self.applicationListParser.serviceName = @"QUERYAPPLICATIONLIST";
            self.applicationListParser.showView = self.view;
            self.applicationListParser.delegate = self;
            break;
            
        default:
            break;
    }
    
    self.applicationListParser.listTableView = self.listTableView;
    self.listTableView.delegate = self.applicationListParser;
    self.listTableView.dataSource = self.applicationListParser;
    [self QueryViewAnimation:isShow];
}

- (void)loadMoreList{
    self.applicationListParser.isRefresh = NO;
    [self.applicationListParser requestData];
}

- (void)loadApplicationDetailViewProcess:(NSString *)name competence:(NSString *)status {
    ApplicationDetailViewController *detailViewController =[[ApplicationDetailViewController alloc] initWithNibName:@"ApplicationDetailViewController" bundle:nil];
    detailViewController.process = self.processName;
    detailViewController.docid = self.docid;
    detailViewController.infoDict = self.applicationInfo;
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
    fileManagerListController.fileOutList = @[@"在办申请",@"已办申请",@"所有申请",@"查询"];
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

//按下弹出日期选择框
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

- (IBAction)queryApplicationResult:(id)sender{
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
    
    self.applicationListParser.paramDict = dicValues;
    self.applicationListParser.isRefresh = YES;
    [self.applicationListParser requestData];
    
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
    
    WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:@"GETAPPLICATIONDETAILReturn" andWithJSONDelegate:self];
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
        self.applicationInfo = tmpDataDict;
        NSString *status = [self.applicationInfo   objectForKey:@"competence"];
        [self loadApplicationDetailViewProcess:self.processName competence:status];
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}

@end
