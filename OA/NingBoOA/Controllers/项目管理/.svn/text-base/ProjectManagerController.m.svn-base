//
//  PostDocManagerViewController.m
//  NingBoOA
//
//  Created by 熊熙 on 13-9-9.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "ProjectManagerController.h"
#import "ServiceUrlString.h"
#import "UICustomButton.h"
#import "UITableViewCell+Custom.h"
#import "PDJsonkit.h"
#import "ZrsUtils.h"
#import "SystemConfigContext.h"
#import "FileInManagerController.h"
#import "OutHandlingParser.h"
#import "ProjectHandlingParser.h"
#import "ProjectBackPercent.h"
#import "ProjectInquiryList.h"
#import "ProjectBookDetailViewController.h"
#import "ProjectTableDetailViewController.h"
#import "ProjectRegistryDetailViewController.h"
#import "ProjectRunDetailViewController.h"
#import "ProjectCheckDetailViewController.h"

@interface ProjectManagerController ()
@property (nonatomic,strong) UIPopoverController *popController;
@end

@implementation ProjectManagerController

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
    
    self.title =@"在办→按日期";
    
    UIBarButtonItem *backItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"返回"];
    self.navigationItem.leftBarButtonItem = backItem;
    UIButton *backButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
    [backButton addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *listItem= [UICustomBarButtonItem woodBarButtonItemWithText:@"项目审批报告书"];
    self.navigationItem.leftBarButtonItem = listItem;
    
    UIButton *listButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
    listButton.tag = 104;
    [listButton addTarget:self action:@selector(docManagerList:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem,listItem, nil];
    
    UIBarButtonItem *projectItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"项目管理"];
    self.navigationItem.rightBarButtonItem = projectItem;
    
    UIButton *projectButton = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
    projectButton.tag = 105;
    [projectButton addTarget:self action:@selector(docManagerList:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.startDateTxt.delegate = self;
    [self.startDateTxt addTarget:self action:@selector(touchFromDate:) forControlEvents:UIControlEventTouchDown];
    
    self.projectListParser = [[ProjectHandlingParser alloc] init];
    self.projectListParser.type = @"date";
    self.projectListParser.delegate = self;
    self.projectListParser.serviceName = @"reportBooKHandleList";
    self.projectListParser.showView = self.view;
    self.InfoType = @"reportBook";
    self.projectListParser.listTableView = self.listTableView;
    self.listTableView.dataSource = self.projectListParser;
    self.listTableView.delegate = self.projectListParser;
    [self.projectListParser requestData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - 
#pragma mark HandleGWDelegate
- (void)HandleGWResult:(BOOL)ret {
    self.projectListParser.isRefresh = YES;
    [self.projectListParser requestData];
}

#pragma mark -
#pragma mark FileManager Delegate

// -------------------------------------------------------------------------------
//	实现FileManager Delegate委托方法
//  选中公文管理列表后调用此方法
// -------------------------------------------------------------------------------

- (void)returnSelectResult:(NSString *)type selected:(NSInteger)row
{
    [self.popController dismissPopoverAnimated:YES];
    if ([type isEqualToString:@"list"]) {
        self.projectType = row;
        NSString *listTitle = @"";
        switch (row) {
            case 0:
                listTitle = @"项目审批报告书";
                break;
            case 1:
                listTitle = @"项目审批报告表";
                break;
            case 2:
                listTitle = @"项目审批登记表";
                break;
            case 3:
                listTitle = @"试运行管理";
                break;
            case 4:
                listTitle = @"竣工验收";
                break;
                
            default:
                break;
        }
        
        UIBarButtonItem *backItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"返回"];
        self.navigationItem.leftBarButtonItem = backItem;
        UIButton *backButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
        [backButton addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *listItem= [UICustomBarButtonItem woodBarButtonItemWithText:listTitle];
        self.navigationItem.leftBarButtonItem = listItem;
        
        UIButton *listButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
        listButton.tag = 104;
        [listButton addTarget:self action:@selector(docManagerList:) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem,listItem, nil];
        
        self.buttonItem = listButton;
        [self showAvaliableSelectList:104];
    }
    
    else {        
        BOOL isShow=NO;
        [self.projectListParser.aryItems removeAllObjects];
        [self.listTableView reloadData];
        if ([type isEqualToString:@"reportBook"]) {
            
            switch (row) {
                case 0:
                    isShow = NO;
                    self.title = @"在办→按日期";
                    self.projectListParser = [[ProjectHandlingParser alloc] init];
                    self.projectListParser.type = @"date";
                    self.projectListParser.serviceName = [NSString stringWithFormat:@"%@HandleList",type];
//                    self.projectListParser.serviceName = @"HANDLEPOSTDOCUMENT";
                    self.projectListParser.showView = self.view;
                    self.projectListParser.delegate = self;
                    self.InfoType = type;
                    [self.projectListParser requestData];
                    break;
                    
                case 1:
                    isShow = NO;
                    self.title = @"在办→按环节";
                    self.projectListParser = [[ProjectHandlingParser alloc] init];
                    self.projectListParser.type = @"process";
                     self.projectListParser.serviceName = [NSString stringWithFormat:@"%@HandleList",type];
                    //self.projectListParser.serviceName = @"HANDLEPOSTDOCUMENT";
                    self.projectListParser.showView = self.view;
                    self.projectListParser.delegate = self;
                    self.InfoType = type;
                    [self.projectListParser requestData];
                    break;
                    
                case 2:
                    isShow = NO;
                    self.title = @"已办→按日期";
                    self.projectListParser = [[ProjectDoneParser alloc] init];
                    self.projectListParser.type = @"date";
                    self.projectListParser.serviceName =  self.projectListParser.serviceName = [NSString stringWithFormat:@"%@DoneList",type];
                    //self.projectListParser.serviceName = @"HANDLEPOSTEDDOCUMENT";
                    self.projectListParser.showView = self.view;
                    self.InfoType = type;
                    self.projectListParser.delegate = self;
                    
                    [self.projectListParser requestData];
                    break;
                    
                case 3:
                    isShow = NO;
                    self.title = @"已办→按文号";
                    self.projectListParser = [[ProjectDoneParser alloc] init];
                    self.projectListParser.type = @"wh";
                    self.projectListParser.serviceName = [NSString stringWithFormat:@"%@DoneList",type];
                    //self.projectListParser.serviceName = @"HANDLEPOSTEDDOCUMENT";
                    self.projectListParser.showView = self.view;
                    self.projectListParser.delegate = self;
                    self.InfoType = type;
                    [self.projectListParser requestData];
                    break;
                    
                case 4:
                    isShow = NO;
                    self.title = @"退回率";
                    self.projectListParser = [[ProjectBackPercent alloc] init];
                    self.projectListParser.type = @"BackPercent";
                    self.projectListParser.serviceName = [NSString stringWithFormat:@"%@BackPercent",type];
//                    self.projectListParser.serviceName = @"PostDocumentBackPercent";
                    self.projectListParser.showView = self.view;
                    [self.projectListParser requestData];
                    break;
                    
                case 5:
                    isShow = YES;
                    self.title = @"查询";
                    self.projectListParser = [[ProjectInquiryList alloc] init];
                    self.projectListParser.type = @"InquiryList";
                    self.projectListParser.serviceName = [NSString stringWithFormat:@"%@Inquiry",type];
                    //self.projectListParser.serviceName = @"InquiryPostDocument";
                    self.projectListParser.showView = self.view;
                    self.projectListParser.delegate = self;
                    self.InfoType = type;
                    break;
                    
                default:
                    break;
            }
            
        }
        else {
            
            switch (row) {
                case 0:
                    isShow = NO;
                    self.title = @"在办→按日期";
                    self.projectListParser = [[ProjectHandlingParser alloc] init];
                    self.projectListParser.type = @"date";
                    self.projectListParser.serviceName = [NSString stringWithFormat:@"%@HandleList",type];
                    self.projectListParser.showView = self.view;
                    self.projectListParser.delegate = self;
                    self.InfoType = type;
                    [self.projectListParser requestData];
                    break;
                    
                case 1:
                    isShow = NO;
                    self.title = @"已办→按日期";
                    self.projectListParser = [[ProjectDoneParser alloc] init];
                    self.projectListParser.type = @"date";
                    self.projectListParser.serviceName =  self.projectListParser.serviceName = [NSString stringWithFormat:@"%@DoneList",type];
                    self.projectListParser.showView = self.view;
                    self.projectListParser.delegate = self;
                    self.InfoType = type;
                    [self.projectListParser requestData];
                    break;
                case 2:
                    isShow = YES;
                    self.title = @"查询";
                    self.projectListParser = [[ProjectInquiryList alloc] init];
                    self.projectListParser.type = @"InquiryList";
                    self.projectListParser.serviceName = [NSString stringWithFormat:@"%@Inquiry",type];
                    self.projectListParser.showView = self.view;
                    self.InfoType = type;
                    self.projectListParser.delegate = self;
                    break;
                    
                default:
                    break;
            }

        }
        
        self.projectListParser.listTableView = self.listTableView;
        self.listTableView.dataSource = self.projectListParser;
        self.listTableView.delegate = self.projectListParser;
        [self QueryViewAnimation:isShow];
    }
}


#pragma mark -
#pragma mark HandleFileOutDetail

- (void)didSelectProjectListItem:(NSString *)docid process:(NSString *)name{
    self.processName = name;
    self.docid = docid;
    NSString *method = [NSString stringWithFormat:@"%@Info",self.InfoType];
    SystemConfigContext *context = [SystemConfigContext sharedInstance];
    NSDictionary *loginUsr = [context getUserInfo];
    NSString *user = [loginUsr objectForKey:@"userId"];
    NSString *strUrl= [ServiceUrlString generateOAWebServiceUrl];
    NSString *params = [WebServiceHelper createParametersWithKey:@"Hy_docid" value:docid, @"Hy_userid",user,@"Hy_year",@"",nil];
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:method nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
    [self.webServiceHelper runAndShowWaitingView:self.view withTipInfo:@"正在载入详情，请稍候..."];
}

- (void)loadMoreList{
    self.projectListParser.isRefresh = NO;
    [self.projectListParser requestData];
}

- (void)loadProjectDetailViewProcess:(NSString *)name competence:(NSString *)status{
    if ([self.InfoType isEqualToString:@"reportBook"]) {
        ProjectBookDetailViewController *projectDetailViewController = [[ProjectBookDetailViewController alloc] initWithNibName:@"ProjectBookDetailViewController" bundle:nil];
        projectDetailViewController.docid = self.docid;
        projectDetailViewController.process = self.processName;
        projectDetailViewController.infoDict = self.postDocInfo;
        projectDetailViewController.delegate = self;
        projectDetailViewController.responder = self;
        projectDetailViewController.competence = status;
        [self.navigationController pushViewController:projectDetailViewController animated:YES];

    }
    
    else  if([self.InfoType isEqualToString:@"reportTable"]){
        ProjectTableDetailViewController *projectDetailViewController = [[ProjectTableDetailViewController alloc] initWithNibName:@"ProjectTableDetailViewController" bundle:nil];
        projectDetailViewController.docid = self.docid;
        projectDetailViewController.process = self.processName;
        projectDetailViewController.infoDict = self.postDocInfo;
        projectDetailViewController.delegate = self;
        projectDetailViewController.responder = self;
        projectDetailViewController.competence = status;
        [self.navigationController pushViewController:projectDetailViewController animated:YES];
    }
    
    else  if([self.InfoType isEqualToString:@"registry"]){
        ProjectRegistryDetailViewController *projectDetailViewController = [[ProjectRegistryDetailViewController alloc] initWithNibName:@"ProjectRegistryDetailViewController" bundle:nil];
        projectDetailViewController.docid = self.docid;
        projectDetailViewController.process = self.processName;
        projectDetailViewController.infoDict = self.postDocInfo;
        projectDetailViewController.delegate = self;
        projectDetailViewController.responder = self;
        projectDetailViewController.competence = status;
        [self.navigationController pushViewController:projectDetailViewController animated:YES];
    }
    
    else  if([self.InfoType isEqualToString:@"testRun"]){
        ProjectRunDetailViewController *projectDetailViewController = [[ProjectRunDetailViewController alloc] initWithNibName:@"ProjectRunDetailViewController" bundle:nil];
        projectDetailViewController.docid = self.docid;
        projectDetailViewController.process = self.processName;
        projectDetailViewController.infoDict = self.postDocInfo;
        projectDetailViewController.delegate = self;
        projectDetailViewController.responder = self;
        projectDetailViewController.competence = status;
        [self.navigationController pushViewController:projectDetailViewController animated:YES];
    }
    else {
        ProjectCheckDetailViewController *projectDetailViewController = [[ProjectCheckDetailViewController alloc] initWithNibName:@"ProjectCheckDetailViewController" bundle:nil];
        projectDetailViewController.docid = self.docid;
        projectDetailViewController.process = self.processName;
        projectDetailViewController.infoDict = self.postDocInfo;
        projectDetailViewController.delegate = self;
        projectDetailViewController.responder = self;
        projectDetailViewController.competence = status;
        [self.navigationController pushViewController:projectDetailViewController animated:YES];
    }
}


#pragma mark -
#pragma mark Handle Event

- (void)goBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)showAvaliableSelectList:(NSInteger)tag {
    NSArray *listArray = nil;
    NSString *type = @"";
    if (tag == 104) {
        switch (self.projectType) {
            case 0:
                type = @"reportBook";
                listArray =  @[@"在办→按日期",@"在办→按环节",@"已办→按日期",@"已办→按文号",@"退回率",@"查询"];
                break;
                
            case 1:
                type = @"reportTable";
                listArray =  @[@"在办→按日期",@"已办→按日期",@"查询"];
                break;
                
            case 2:
                type = @"registry";
                listArray =  @[@"在办→按日期",@"已办→按日期",@"查询"];
                break;
                
            case 3:
                type = @"testRun";
                listArray =  @[@"在办→按日期",@"已办→按日期",@"查询"];
                break;
                
            case 4:
                type = @"checkAccept";
                listArray =  @[@"在办→按日期",@"已办→按日期",@"查询"];
                break;
                
            default:
                break;
        }
    }
    
    else {
        listArray =  @[@"项目审批报告书",@"项目审批报告表",@"项目审批登记表",@"试运行管理",@"竣工验收"];
        type = @"list";
    }
    
    FileManagerListController *fileManagerListController = [[FileManagerListController alloc] initWithStyle:UITableViewStylePlain];
    fileManagerListController.fileOutList = listArray;
    fileManagerListController.fileType = type;
    fileManagerListController.delegate = self;
    
    UIPopoverController*popController = [[UIPopoverController alloc] initWithContentViewController:fileManagerListController];
    
    popController.popoverContentSize = CGSizeMake(240,44*[listArray count]);
    
    self.popController = popController;
    
    [self.popController presentPopoverFromRect:self.buttonItem.bounds inView:self.buttonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
- (void)docManagerList:(id)sender
{
    self.buttonItem = (UIButton *)sender;
    NSInteger tag = [sender tag];
    [self showAvaliableSelectList:tag];
}

- (IBAction)queryFileOutResult:(id)sender{
    NSMutableDictionary *dicValues = [NSMutableDictionary dictionaryWithCapacity:6];
    [dicValues setValue:self.startDateTxt.text forKey:@"begin"];
    [dicValues setValue:self.endDateTxt.text forKey:@"end"];
    [dicValues setValue:self.fwbhTxt.text forKey:@"fwbh"];
    [dicValues setValue:self.zbbmTxt.text forKey:@"dept"];
    [dicValues setValue:self.titleTxt.text forKey:@"title"];
    [dicValues setValue:self.urgentTxt.text forKey:@"urgent"];
    
    self.projectListParser.paramDict = dicValues;
    self.projectListParser.isRefresh = YES;
    [self.projectListParser requestData];
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
    self.currentTag = txtField.tag;
    
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
        if (height < 916) {
            height = height +236;
        }
        self.listTableView.frame = CGRectMake(x, 26, width, height);
        [UIView commitAnimations];
    }
}

#pragma mark -
#pragma mark WordsDelegate
- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row {
    [self.popController dismissPopoverAnimated:YES];
    if (self.currentTag == 103) {
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

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
    
    NSString *method = [NSString stringWithFormat:@"%@InfoReturn",self.InfoType];
    
    WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:method andWithJSONDelegate:self];
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
        //NSArray *arr = self.listDataArray;
        //[self.listDataArray removeAllObjects];//文档ID
        self.postDocInfo = [tmpParsedJsonDict objectForKey:@"postDocInfo"] ;
        NSString *status = [self.postDocInfo   objectForKey:@"competence"];
        [self loadProjectDetailViewProcess:self.processName competence:status];
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
