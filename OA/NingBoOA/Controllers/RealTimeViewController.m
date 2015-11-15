//
//  RealTimeViewController.m
//  NingBoOA
//
//  Created by PowerData on 14-3-12.
//  Copyright (c) 2014年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "RealTimeViewController.h"
#import "RealTimeTableViewCell.h"
#import "UICustomButton.h"
#import "SiteInfoViewController.h"
#import "WebServiceHelper.h"
#import "GDataXMLNode.h"
#import "S7GraphView.h"
#import "JSONKit.h"
#import <QuartzCore/QuartzCore.h>
#import "CommenWordsViewController.h"
#import "SiteInfoViewController.h"
#import "PopupDateViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface RealTimeViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,S7GraphViewDataSource,WordsDelegate,PopupDateDelegate>
@property (nonatomic,strong) UIPopoverController *poverController;
@property (nonatomic,strong) S7GraphView *graphView;
@property (nonatomic,strong) UIWebView *resultWebView;
@property (nonatomic,strong) NSMutableArray *siteNameArray;
@property (nonatomic,strong) NSMutableArray *timeArray;
@property (nonatomic,strong) NSMutableArray *valueArray;
@property (nonatomic,strong) NSMutableArray *stateArray;
@property (nonatomic,strong) NSMutableArray *yzArray;
@property (nonatomic,strong) NSMutableArray *infoArray;
@property (nonatomic,strong) NSArray *array;
@property (nonatomic,strong) NSDate *time;
@property (nonatomic,copy) NSString *sbbm;
@property (nonatomic,copy)NSString *unit;
@property (nonatomic,strong) NSMutableString *html;
@property (nonatomic,assign) NSInteger selectRow;
@property (nonatomic,assign) BOOL isFrist;
@end

@implementation RealTimeViewController
@synthesize siteArray,qyid;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)leftButtonPress:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightButton1Press:(UIButton *)button{
    PopupDateViewController *dateViewController = [[PopupDateViewController alloc]initWithPickerMode:UIDatePickerModeDateAndTime];
    dateViewController.delegate = self;
    dateViewController.date = self.time;
    UINavigationController *dateNav = [[UINavigationController alloc]initWithRootViewController:dateViewController];
    self.poverController = [[UIPopoverController alloc]initWithContentViewController:dateNav];
    [self.poverController presentPopoverFromRect:button.bounds inView:button permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

-(void)rightButtonPress:(UIButton *)button{
    SiteInfoViewController *siteVC = [[SiteInfoViewController alloc]init];
    siteVC.qyid = self.qyid;
    siteVC.siteArray = self.siteArray;
    siteVC.title = self.wrymc;
    [self.navigationController pushViewController:siteVC animated:YES];
}

- (IBAction)textFieldTouchDonw:(UITextField *)sender {
    CommenWordsViewController *wordsViewController = [[CommenWordsViewController alloc]initWithStyle:UITableViewStylePlain];
    wordsViewController.contentSizeForViewInPopover = CGSizeMake(150, 200);
    wordsViewController.wordsAry = self.siteNameArray;
    wordsViewController.delegate = self;
    self.poverController = [[UIPopoverController alloc]initWithContentViewController:wordsViewController];
    [self.poverController presentPopoverFromRect:sender.bounds inView:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

-(void)setViewLayer:(UIView *)view{
    CALayer *tvLayer = [view layer];
    tvLayer.borderColor = [UIColor colorWithWhite:204/255.f alpha:1].CGColor;
    tvLayer.borderWidth = 2.f;
    tvLayer.cornerRadius = 5.f;
    tvLayer.shadowColor = [UIColor blackColor].CGColor;
    tvLayer.shadowOffset = CGSizeMake(1.f, 1.f);
    tvLayer.shadowOpacity = 0.5f;
    tvLayer.shadowRadius = 4.f;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.webServiceHelper) {
        [self.webServiceHelper cancel];
    }
    [self.poverController dismissPopoverAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = [NSString stringWithFormat:@"%@在线监控",self.wrymc];
    
    UIBarButtonItem *rightBarButton = [UICustomBarButtonItem woodBarButtonItemWithText:@"站点信息"];
    UIButton *rightButton = (UIButton *)rightBarButton.customView;
    [rightButton addTarget:self action:@selector(rightButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton1 = [UICustomBarButtonItem woodBarButtonItemWithText:@"选择时间"];
    UIButton *rightButton1 = (UIButton *)rightBarButton1.customView;
    [rightButton1 addTarget:self action:@selector(rightButton1Press:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItems = @[rightBarButton,rightBarButton1];
    
    UIBarButtonItem *leftBarButton = [UICustomBarButtonItem woodBarButtonItemWithText:@"返回"];
    UIButton *leftButton = (UIButton *)leftBarButton.customView;
    [leftButton addTarget:self action:@selector(leftButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    [self setViewLayer:self.BgView];
    [self setViewLayer:self.YZTableView.backgroundView];
    [self setViewLayer:self.resultWebView];
    
    self.graphView = [[S7GraphView alloc] initWithFrame:CGRectMake(20, 20, 728, 525)];
	self.graphView.dataSource = self;
	NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
	[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[numberFormatter setMinimumFractionDigits:1];
	[numberFormatter setMaximumFractionDigits:1];
	self.graphView.yValuesFormatter = numberFormatter;

	self.graphView.drawAxisX = YES;
	self.graphView.drawAxisY = YES;
	self.graphView.drawGridX = YES;
	self.graphView.drawGridY = YES;
	
    self.graphView.backgroundColor = [UIColor whiteColor];
	self.graphView.xValuesColor = [UIColor blackColor];
	self.graphView.yValuesColor = [UIColor blackColor];
	self.graphView.gridXColor = [UIColor blackColor];
	self.graphView.gridYColor = [UIColor blackColor];
	self.graphView.infoColor = [UIColor blackColor];
    
    [self.view addSubview:self.graphView];
    
    self.resultWebView = [[UIWebView alloc] initWithFrame:CGRectMake(277, 553, 471, 387)];
    [self.view addSubview:self.resultWebView];
    
    self.time = [NSDate date];
    self.siteNameArray = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in self.siteArray) {
        [self.siteNameArray addObject:[dic objectForKey:@"PKMC"]];
    }

    self.PKMCTextField.text = [self.siteNameArray objectAtIndex:0];
    
    self.sbbm = [[self.siteArray objectAtIndex:0]objectForKey:@"SBBM"];
    self.yzArray = [[NSMutableArray alloc]init];
    self.timeArray = [[NSMutableArray alloc]init];
    self.valueArray = [[NSMutableArray alloc]init];
    self.stateArray = [[NSMutableArray alloc]init];
    
    self.unit = @"";
    self.isFrist = YES;
    [self requestWebData];
}

-(void)requestWebData{
    NSDateFormatter *matter = [[NSDateFormatter alloc]init];
    [matter setDateFormat:@"yyyy-MM-dd HH"];
    NSString *time = [matter stringFromDate:self.time];
    NSString *beginTime = [NSString stringWithFormat:@"%@:00:00",time];
    NSString *endTime = [NSString stringWithFormat:@"%@:59:59",time];
    NSString *params = [WebServiceHelper createParametersWithKey:@"ID" value:self.sbbm,@"BeginTime",beginTime,@"EndTime",endTime,nil];
    self.webServiceHelper = [[WebServiceHelper alloc]initWithUrl:@"http://10.33.2.27/MobileLawService_OA/Services/TZxjkService.asmx" method:@"GetZxjcYzSssj" nameSpace:WEBSERVICE_NAMESPACE parameters:params delegate:self];
    [self.webServiceHelper runAndShowWaitingView:self.view withTipInfo:@"正在加载数据，请稍候..."];
}

-(void)displayData{

    [self.timeArray removeAllObjects];
    [self.valueArray removeAllObjects];
    [self.stateArray removeAllObjects];
    
    self.graphView.info = self.unit;
    NSString *itemName = [self.yzArray objectAtIndex:self.selectRow];
    
    for (int i=self.array.count-1;i>=0;i-- ) {
        NSDictionary *dic = [self.array objectAtIndex:i];
        NSString *time = [dic objectForKey:@"RecordTime"];
        NSString *value = [dic objectForKey:[self.yzArray objectAtIndex:self.selectRow]];
        NSArray *array = [value componentsSeparatedByString:@","];
        value = [array objectAtIndex:0];
        NSString *state = [array objectAtIndex:1];
        [self.timeArray addObject:time];
        [self.valueArray addObject:value];
        [self.stateArray addObject:state];
    }
    
    NSString *width = @"471px";
    
    self.html = [NSMutableString string];
    [self.html appendFormat:@"<html><body topmargin=0 leftmargin=0><table width=\"%@\" bgcolor=\"#FFCC32\" border=1 bordercolor=\"#893f7e\" frame=below rules=none><tr><th><font color=\"Black\">%@监测详细信息</font></th></tr><table><table width=\"%@\" bgcolor=\"#893f7e\" border=0 cellpadding=\"1\"><tr bgcolor=\"#e6e7d5\" ><th>监测时间</th><th>监测数据</th><th>监测结果</th></tr>",width,itemName,width];
    
    BOOL boolColor = true;
    for (int i=0;i<self.array.count;i++) {
        [self.html appendFormat:@"<tr bgcolor=\"%@\">",boolColor ? @"#cfeeff" : @"#ffffff"];
        boolColor = !boolColor;
        NSString *state = [self.stateArray objectAtIndex:i];
        if ([state isEqualToString:@"告警"]) {
            state = [NSString stringWithFormat:@"<font color=\"#FFFF37\">%@</font>",state];
        }
        else if ([state isEqualToString:@"异常"]) {
            state = [NSString stringWithFormat:@"<font color=\"#FF0000\">%@</font>",state];
        }
        [self.html appendFormat:@"<td align=center>%@</td><td align=center>%@</td><td align=center>%@</td>",[self.timeArray objectAtIndex:i],[NSString stringWithFormat:@"%@%@",[self.valueArray objectAtIndex:i],self.unit],state];
        [self.html appendString:@"</tr>"];
    }
    [self.html appendString:@"</table></body></html>"];
    
    [self.graphView reloadData];
    [self addView:self.graphView type:@"rippleEffect" subType:kCATransitionFromTop];
    [self.resultWebView loadHTMLString:self.html baseURL:nil];
    [self addView:self.resultWebView type:@"pageCurl" subType:kCATransitionFromRight];

}

#pragma mark - Private methods

- (void)addView:(UIView *)view type:(NSString *)type subType:(NSString *)subType
{
    if(view.superview !=nil)
        [view removeFromSuperview];
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = type;
    transition.subtype = subType;
    [self.view addSubview:view];
    [[view layer] addAnimation:transition forKey:@"ADD"];
}

#pragma mark - UItableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.yzArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *Identifier = @"YZCell";
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    cell.textLabel.text = [self.yzArray objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectRow = indexPath.row;
    [self displayData];
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - PopupDateDelegate

-(void)PopupDateController:(PopupDateViewController *)controller Saved:(BOOL)bSaved selectedDate:(NSDate *)date{
    if (bSaved) {
        self.time = date;
        [self requestWebData];
    }
    [self.poverController dismissPopoverAnimated:YES];
}

#pragma mark - WordsDelegate

-(void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row{
    NSDictionary *dic = [self.siteArray objectAtIndex:row];
    self.sbbm = [NSString stringWithFormat:@"%@",[dic objectForKey:@"SBBM"]];
    [self requestWebData];
    self.PKMCTextField.text = words;
    [self.poverController dismissPopoverAnimated:YES];
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}

#pragma mark - S7GraphViewDelegate

-(NSUInteger)graphViewNumberOfPlots:(S7GraphView *)graphView{
    if (self.valueArray.count) {
        return 1;
    }
    else{
        return 0;
    }
}

-(NSArray *)graphView:(S7GraphView *)graphView yValuesForPlot:(NSUInteger)plotIndex{
    return self.valueArray;
}

-(NSArray *)graphViewXValues:(S7GraphView *)graphView{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (NSString *str in self.timeArray) {
        [array addObject:[str substringFromIndex:11]];
    }
    return array;
}

#pragma mark - Network Request

-(void)processWebData:(NSData *)webData{
    if ([webData length]<=0) {
        [self showAlertMessage:NETWORK_DATA_ERROR_MESSAGE];
    }
    NSString *jsonStr = [[NSString alloc]initWithData:webData encoding:NSUTF8StringEncoding];
    NSDictionary *dataDic = [jsonStr objectFromJSONString];
    NSString *columns = [dataDic objectForKey:@"columns"];
    NSArray *array = [columns componentsSeparatedByString:@","];
    [self.yzArray removeAllObjects];
    for (NSString *yzStr in array) {
        [self.yzArray addObject:yzStr];
    }
    NSArray *dataArray = [dataDic objectForKey:@"rows"];
    if (dataArray && dataArray.count) {
        self.array = [NSArray arrayWithArray:dataArray];
        [self.YZTableView reloadData];
        
        if (self.isFrist == YES) {
            self.isFrist = NO;
        }
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.selectRow inSection:0];
        [self.YZTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self displayData];
    }
    else if (self.isFrist == YES){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该企业无监测数据" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alert.tag = 100;
        [alert show];
    }
    else{
        [self showAlertMessage:NETWORK_DATA_ERROR_MESSAGE];
    }
}

-(void)processError:(NSError *)error{
    [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setYZTableView:nil];
    [self setYZTableView:nil];
    [self setBgView:nil];
    [self setPKMCTextField:nil];
    [super viewDidUnload];
}
@end
