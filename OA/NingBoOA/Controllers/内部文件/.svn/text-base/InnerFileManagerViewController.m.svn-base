//
//  InnerFileManagerViewController.h
//  内部文件管理（在办-按日期、已办-按日期、查询）
//
//  Created by 曾静 on 13-9-27.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "InnerFileManagerViewController.h"
#import "ServiceUrlString.h"
#import "UICustomButton.h"
#import "UITableViewCell+Custom.h"
#import "PDJsonkit.h"
#import "ZrsUtils.h"
#import "SystemConfigContext.h"
#import "InnerFileHandlingParser.h"
#import "InnerFileDoneParser.h"
#import "InnerFileDetailViewController.h"
#import "QueryInnerFileParser.h"

#define kTag_NGRQ_Field 1001 //拟稿日期
#define kTag_JZRQ_Field 1002 //截止日期
#define kTag_HJ_Field 1003 //缓急


@interface InnerFileManagerViewController ()
@property (nonatomic,strong) UIPopoverController *popController;
@property (nonatomic,strong) PopupDateViewController *dateController;
@property (nonatomic,strong) InnerFileListParser *innerFileListParser;
@property (nonatomic,assign) int currentTag;
@end

@implementation InnerFileManagerViewController

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
    
    self.title =@"在办→按日期";
    
    //导航栏上面的按钮初始化
    UIBarButtonItem *backItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"返回"];
    self.navigationItem.leftBarButtonItem = backItem;
    UIButton *backButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
    [backButton addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *listItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"内部文件"];
    self.navigationItem.leftBarButtonItem = listItem;
    UIButton *listButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
    [listButton addTarget:self action:@selector(docManagerList:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem,listItem, nil];
    
    //初始化请求数据
    self.innerFileListParser = [[InnerFileHandlingParser alloc] init];
    self.innerFileListParser.serviceName = @"GETHANDLEFILEINSIDELIST";
    self.innerFileListParser.showView = self.view;
    self.innerFileListParser.delegate = self;
    self.innerFileListParser.listTableView = self.listTableView;
    self.listTableView.delegate = self.innerFileListParser;
    self.listTableView.dataSource = self.innerFileListParser;
    [self.innerFileListParser requestData];
}

- (void)viewDidUnload
{
    [self setNgrqField:nil];
    [self setWjbhField:nil];
    [self setBtField:nil];
    [self setJzrqField:nil];
    [self setSearchButton:nil];
    [self setZbbmField:nil];
    [self setHjField:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)HandleGWResult:(BOOL)ret {
    self.innerFileListParser.isRefresh = YES;
    [self.innerFileListParser requestData];
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
    [self.innerFileListParser.aryItems removeAllObjects];
    [self.listTableView reloadData];

    switch (row)
    {
        case 0:
            isShow = NO;
            self.title = @"在办→按日期";
            self.innerFileListParser = [[InnerFileHandlingParser alloc] init];
            self.innerFileListParser.type = @"date";
            self.innerFileListParser.serviceName = @"GETHANDLEFILEINSIDELIST";
            self.innerFileListParser.showView = self.view;
            self.innerFileListParser.delegate = self;
            [self.innerFileListParser requestData];
            
            break;
        case 1:
            isShow = NO;
            self.title = @"已办→按日期";
            self.innerFileListParser = [[InnerFileDoneParser alloc] init];
            self.innerFileListParser.type = @"date";
            self.innerFileListParser.serviceName = @"GETDONEFILEINSIDELIST";
            self.innerFileListParser.showView = self.view;
            self.innerFileListParser.delegate = self;
            [self.innerFileListParser requestData];
            break;
        case 2:
            isShow = YES;
            self.title = @"查询";
            self.innerFileListParser = [[QueryInnerFileParser alloc] init];
            self.innerFileListParser.type = @"InquiryList";
            self.innerFileListParser.serviceName = @"QueryFileInsideList";
            self.innerFileListParser.showView = self.view;
            self.innerFileListParser.delegate = self;
            break;
            
        default:
            break;
    }
    
    self.innerFileListParser.listTableView = self.listTableView;
    self.listTableView.delegate = self.innerFileListParser;
    self.listTableView.dataSource = self.innerFileListParser;
    [self QueryViewAnimation:isShow];
}

#pragma mark -
#pragma mark HandleInnerFileDetail
- (void)didSelectInnerFileListItem:(NSString *)docid process:(NSString *)name {
    
    self.docid = docid;
    self.processName = name;
    SystemConfigContext *context = [SystemConfigContext sharedInstance];
    NSDictionary *loginUsr = [context getUserInfo];
    NSString *user = [loginUsr objectForKey:@"userId"];
    
    NSString *strUrl= [ServiceUrlString generateOAWebServiceUrl];
    NSString *params = [WebServiceHelper createParametersWithKey:@"Hy_docid" value:self.docid, @"Hy_userid",user,@"Hy_year",@"",nil];

    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:@"GetFileInsideDetail" nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
     [self.webServiceHelper runAndShowWaitingView:self.view withTipInfo:@"正在载入详情,请稍候..."];
}

- (void)loadMoreList{
    self.innerFileListParser.isRefresh = NO;
    [self.innerFileListParser requestData];
}

- (void)loadInnerFileDetailViewProcess:(NSString *)name competence:(NSString *)status
{
    InnerFileDetailViewController *detailViewController =[[InnerFileDetailViewController alloc] initWithNibName:@"InnerFileDetailViewController" bundle:nil];
    detailViewController.process = self.processName;
    detailViewController.docid = self.docid;
    detailViewController.infoDict = self.innerInfo;
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
    fileManagerListController.fileOutList = @[@"在办→按日期",@"已办→按日期",@"查询"];
    fileManagerListController.fileType = @"FileOut";
    fileManagerListController.delegate = self;
    
    UIPopoverController*popController = [[UIPopoverController alloc] initWithContentViewController:fileManagerListController];
    
    popController.popoverContentSize = CGSizeMake(240,44*3);
    
    self.popController = popController;
    [self.popController presentPopoverFromRect:button.bounds inView:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
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
        txtField = self.hjField;
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

- (IBAction)queryInnerFileResult:(id)sender{
    NSString *errMsg = @"";
    if([self.ngrqField.text length] <= 0 &&
       [self.jzrqField.text length] <= 0 &&
       [self.wjbhField.text length] <= 0 &&
       [self.zbbmField.text length] <= 0 &&
       [self.btField.text length] <= 0 &&
       [self.hjField.text length] <= 0){
        errMsg = @"请输入查询条件";
    }
    
    if ([errMsg length] > 0) {
        [self showAlertMessage:errMsg];
        return;
    }
    
    NSMutableDictionary *dicValues = [NSMutableDictionary dictionaryWithCapacity:6];
    [dicValues setValue:self.ngrqField.text forKey:@"begin"];
    [dicValues setValue:self.ngrqField.text forKey:@"end"];
    [dicValues setValue:self.wjbhField.text forKey:@"bh"];
    [dicValues setValue:self.zbbmField.text forKey:@"dept"];
    [dicValues setValue:self.hjField.text forKey:@"urgent"];
    [dicValues setValue:self.btField.text forKey:@"title"];
    
    self.innerFileListParser.paramDict = dicValues;
    self.innerFileListParser.isRefresh = YES;
    [self.innerFileListParser requestData];

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
        self.hjField.text = words;
    }
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
            self.ngrqField.text =  dateString;
        }
        if (self.currentTag == 102) {
            self.jzrqField.text =  dateString;
            if (([self.ngrqField.text compare:self.jzrqField.text] == NSOrderedDescending)||
                [self.ngrqField.text compare:self.jzrqField.text] == NSOrderedSame)
            {
                
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"提示"
                                      message:@"截止时间不能早于等于开始时间"
                                      delegate:nil
                                      cancelButtonTitle:@"确定"
                                      otherButtonTitles:nil];
                [alert show];
                
                [self.jzrqField becomeFirstResponder];
                self.jzrqField.text=@"";
                
            }
        }
	}
    
}

#pragma mark- UITextField Delegate Method

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
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
    
    WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:@"GetFileInsideDetailReturn" andWithJSONDelegate:self];
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
        self.innerInfo = tmpDataDict;
        NSString *status = [self.innerInfo   objectForKey:@"competence"];
        [self loadInnerFileDetailViewProcess:self.processName competence:status];
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
