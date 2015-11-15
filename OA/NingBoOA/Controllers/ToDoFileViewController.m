//
//  ToDoFileViewController.m
//  NingBoOA
//
//  Created by ZHONGWEN on 13-9-15.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "ToDoFileViewController.h"
#import "PDJsonkit.h"
#import "UICustomButton.h"
#import "ZrsUtils.h"
#import "ServiceUrlString.h"
#import "SystemConfigContext.h"
#import "FileOutDetailViewController.h"
#import "FileInDetailViewController.h"
#import "SignDocDetailViewController.h"
#import "InnerFileDetailViewController.h"
#import "DeptFileDetailViewController.h"
#import "PublicOpinionDetailViewController.h"
#import "ApplicationDetailViewController.h"
#import "XJZXFileInDetailViewController.h"
#import "XJZXFileOutDetailViewController.h"
#import "XJZXSignDocDetailViewController.h"
#import "XJZXPMDetailViewController.h"
#import "JCZDFileInDetailViewController.h"
#import "JCZDFileOutDetailViewController.h"
#import "JCZDSignReportDetailViewController.h"
#import "ProjectBookDetailViewController.h"
#import "ProjectRunDetailViewController.h"
#import "ProjectCheckDetailViewController.h"
#import "CapitalViewController.h"
#import "ArticleViewController.h"
#import "ProjectBookDetailViewController.h"
#import "ProjectTableDetailViewController.h"
#import "ProjectRegistryDetailViewController.h"
#import "ApplicationDetailViewController.h"

@interface ToDoFileViewController ()
@property (nonatomic, strong) UIPopoverController *popController;
@end

@implementation ToDoFileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isRefresh = YES;
        self.start = 1;
        self.aryItems = [NSMutableArray arrayWithCapacity:10];
        self.requestType = @"handle";
        self.fileServiceName = @"ToDoOfficialBusiness";
        self.category = @"";
    }
    return self;
}

- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)requestWebData{
    NSDictionary *userInfo = [[SystemConfigContext sharedInstance] getUserInfo];
    NSString *user = [userInfo objectForKey:@"userId"];
    
    NSLog(@"user = %@",user);
    
    //初始化请求数据
    self.currentPage = 1;
    NSString *URL = [ServiceUrlString generateOAWebServiceUrl];
    NSString *params = [WebServiceHelper createParametersWithKey:@"Hy_userid" value:user, @"Hy_ts", ONE_PAGE_SIZE, @"Hy_start",[NSString stringWithFormat:@"%d",self.start], @"Hy_Type",self.requestType,@"Hy_LB",self.category,nil];
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:URL method:@"ToDoOfficialBusiness" nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
    [self.webServiceHelper runAndShowWaitingView:self.view  withTipInfo:@"正在加载待数据，请稍候..."];
    self.fileServiceName = @"ToDoOfficialBusiness";
    self.isLoading = YES;
}

#pragma mark -
#pragma mark CustomSegmentedControlDelegate
- (UIButton*) buttonFor:(CustomSegmentedControl*)segmentedControl atIndex:(NSUInteger)segmentIndex{
    CapLocation location;
    if (segmentIndex == 0)
        location = CapLeft;
    else
        location = CapRight;
    
    UIButton* button = [UICustomButton woodButtonWithText:[self.segmentControlTitles objectAtIndex:segmentIndex] stretch:location];
    if (segmentIndex == 0)
        button.selected = YES;
    return button;
}

- (void)touchDownAtSegmentIndex:(NSUInteger)segmentIndex
{
    
    if (segmentIndex == 0) {
        self.requestType = @"handle";
    }
    else {
        self.category    = @"";
        self.requestType = @"read";
    }
    self.start = 1;
    self.isRefresh = YES;
    [self requestWebData];
}

#pragma mark -
#pragma mark Handle Event
// -------------------------------------------------------------------------------
//	实现事件处托方法
//  响应返回按钮
// -------------------------------------------------------------------------------

- (void)goBackAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)docManagerList:(id)sender
{
    UIButton *button = (UIButton *)sender;
    FileManagerListController *fileManagerListController = [[FileManagerListController alloc] initWithStyle:UITableViewStylePlain];
    fileManagerListController.fileOutList = @[@"待办收文",@"待办发文",@"待办签报",@"待办内部文件",@"待办处室文件",@"待办舆情信息",@"待办依法申请公开"];
    fileManagerListController.delegate = self;
    fileManagerListController.fileType = self.requestType;
    UIPopoverController*popController = [[UIPopoverController alloc] initWithContentViewController:fileManagerListController];
    
    popController.popoverContentSize = CGSizeMake(240,308);
    
    self.popController = popController;
    
    NSLog(@"button = %f",button.bounds.size.width);
    NSLog(@"button = %f",button.bounds.size.height);

    
    [self.popController presentPopoverFromRect:button.bounds inView:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}

#pragma mark -
#pragma mark FileManager Delegate
- (void)returnSelectResult:(NSString *)type selected:(NSInteger)row
{
    self.start = 1;
    self.requestType = type;
    [self.popController dismissPopoverAnimated:YES];
    switch (row) {
        case 0:
            self.category = @"sw";
            self.categoryName = @"待办收文";
            break;
        case 1:
            self.category = @"fw";
            self.categoryName = @"待办发文";
            break;
        case 2:
            self.category = @"qb";
            self.categoryName = @"待办签报";
            break;
        case 3:
            self.category = @"in";
            self.categoryName = @"待办内部文件";
            break;
        case 4:
            self.category = @"cs";
            self.categoryName = @"待办处室文件";
            break;
        case 5:
            self.category = @"yq";
            self.categoryName = @"待办舆情";
            break;
        case 6:
            self.category = @"yfsq";
            self.categoryName = @"依法申请公文";
            break;
            
        default:
            self.category = @"";
            break;
    }
    if ([self.requestType isEqualToString:@"handle"]) {
        [self requestWebData];
    }
    
}


#pragma mark -
#pragma mark HandleGWDelegate
-(void)HandleGWResult:(BOOL)ret{
    self.requestType = @"handle";
    [self requestWebData];
    NSUserDefaults *preference = [NSUserDefaults standardUserDefaults];
    
    int todo = [[preference objectForKey:@"待办事宜"] intValue];
    todo--;
    [preference setObject:[NSString stringWithFormat:@"%d",todo] forKey:@"待办事宜"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBdages" object:nil];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *backItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"返回"];
    self.navigationItem.leftBarButtonItem = backItem;
    UIButton *backButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
    [backButton addTarget:self action:@selector(goBackAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *listItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"公文类别"];
    self.navigationItem.leftBarButtonItem = listItem;
    
    UIButton *listButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
    [listButton addTarget:self action:@selector(docManagerList:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem,listItem, nil];
    
    
    self.segmentControlTitles = @[@"待办件",@"待阅件"];
    UIImage* dividerImage = [UIImage imageNamed:@"view-control-divider.png"];
    self.navigationItem.titleView = [[CustomSegmentedControl alloc] initWithSegmentCount:self.segmentControlTitles.count segmentsize:CGSizeMake(100.0, dividerImage.size.height) dividerImage:dividerImage tag:0 delegate:self] ;
    
    [self requestWebData];
    [self setExtraCellLineHidden:self.listTableView];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UIScrollView Delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.isLoading) return;
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 850 ) {
        self.isLoading = YES;
        self.isRefresh = NO;
        [self requestWebData];
    }
}

#pragma mark -
#pragma mark tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.isEmpty) {
        return 1;
    }
    
    return [self.aryItems count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isEmpty) {
        return;
    }
    
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isEmpty) {
        return 60.0;
    }
    return 99.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectZero];
    headerView.font = [UIFont systemFontOfSize:17.0];
    headerView.backgroundColor = [UIColor colorWithRed:170.0/255 green:223.0/255 blue:234.0/255 alpha:1.0];
    headerView.textColor = [UIColor blackColor];
    
    
    return headerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    if (self.isEmpty) {
        static NSString *tipCell = @"Tip";
        
        cell = [tableView dequeueReusableCellWithIdentifier:tipCell];
        
        if (cell == nil) {
            NSArray *nibTableCells = [[NSBundle mainBundle] loadNibNamed:@"ToDoListCell" owner:nil options:nil];
            cell = [nibTableCells objectAtIndex:1];
        }
        
        UILabel *textlabel = (UILabel *)[cell viewWithTag:101];
        
        if ([self.requestType isEqualToString:@"handle"]) {
            if ([self.category isEqualToString:@""]) {
                textlabel.text = @"暂无新待办件!";
            }
            else {
                textlabel.text = [NSString stringWithFormat:@"暂无%@!",self.categoryName];
            }
        }
        else {
            textlabel.text = @"暂无新传阅件";
        }
        cell.userInteractionEnabled = NO;
    }
    else {
        
        NSInteger row = indexPath.row;
        
        NSDictionary *docDict =  [self.aryItems objectAtIndex:row];
        
        
        static NSString *cellIdentifer = @"Done";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
        if (!cell) {
            NSArray *nibTableCells = [[NSBundle mainBundle] loadNibNamed:@"ToDoListCell" owner:nil options:nil];
            cell = [nibTableCells objectAtIndex:0];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        UILabel *numberLabel = (UILabel *)[cell viewWithTag:101];
        numberLabel.text = [docDict objectForKey:@"xh"];
        
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:102];
        titleLabel.text = [docDict objectForKey:@"bt"];
        
        UILabel *typeLabel = (UILabel *)[cell viewWithTag:103];
        typeLabel.text = [docDict objectForKey:@"lb"];
        
        
        UILabel *dateLabel = (UILabel *)[cell viewWithTag:104];
        dateLabel.text = [docDict objectForKey:@"rq"];
        
        UILabel *senderLabel = (UILabel *)[cell viewWithTag:105];
        senderLabel.text = [docDict objectForKey:@"fsr"];
        
        UILabel *urgentLabel = (UILabel *)[cell viewWithTag:106];
        urgentLabel.text = [docDict objectForKey:@"hj"];
        
    }
    
    
    return cell;
}

#pragma mark -
#pragma mark tableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *docDict =  [self.aryItems objectAtIndex:indexPath.row];
    
    SystemConfigContext *context = [SystemConfigContext sharedInstance];
    NSDictionary *loginUsr = [context getUserInfo];
    NSString *user = [loginUsr objectForKey:@"userId"];
    NSString *docid = [docDict objectForKey:@"docid"];
    
    NSString *dqhj = [docDict objectForKey:@"dqhj"];
    NSString *year = [docDict objectForKey:@"year"];
    NSString *type = [docDict objectForKey:@"id"];
    
    self.docid  = docid;
    self.process = dqhj;
    
    if ([type isEqualToString:@"fwgl"]) {
        self.fileServiceName = @"GetFileOutDocumentInfo";
        
    }
    else if([type isEqualToString:@"swgl"]){
        self.fileServiceName = @"GetFileInDocumentInfo";
        
    }
    else if([type isEqualToString:@"qbgl"]){
        self.fileServiceName = @"GetSignReportDetail";
    }
    else if([type isEqualToString:@"nbwj"]){
        self.fileServiceName = @"GetFileInsideDetail";
    }
    else if([type isEqualToString:@"cswj"]){
        self.fileServiceName = @"GetFileDeptDetail";
        
    }
    else if([type isEqualToString:@"yqxx"]){
        self.fileServiceName = @"GetPublicOpinionDetail";
        
    }
    else if([type isEqualToString:@"yfsq"]) {
        self.fileServiceName = @"GetApplicationDetail";
        
    }
    else if([type isEqualToString:@"xjzxfwgl"]) {
        self.fileServiceName = @"XJZXPostDocumentInfo";
        
    }
    else if([type isEqualToString:@"xjzxswgl"]) {
        self.fileServiceName = @"XJZXReceiveDocumentInfo";
        
    }
    else if([type isEqualToString:@"xjzxqbgl"]) {
        self.fileServiceName = @"XJZXSignReportDetail";
        
    }
    else if([type isEqualToString:@"xjzxxmgl"]) {
        self.fileServiceName = @"XJZXPMDocumentInfo";
        
    }
    else if([type isEqualToString:@"jczdfwgl"]) {
        self.fileServiceName = @"JCZDPostDocumentInfo";
    }
    else if([type isEqualToString:@"jczdswgl"]) {
        self.fileServiceName = @"JCZDReceiveDocumentInfo";
    }
    else if([type isEqualToString:@"jczdqbgl"]) {
        self.fileServiceName = @"JCZDSignReportDetail";
    }
    else if([type isEqualToString:@"xmspbgs"]) {
        self.fileServiceName = @"reportBookInfo";
    }
    else if([type isEqualToString:@"syxgl"]) {
        self.fileServiceName = @"testRunInfo";
    }
    else if([type isEqualToString:@"jgys"]) {
        self.fileServiceName = @"checkAcceptInfo";
    }
    else if ([type isEqualToString:@"zjsq"]){
        self.fileServiceName = @"GetApplicationFundsDocumentInfo";
    }
    else if ([type isEqualToString:@"wpcg"]){
        self.fileServiceName = @"GetProcurementDocumentInfo";
    }
    else if ([type isEqualToString:@"xmspbgs"]){
        self.fileServiceName = @"reportBookInfo";
    }
    else if ([type isEqualToString:@"xmspbgb"]){
        self.fileServiceName = @"reportTableInfo";
    }
    else if ([type isEqualToString:@"xmspbjb"]){
        self.fileServiceName = @"registryInfo";
    }
    else if ([type isEqualToString:@"ysqgk"]){
        self.fileServiceName = @"GETAPPLICATIONDETAIL";
    }
    else{
        return;
    }
    
    NSString *strUrl= [ServiceUrlString generateOAWebServiceUrl];
    NSString *params = @"";
    if ([type isEqualToString:@"zjsq"] || [type isEqualToString:@"wpcg"]) {
        params = [WebServiceHelper createParametersWithKey:@"Hy_docid" value:docid, @"Hy_userid",user,nil];
    }
    else{
        params = [WebServiceHelper createParametersWithKey:@"Hy_docid" value:docid, @"Hy_userid",user,@"Hy_year",year,nil];
    }
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl
                                                           method:self.fileServiceName
                                                        nameSpace:WEBSERVICE_NAMESPACE
                                                       parameters:params
                                                         delegate:self];
    [self.webServiceHelper runAndShowWaitingView:self.view withTipInfo:@"正在载入详情，请稍候..."];
    
}

- (void)loadDocumentDetailViewWithCompetence:(NSString *)status {
    if ([self.fileServiceName isEqualToString:@"GetFileOutDocumentInfo"])
    {
        
        FileOutDetailViewController *detailViewController = [[FileOutDetailViewController alloc] initWithNibName:@"FileOutDetailViewController" bundle:nil];
        detailViewController.docid = self.docid;
        detailViewController.process = self.process;
        detailViewController.infoDict = self.infoDict;
        detailViewController.delegate = self;
        detailViewController.responder = self;
        detailViewController.competence = status;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    else if([self.fileServiceName isEqualToString:@"GetFileInDocumentInfo"])
    {
        FileInDetailViewController *detailViewController = [[FileInDetailViewController alloc] initWithNibName:@"FileInDetailViewController" bundle:nil];
        detailViewController.docid = self.docid;
        detailViewController.process = self.process;
        detailViewController.infoDict = self.infoDict;
        detailViewController.delegate = self;
        detailViewController.responder = self;
        detailViewController.competence = status;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    else if([self.fileServiceName isEqualToString:@"GetSignReportDetail"])
    {
        SignDocDetailViewController *detailViewController = [[SignDocDetailViewController alloc] initWithNibName:@"SignDocDetailViewController" bundle:nil];
        detailViewController.docid = self.docid;
        detailViewController.process = self.process;
        detailViewController.infoDict = self.infoDict;
        detailViewController.delegate = self;
        detailViewController.responder = self;
        detailViewController.competence = status;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    else if([self.fileServiceName isEqualToString:@"GetFileInsideDetail"])
    {
        InnerFileDetailViewController *detailViewController = [[InnerFileDetailViewController alloc] initWithNibName:@"InnerFileDetailViewController" bundle:nil];
        detailViewController.docid = self.docid;
        detailViewController.process = self.process;
        detailViewController.infoDict = self.infoDict;
        detailViewController.delegate = self;
        detailViewController.responder = self;
        detailViewController.competence = status;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    
    else if([self.fileServiceName isEqualToString:@"GetFileDeptDetail"])
    {
        DeptFileDetailViewController *detailViewController = [[DeptFileDetailViewController alloc] initWithNibName:@"DeptFileDetailViewController" bundle:nil];
        detailViewController.docid = self.docid;
        detailViewController.process = self.process;
        detailViewController.infoDict = self.infoDict;
        detailViewController.delegate = self;
        detailViewController.responder = self;
        detailViewController.competence = status;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    else if([self.fileServiceName isEqualToString:@"GetPublicOpinionDetail"])
    {
        PublicOpinionDetailViewController *detailViewController = [[PublicOpinionDetailViewController alloc] initWithNibName:@"PublicOpinionDetailViewController" bundle:nil];
        detailViewController.docid = self.docid;
        detailViewController.process = self.process;
        detailViewController.infoDict = self.infoDict;
        detailViewController.delegate = self;
        detailViewController.responder = self;
        detailViewController.competence = status;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    else if([self.fileServiceName isEqualToString:@"GetApplicationDetail"])
    {
        ApplicationDetailViewController *detailViewController = [[ApplicationDetailViewController alloc] initWithNibName:@"ApplicationDetailViewController" bundle:nil];
        detailViewController.docid = self.docid;
        detailViewController.process = self.process;
        detailViewController.infoDict = self.infoDict;
        detailViewController.delegate = self;
        detailViewController.responder = self;
        detailViewController.competence = status;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    
    else if([self.fileServiceName isEqualToString:@"XJZXPostDocumentInfo"]){
        XJZXFileInDetailViewController *detailViewController = [[XJZXFileInDetailViewController alloc] initWithNibName:@"XJZXFileInDetailViewController" bundle:nil];
        detailViewController.docid = self.docid;
        detailViewController.process = self.process;
        detailViewController.infoDict = self.infoDict;
        detailViewController.delegate = self;
        detailViewController.responder = self;
        detailViewController.competence = status;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    
    else if([self.fileServiceName isEqualToString:@"XJZXReceiveDocumentInfo"]){
        XJZXFileOutDetailViewController *detailViewController = [[XJZXFileOutDetailViewController alloc] initWithNibName:@"XJZXFileOutDetailViewController" bundle:nil];
        detailViewController.docid = self.docid;
        detailViewController.process = self.process;
        detailViewController.infoDict = self.infoDict;
        detailViewController.delegate = self;
        detailViewController.responder = self;
        detailViewController.competence = status;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    
    else if([self.fileServiceName isEqualToString:@"XJZXSignReportDetail"]){
        XJZXSignDocDetailViewController *detailViewController = [[XJZXSignDocDetailViewController alloc] initWithNibName:@"XJZXSignDocDetailViewController" bundle:nil];
        detailViewController.docid = self.docid;
        detailViewController.process = self.process;
        detailViewController.infoDict = self.infoDict;
        detailViewController.delegate = self;
        detailViewController.responder = self;
        detailViewController.competence = status;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    
    else if([self.fileServiceName isEqualToString:@"XJZXPMDocumentInfo"]){
        XJZXPMDetailViewController *detailViewController = [[XJZXPMDetailViewController alloc] initWithNibName:@"XJZXPMDetailViewController" bundle:nil];
        detailViewController.docid = self.docid;
        detailViewController.process = self.process;
        detailViewController.infoDict = self.infoDict;
        detailViewController.delegate = self;
        detailViewController.responder = self;
        detailViewController.competence = status;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    
    else if([self.fileServiceName isEqualToString:@"JCZDPostDocumentInfo"]) {
        JCZDFileOutDetailViewController *detailViewController = [[JCZDFileOutDetailViewController alloc] initWithNibName:@"JCZDFileOutDetailViewController" bundle:nil];
        detailViewController.docid = self.docid;
        detailViewController.process = self.process;
        detailViewController.infoDict = self.infoDict;
        detailViewController.delegate = self;
        detailViewController.responder = self;
        detailViewController.competence = status;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    
    else if([self.fileServiceName isEqualToString:@"JCZDReceiveDocumentInfo"]) {
        JCZDFileInDetailViewController *detailViewController = [[JCZDFileInDetailViewController alloc] initWithNibName:@"JCZDFileInDetailViewController" bundle:nil];
        detailViewController.docid = self.docid;
        detailViewController.process = self.process;
        detailViewController.infoDict = self.infoDict;
        detailViewController.delegate = self;
        detailViewController.responder = self;
        detailViewController.competence = status;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    
    else if([self.fileServiceName isEqualToString:@"JCZDSignReportDetail"]) {
        JCZDSignReportDetailViewController *detailViewController = [[JCZDSignReportDetailViewController alloc] initWithNibName:@"JCZDSignReportDetailViewController" bundle:nil];
        detailViewController.docid = self.docid;
        detailViewController.process = self.process;
        detailViewController.infoDict = self.infoDict;
        detailViewController.delegate = self;
        detailViewController.responder = self;
        detailViewController.competence = status;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    else if([self.fileServiceName isEqualToString:@"reportBookInfo"]) {
        ProjectBookDetailViewController *detailViewController = [[ProjectBookDetailViewController alloc] initWithNibName:@"ProjectBookDetailViewController" bundle:nil];
        detailViewController.docid = self.docid;
        detailViewController.process = self.process;
        detailViewController.infoDict = self.infoDict;
        detailViewController.delegate = self;
        detailViewController.responder = self;
        detailViewController.competence = status;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    else if([self.fileServiceName isEqualToString:@"testRunInfo"]) {
        ProjectRunDetailViewController *detailViewController = [[ProjectRunDetailViewController alloc] initWithNibName:@"ProjectRunDetailViewController" bundle:nil];
        detailViewController.docid = self.docid;
        detailViewController.process = self.process;
        detailViewController.infoDict = self.infoDict;
        detailViewController.delegate = self;
        detailViewController.responder = self;
        detailViewController.competence = status;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    else if([self.fileServiceName isEqualToString:@"checkAcceptInfo"]) {
        ProjectCheckDetailViewController *detailViewController = [[ProjectCheckDetailViewController alloc] initWithNibName:@"ProjectCheckDetailViewController" bundle:nil];
        detailViewController.docid = self.docid;
        detailViewController.process = self.process;
        detailViewController.infoDict = self.infoDict;
        detailViewController.delegate = self;
        detailViewController.responder = self;
        detailViewController.competence = status;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    else if ([self.fileServiceName isEqualToString:@"GetApplicationFundsDocumentInfo"]){
        CapitalViewController *capitalViewController = [[CapitalViewController alloc]initWithNibName:@"CapitalViewController" bundle:nil];
        capitalViewController.delegate = self;
        capitalViewController.infoDict = self.infoDict;
        [self.navigationController pushViewController:capitalViewController animated:YES];
    }
    else if ([self.fileServiceName isEqualToString:@"GetProcurementDocumentInfo"]){
        ArticleViewController *articleViewController = [[ArticleViewController alloc]initWithNibName:@"ArticleViewController" bundle:nil];
        articleViewController.delegate = self;
        articleViewController.infoDict = self.infoDict;
        [self.navigationController pushViewController:articleViewController animated:YES];
    }
    else if ([self.fileServiceName  isEqualToString:@"reportBookInfo"]){
        ProjectBookDetailViewController *articleViewController = [[ProjectBookDetailViewController alloc]initWithNibName:@"ProjectBookDetailViewController" bundle:nil];
        articleViewController.delegate = self;
        articleViewController.infoDict = self.infoDict;
        [self.navigationController pushViewController:articleViewController animated:YES];
    }
    else if ([self.fileServiceName  isEqualToString:@"reportTableInfo"]){
        ProjectTableDetailViewController *articleViewController = [[ProjectTableDetailViewController alloc]initWithNibName:@"ProjectTableDetailViewController" bundle:nil];
        articleViewController.delegate = self;
        articleViewController.infoDict = self.infoDict;
        [self.navigationController pushViewController:articleViewController animated:YES];
    }
    else if ([self.fileServiceName  isEqualToString:@"registryInfo"]){
        ProjectRegistryDetailViewController *articleViewController = [[ProjectRegistryDetailViewController alloc]initWithNibName:@"ProjectRegistryDetailViewController" bundle:nil];
        articleViewController.delegate = self;
        articleViewController.infoDict = self.infoDict;
        [self.navigationController pushViewController:articleViewController animated:YES];
    }
    else if ([self.fileServiceName  isEqualToString:@"GETAPPLICATIONDETAIL"]){
        ApplicationDetailViewController *articleViewController = [[ApplicationDetailViewController alloc]initWithNibName:@"ApplicationDetailViewController" bundle:nil];
        articleViewController.delegate = self;
        articleViewController.infoDict = self.infoDict;
        [self.navigationController pushViewController:articleViewController animated:YES];
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
    NSString *method = [NSString stringWithFormat:@"%@Return",self.fileServiceName];
    
    WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:method  andWithJSONDelegate:self];
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
    self.isLoading = NO;
    NSDictionary *tmpParsedJsonDict = [jsonStr objectFromJSONString];
    BOOL bParseError = NO;
    if (tmpParsedJsonDict && jsonStr.length > 0)
    {
        if([self.fileServiceName isEqualToString:@"ToDoOfficialBusiness"])
        {
            NSString *status = [tmpParsedJsonDict objectForKey:@"status"];
            if ([status isEqualToString:@"1"]) {
                NSString *reason = [tmpParsedJsonDict objectForKey:@"reason"];
                [self showAlertMessage:reason];
                return;
            }
            
            NSArray *tmpAry = [tmpParsedJsonDict objectForKey:@"listinfo"];
            if([tmpAry count] > 0){
                self.isEmpty = NO;
                self.start = [tmpAry count] +self.start;
                if (self.isRefresh) {
                    [self.aryItems removeAllObjects];
                    [self.aryItems addObjectsFromArray:tmpAry];
                }
                else {
                    [self.aryItems addObjectsFromArray:tmpAry];
                }
            }
            
            else if(self.isRefresh){
                self.isEmpty = YES;
            }
            else {
                [self showAlertMessage:@"已经显示最后一条数据!"];
            }
            
        }
        else {
            self.infoDict = [tmpParsedJsonDict objectForKey:@"postDocInfo"];
            NSString *status = [self.infoDict objectForKey:@"competence"];
            [self loadDocumentDetailViewWithCompetence:status];
        }
    }
    
    else
    {
        bParseError = YES;
    }
    
    if (bParseError)
    {
        [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
    }
    
    [self.listTableView reloadData];
}

// -------------------------------------------------------------------------------
//	实现WebDataParserDelegate委托方法
//  解析json字符串发生错误
// -------------------------------------------------------------------------------

- (void)parseWithError:(NSString *)errorString
{
    self.isLoading = NO;
    [self showAlertMessage:errorString];
}

@end
