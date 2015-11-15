//
//  PostDocManagerViewController.m
//  NingBoOA
//
//  Created by 熊熙 on 13-9-9.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "XJZXFileInManagerController.h"
#import "ServiceUrlString.h"
#import "UICustomButton.h"
#import "UITableViewCell+Custom.h"
#import "PDJsonkit.h"
#import "ZrsUtils.h"
#import "SystemConfigContext.h"
#import "FileInManagerController.h"
#import "InHandingParser.h"
#import "InDoneParser.h"
#import "InAllParser.h"
#import "InDeadlineParser.h"
#import "InInquiryList.h"
#import "XJZXFileInDetailViewController.h"
#import "XJZXViewController.h"
//static const NSString *HandleToDate = @"HandleToDate";
//static const NSString *HandleToProcess = @"HandleToProcess";
//static const NSString *DoneToDate = @"DoneToDate";
//static const NSString *DoneToDoc = @"DoneToDoc";
//static const NSString *FileOutType = @"FileOutType";
//static const NSString *BackPrecent = @"BackPrecent";
//static const NSString *FileOutQuery = @"FileOutQuery";

@interface XJZXFileInManagerController ()
@property (nonatomic,strong) UIPopoverController *popController;
@end

@implementation XJZXFileInManagerController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"在办→按日期";
    
    UIBarButtonItem *backItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"返回"];
    self.navigationItem.leftBarButtonItem = backItem;
    UIButton *backButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
    [backButton addTarget:self action:@selector(goBackAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *listItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"收文管理"];
    self.navigationItem.leftBarButtonItem = listItem;
    
    UIButton *listButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
    [listButton addTarget:self action:@selector(docManagerList:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem,listItem, nil];
    
    self.InListParser = [[InHandingParser alloc] init];
    self.inListParser.type = @"date";
    self.inListParser.delegate = self;
    self.inListParser.serviceName = @"XJZXHandleReceiveDocument";
    self.inListParser.showView = self.view;
    self.inListParser.listTableView = self.listTableView;
    self.listTableView.dataSource = self.inListParser;
    self.listTableView.delegate = self.inListParser;
    [self.inListParser requestData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self.delegate changeBackView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark -
#pragma mark HandleGWDelegate
- (void)HandleGWResult:(BOOL)ret {
    self.inListParser.isRefresh = YES;
    [self.inListParser requestData];
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
    [self.inListParser.aryItems removeAllObjects];
    [self.listTableView reloadData];
    if (self.popController)
        [self.popController dismissPopoverAnimated:YES];
    switch (row) {
        case 0:
            self.title = @"在办→按日期";
            isShow = NO;
            self.InListParser = [[InHandingParser alloc] init];
            self.inListParser.type = @"date";
            self.inListParser.serviceName = @"XJZXHandleReceiveDocument";
            self.inListParser.delegate = self;
            self.inListParser.showView = self.view;
            [self.inListParser requestData];
            break;
            
        case 1:
            self.title = @"在办→按环节";
            isShow = NO;
            self.InListParser = [[InHandingParser alloc] init];
            self.inListParser.type = @"process";
            self.inListParser.serviceName = @"XJZXHandleReceiveDocument";
            self.inListParser.delegate = self;
            self.inListParser.showView = self.view;
            [self.inListParser requestData];
            break;

        case 2:
            self.title = @"已办收文";
            isShow = NO;
            self.inListParser = [[InDoneParser alloc] init];
            self.inListParser.serviceName = @"XJZXDoneReceiveDocument";
            self.inListParser.delegate = self;
            self.inListParser.showView = self.view;
            [self.inListParser requestData];
            break;
            
        case 3:
            self.title = @"所有收文";
            isShow = NO;
            self.InListParser = [[InAllParser alloc] init];
            self.inListParser.serviceName = @"XJZXAllReceiveDocument";
            self.inListParser.delegate = self;
            self.inListParser.showView = self.view;
            [self.inListParser requestData];
            break;
            
        case 4:
            isShow = NO;
            self.title = @"期限收文";
            self.InListParser = [[InDeadlineParser alloc] init];
            self.inListParser.serviceName = @"XJZXToDateReceiveDocument";
            self.inListParser.showView = self.view;
            self.inListParser.delegate = self;
            [self.inListParser requestData];
            break;
            
        case 5:
            self.title = @"查询";
            self.InListParser = [[InInquiryList alloc] init];
            self.inListParser.type = @"InquiryList";
            self.inListParser.serviceName = @"XJZXInquiryReceiveDocument";
            self.inListParser.showView = self.view;
            self.inListParser.delegate = self;
            isShow = YES;
            break;
            
        default:
            break;
    }
    self.inListParser.listTableView = self.listTableView;
    self.listTableView.dataSource = self.inListParser;
    self.listTableView.delegate = self.inListParser;
    
    [self QueryViewAnimation:isShow];
}

#pragma maek -
#pragma mark HandleFileOutDetail
- (void)didSelectFileInListItem:(NSString *)docid process:(NSString *)name{
    
    self.processName = name;
    self.docid = docid;
    SystemConfigContext *context = [SystemConfigContext sharedInstance];
    NSDictionary *loginUsr = [context getUserInfo];
    NSString *user = [loginUsr objectForKey:@"userId"];
    
    NSString *strUrl= [ServiceUrlString generateOAWebServiceUrl];
    NSString *params = [WebServiceHelper createParametersWithKey:@"Hy_docid" value:docid, @"Hy_userid",user,@"Hy_year",@"",nil];
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:@"XJZXReceiveDocumentInfo" nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
    [self.webServiceHelper runAndShowWaitingView:self.view withTipInfo:@"正在载入详情，请稍候..."];
}

- (void)loadMoreList{
    self.inListParser.isRefresh = NO;
    [self.inListParser requestData];
}

- (void)loadFileInDetailViewProcess:(NSString *)name competence:(NSString *)status {
     
    XJZXFileInDetailViewController *fileInDetailViewController = [[XJZXFileInDetailViewController alloc] initWithNibName:@"XJZXFileInDetailViewController" bundle:nil];
    fileInDetailViewController.docid = self.docid;
    fileInDetailViewController.process = self.processName;
    fileInDetailViewController.infoDict = self.postDocInfo;
    fileInDetailViewController.responder = self;
    fileInDetailViewController.delegate = self;
    fileInDetailViewController.competence = status;
    
    //隐藏tabbar，并且扩展view高度
    [self.delegate changeToNextView];
    [self.navigationController pushViewController:fileInDetailViewController animated:YES];
}

#pragma mark -
#pragma mark UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.popController dismissPopoverAnimated:YES];
}

#pragma mark -
#pragma mark WordsDelegate
- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row {
    [self.popController dismissPopoverAnimated:YES];
    if (self.currentPage == 103) {
        self.lwdwtxt.text = words;
    }
    if (self.currentPage == 104) {
        self.urgentTxt.text = words;
    }
}

#pragma mark -
#pragma mark PopupDateDelegate
- (void)PopupDateController:(PopupDateViewController *)controller Saved:(BOOL)Saved selectedDate:(NSDate*)date{
	[self.popController dismissPopoverAnimated:YES];
	if (Saved) {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd"];
		NSString *dateString = [dateFormatter stringFromDate:date];
		
        if (self.currentTag == 101) {
            self.startDateTxt.text =  dateString;
        }
        if (self.currentTag == 102) {
            self.endDateTxt.text =  dateString;
            if (([self.startDateTxt.text compare:self.endDateTxt.text] == NSOrderedDescending)||
                [self.startDateTxt.text compare:self.endDateTxt.text] == NSOrderedSame)
            {
                
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"提示"
                                      message:@"截止时间不能早于等于开始时间"
                                      delegate:nil
                                      cancelButtonTitle:@"确定"
                                      otherButtonTitles:nil];
                [alert show];
                
                [self.endDateTxt becomeFirstResponder];
                self.endDateTxt.text=@"";
                
            }
        }
	}
    
}


#pragma mark -
#pragma mark Handle Event

- (void)goBackAction:(id)sender
{
   [self.delegate backMainMenu:sender];
}

- (void)docManagerList:(id)sender
{
    UIButton *button = (UIButton *)sender;
    FileManagerListController *fileManagerListController = [[FileManagerListController alloc] initWithStyle:UITableViewStylePlain];
    fileManagerListController.fileOutList = @[ @"在办→按日期",@"在办→按环节",@"已办收文",@"所有收文",@"期限收文",@"查询" ];
    fileManagerListController.fileType = @"FileOut";
    fileManagerListController.delegate = self;
    
    UIPopoverController*popController = [[UIPopoverController alloc] initWithContentViewController:fileManagerListController];
    
    popController.popoverContentSize = CGSizeMake(240,264);
    
    self.popController = popController;
    
    [self.popController presentPopoverFromRect:button.bounds inView:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)queryFileInResult:(id)sender{
    NSString *errMsg = @"";
    
    if([self.startDateTxt.text length] <= 0 &&
       [self.endDateTxt.text length] <= 0 &&
       [self.yearTxt.text length] <= 0 &&
       [self.swhTxt.text length] <= 0 &&
       [self.lwwhTxt.text length] <= 0 &&
       [self.lwdwtxt.text length] <= 0 &&
       [self.titleTxt.text length] <= 0 &&
       [self.urgentTxt.text length] <= 0){
        errMsg = @"请输入查询条件";
    }
    
    if ([errMsg length] > 0) {
        [self showAlertMessage:errMsg];
        return;
    }
    
    NSMutableDictionary *dicValues = [NSMutableDictionary dictionaryWithCapacity:6];
    [dicValues setValue:self.startDateTxt.text forKey:@"begin"];
    [dicValues setValue:self.endDateTxt.text forKey:@"end"];
    [dicValues setValue:self.yearTxt.text forKey:@"year"];
    [dicValues setValue:self.swhTxt.text forKey:@"swh"];
    [dicValues setValue:self.lwwhTxt.text forKey:@"lwwh"];
    [dicValues setValue:self.lwdwtxt.text forKey:@"lwdw"];
    [dicValues setValue:self.titleTxt.text forKey:@"title"];
    [dicValues setValue:self.urgentTxt.text forKey:@"urgent"];
    
    self.inListParser.paramDict = dicValues;
    self.inListParser.isRefresh = YES;
    [self.inListParser requestData];
}

-(IBAction)touchFromDate:(id)sender{
    self.currentTag = [sender tag];
    UITextField *txtField = (UITextField*)sender;
    
    PopupDateViewController *dateController = [[PopupDateViewController alloc] initWithPickerMode:UIDatePickerModeDate];
    dateController.delegate = self;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dateController];
    
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
    
    self.popController = popover;
    
    [self.popController presentPopoverFromRect:txtField.bounds inView:txtField permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)selectCommenWords:(id)sender{
    UITextField *txtField = (UITextField *)sender;
    self.currentPage = txtField.tag;
    
    NSArray *listArray = nil;
    if ([sender tag] == 103) {
        txtField = self.lwdwtxt;
        listArray = @[@"中共中央",@"国务院及部委",@"省委省政府省人大政协",@"省各部委办",@"市委",@"市委会议及通报",@"市委组织部及纪委",@"市委及各部委",@"市政府",@"领导批示单、告知单",@"市人大市政协",@"市府各局委办",@"市人事局及编委",@"财税局、物价局和审计局",@"市发改委和计委及项目审批",@"国家环保部",@"省环保厅",@"各县（市）区",@"局属单位",@"企业",@"光荣榜",@"局领导兼职",@"会议通知",@"参阅简报",@"其他"];
    }
    else if ([sender tag] == 104){
        txtField = self.urgentTxt;
        listArray = @[@"一般",@"急件",@"特急"];
    }
    
    NSInteger number = [listArray count];
    if ([listArray count] > 12) {
        number = 12;
    }
    
    CommenWordsViewController *tmpController = [[CommenWordsViewController alloc] initWithNibName:@"CommenWordsViewController" bundle:nil ];
    tmpController.contentSizeForViewInPopover = CGSizeMake(200, 44*number);
    tmpController.delegate = self;
    tmpController.wordsAry = listArray;
    UIPopoverController *tmppopover = [[UIPopoverController alloc] initWithContentViewController:tmpController];
    self.popController = tmppopover;
    [self.popController presentPopoverFromRect:txtField.bounds
                                        inView:txtField
                      permittedArrowDirections:UIPopoverArrowDirectionAny
                                      animated:YES];
}

- (void)QueryViewAnimation:(BOOL)isShow{
    if(isShow) {
        self.queryView.hidden = NO;
        
        CGRect frame = self.listTableView.frame;
        [UIView beginAnimations:@"ShowListTable" context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        CGFloat x = CGRectGetMinX(frame);
        //CGFloat y = CGRectGetMinY(frame);
        CGFloat width = CGRectGetWidth(frame);
        CGFloat height = CGRectGetHeight(frame);
        
        self.listTableView.frame = CGRectMake(x, 280, width, height-254);
        [UIView commitAnimations];
    }
    else {
        self.queryView.hidden = YES;
        
        CGRect frame = self.listTableView.frame;
        [UIView beginAnimations:@"HIdeListTable" context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        CGFloat x = CGRectGetMinX(frame);
        //CGFloat y = CGRectGetMinY(frame);
        CGFloat width = CGRectGetWidth(frame);
        CGFloat height = CGRectGetHeight(frame);
        if (height < 856) {
            height = height +254;
        }
        self.listTableView.frame = CGRectMake(x, 24, width, height);
        [UIView commitAnimations];
    }
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
    WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:@"XJZXReceiveDocumentInfoReturn" andWithJSONDelegate:self];
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
       
        self.postDocInfo = [tmpParsedJsonDict objectForKey:@"postDocInfo"] ;
        NSString *status = [self.postDocInfo   objectForKey:@"competence"];
        
        [self loadFileInDetailViewProcess:self.processName competence:status];
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
