//
//  ContinuteProcessViewController.m
//  NingBoOA
//
//  Created by PowerData on 13-10-14.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "ContinueProcessViewController.h"
#import "UICustomButton.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "DeSelectBtn.h"
#import "StepUserItem.h"
#import "SystemConfigContext.h"

#define kService_NextStep_Tag 0
#define kService_PersonList_tag 1
#define kService_Continue_tag 2

@interface ContinueProcessViewController ()
@property (strong, nonatomic) NSMutableArray *arySectionIsOpen;
@property (strong, nonatomic) UIPopoverController *popController;
@end

@implementation ContinueProcessViewController

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
    self.title =@"流程处理选项";
    
    self.selectHandler = [NSMutableArray arrayWithCapacity:5];//下一环节处理人员
    self.selectReader  = [NSMutableArray arrayWithCapacity:5];//下一环节传阅人员
    
    //返回按钮
    UIBarButtonItem *backItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"返回"];
    self.navigationItem.leftBarButtonItem = backItem;
    UIButton *backButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
    [backButton addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    //确定
    UIBarButtonItem *doneItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"确定"];
    self.navigationItem.rightBarButtonItem = doneItem;
    UIButton *doneButton = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
    [doneButton addTarget:self action:@selector(btnTransferPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //当前环节名称
    self.currentProcess.text = self.currentProcessName;
    
    NSDictionary *userInfo = [[SystemConfigContext sharedInstance] getUserInfo];
    
    NSString  *deptid= [userInfo objectForKey:@"deptid"];
    NSString  *docid = [self.parameterDictionary objectForKey:@"Hy_docid"];
    NSString  *modid = [self.parameterDictionary objectForKey:@"Hy_mdid"];
    
    //请求下一流程数据
    NSString *strUrl = [ServiceUrlString generateOAWebServiceUrl];
    NSString *params = [WebServiceHelper createParametersWithKey:@"Hy_mdid" value:modid, @"docid", docid, @"Hy_deptid", deptid, nil];
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:@"getnextclry" nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
    [self.webServiceHelper runAndShowWaitingView:self.view andTag:kService_NextStep_Tag];
    
    //获取用户列表数据
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"contacts.plist"];
    self.deptList = [NSArray arrayWithContentsOfFile:filePath];
    
    NSInteger count = [self.deptList count];
    if(count > 0)
    {
        self.arySectionIsOpen = [NSMutableArray arrayWithCapacity:count];
        for (NSInteger i = 0; i < count; i++)
        {
            [self.arySectionIsOpen addObject:[NSNumber numberWithBool:NO]];
        }
    }
    [self.nextProcessTxt addTarget:self action:@selector(beginEditing:) forControlEvents:UIControlEventTouchDown];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (!self.deptList)
    {
        NSString *strURL = [ServiceUrlString generateOAWebServiceUrl];
        NSString *params = nil;
        self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strURL method:@"returnPersonList" nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
        [self.webServiceHelper runAndShowWaitingView:self.view andTag:1];
    }
    
}

#pragma mark - 
#pragma mark tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1)
    {
        if(section < [self.arySectionIsOpen count])
        {
            BOOL opened = [[self.arySectionIsOpen objectAtIndex:section] boolValue];
            if(opened == NO) return 0;
        }
        NSDictionary *bmDict =[self.deptList objectAtIndex:section];
        NSArray *userAry = [bmDict objectForKey:@"users"];
        return [userAry count];
    }
    NSString *nameStr = [self.processHandler objectForKey:@"name"];
    NSArray  *nameAry = [nameStr componentsSeparatedByString:@","];
    return [nameAry count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == 1)
    {
        return [self.deptList count];
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView.tag == 1)
    {
        return 36.0;
    }
    return 30.0;
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == 1)
    {
        CGFloat headerHeight = 36.0;
        NSDictionary *bmDict =[self.deptList objectAtIndex:section];
        NSString *bmMC = [bmDict objectForKey:@"BMMC"];
        BOOL opened = NO;
        if(section < [self.arySectionIsOpen count])
        {
            opened = [[self.arySectionIsOpen objectAtIndex:section] boolValue];
        }
        QQSectionHeaderView *sectionHeadView = [[QQSectionHeaderView alloc]
                                                initWithFrame:CGRectMake(0.0, 0.0, self.readerTableView.bounds.size.width, headerHeight)
                                                title:bmMC
                                                section:section
                                                opened:opened
                                                delegate:self];
        return sectionHeadView;
        
    }
    
    UILabel *tmpheaderView = [[UILabel alloc] initWithFrame:CGRectZero];
    tmpheaderView.font = [UIFont systemFontOfSize:15.0];
    tmpheaderView.backgroundColor = [UIColor colorWithRed:159.0/255 green:215.0/255 blue:230.0/255 alpha:1.0];
    tmpheaderView.textColor = [UIColor blackColor];
    tmpheaderView.textAlignment = UITextAlignmentCenter;
    tmpheaderView.text =  [self.nextProcess objectForKey:@"name"];
    return tmpheaderView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1)
    {
        NSInteger row = indexPath.row;
        NSInteger section = indexPath.section;
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        NSDictionary *bmDict = [self.deptList objectAtIndex:section];
        NSArray *userAry = [bmDict objectForKey:@"users"];
        NSDictionary *userDict = [userAry objectAtIndex:row];
        NSString *userName = [userDict objectForKey:@"name"];
        cell.textLabel.text = userName;
        return cell;
    }
    else
    {
        static NSString *cellIdentifer = @"CellIdentifer";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifer];
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
            cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
            
            UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
            bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
            cell.selectedBackgroundView = bgview;
        }
        NSString *nameStr = [self.processHandler objectForKey:@"name"];
        NSArray  *nameAry = [nameStr componentsSeparatedByString:@","];
        
        NSString *deptStr = [self.processHandler objectForKey:@"dept"];
        NSArray  *deptAry = [deptStr componentsSeparatedByString:@","];
        
        
        cell.textLabel.text = [nameAry objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [deptAry objectAtIndex:indexPath.row];
        
        return cell;
    }
}

#pragma mark -
#pragma mark tableviw delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (tableView.tag == 0) {
        self.currentTableTag = 0;
        BOOL alreadyChecked = NO;
        
        NSString *userIdStr   = [self.processHandler objectForKey:@"id"];
        NSArray  *userIdAry   = [userIdStr componentsSeparatedByString:@","];
        
        NSString *userNameStr = [self.processHandler objectForKey:@"name"];
        NSArray  *userNameAry = [userNameStr componentsSeparatedByString:@","];
        
        NSString *userName = [userNameAry objectAtIndex:indexPath.row];
        NSString *userId   = [userIdAry   objectAtIndex:indexPath.row];
        
        NSString *stepId   = [self.nextProcess objectForKey:@"id"];
        NSString *stepName = [self.nextProcess objectForKey:@"name"];
        
        for (StepUserItem *aUsrItem in self.selectHandler) {
            if ([aUsrItem.userId isEqualToString:userId] && [aUsrItem.stepID isEqualToString:stepId])  {
                [self.selectHandler removeObject:aUsrItem];
                alreadyChecked = YES;
                cell.accessoryType = UITableViewCellAccessoryNone;
                break;
                
            }
        }
        
        if (alreadyChecked == NO) {
            StepUserItem *aUsrItem = [[StepUserItem alloc] init];
            aUsrItem.userName = userName;
            aUsrItem.userId = userId;
            aUsrItem.stepID = stepId;
            aUsrItem.stepName = stepName;
            aUsrItem.section  = indexPath.section;
            aUsrItem.row      = indexPath.row;
            
            [self.selectHandler addObject:aUsrItem];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
        }
        // [self showSelectedStepInWebView];
        [self showSelectNameTableView:0 ];
        //[self.handlerTableView reloadData];
    }
    
    else{
        NSString *reader = [self.nextProcess objectForKey:@"reader"];
        if ([reader isEqualToString:@"0"]) {
            [self showAlertMessage:@"该环节不允许传阅!"];
            return;
        }
        
        self.currentTableTag = 1;
        BOOL alreadyChecked = NO;
        
        NSDictionary *bmDict = [self.deptList objectAtIndex:indexPath.section];
        NSArray *userAry = [bmDict objectForKey:@"users"];
        NSDictionary *userDict = [userAry objectAtIndex:indexPath.row];
        
        NSString *userId = [userDict objectForKey:@"userid"];
        NSString *userName = [userDict objectForKey:@"name"];
        
        
        for (StepUserItem *aUsrItem in self.selectReader) {
            if ([aUsrItem.userId isEqualToString:userId])  {
                cell.accessoryType = UITableViewCellAccessoryNone;
                [self.selectReader removeObject:aUsrItem];
                alreadyChecked = YES;
                break;
                
            }
        }
        if (alreadyChecked == NO) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            StepUserItem *aUsrItem = [[StepUserItem alloc] init];
            aUsrItem.userName = userName;
            aUsrItem.userId = userId;
            aUsrItem.section = indexPath.section;
            aUsrItem.row     = indexPath.row;
            
            [self.selectReader addObject:aUsrItem];
        }
        // [self showSelectedStepInWebView];
        [self showSelectNameTableView:1];
        
    }
    
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([alertView.message isEqualToString:@"流转成功!"])
    {
        BaseViewController *documentListController = (BaseViewController *)self.delegate;
        [self.navigationController popToViewController:documentListController animated:YES];
        [self.delegate HandleGWResult:TRUE];
    }
}

#pragma mark - Event Handle 

- (void)didDeSelectClicked:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    
    NSInteger tag = btn.tag;
    NSInteger tableTag = tag / 10000;
    NSInteger section =   (tag -tableTag*10000) / 100;
    NSInteger row     = tag % 100;
     NSIndexPath *indexPath =  [NSIndexPath indexPathForRow:row inSection:section];
    BOOL alreadyChecked = NO;
    if (tableTag == 0) {
        
        NSString *userIdStr   = [self.processHandler objectForKey:@"id"];
        NSArray  *userIdAry   = [userIdStr componentsSeparatedByString:@","];
        NSString *userId   = [userIdAry  objectAtIndex:row];
        NSString *stepId   = [self.nextProcess objectForKey:@"id"];
        
        for (StepUserItem *aUsrItem in self.selectHandler) {
            if ([aUsrItem.userId isEqualToString:userId] && [aUsrItem.stepID isEqualToString:stepId])  {
                [self.selectHandler removeObject:aUsrItem];
                
                UITableViewCell *cell = [self.handlerTableView cellForRowAtIndexPath:indexPath];
                if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                alreadyChecked = YES;
                break;
                
            }
        }
    }
    
    else {
        
        NSDictionary *bmDict = [self.deptList objectAtIndex:section];
        NSArray *userAry = [bmDict objectForKey:@"users"];
        NSDictionary *userDict = [userAry objectAtIndex:row];
        
        NSString *userId = [userDict objectForKey:@"userid"];
        
        for (StepUserItem *aUsrItem in self.selectReader) {
            if ([aUsrItem.userId isEqualToString:userId])  {
                
                UITableViewCell *cell = [self.readerTableView cellForRowAtIndexPath:indexPath];
                if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }

                [self.selectReader removeObject:aUsrItem];
                
                alreadyChecked = YES;
                break;
                
            }
        }
    }
    
    [self showSelectNameTableView:tableTag];
    
}

-(void)showSelectNameTableView:(NSInteger)tag
{
    if (tag == 0)
    {
        if (self.aryName0Views)
        {
            for (int i = 0; i < [self.aryName0Views count]; i++)
            {
                [[self.aryName0Views objectAtIndex:i] removeFromSuperview];
                
            }
            [self.aryName0Views removeAllObjects];
        }
        int i = 0;
        CGRect rect = CGRectMake(10, -40, 110, 40);
        for (StepUserItem *aUsrItem in self.selectHandler) {
            
            if (i%4 == 0) {
                rect.origin.x = 10;
                rect.origin.y += 45;
            }
            else if (i%4 == 1) {
                rect.origin.x += 100;
            }
            else{
                rect.origin.x += 100;
                
            }
            
            DeSelectBtn *deSelectBtn=[[DeSelectBtn alloc]initWithFrame:rect];
            deSelectBtn.tag = aUsrItem.section *100 + aUsrItem.row +tag*10000;
            [deSelectBtn setTitle:aUsrItem.userName forState:UIControlStateNormal];
            deSelectBtn.titleLabel.font=[UIFont systemFontOfSize:18];
            [deSelectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [deSelectBtn setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
            [deSelectBtn setTarget:self fun:@selector(didDeSelectClicked:)];
            
            [self.handlerScrollView addSubview:deSelectBtn];
            if (self.aryName0Views == nil)
            {
                self.aryName0Views = [NSMutableArray arrayWithCapacity:5];
            }
            [self.aryName0Views addObject:deSelectBtn];
            
            i++;
        }
    }
    else
    {
        if (self.aryName1Views)
        {
            for (int i = 0; i < [self.aryName1Views count]; i++)
            {
                [[self.aryName1Views objectAtIndex:i] removeFromSuperview];
            }
            [self.aryName1Views removeAllObjects];
        }
        int i = 0;
        CGRect rect = CGRectMake(10, -40, 110, 40);
        for (StepUserItem *aUsrItem in self.selectReader)
        {
            if (i%4 == 0)
            {
                rect.origin.x = 10;
                rect.origin.y += 45;
            }
            else if (i%4 == 1)
            {
                rect.origin.x += 100;
            }
            else
            {
                rect.origin.x += 100;
                
            }
            
            DeSelectBtn *deSelectBtn=[[DeSelectBtn alloc]initWithFrame:rect];
            deSelectBtn.tag = aUsrItem.section *100 + aUsrItem.row +tag*10000;
            [deSelectBtn setTitle:aUsrItem.userName forState:UIControlStateNormal];
            deSelectBtn.titleLabel.font=[UIFont systemFontOfSize:18];
            [deSelectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [deSelectBtn setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
            [deSelectBtn setTarget:self fun:@selector(didDeSelectClicked:)];
            
            [self.readerScrollView addSubview:deSelectBtn];
            if (self.aryName1Views == nil) {
                self.aryName1Views = [NSMutableArray arrayWithCapacity:5];
            }
            [self.aryName1Views addObject:deSelectBtn];
            
            i++;
        }
    }
}

- (void)transferToNextStep
{
    //下一环节处理人员
    NSMutableString *nextTacheTransactor = [[NSMutableString alloc] init];
    for (StepUserItem *aUsrItem in self.selectHandler)
    {
        if ([nextTacheTransactor isEqualToString:@""])
        {
            [nextTacheTransactor appendString:aUsrItem.userId];
        }
        else
        {
            [nextTacheTransactor appendFormat:@"+%@",aUsrItem.userId];
        }
    }
    
    //下一环节传阅人员
    NSMutableString *nextTachePasser = [[NSMutableString alloc] init];
    for (StepUserItem *aUsrItem in self.selectReader)
    {
        if ([nextTachePasser isEqualToString:@""])
        {
            [nextTachePasser appendString:aUsrItem.userId];
        }
        else
        {
            [nextTachePasser appendFormat:@"+%@",aUsrItem.userId];
        }
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:self.parameterDictionary];
    [params setObject:[NSString stringWithFormat:@"%@", [self.nextProcess objectForKey:@"id"]] forKey:@"Hy_NextTacheId"];
    [params setObject:[NSString stringWithFormat:@"%@", [self.nextProcess objectForKey:@"name"]] forKey:@"Hy_NextTacheName"];
    [params setObject:nextTacheTransactor forKey:@"Hy_NextTacheTransactor"];
    [params setObject:nextTachePasser forKey:@"Hy_NextTachePasser"];
    
    NSString *strUrl = [ServiceUrlString generateOAWebServiceUrl];
    NSString *paramStr = [WebServiceHelper createParametersWithKeys:self.paramsAry andValues:params];
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:self.serviceName nameSpace:WEBSERVICE_NAMESPACE  parameters:paramStr delegate:self];
    [self.webServiceHelper runAndShowWaitingView:self.view withTipInfo:@"正在提交环节流转" andTag:kService_Continue_tag];
}

-(void)btnTransferPressed:(id)sender
{
    NSString *multi = [self.nextProcess objectForKey:@"multi"];
    if([self.selectHandler count] < 1)
    {
        [self showAlertMessage:@"环节处理人不能为空."];
        return;
    }
    else if([self.selectHandler count] > 1 && [multi isEqualToString:@"0"]){
        [self showAlertMessage:@"该环节处理人不能为多人，请重新选择."];
        return;
    }
    else {
        [self transferToNextStep];
    }
}

- (IBAction)btnSelectProcess:(id)sender
{
    
    for (StepUserItem *aUsrItem in self.selectHandler) {
        NSInteger section  = aUsrItem.section;
        NSInteger row =  aUsrItem.row;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        
        UITableViewCell *cell = [self.handlerTableView cellForRowAtIndexPath:indexPath];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    for (StepUserItem *aUsrItem in self.selectReader) {
        NSInteger section  = aUsrItem.section;
        NSInteger row =  aUsrItem.row;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        
        UITableViewCell *cell = [self.readerTableView cellForRowAtIndexPath:indexPath];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    [self.selectHandler removeAllObjects];
    [self.selectReader removeAllObjects];

    [self showSelectNameTableView:0];
    [self showSelectNameTableView:1];
    
   
    
    NSMutableArray *listArray = [NSMutableArray arrayWithCapacity:2];
    for (NSDictionary *process in self.nextProcessArray)
    {
        NSString *processName = [process objectForKey:@"name"];
        [listArray addObject:processName];
    }

    
    UITextField *ctrl = self.nextProcessTxt;
    CommenWordsViewController *tmpController = [[CommenWordsViewController alloc] initWithNibName:@"CommenWordsViewController" bundle:nil ];
	tmpController.contentSizeForViewInPopover = CGSizeMake(260, 44*[listArray count]);
	tmpController.delegate = self;
    tmpController.wordsAry = listArray;
    UIPopoverController *tmppopover = [[UIPopoverController alloc] initWithContentViewController:tmpController];
    self.popController = tmppopover;
    [self.popController presentPopoverFromRect: ctrl.frame inView:self.view
                      permittedArrowDirections:UIPopoverArrowDirectionAny
                                      animated:YES];
}

- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row
{

    [self.popController dismissPopoverAnimated:YES];
    self.nextProcessTxt.text = words;
    self.nextProcess = [self.nextProcessArray objectAtIndex:row];
    [self.selectHandler removeAllObjects];
    [self.handlerTableView reloadData];
    
}

- (void)goBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - QQSectionHeaderViewDelegate Methods

-(void)sectionHeaderView:(QQSectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)section
{
    NSNumber *opened = [self.arySectionIsOpen objectAtIndex:section];
    [self.arySectionIsOpen replaceObjectAtIndex:section withObject:[NSNumber numberWithBool:!opened.boolValue]];
	
	// 收缩+动画 (如果不需要动画直接reloaddata)
	NSInteger countOfRowsToDelete = [self.readerTableView numberOfRowsInSection:section];
    if (countOfRowsToDelete > 0)
    {
		[self.readerTableView reloadData];
    }
}

-(void)sectionHeaderView:(QQSectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)section
{
	NSNumber *opened = [self.arySectionIsOpen objectAtIndex:section];
    [self.arySectionIsOpen replaceObjectAtIndex:section withObject:[NSNumber numberWithBool:!opened.boolValue]];
	[self.readerTableView reloadData];
}

#pragma mark - NSURLConnHelperDelegate  Methods

/**
 *  解析webservice请求返回的数据
 *
 *  @param webData 请求响应的数据
 *  @param tag     区分webservice标志
 */

- (void)processWebData:(NSData *)webData andTag:(NSInteger)tag
{
    if([webData length] <=0)
    {
        [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
    }
    if (tag == kService_NextStep_Tag)
    {
        WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:@"getnextclryReturn" andWithJSONDelegate:self];
        webDataHelper.serviceTag = tag;
        [webDataHelper parseXMLData:webData];
    }
    else if(tag == kService_PersonList_tag)
    {
        WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:@"returnPersonListReturn" andWithJSONDelegate:self];
        webDataHelper.serviceTag = tag;
        [webDataHelper parseXMLData:webData];
    }
    else if(tag == kService_Continue_tag)
    {
        WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:[NSString stringWithFormat:@"%@Return", self.serviceName] andWithJSONDelegate:self];
        webDataHelper.serviceTag = tag;
        [webDataHelper parseXMLData:webData];
    }
}

/**
 *  处理webservice请求失败和数据错误
 *
 *  @param error 错误信息
 */
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
        if(tag == kService_NextStep_Tag)
        {
            NSDictionary *processDict = [tmpParsedJsonDict objectForKey:@"getnextclry"];
            self.processHandlerArray = [processDict objectForKey:@"Hy_NextTransactor"];
            self.nextProcessArray = [processDict objectForKey:@"Hy_NextProcess"];
            self.processHandler = [self.processHandlerArray objectAtIndex:0];
            self.nextProcess =  [self.nextProcessArray objectAtIndex:0];
            self.nextProcessTxt.text = [[self.nextProcessArray objectAtIndex:0] objectForKey:@"name"];
            [self.handlerTableView reloadData];
        }
        else if(tag == kService_PersonList_tag)
        {
            NSArray *dataAry = [tmpParsedJsonDict objectForKey:@"Department"];
            self.deptList = dataAry;
            NSString *documnetPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *filePath = [documnetPath stringByAppendingPathComponent:@"contacts.plist"];
            [dataAry writeToFile:filePath atomically:YES];
            NSInteger count = [self.deptList count];
            if(count > 0)
            {
                self.arySectionIsOpen = [NSMutableArray arrayWithCapacity:count];
                for (NSInteger i = 0; i < count; i++)
                {
                    [self.arySectionIsOpen addObject:[NSNumber numberWithBool:NO]];
                }
            }
            [self.readerTableView reloadData];
        }
        else if(tag == kService_Continue_tag)
        {
            NSString *status = [tmpParsedJsonDict objectForKey:@"status"];
            if ([status isEqualToString:@"0"])
            {
                
                [self showAlertMessage:@"流转成功!"];

            }
            else
            {
                NSString *msg = [tmpParsedJsonDict objectForKey:@"reason"];
                [self showAlertMessage:msg];
            }
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
