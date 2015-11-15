//
//  PostDocManagerViewController.m
//  NingBoOA
//
//  Created by 熊熙 on 13-9-9.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "XJZXPMDocumentController.h"
#import "XJZXPMDetailViewController.h"
#import "XJZXViewController.h"
#import "ServiceUrlString.h"
#import "UICustomButton.h"
#import "UITableViewCell+Custom.h"
#import "PDJsonkit.h"
#import "ZrsUtils.h"
#import "SystemConfigContext.h"
#import "FileInManagerController.h"
#import "OutDoneParser.h"
#import "OutHandlingParser.h"
#import "OutFileOutType.h"
#import "OutBackPercent.h"
#import "OutInquiryList.h"

//static const NSString *HandleToDate = @"HandleToDate";
//static const NSString *HandleToProcess = @"HandleToProcess";
//static const NSString *DoneToDate = @"DoneToDate";
//static const NSString *DoneToDoc = @"DoneToDoc";
//static const NSString *FileOutType = @"FileOutType";
//static const NSString *BackPrecent = @"BackPrecent";
//static const NSString *FileOutQuery = @"FileOutQuery";

@interface XJZXPMDocumentController ()
@property (nonatomic,strong) UIPopoverController *popController;
@end

@implementation XJZXPMDocumentController

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
    
    UIBarButtonItem *listItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"项目管理"];
    self.navigationItem.leftBarButtonItem = listItem;
    
    UIButton *listButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
    [listButton addTarget:self action:@selector(docManagerList:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem,listItem, nil];
    
    self.startDateTxt.delegate = self;
    [self.startDateTxt addTarget:self action:@selector(touchFromDate:) forControlEvents:UIControlEventTouchDown];
    
    self.outListParser = [[OutHandlingParser alloc] init];
    self.outListParser.type = @"date";
    self.outListParser.delegate = self;
    self.outListParser.serviceName = @"XJZXHandlePMDocument";
    self.outListParser.showView = self.view;
    self.outListParser.listTableView = self.listTableView;
    self.listTableView.dataSource = self.outListParser;
    self.listTableView.delegate = self.outListParser;
    [self.outListParser requestData];
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
    self.outListParser.isRefresh = YES;
    [self.outListParser requestData];
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
    [self.outListParser.aryItems removeAllObjects];
    [self.listTableView reloadData];
    [self.popController dismissPopoverAnimated:YES];
    switch (row) {
                    
        case 0:
            isShow = NO;
            self.title = @"在办→按日期";
            self.outListParser = [[OutHandlingParser alloc] init];
            self.outListParser.type = @"date";
            self.outListParser.serviceName = @"XJZXHandlePMDocument";
            self.outListParser.showView = self.view;
            self.outListParser.delegate = self;
            [self.outListParser requestData];
            break;
            
        case 1:
            isShow = NO;
            self.title = @"在办→按环节";
            self.outListParser = [[OutHandlingParser alloc] init];
            self.outListParser.type = @"process";
            self.outListParser.serviceName = @"XJZXHandlePMDocument";
            self.outListParser.showView = self.view;
            self.outListParser.delegate = self;
            [self.outListParser requestData];
            break;
            
        case 2:
            isShow = NO;
            self.title = @"已办→按日期";
            self.outListParser = [[OutDoneParser alloc] init];
            self.outListParser.type = @"date";
            self.outListParser.serviceName = @"XJZXDonePMDocument";
            self.outListParser.showView = self.view;
            self.outListParser.delegate = self;
            [self.outListParser requestData];
            break;
            
        case 3:
            isShow = NO;
            self.title = @"已办→按文号";
            self.outListParser = [[OutDoneParser alloc] init];
            self.outListParser.type = @"wh";
            self.outListParser.serviceName = @"XJZXDonePMDocument";
            self.outListParser.showView = self.view;
            self.outListParser.delegate = self;
            [self.outListParser requestData];
            break;
            
        case 4:
            isShow = NO;
            self.title = @"退回率";
            self.outListParser = [[OutBackPercent alloc] init];
            self.outListParser.type = @"BackPrecent";
            self.outListParser.serviceName = @"XJZXPMDocumentBackPercent";
            self.outListParser.showView = self.view;
            [self.outListParser requestData];
            break;
            
        case 5:
            isShow = YES;
            self.title = @"查询";
            self.outListParser = [[OutInquiryList alloc] init];
            self.outListParser.type = @"InquiryList";
            self.outListParser.serviceName = @"XJZXInquiryPMDocument";
            self.outListParser.showView = self.view;
            self.outListParser.delegate = self;
            break;
            
        default:
            break;
    }
    
    self.outListParser.listTableView = self.listTableView;
    self.listTableView.dataSource = self.outListParser;
    self.listTableView.delegate = self.outListParser;
    [self QueryViewAnimation:isShow];
}


#pragma mark -
#pragma mark HandleFileOutDetail
- (void)didSelectFileOutListItem:(NSString *)docid process:(NSString *)name{
    
    self.processName = name;
    self.docid = docid;
    SystemConfigContext *context = [SystemConfigContext sharedInstance];
    NSDictionary *loginUsr = [context getUserInfo];
    NSString *user = [loginUsr objectForKey:@"userId"];
    
    NSString *strUrl= [ServiceUrlString generateOAWebServiceUrl];
    NSString *params = [WebServiceHelper createParametersWithKey:@"Hy_docid" value:docid, @"Hy_userid",user,@"Hy_year",@"",nil];
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:@"XJZXPMDocumentInfo" nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
    [self.webServiceHelper runAndShowWaitingView:self.view withTipInfo:@"正在载入详情..."];
}

- (void)loadMoreList{
    self.outListParser.isRefresh = NO;
    [self.outListParser requestData];
}

- (void)loadFileOutDetailViewProcess:(NSString *)name competence:(NSString *)status{
    
    //隐藏tabbar，并且扩展view高度
    [self.delegate changeToNextView];
    
    XJZXPMDetailViewController *pmDetailViewController = [[XJZXPMDetailViewController alloc] initWithNibName:@"XJZXPMDetailViewController" bundle:nil];
    pmDetailViewController.docid = self.docid;
    pmDetailViewController.process = self.processName;
    pmDetailViewController.infoDict = self.postDocInfo;
    pmDetailViewController.delegate = self;
    pmDetailViewController.responder = self;
    pmDetailViewController.competence = status;

    [self.navigationController pushViewController:pmDetailViewController animated:YES];
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
    fileManagerListController.fileOutList = @[ @"在办→按日期",@"在办→按环节",@"已办→按日期",@"已办→按文号",@"退回率",@"查询" ];
    fileManagerListController.fileType = @"FileOut";
    fileManagerListController.delegate = self;
    
    UIPopoverController*popController = [[UIPopoverController alloc] initWithContentViewController:fileManagerListController];
    
    popController.popoverContentSize = CGSizeMake(240,44*6);
    
    self.popController = popController;
    
    [self.popController presentPopoverFromRect:button.bounds inView:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}

- (IBAction)queryFileOutResult:(id)sender{
    NSString *errMsg = @"";
    if([self.startDateTxt.text length] <= 0 &&
            [self.endDateTxt.text length] <= 0 &&
            [self.fwbhTxt.text length] <= 0 &&
            [self.zbbmTxt.text length] <= 0 &&
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
    [dicValues setValue:self.fwbhTxt.text forKey:@"fwbh"];
    [dicValues setValue:self.zbbmTxt.text forKey:@"dept"];
    [dicValues setValue:self.titleTxt.text forKey:@"title"];
    [dicValues setValue:self.urgentTxt.text forKey:@"urgent"];
    
    self.outListParser.paramDict = dicValues;
    self.outListParser.isRefresh = YES;
    [self.outListParser requestData];
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

     if ([sender tag] == 103){
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
        
        self.listTableView.frame = CGRectMake(x, 260, width, height-236);
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
            height = height +236;
        }
        self.listTableView.frame = CGRectMake(x, 24, width, height);
        [UIView commitAnimations];
    }
}

#pragma mark -
#pragma mark WordsDelegate
- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row {
    [self.popController dismissPopoverAnimated:YES];
    if (self.currentPage == 103) {
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
#pragma mark UITextField Delegate



- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.popController dismissPopoverAnimated:YES];
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
    WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:@"XJZXPMDocumentInfoReturn" andWithJSONDelegate:self];
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
        //NSArray *arr = self.listDataArray;
        //[self.listDataArray removeAllObjects];//文档ID
        self.postDocInfo = [tmpParsedJsonDict objectForKey:@"postDocInfo"] ;
        NSString *status = [self.postDocInfo   objectForKey:@"competence"];
        [self loadFileOutDetailViewProcess:self.processName competence:status];
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
