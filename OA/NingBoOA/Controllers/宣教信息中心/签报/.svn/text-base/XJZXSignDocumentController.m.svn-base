//
//  SignDocumentController.m
//  NingBoOA
//
//  Created by 张仁松 on 13-9-26.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//
#import "XJZXSignDocumentController.h"
#import "ServiceUrlString.h"
#import "UICustomButton.h"
#import "UITableViewCell+Custom.h"
#import "PDJsonkit.h"
#import "ZrsUtils.h"
#import "SystemConfigContext.h"

#import "SignDocDoneParser.h"
#import "SignDocHandlingParser.h"
#import "XJZXSignDocDetailViewController.h"
#import "QuerySignDocParser.h"
#import "PopupDateViewController.h"
#import "XJZXViewController.h"

@interface XJZXSignDocumentController ()
@property (nonatomic,strong) UIPopoverController *popController;
@property(nonatomic,assign) NSInteger currentTag;
@end

@implementation XJZXSignDocumentController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title =@"在办→按日期";
    
    UIBarButtonItem *backItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"返回"];
    self.navigationItem.leftBarButtonItem = backItem;
    UIButton *backButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
    [backButton addTarget:self action:@selector(goBackAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *listItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"签报管理"];
    self.navigationItem.leftBarButtonItem = listItem;
    
    UIButton *listButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
    [listButton addTarget:self action:@selector(docManagerList:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem,listItem, nil];
    UIButton* createFileOutButton = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
    [createFileOutButton addTarget:self action:@selector(presentFileOutDetailView) forControlEvents:UIControlEventTouchUpInside];
    
    self.signListParser = [[SignDocHandlingParser alloc] init];
    self.signListParser.type = @"date";
    self.signListParser.delegate = self;
    self.signListParser.serviceName = @"XJZXHandleSignReportList";
    self.signListParser.showView = self.view;
    self.signListParser.listTableView = self.listTableView;
    self.listTableView.dataSource = self.signListParser;
    self.listTableView.delegate = self.signListParser;
    [self.signListParser requestData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.delegate changeBackView];
}


#pragma mark -
#pragma mark WordsDelegate
- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row {
    [self.popController dismissPopoverAnimated:YES];
    if (self.currentPage == 103) {
        hjField.text = words;
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
            ngrqField.text =  dateString;
        }
        if (self.currentTag == 102) {
            jzrqField.text =  dateString;
            if (([ngrqField.text compare:jzrqField.text] == NSOrderedDescending)||
                [ngrqField.text compare:jzrqField.text] == NSOrderedSame)
            {
                
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"提示"
                                      message:@"截止时间不能早于等于开始时间"
                                      delegate:nil
                                      cancelButtonTitle:@"确定"
                                      otherButtonTitles:nil];
                [alert show];
                
                [jzrqField becomeFirstResponder];
                jzrqField.text=@"";
                
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

#pragma mark -
#pragma mark HandleGWDelegate
- (void)HandleGWResult:(BOOL)ret {
    self.signListParser.isRefresh = YES;
    [self.signListParser requestData];
}

#pragma mark - FileManager Delegate

// -------------------------------------------------------------------------------
//	实现FileManager Delegate委托方法
//  选中公文管理列表后调用此方法
// -------------------------------------------------------------------------------

- (void)returnSelectResult:(NSString *)type selected:(NSInteger)row
{
    BOOL isShow=NO;
    [self.signListParser.aryItems removeAllObjects];
    [self.listTableView reloadData];

    if (self.popController)
        [self.popController dismissPopoverAnimated:YES];
    
    switch (row) {
        case 0:
            isShow = NO;
            self.title = @"在办→按日期";
            self.signListParser = [[SignDocHandlingParser alloc] init];
            self.signListParser.type = @"date";
            self.signListParser.serviceName = @"XJZXHandleSignReportList";
            self.signListParser.showView = self.view;
            self.signListParser.delegate = self;
            [self.signListParser requestData];
            break;
            
        case 1:
            isShow = NO;
            self.title = @"在办→按环节";
            self.signListParser = [[SignDocHandlingParser alloc] init];
            self.signListParser.type = @"process";
            self.signListParser.serviceName = @"XJZXHandleSignReportList";
            self.signListParser.showView = self.view;
            self.signListParser.delegate = self;
            [self.signListParser requestData];
            break;
            
        case 2:
            isShow = NO;
            self.title = @"已办→按日期";
            self.signListParser = [[SignDocDoneParser alloc] init];
            self.signListParser.type = @"date";
            self.signListParser.serviceName = @"XJZXDoneSignReportList";
            self.signListParser.showView = self.view;
            self.signListParser.delegate = self;
            [self.signListParser requestData];
            break;
            
        case 3:
            isShow = NO;
            self.title = @"已办→按文号";
            self.signListParser = [[SignDocDoneParser alloc] init];
            self.signListParser.type = @"docid";
            self.signListParser.serviceName = @"XJZXDoneSignReportList";
            self.signListParser.showView = self.view;
            self.signListParser.delegate = self;
            [self.signListParser requestData];
            
            break;
            
        case 4:
            isShow = YES;
            self.title = @"查询";
            self.signListParser = [[QuerySignDocParser alloc] init];
            self.signListParser.type = @"InquiryList";
            self.signListParser.serviceName = @"XJZXQuerySignReportList";
            self.signListParser.showView = self.view;
            self.signListParser.delegate = self;
            break;
            
        default:
            break;
    }
    
    self.signListParser.listTableView = self.listTableView;
    self.listTableView.dataSource = self.signListParser;
    self.listTableView.delegate = self.signListParser;
    [self QueryViewAnimation:isShow];
}

#pragma mark - HandleSignDocDetail

// -------------------------------------------------------------------------------
//	实现HandleSignFileDetail Delegate委托方法
//  选中公文管理列表后调用此方法
// -------------------------------------------------------------------------------

- (void)didSelectSignDocListItem:(NSString *)docid process:(NSString *)name
{
    self.docid = docid;
    self.processName = name;
    SystemConfigContext *context = [SystemConfigContext sharedInstance];
    NSDictionary *loginUsr = [context getUserInfo];
    NSString *user = [loginUsr objectForKey:@"userId"];
    
    NSString *strUrl= [ServiceUrlString generateOAWebServiceUrl];
    NSString *params = [WebServiceHelper createParametersWithKey:@"HY_DOCID" value:self.docid, @"HY_USERID",user,@"Hy_year",@"",nil];
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:@"XJZXSignReportDetail" nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
  
    [self.webServiceHelper runAndShowWaitingView:self.view withTipInfo:@"正在载入签报详情..."];
}

- (void)loadMoreList{
    self.signListParser.isRefresh = NO;
    [self.signListParser requestData];
}

- (void)loadSignDocDetailViewProcess:(NSString *)name competence:(NSString *)status
{
    XJZXSignDocDetailViewController *detailViewController =[[XJZXSignDocDetailViewController alloc] initWithNibName:@"XJZXSignDocDetailViewController" bundle:nil];
    detailViewController.process = self.processName;
    detailViewController.docid = self.docid;
    detailViewController.infoDict = self.signDocInfo;
    detailViewController.delegate = self;
    detailViewController.responder = self;
    detailViewController.competence = status;
    //隐藏tabbar，并且扩展view高度
    [self.delegate changeToNextView];
    
    [self.navigationController pushViewController:detailViewController
                                        animated:YES];
}

#pragma mark - Handle Event

- (void)goBackAction:(id)sender
{
    [self.delegate backMainMenu:sender];
}

- (void)docManagerList:(id)sender
{
    UIButton *button = (UIButton *)sender;
    FileManagerListController *fileManagerListController = [[FileManagerListController alloc] initWithStyle:UITableViewStylePlain];
    fileManagerListController.fileOutList = @[@"在办→按日期",@"在办→按环节",@"已办→按日期",@"已办→按文号",@"查询"];
    fileManagerListController.fileType = @"SignDoc";
    fileManagerListController.delegate = self;
    
    UIPopoverController* tmpController = [[UIPopoverController alloc] initWithContentViewController:fileManagerListController];
    
    tmpController.popoverContentSize = CGSizeMake(240,44*5);
    self.popController = tmpController;
    [self.popController presentPopoverFromRect:button.bounds inView:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(IBAction)querySignDocResult:(id)sender
{
    NSString *errMsg = @"";
    if([ngrqField.text length] <= 0 &&
       [jzrqField.text length] <= 0 &&
       [fwbhField.text length] <= 0 &&
       [zbbmField.text length] <= 0 &&
       [btField.text length] <= 0 &&
       [hjField.text length] <= 0){
        errMsg = @"请输入查询条件";
    }
    
    if ([errMsg length] > 0) {
        [self showAlertMessage:errMsg];
        return;
    }
    
    NSMutableDictionary *dicValues = [NSMutableDictionary dictionaryWithCapacity:6];
    [dicValues setValue:ngrqField.text forKey:@"begin"];
    [dicValues setValue:jzrqField.text forKey:@"end"];
    [dicValues setValue:fwbhField.text forKey:@"bh"];
    [dicValues setValue:zbbmField.text forKey:@"dept"];
    [dicValues setValue:hjField.text forKey:@"urgent"];
    [dicValues setValue:btField.text forKey:@"title"];
   
    self.signListParser.paramDict = dicValues;
    self.signListParser.isRefresh = YES;
    [self.signListParser requestData];
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

- (IBAction)selectCommenWords:(id)sender{
    UITextField *txtField = (UITextField *)sender;
    self.currentPage = txtField.tag;
    
    NSArray *listArray = nil;
   
     if ([sender tag] == 103){
         txtField = hjField;
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

- (void)QueryViewAnimation:(BOOL)isShow
{
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
        if (height < 920) {
            height = height +236;
        }
        self.listTableView.frame = CGRectMake(x, 26, width, height);
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
    
    WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:@"XJZXSignReportDetailReturn" andWithJSONDelegate:self];
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
        NSDictionary *tmpDataDict = [tmpParsedJsonDict objectForKey:@"postDocInfo"];
            self.signDocInfo = tmpDataDict;
        NSString *status = [self.signDocInfo   objectForKey:@"competence"];
        [self loadSignDocDetailViewProcess:self.processName competence:status];
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
