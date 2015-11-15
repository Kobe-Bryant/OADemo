//
//  SQSearchViewController.m
//  NingBoOA
//
//  Created by PowerData on 14-3-10.
//  Copyright (c) 2014年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "SQSearchViewController.h"
#import "UICustomButton.h"
#import "CustomSegmentedControl.h"
#import "PopupDateViewController.h"
#import "CommenWordsViewController.h"
#import "WebDataParserHelper.h"
#import "SystemConfigContext.h"
#import "ServiceUrlString.h"
#import "SQListCell.h"
#import "JSONKit.h"
#import "CapitalViewController.h"
#import "ArticleViewController.h"

#define kDetailsService_Tag 1

@interface SQSearchViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,CustomSegmentedControlDelegate,PopupDateDelegate,WordsDelegate,WebDataParserDelegate>
@property (nonatomic,strong) NSArray *segmentControlTitles;
@property (nonatomic,strong) UIPopoverController *poverController;
@property (nonatomic,strong) UIBarButtonItem *searchItem;
@property (nonatomic,strong) UIBarButtonItem *closeItem;
@property (nonatomic,strong) NSMutableArray *valueArray;
@property (nonatomic,copy) NSString *method;
@property (nonatomic,copy) NSString *dqhj;
@property (nonatomic,assign) BOOL isSearch;
@property (nonatomic,assign) NSInteger saveCtrl;
@property (nonatomic,assign) NSInteger saveTag;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) NSInteger start;
@property (nonatomic,assign) BOOL isLoading;
@property (nonatomic,assign) BOOL isEnd;
@end

@implementation SQSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)goBackAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)closeButtonPress:(UIButton *)sender{
    self.isEnd = NO;
    self.isSearch = NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    self.tableView.frame = CGRectMake(20, 27, 728, 918);
    [UIView commitAnimations];
    self.navigationItem.rightBarButtonItem = self.searchItem;
}

-(void)barSearchButtonPress:(UIButton *)sender{
    self.isSearch = YES;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    self.tableView.frame = CGRectMake(20, 183, 728, 762);
    [UIView commitAnimations];
    self.navigationItem.rightBarButtonItem = self.closeItem;
}
- (IBAction)searchButtonPress:(UIButton *)sender {
    self.start = 1;
    self.currentPage = 1;
    [self requestWebData];
}

-(void)requestWebData{
    NSDictionary *userInfo = [[SystemConfigContext sharedInstance] getUserInfo];
    NSString *user = [userInfo objectForKey:@"userId"];
    
    //初始化请求数据
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:user forKey:@"Hy_userid"];
    [params setObject:[NSString stringWithFormat:ONE_PAGE_SIZE] forKey:@"Hy_ts"];
    [params setObject:[NSString stringWithFormat:@"%d",self.start] forKey:@"Hy_start"];
    
    if (self.isSearch) {
        if (self.saveCtrl == 0) {
            self.method = @"ApplicationFundsInquiryDocument";
        }
        else{
            self.method = @"ProcurementInquiryDocument";
        }
        [params setObject:self.sqrTextField.text forKey:@"Hy_sqr"];
    
        [params setObject:self.sqbmTextField.text forKey:@"Hy_sqbm"];

        [params setObject:self.sqrqTextField.text forKey:@"Hy_qssj"];
    
        [params setObject:self.jzrqTextField.text forKey:@"Hy_jzsj"];
    
        if (self.saveCtrl == 0) {
            [params setObject:self.ytTextField.text forKey:@"Hy_yt"];
        }
        else{
            [params setObject:self.ytTextField.text forKey:@"Hy_wplb"];
        }
    }
    else{
        if (self.saveCtrl == 0) {
             self.method = @"ApplicationFundsListDocument";
        }
        else{
             self.method = @"ProcurementListDocument";
        }
    }
    
    NSString *paramStr = [WebServiceHelper createParametersWithParams:params];
    NSString *URL = [ServiceUrlString generateOAWebServiceUrl];
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:URL method:self.method nameSpace:WEBSERVICE_NAMESPACE  parameters:paramStr delegate:self];
    [self.webServiceHelper runAndShowWaitingView:self.view  withTipInfo:@"正在加载待数据，请稍候..."];
    self.isLoading = YES;

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
    self.title = @"资金申请";
    UIBarButtonItem *backItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"返回"];
    UIButton *backButton = (UIButton*)backItem.customView;
    [backButton addTarget:self action:@selector(goBackAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.searchItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"查询"];
    UIButton *searchButton = (UIButton *)self.searchItem.customView;
    [searchButton addTarget:self action:@selector(barSearchButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    
    self.closeItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"关闭"];
    UIButton *closeButton = (UIButton *)self.closeItem.customView;
    [closeButton addTarget:self action:@selector(closeButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = self.searchItem;
    
    self.segmentControlTitles = @[@"资金申请",@"物品采购"];
    UIImage* dividerImage = [UIImage imageNamed:@"view-control-divider.png"];
    self.navigationItem.titleView = [[CustomSegmentedControl alloc] initWithSegmentCount:self.segmentControlTitles.count segmentsize:CGSizeMake(100.0, dividerImage.size.height) dividerImage:dividerImage tag:0 delegate:self];
    
    self.valueArray = [[NSMutableArray alloc]init];
    
    NSDateFormatter *matter = [[NSDateFormatter alloc]init];
    [matter setDateFormat:@"yyyy-MM-dd"];
    self.sqrqTextField.text = [matter stringFromDate:[NSDate dateWithTimeInterval:-60*60*24*30 sinceDate:[NSDate date]]];
    self.jzrqTextField.text = [matter stringFromDate:[NSDate date]];
    
    self.start = 1;
    self.currentPage = 1;
    [self requestWebData];
}

#pragma mark - CustomSegmentedControlDelegate

-(UIButton *)buttonFor:(CustomSegmentedControl *)segmentedControl atIndex:(NSUInteger)segmentIndex{
    CapLocation location;
    if (segmentIndex == 0) {
        location = CapLeft;
    }
    else{
        location = CapRight;
    }
    UIButton *button = [UICustomButton woodButtonWithText:[self.segmentControlTitles objectAtIndex:segmentIndex] stretch:location];
    if (segmentIndex == 0) {
        button.selected = YES;
    }
    return button;
}

#pragma mark - WordsDelegate

-(void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row{
    self.ytTextField.text = words;
    [self.poverController dismissPopoverAnimated:YES];
}

-(void)touchUpInsideSegmentIndex:(NSUInteger)segmentIndex{
    if (segmentIndex == 0) {
        self.saveCtrl = 0;
        self.ytLabel.text = @"用       途：";
        self.ytTextField.placeholder = @"请输入用途";
        self.ytTextField.delegate = nil;
        [self.ytTextField removeTarget:self action:@selector(textFieldTouchDonw:) forControlEvents:UIControlEventTouchDown];
    }
    else{
        self.saveCtrl = 1;
        self.method = @"ProcurementListDocument";
        self.ytLabel.text = @"物品类别：";
        self.ytTextField.placeholder = @"请选择物品类别";
        self.ytTextField.delegate = self;
        [self.ytTextField addTarget:self action:@selector(textFieldTouchDonw:) forControlEvents:UIControlEventTouchDown];
    }
    self.ytTextField.text = @"";
    [self.sqrTextField resignFirstResponder];
    [self.sqbmTextField resignFirstResponder];
    [self.ytTextField resignFirstResponder];
    
    self.start = 1;
    self.isEnd = NO;
    self.currentPage = 1;
    
    if (!self.isSearch) {
        [self requestWebData];
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.isLoading) return;
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 850 ) {
        if (self.isEnd == NO || self.start == 1) {
            [self requestWebData];
        }
        else{
            return;
        }
    }
}

#pragma mark - WebRequestDelegate

-(void)processWebData:(NSData *)webData andTag:(NSInteger)tag{
    self.isLoading = NO;
    if ([webData length] <=0) {
        [self showAlertMessage:NETWORK_DATA_ERROR_MESSAGE];
    }
    NSString *documentReturn = nil;
    if (tag == kDetailsService_Tag) {
        if (self.saveCtrl == 0) {
            documentReturn = @"GetApplicationFundsDocumentInfoReturn";
        }
        else{
            documentReturn = @"GetProcurementDocumentInfoReturn";
        }
    }
    else{
        if (self.isSearch) {
            if (self.saveCtrl == 0) {
                documentReturn = @"ApplicationFundsInquiryDocumentReturn";
            }
            else{
                documentReturn = @"ProcurementInquiryDocumentReturn";
            }
        }
        else{
            if (self.saveCtrl == 0) {
                documentReturn = @"ApplicationFundsListDocumentReturn";
            }
            else{
                documentReturn = @"ProcurementListDocumentReturn";
            }
        }
    }
    WebDataParserHelper *parser = [[WebDataParserHelper alloc]initWithFieldName:documentReturn andWithJSONDelegate:self andTag:tag];
    [parser parseXMLData:webData];
}

-(void)processError:(NSError *)error{
    self.isLoading = NO;
    [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
}

#pragma mark - WebDataParserDelegate

-(void)parseJSONString:(NSString *)jsonStr andTag:(NSInteger)tag{
    if (tag == kDetailsService_Tag) {
        NSDictionary *dataDic = [jsonStr objectFromJSONString];
        if (dataDic &&dataDic.count) {
            if (self.saveCtrl == 0) {
                CapitalViewController *capital = [[CapitalViewController alloc]initWithNibName:@"CapitalViewController" bundle:nil];
                capital.title = self.dqhj;
                capital.delegate = self;
                capital.infoDict = [dataDic objectForKey:@"postDocInfo"];
                [self.navigationController pushViewController:capital animated:YES];
            }
            else{
                ArticleViewController *article = [[ArticleViewController alloc]initWithNibName:@"ArticleViewController" bundle:nil];
                article.title = self.dqhj;
                article.delegate = self;
                article.infoDict = [dataDic objectForKey:@"postDocInfo"];
                [self.navigationController pushViewController:article animated:YES];
            }
        }
        else{
            [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
        }
    }
    else{
        NSArray *array = [[jsonStr objectFromJSONString] objectForKey:@"listinfo"];
        if (self.start == 1) {
            [self.valueArray removeAllObjects];
        }
        if (array && array.count) {
            if (array.count < [ONE_PAGE_SIZE intValue]) {
                self.isEnd = YES;
            }
            self.start += array.count;
            [self.valueArray addObjectsFromArray:array];
        }
        else{
            [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
        }
        [self.tableView reloadData];
    }
}

#pragma mark - UITextFirldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}

- (IBAction)textFieldTouchDonw:(UITextField *)sender {
    if (sender.tag) {
        self.saveTag = sender.tag;
        PopupDateViewController *dateViewController = [[PopupDateViewController alloc]initWithPickerMode:UIDatePickerModeDate];
        dateViewController.delegate = self;
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:dateViewController];
        self.poverController = [[UIPopoverController alloc]initWithContentViewController:navController];
        [self.poverController presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
    else{
        CommenWordsViewController *wordsViewController = [[CommenWordsViewController alloc]initWithStyle:UITableViewStylePlain];
        wordsViewController.delegate = self;
        wordsViewController.wordsAry = @[@"文印耗材",@"办公用品",@"计算机耗材"];
        wordsViewController.contentSizeForViewInPopover = CGSizeMake(200, 250);
        self.poverController = [[UIPopoverController alloc]initWithContentViewController:wordsViewController];
        [self.poverController presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
}

#pragma mark - PopupDateViewControllerDelegate

-(void)PopupDateController:(PopupDateViewController *)controller Saved:(BOOL)bSaved selectedDate:(NSDate *)date{
    if (bSaved) {
        if (self.saveTag == 1)
        {
            NSDateFormatter *matter = [[NSDateFormatter alloc]init];
            [matter setDateFormat:@"yyyy-MM-dd"];
            NSString *dateString = [matter stringFromDate:date];
            NSDate *jzsjDate = [matter dateFromString:self.jzrqTextField.text];
            NSTimeInterval qssj = [date timeIntervalSince1970];
            NSTimeInterval jzsj = [jzsjDate timeIntervalSince1970];
            if (jzsj>qssj || ![self.jzrqTextField.text length]) {
                self.sqrqTextField.text = dateString;
            }
            else{
                [self showAlertMessage:@"起始时间不能晚于截止时间"];
            }
        }
        else
        {
            NSDateFormatter *matter = [[NSDateFormatter alloc]init];
            [matter setDateFormat:@"yyyy-MM-dd"];
            NSString *dateString = [matter stringFromDate:date];
            NSDate *qssjDate = [matter dateFromString:self.sqrqTextField.text];
            NSTimeInterval jzsj = [date timeIntervalSince1970];
            NSTimeInterval qssj = [qssjDate timeIntervalSince1970];
            if (jzsj>qssj || ![self.sqrqTextField.text length]) {
                self.jzrqTextField.text = dateString;
            }
            else{
                [self showAlertMessage:@"截止时间不能早于起始时间"];
            }
        }
    }
    [self.poverController dismissPopoverAnimated:YES];
}

#pragma mark - UItableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.valueArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *Identifier = @"Cell";
    SQListCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[SQListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    NSDictionary *dic = [self.valueArray objectAtIndex:indexPath.row];
    NSString *title = @"";
    NSString *value3 = @"";
    NSString *value4 = @"";
    if (self.saveCtrl == 0) {
        title = [NSString stringWithFormat:@"%@",[dic objectForKey:@"yt"]];
        value3 = [NSString stringWithFormat:@"金额：%@",[dic objectForKey:@"je"]];
        value4 = [NSString stringWithFormat:@"科目：%@",[dic objectForKey:@"km"]];
        
    }
    else{
        title = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cgnr"]];
        value3 = [NSString stringWithFormat:@"型号：%@",[dic objectForKey:@"xh"]];
        value4 = [NSString stringWithFormat:@"资金来源：%@",[dic objectForKey:@"zjly"]];
    }
    NSString *dqclr = [dic objectForKey:@"dqclr"];
    NSString *dqhj = [dic objectForKey:@"dqhj"];
    NSString *sqr = [dic objectForKey:@"sqr"];
    NSString *sqrq = [dic objectForKey:@"sqrq"];
    if (dqclr == nil ) {
        dqclr = @"";
    }
    if (dqhj == nil ) {
        dqhj = @"";
    }
    if (sqr == nil ) {
        sqr = @"";
    }
    if (sqrq == nil ) {
        sqrq = @"";
    }
    NSString *value1 = [NSString stringWithFormat:@"申请人：%@",sqr];
    NSString *value2 = [NSString stringWithFormat:@"申请日期：%@",sqrq];
    NSString *value5 = [NSString stringWithFormat:@"处理人：%@",dqclr];
    NSString *value6 = [NSString stringWithFormat:@"当前环节：%@",dqhj];
    
    cell.labelID.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
    cell.labelTitle.text = title;
    cell.labelValue1.text = value1;
    cell.labelValue2.text = value2;
    cell.labelValue3.text = value3;
    cell.labelValue4.text = value4;
    cell.labelValue5.text = value5;
    cell.labelValue6.text = value6;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
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

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row%2 == 0) {
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dataDic = [self.valueArray objectAtIndex:indexPath.row];
    NSString *docid = [dataDic objectForKey:@"docid"];
    SystemConfigContext *context = [SystemConfigContext sharedInstance];
    NSDictionary *loginUsr = [context getUserInfo];
    NSString *user = [loginUsr objectForKey:@"userId"];
    self.dqhj = [dataDic objectForKey:@"dqhj"];
    
    NSString *details = @"";
    if (self.saveCtrl == 0) {
        details = @"GetApplicationFundsDocumentInfo";
    }
    else{
        details = @"GetProcurementDocumentInfo";
    }
    
    NSString *strUrl= [ServiceUrlString generateOAWebServiceUrl];
    NSString *params = [WebServiceHelper createParametersWithKey:@"Hy_docid" value:docid, @"Hy_userid",user,nil];
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:details nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
    [self.webServiceHelper runAndShowWaitingView:self.view withTipInfo:@"正在载入详情..." andTag:kDetailsService_Tag];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setSqrTextField:nil];
    [self setSqbmTextField:nil];
    [self setSqrqTextField:nil];
    [self setJzrqTextField:nil];
    [self setYtTextField:nil];
    [self setSearchButton:nil];
    [self setTableView:nil];
    [self setYtLabel:nil];
    [super viewDidUnload];
}
@end
