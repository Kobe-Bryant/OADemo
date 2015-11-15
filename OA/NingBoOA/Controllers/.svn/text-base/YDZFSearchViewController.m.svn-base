//
//  YDZFSearchViewController.m
//  NingBoOA
//
//  Created by PowerData on 13-10-18.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "YDZFSearchViewController.h"
#import "UITableViewCell+Custom.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "YDZFMainRecordViewController.h"
#import "UICustomButton.h"

#define kTag_StartDate_Field 1001 //拟稿日期
#define kTag_EndDate_Field 1002 //截止日期

@interface YDZFSearchViewController ()
@property (nonatomic,strong) UIPopoverController *datePopController;
@property (nonatomic,strong) PopupDateViewController *dateController;
@property (nonatomic,assign) int currentTag;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic,strong) NSMutableArray *listDataArray;
@property (nonatomic,assign) BOOL isLoading;
@property (nonatomic,assign) int totalRecord;
@property (nonatomic,assign) int currentPage;

@property (nonatomic,strong) WebServiceHelper *webServiceHelper;
@end

@implementation YDZFSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"移动执法信息查询";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *backItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"返回"];
    self.navigationItem.leftBarButtonItem = backItem;
    UIButton *backButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
    [backButton addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    self.currentPage = 1;
    [self initQueryView];
    [self initDatePoporController];
    [self requestData];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    if(self.webServiceHelper)
    {
        [self.webServiceHelper cancel];
    }
    if(self.datePopController)
    {
        [self.datePopController dismissPopoverAnimated:YES];
    }
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [self setListTableView:nil];
    [self setQyxxLabel:nil];
    [self setQyxxField:nil];
    [self setKssjLabel:nil];
    [self setKssjField:nil];
    [self setJssjLabel:nil];
    [self setJssjField:nil];
    [self setSearchButton:nil];
    [super viewDidUnload];
}

#pragma mark - UITableView Delegate & DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listDataArray.count;
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
    tmpheaderView.text = [NSString stringWithFormat:@"  移动执法信息查询:%d条", self.totalRecord];
    return tmpheaderView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tmpDic = [self.listDataArray objectAtIndex:indexPath.row];
    NSString *dwmc = [tmpDic objectForKey:@"DWMC"];
    NSString *dwdz = [NSString stringWithFormat:@"地址:%@", [tmpDic objectForKey:@"DWDZ"]];
    UITableViewCell *cell;
    NSString *date1 = [tmpDic objectForKey:@"DCSJ"];
    date1 = [date1 substringToIndex:10];
    NSString *date2 = [tmpDic objectForKey:@"DCJSSJ"];
    date2 = [date2 substringToIndex:10];
    NSString *sfhg = [NSString stringWithFormat:@"是否合格：%@", [tmpDic objectForKey:@"SFHG"]];
    NSString *jckssj = [NSString stringWithFormat:@"开始时间：%@",date1];
    NSString *jcjssj = [NSString stringWithFormat:@"结束时间：%@",date2];
    cell = [UITableViewCell makeSubCell:tableView withTitle:dwmc andSubvalue1:dwdz andSubvalue2:jcjssj andSubvalue3:jckssj andSubvalue4:sfhg andNoteCount:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    int pages = self.totalRecord%25 == 0 ? self.totalRecord/25 : self.totalRecord/25+1;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.listDataArray objectAtIndex:indexPath.row];
    YDZFMainRecordViewController *detail = [[YDZFMainRecordViewController alloc] initWithNibName:@"YDZFMainRecordViewController" bundle:nil];
    detail.DWMC = [dic objectForKey:@"DWMC"];
    detail.XCZFBH = [dic objectForKey:@"XCZFBH"];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - Event Handler Methods
- (void)goBackAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)touchForDate:(id)sender
{
    UIControl *btn =(UIControl*)sender;
	[self.datePopController presentPopoverFromRect:[btn bounds] inView:btn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	self.currentTag = btn.tag;
}

- (IBAction)searchButtonClick:(id)sender
{
    if(self.listDataArray)
    {
        [self.listDataArray removeAllObjects];
    }
    NSString *kw = @"";
    NSString *kssj = @"";
    NSString *jssj = @"";
    if(self.qyxxField.text != nil || self.qyxxField.text.length > 0)
    {
        kw = self.qyxxField.text;
    }
    if(self.kssjField.text != nil && self.kssjField.text.length > 0)
    {
        kssj = self.kssjField.text;
    }
    if(self.jssjField.text != nil && self.jssjField.text.length > 0)
    {
        jssj = self.jssjField.text;
    }
    self.isLoading = YES;
    NSString *params = [WebServiceHelper createParametersWithKey:@"keyword" value:kw, @"kssj", kssj, @"jssj", jssj, nil];
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:self.urlString method:@"QueryXzjgList" nameSpace:@"http://tempuri.org/" parameters:params delegate:self];
    [self.webServiceHelper runAndShowWaitingView:self.view];
}

#pragma mark - Private Methods

- (void)requestData
{
    self.urlString = [ServiceUrlString generateMobileLawServiceUrl:@"TYdzfService.asmx"];
    NSString *kw = @"";
    if(self.qyxxField.text == nil || self.qyxxField.text.length == 0)
    {
        kw = self.qyxxField.text;
    }
    
    NSString *method = @"QueryXzjgList";
    NSString *params = [WebServiceHelper createParametersWithKey:@"pageCurr" value:[NSString stringWithFormat:@"%d", self.currentPage], nil];
//    NSString *method = @"GetVersion";
//    NSString *params = nil;

    
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:self.urlString method:method nameSpace:@"http://tempuri.org/" parameters:params delegate:self];
    self.isLoading = YES;
    [self.webServiceHelper runAndShowWaitingView:self.view withTipInfo:@"正在加载列表，请稍候..."];
}

//初始化查询区域视图控件
- (void)initQueryView
{
    //开始时间
    self.kssjField.tag = kTag_StartDate_Field;
    self.kssjField.delegate = self;
    //结束时间
    self.jssjField.tag = kTag_EndDate_Field;
    self.jssjField.delegate = self;
}

//初始化时间选择器
- (void)initDatePoporController
{
    //初始化PopDate
    PopupDateViewController *tmpdate = [[PopupDateViewController alloc] initWithPickerMode:UIDatePickerModeDate];
	self.dateController = tmpdate;
	self.dateController.delegate = self;
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.dateController];
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
	self.datePopController = popover;
}

#pragma mark - PopupDateController Delegate Method

// -------------------------------------------------------------------------------
//	实现PopupDateController Delegate委托方法
//  选中日期弹出框的时间后调用此方法
// -------------------------------------------------------------------------------

- (void)PopupDateController:(PopupDateViewController *)controller Saved:(BOOL)bSaved selectedDate:(NSDate *)date
{
    [self.datePopController dismissPopoverAnimated:YES];
	if (bSaved)
    {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd"];
		NSString *dateString = [dateFormatter stringFromDate:date];
		
		switch (self.currentTag)
        {
			case kTag_StartDate_Field:
				self.kssjField.text = dateString;
				break;
			case kTag_EndDate_Field:
				self.jssjField.text = dateString;
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
				self.kssjField.text = @"";
				break;
			case kTag_EndDate_Field:
				self.jssjField.text = @"";
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
        if([tmpAry count] > 0)
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
