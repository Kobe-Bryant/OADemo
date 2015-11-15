//
//  WrySearchViewController.m
//  NingBoOA
//
//  Created by PowerData on 13-10-16.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "WrySearchViewController.h"
#import "UICustomButton.h"
#import "PDJsonkit.h"
#import "WebDataParserHelper.h"
#import "UITableViewCell+Custom.h"
#import "WryCategoryViewController.h"
#import "ServiceUrlString.h"
#import "WryIntroduceViewController.h"

#define kTag_StartDate_Field 1001 //拟稿日期
#define kTag_EndDate_Field 1002 //截止日期

@interface WrySearchViewController ()
@property (nonatomic,strong) UIPopoverController *dateController;
@property (nonatomic,strong) UIPopoverController *wordsViewController;
@property (nonatomic,assign) int currentTag;
@property (nonatomic,assign) BOOL beHaveShow;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic,strong) NSMutableArray *listDataArray;
@property (nonatomic,assign) BOOL isLoading;
@property (nonatomic,assign) int totalRecord;
@property (nonatomic,assign) int currentPage;
@end

@implementation WrySearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)wordsTextFieldTouchDonw:(UITextField *)sender {
    [self.wordsViewController presentPopoverFromRect:sender.bounds inView:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"污染源企业信息查询";
    
    UIBarButtonItem *backItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"返回"];
    self.navigationItem.leftBarButtonItem = backItem;
    UIButton *backButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
    [backButton addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self initQueryView];
    
    [self initDatePoporController];
    
    self.currentPage = 1;
    [self requestData];
    self.beHaveShow = NO;
    
    //[self showSearchArea:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [self setNameLabel:nil];
    [self setListTableView:nil];
    [self setJgjbTextField:nil];
    [super viewDidUnload];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 72.0f;
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
    tmpheaderView.text = [NSString stringWithFormat:@"  污染源查询:%d条", self.totalRecord];
    return tmpheaderView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = [self.listDataArray objectAtIndex:indexPath.row];
    NSString *wrymc_value = [item objectForKey:@"MC"];
    NSString *wrydz_value = [NSString stringWithFormat:@"联系人：%@   联系电话：%@", [item objectForKey:@"LXR"],[item objectForKey:@"LXDH"]];
    NSString *wryhylx_value = [NSString stringWithFormat:@"所在区域：%@", [item objectForKey:@"SZQY"]];
    NSString *wryszqy_value = [NSString stringWithFormat:@"行业类别：%@", [item objectForKey:@"HYLB"]];
    NSString *wryjgjb_value = @"";
    UITableViewCell *cell = [UITableViewCell makeSubCell:tableView withTitle:wrymc_value  andSubvalue1:wrydz_value andSubvalue2:wryhylx_value andSubvalue3:wryszqy_value  andSubvalue4:wryjgjb_value andNoteCount:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WryIntroduceViewController *detail = [[WryIntroduceViewController alloc] init];
    NSDictionary *dict = [self.listDataArray objectAtIndex:indexPath.row];
    detail.wrybh = [NSString stringWithFormat:@"%@", [dict objectForKey:@"MC"]];
    [self.navigationController pushViewController:detail animated:YES];
    /*WryCategoryViewController *detail = [[WryCategoryViewController alloc] init];
    NSDictionary *dict = [self.listDataArray objectAtIndex:indexPath.row];
    detail.wrymc = [NSString stringWithFormat:@"%@", [dict objectForKey:@"MC"]];
    detail.wrybh = [NSString stringWithFormat:@"%d", [[dict objectForKey:@"OBJECTID"] integerValue]];
    [self.navigationController pushViewController:detail animated:YES];*/
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    int pages = self.totalRecord%20 == 0 ? self.totalRecord/20 : self.totalRecord/20+1;
    if(self.currentPage == pages || pages == 0)
    {
        return;
    }
	if (self.isLoading)
    {
        return;
    }
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 850 )
    {
        self.currentPage++;
        self.isLoading = YES;
        [self requestData];
    }
}

#pragma mark - Event Handler Methods

//按下弹出日期选择框
- (void)touchForDate:(id)sender
{
    UIControl *btn =(UIControl*)sender;
	[self.dateController presentPopoverFromRect:[btn bounds] inView:btn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	self.currentTag = btn.tag;
}

//搜索按钮点击处理
- (void)searchButtonClick:(id)sender
{
    //开始日期
    NSString *key = @"";
    NSString *jgjb = @"";
    if(self.nameField.text != nil && self.nameField.text.length > 0)
    {
        key = self.nameField.text;
    }
    if([self.jgjbTextField.text isEqualToString:@"全部"])
    {
        jgjb = @"";
    }
    self.totalRecord = 0;
    if(self.listDataArray)
    {
        [self.listDataArray removeAllObjects];
    }
    [self.listTableView reloadData];
    
    self.isLoading = YES;
    self.urlString = [ServiceUrlString generateMobileLawServiceUrl:@"TWryService.asmx"];
    NSString *params = [WebServiceHelper createParametersWithKey:@"keyword" value:key,@"gljb",jgjb  , nil];
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:self.urlString method:@"QueryWryList" nameSpace:@"http://tempuri.org/" parameters:params delegate:self];
    
    [self.webServiceHelper runAndShowWaitingView:self.view withTipInfo:@"正在查询，请稍候..."];
}

- (void)goBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - WordsDelegate

-(void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row{
    self.jgjbTextField.text = words;
    [self.wordsViewController dismissPopoverAnimated:YES];
}

#pragma mark - PopupDateController Delegate Method

// -------------------------------------------------------------------------------
//	实现PopupDateController Delegate委托方法
//  选中日期弹出框的时间后调用此方法
// -------------------------------------------------------------------------------

- (void)PopupDateController:(PopupDateViewController *)controller Saved:(BOOL)bSaved selectedDate:(NSDate *)date
{
    [self.dateController dismissPopoverAnimated:YES];
	if (bSaved)
    {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd"];
		NSString *dateString = [dateFormatter stringFromDate:date];
		
		switch (self.currentTag)
        {
			case kTag_StartDate_Field:
				self.startDateField.text = dateString;
				break;
			case kTag_EndDate_Field:
				self.endDateField.text = dateString;
				break;
			default:
				break;
		}
	}
    else
    {
        switch (self.currentTag)
        {
			case kTag_StartDate_Field:
				self.startDateField.text = @"";
				break;
			case kTag_EndDate_Field:
				self.endDateField.text = @"";
				break;
			default:
				break;
		}
    }
}

#pragma mark- UITextField Delegate Method

// -------------------------------------------------------------------------------
//	实现UITextField Delegate委托方法
//  按下UITextField后不让键盘弹出来，实现可以选择时间
// -------------------------------------------------------------------------------

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}

//初始化查询区域视图控件
- (void)initQueryView
{
    //开始时间
    self.startDateField.tag = kTag_StartDate_Field;
    self.startDateField.delegate = self;
    [self.startDateField addTarget:self action:@selector(touchForDate:) forControlEvents:UIControlEventTouchDown];
    //结束时间
    self.endDateField.tag = kTag_EndDate_Field;
    self.endDateField.delegate = self;
    [self.endDateField addTarget:self action:@selector(touchForDate:) forControlEvents:UIControlEventTouchDown];
    //搜索按钮
    [self.searchButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

//初始化时间选择器
- (void)initDatePoporController
{
    //初始化PopDate
    PopupDateViewController *tmpdate = [[PopupDateViewController alloc] initWithPickerMode:UIDatePickerModeDate];
	tmpdate.delegate = self;
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tmpdate];
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
	self.dateController = popover;
    
    CommenWordsViewController *tmpwprd = [[CommenWordsViewController alloc] initWithStyle:UITableViewStylePlain];
	tmpwprd.delegate = self;
    tmpwprd.wordsAry = @[@"全部",@"国控",@"省控",@"市控",@"其他"];
    tmpwprd.contentSizeForViewInPopover = CGSizeMake(200, 300);
	UIPopoverController *popoverword = [[UIPopoverController alloc] initWithContentViewController:tmpwprd];
	self.wordsViewController = popoverword;
}

- (void)QueryViewAnimation:(BOOL)isShow
{
    if(isShow)
    {
        self.nameLabel.hidden = NO;
        self.nameField.hidden = NO;
        self.addressField.hidden = NO;
        self.addressLabel.hidden = NO;
        self.startDateLabel.hidden = NO;
        self.startDateField.hidden = NO;
        self.endDateLabel.hidden = NO;
        self.endDateField.hidden = NO;
        self.searchButton.hidden = NO;
        
        CGRect frame = self.listTableView.frame;
        [UIView beginAnimations:@"ShowListTable" context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        CGFloat x = CGRectGetMinX(frame);
        CGFloat width = CGRectGetWidth(frame);
        CGFloat height = CGRectGetHeight(frame);
        
        self.listTableView.frame = CGRectMake(x, 260, width, height);
        [UIView commitAnimations];
    }
    else
    {
        self.nameLabel.hidden = YES;
        self.nameField.hidden = YES;
        self.addressField.hidden = YES;
        self.addressLabel.hidden = YES;
        self.startDateLabel.hidden = YES;
        self.startDateField.hidden = YES;
        self.endDateLabel.hidden = YES;
        self.endDateField.hidden = YES;
        self.searchButton.hidden = YES;
        
        CGRect frame = self.listTableView.frame;
        [UIView beginAnimations:@"HIdeListTable" context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        CGFloat x = CGRectGetMinX(frame);
        CGFloat width = CGRectGetWidth(frame);
        CGFloat height = CGRectGetHeight(frame);
        
        self.listTableView.frame = CGRectMake(x, 20, width, height);
        [UIView commitAnimations];
    }
}

- (void)requestData
{
    self.urlString = [ServiceUrlString generateMobileLawServiceUrl:@"TWryService.asmx"];
    NSString *params = [WebServiceHelper createParametersWithKey:@"pageCurr" value:[NSString stringWithFormat:@"%d", self.currentPage], nil];
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:self.urlString method:@"QueryWryList" nameSpace:@"http://tempuri.org/" parameters:params delegate:self];
    self.isLoading = YES;
    [self.webServiceHelper runAndShowWaitingView:self.view withTipInfo:@"正在加载列表，请稍候..."];
}

// -------------------------------------------------------------------------------
//	实现NSURLConnHelperDelegate委托方法
//  处理网络请求的NSData数据
// -------------------------------------------------------------------------------

-(void)processWebData:(NSData*)webData
{
    if([webData length] <=0)
    {
        [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
    }
    WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:@"string" andWithJSONDelegate:self];
    [webDataHelper parseJSONData:webData];
}

// -------------------------------------------------------------------------------
//	实现NSURLConnHelperDelegate委托方法
//  处理网络请求失败
// -------------------------------------------------------------------------------

-(void)processError:(NSError *)error
{
    self.isLoading = NO;
    [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
}

// -------------------------------------------------------------------------------
//	实现WebDataParserDelegate委托方法
//  解析json字符串
// -------------------------------------------------------------------------------

- (void)parseJSONString:(NSString *)jsonStr
{
    self.isLoading = NO;
    NSDictionary *tmpParsedJsonDict = [jsonStr objectFromJSONString];
    BOOL bParseError = NO;
    if (tmpParsedJsonDict && jsonStr.length > 0)
    {
        self.totalRecord = [[tmpParsedJsonDict objectForKey:@"total"] integerValue];
        NSArray *tmpAry = [tmpParsedJsonDict objectForKey:@"rows"];
        if(self.totalRecord > 0)
        {
            if(self.listDataArray == nil)
            {
                self.listDataArray = [NSMutableArray arrayWithCapacity:10];
            }
            [self.listDataArray addObjectsFromArray:tmpAry];
        }
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

@end
