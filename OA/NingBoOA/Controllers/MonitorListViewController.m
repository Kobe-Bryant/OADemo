//
//  MonitorListViewController.m
//  NingBoOA
//
//  Created by PowerData on 14-3-11.
//  Copyright (c) 2014年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "MonitorListViewController.h"
#import "CommenWordsViewController.h"
#import "ServiceUrlString.h"
#import "WebDataParserHelper.h"
#import "UICustomButton.h"
#import "RealTimeViewController.h"
#import "UITableViewCell+Custom.h"
#import "JSONKit.h"

@interface MonitorListViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,WordsDelegate>
@property (nonatomic,strong) UIPopoverController *poverController;
@property (nonatomic,strong) NSMutableArray *aryItems;
@property (nonatomic,strong) NSString *fileServiceName;
@property (nonatomic,strong) NSMutableArray *valueArray;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) NSInteger totalRecord;
@property (nonatomic,strong) NSDictionary *siteDic;
@property (nonatomic,assign) BOOL isLoading;
@end

@implementation MonitorListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.aryItems = [[NSMutableArray alloc]init];
        self.fileServiceName  = @"QueryZxjgList";
    }
    return self;
}

-(void)goBackAction:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)searchButtonPress:(UIButton *)sender {
    self.currentPage = 1;
    [self.qymcTextField resignFirstResponder];
    [self requestWebData];
}
- (IBAction)textFieldTouchDonw:(UITextField *)sender {
    self.jgjbTextField.text = @"";
    [self.qymcTextField resignFirstResponder];
    
    CommenWordsViewController *wordsViewController = [[CommenWordsViewController alloc]initWithStyle:UITableViewStylePlain];
    wordsViewController.delegate = self;
    wordsViewController.wordsAry = @[@"全部",@"国控",@"省控",@"市控",@"其他",];
    wordsViewController.contentSizeForViewInPopover = CGSizeMake(200, 300);
    self.poverController = [[UIPopoverController alloc]initWithContentViewController:wordsViewController];
    [self.poverController presentPopoverFromRect:sender.bounds inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.webServiceHelper) {
        [self.webServiceHelper cancel];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"在线监控";
    
    UIBarButtonItem *backItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"返回"];
    UIButton *backButton = (UIButton*)backItem.customView;
    [backButton addTarget:self action:@selector(goBackAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.currentPage = 1;
    self.valueArray = [[NSMutableArray alloc]init];
    
    [self requestWebData];
}

-(void)requestWebData{
    self.isLoading = YES;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    
    [params setObject:ONE_PAGE_SIZE forKey:@"pageSize"];
    [params setObject:[NSString stringWithFormat:@"%d",self.currentPage] forKey:@"pageCurr"];
    
    if ([self.qymcTextField.text length]) {
        [params setObject:self.qymcTextField.text forKey:@"qymc"];
    }
    else{
        [params setObject:@"" forKey:@"qymc"];
    }
    if ([self.jgjbTextField.text isEqualToString:@"全部"]) {
        [params setObject:@"" forKey:@"jgjb"];
    }
    else if ([self.jgjbTextField.text length]) {
        [params setObject:self.jgjbTextField.text forKey:@"jgjb"];
    }
    else{
        [params setObject:@"" forKey:@"jgjb"];
    }
    
   NSString *paramsStr = [WebServiceHelper createParametersWithParams:params];
    self.webServiceHelper = [[WebServiceHelper alloc]initWithUrl:@"http://10.33.2.27/MobileLawService_OA/Services/TZxjkService.asmx" method:@"QueryZxjgList"  nameSpace:WEBSERVICE_NAMESPACE parameters:paramsStr delegate:self];
    [self.webServiceHelper runAndShowWaitingView:self.view withTipInfo:@"正在加载数据，请稍候..."];
}

#pragma mark - Network Request

-(void)processWebData:(NSData *)webData andTag:(NSInteger)tag{
    self.isLoading = NO;
    if ([webData length]<=0) {
        [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
    }
    if (tag == 1) {
        NSArray *array = [webData objectFromJSONData];
        RealTimeViewController *realTimeVC = [[RealTimeViewController alloc]init];
        realTimeVC.qyid = [[self.siteDic objectForKey:@"OBJECTID"] stringValue];
        realTimeVC.wrymc = [self.siteDic objectForKey:@"MC"];
        realTimeVC.siteArray = [NSArray arrayWithArray:array];
        [self.navigationController pushViewController:realTimeVC animated:YES];
    }
    else{
        NSDictionary *dataDic = [webData objectFromJSONData];
        if (dataDic && dataDic.count) {
            if (self.currentPage == 1) {
                [self.valueArray removeAllObjects];
            }
            self.totalRecord = [[dataDic objectForKey:@"total"] integerValue];
            if (self.totalRecord) {
                [self.valueArray addObjectsFromArray:[dataDic objectForKey:@"rows"]];
                [self.tableView reloadData];
            }
            else{
                [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
            }
        }
    }
}

-(void)processError:(NSError *)error{
    self.isLoading = NO;
    [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
}

#pragma mark - WordsDelegate

-(void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row{
    self.jgjbTextField.text = words;
    [self.poverController dismissPopoverAnimated:YES];
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.valueArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dataDic = [self.valueArray objectAtIndex:indexPath.row];
    NSString *value1 = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"MC"]];
    NSString *value2 = [NSString stringWithFormat:@"所属行业：%@",[dataDic objectForKey:@"HYLB"]];
    NSString *value3 = [NSString stringWithFormat:@"企业法人：%@",[dataDic objectForKey:@"FR"]];
    NSString *value4 = [NSString stringWithFormat:@"所在区域：%@",[dataDic objectForKey:@"SZQY"]];
    NSString *value5 = [NSString stringWithFormat:@"监管级别：%@",[dataDic objectForKey:@"GLJB"]];
    UITableViewCell *cell = [UITableViewCell makeSubCell:tableView withTitle:value1 andSubvalue1:value2 andSubvalue2:value3 andSubvalue3:value4 andSubvalue4:value5 andNoteCount:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 72.0f;
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
    tmpheaderView.text = [NSString stringWithFormat:@"  查询结果:%d条", self.valueArray.count];
    return tmpheaderView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.siteDic = [self.valueArray objectAtIndex:indexPath.row];
    NSString *qyid = [[self.siteDic objectForKey:@"OBJECTID"] stringValue];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:qyid forKey:@"id"];
    NSString *paramsStr = [WebServiceHelper createParametersWithParams:params];
    self.webServiceHelper = [[WebServiceHelper alloc]initWithUrl:@"http://10.33.2.27/MobileLawService_OA/Services/TZxjkService.asmx" method:@"GetZxjgPkList"  nameSpace:WEBSERVICE_NAMESPACE parameters:paramsStr delegate:self];
    [self.webServiceHelper runAndShowWaitingView:self.view withTipInfo:@"正在加载数据，请稍候..." andTag:1];
}

#pragma mark - UIScrollViewDelegate

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
        [self requestWebData];
    }
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setQymcTextField:nil];
    [self setJgjbTextField:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
