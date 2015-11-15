//
//  HandleProcessViewController.m
//  NingBoOA
//
//  Created by 熊熙 on 13-10-8.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "HandleProcessViewController.h"
#import "UICustomButton.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "DeSelectBtn.h"
#import "StepUserItem.h"
#import "QQSectionHeaderView.h"
#import "FileOutManagerController.h"
#import "SystemConfigContext.h"

@interface HandleProcessViewController ()<QQSectionHeaderViewDelegate>
@property (strong, nonatomic) NSMutableArray *arySectionIsOpen;
@property (strong, nonatomic) UIPopoverController *popController;

@end

@implementation HandleProcessViewController

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
    self.selectHandler = [NSMutableArray arrayWithCapacity:5];
    self.selectReader  = [NSMutableArray arrayWithCapacity:5];
    UIBarButtonItem *backItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"返回"];
    self.navigationItem.leftBarButtonItem = backItem;
    UIButton *backButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
    [backButton addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.currentProcess.text = [NSString stringWithFormat:@"当前环节:%@",[self.valueDict objectForKey:@"Hy_process"]];
    
    NSString *modid = [self.valueDict objectForKey:@"Hy_modid"];
    NSString *docid = [self.valueDict objectForKey:@"Hy_docid"];
    
    NSString *strUrl = [ServiceUrlString generateWebServiceUrl];
    
    NSString *params = [WebServiceHelper createParametersWithKey:@"Hy_mdid" value:modid, @"docid", docid, nil];
    
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:@"getnextclry" nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
    [self.webServiceHelper runAndShowWaitingView:self.view andTag:0];
    
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"contacts.plist"];
    
    self.deptList = [NSArray arrayWithContentsOfFile:filePath];
    
    NSInteger count = [self.deptList count];
    if(count > 0){
        self.arySectionIsOpen = [NSMutableArray arrayWithCapacity:count];
        for (NSInteger i = 0; i < count; i++) {
            [self.arySectionIsOpen addObject:[NSNumber numberWithBool:NO]];
        }
    }
    
    [self.nextProcessTxt addTarget:self action:@selector(beginEditing:) forControlEvents:UIControlEventTouchDown];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated {
    if (!self.deptList)
    {
        NSString *strURL = [ServiceUrlString generateWebServiceUrl];
        NSString *params = nil;
        self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strURL method:@"returnPersonList" nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
        [self.webServiceHelper runAndShowWaitingView:self.view andTag:1];
    }
    
}

#pragma mark -
#pragma mark tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 1) {
        if(section < [self.arySectionIsOpen count]){
            BOOL opened = [[self.arySectionIsOpen objectAtIndex:section] boolValue];
            if(opened == NO) return 0;
        }
        NSDictionary *bmDict =[self.deptList objectAtIndex:section];
        NSArray      *userAry = [bmDict objectForKey:@"users"];
        
        return [userAry count];

    }
    NSString *nameStr = [self.processHandler objectForKey:@"name"];
    NSArray  *nameAry = [nameStr componentsSeparatedByString:@","];
    return [nameAry count];
   
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tag == 1) {
        return [self.deptList count];

    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(tableView.tag == 1){
        return 36.0;
    }
    
    return 30.0;
}



-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == 1) {
        CGFloat headerHeight = 36.0;
        NSDictionary *bmDict =[self.deptList objectAtIndex:section];
        NSString *bmMC = [bmDict objectForKey:@"BMMC"];
        BOOL opened = NO;
        if(section < [self.arySectionIsOpen count]){
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 1) {
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
//        if(self.showPhone){
//            NSString *userNumber   = [userDict objectForKey:@"mobile"];
//            cell.detailTextLabel.text = userNumber;
//        }
//        
//        if ([_userAry containsObject:userid]) {
//            cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        }
//        else {
//            cell.accessoryType = UITableViewCellAccessoryNone;
//        }
        // Configure the cell...
        
        return cell;
    }
    
    
    static NSString *cellIdentifer = @"CellIdentifer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    
    if (cell == nil) {
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

#pragma mark -
#pragma mark tableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (tableView.tag == 0) {
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
            //aUsrItem.index = indexPath.row;
            [self.selectHandler addObject:aUsrItem];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
           
        }
        // [self showSelectedStepInWebView];
        [self showSelectNameTableView:0 ];
        //[self.handlerTableView reloadData];
    }
    
    else{
        BOOL alreadyChecked = NO;
        
        NSDictionary *bmDict = [self.deptList objectAtIndex:indexPath.section];
        NSArray *userAry = [bmDict objectForKey:@"users"];
        NSDictionary *userDict = [userAry objectAtIndex:indexPath.row];
        
        NSString *userId = [userDict objectForKey:@"userid"];
        NSString *userName = [userDict objectForKey:@"name"];
        
        
        for (StepUserItem *aUsrItem in self.selectReader) {
            if ([aUsrItem.userId isEqualToString:userId])  {
                [self.selectReader removeObject:aUsrItem];
                alreadyChecked = YES;
                break;
                
            }
        }
        if (alreadyChecked == NO) {
            StepUserItem *aUsrItem = [[StepUserItem alloc] init];
            aUsrItem.userName = userName;
            aUsrItem.userId = userId;
            //aUsrItem.index = indexPath.row;
            [self.selectReader addObject:aUsrItem];
            
        }
        // [self showSelectedStepInWebView];
        [self showSelectNameTableView:1];

    }

}


#pragma mark -
#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[self.navigationController.viewControllers objectAtIndex:2] isKindOfClass:[FileOutManagerController class]]) {
        FileOutManagerController *fileOutManagerController = [self.navigationController.viewControllers objectAtIndex:2];
        fileOutManagerController.isRefresh = YES;
        
    }
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
}


#pragma mark -
#pragma mark Handle Event

- (void)didDeSelectClicked:(id)sender{
    UIButton *btn = (UIButton*)sender;
   
    NSInteger row = btn.tag;
    BOOL alreadyChecked = NO;
    
    NSString *userIdStr   = [self.processHandler objectForKey:@"id"];
    NSArray  *userIdAry   = [userIdStr componentsSeparatedByString:@","];
    
    NSString *userId   = [userIdAry   objectAtIndex:row];
    
    NSString *stepId   = [self.nextProcess objectForKey:@"id"];
    

    for (StepUserItem *aUsrItem in self.selectHandler) {
        if ([aUsrItem.userId isEqualToString:userId] && [aUsrItem.stepID isEqualToString:stepId])  {
            [self.selectHandler removeObject:aUsrItem];
            alreadyChecked = YES;
            break;
            
        }
    }
    
    [self showSelectNameTableView:0];
    [self.handlerTableView reloadData];
}

-(void)showSelectNameTableView:(NSInteger)tag {
    
    if (tag == 0) {
        if (self.aryName0Views) {
            for (int i = 0; i < [self.aryName0Views count]; i++) {
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
            //deSelectBtn.tag = aUsrItem.index;
            [deSelectBtn setTitle:aUsrItem.userName forState:UIControlStateNormal];
            deSelectBtn.titleLabel.font=[UIFont systemFontOfSize:18];
            [deSelectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [deSelectBtn setImage:[UIImage imageNamed:@"jian.png"] forState:UIControlStateNormal];
            [deSelectBtn setTarget:self fun:@selector(didDeSelectClicked:)];
            
            [self.handlerScrollView addSubview:deSelectBtn];
            if (self.aryName0Views == nil) {
                self.aryName0Views = [NSMutableArray arrayWithCapacity:5];
            }
            [self.aryName0Views addObject:deSelectBtn];
            
            i++;
        }

    }
    
    else {
        if (self.aryName1Views) {
            for (int i = 0; i < [self.aryName1Views count]; i++) {
                [[self.aryName1Views objectAtIndex:i] removeFromSuperview];
            }
            [self.aryName1Views removeAllObjects];
        }
        int i = 0;
        CGRect rect = CGRectMake(10, -40, 110, 40);
        for (StepUserItem *aUsrItem in self.selectReader) {
            
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
            //deSelectBtn.tag = aUsrItem.index;
            [deSelectBtn setTitle:aUsrItem.userName forState:UIControlStateNormal];
            deSelectBtn.titleLabel.font=[UIFont systemFontOfSize:18];
            [deSelectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [deSelectBtn setImage:[UIImage imageNamed:@"jian.png"] forState:UIControlStateNormal];
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

- (void)transferToNextStep{
    NSString *docid = [self.valueDict objectForKey:@"Hy_docid"];
    NSString *fwgz  = [self.valueDict objectForKey:@"Hy_FWGZ"];
    NSString *ldqfm  = [self.valueDict objectForKey:@"Hy_LDQFM"];
    NSString *hq  = [self.valueDict objectForKey:@"Hy_HQ"];
    NSString *zsdw  = [self.valueDict objectForKey:@"Hy_ZSDW"];
    NSString *csdw  = [self.valueDict objectForKey:@"Hy_CSDW"];
    NSString *sfgk  = [self.valueDict objectForKey:@"Hy_SFGK"];
    NSString *wzfb  = [self.valueDict objectForKey:@"Hy_WZFB"];
    NSString *cssh  = [self.valueDict objectForKey:@"Hy_CSSH"];
    NSString *bgsh  = [self.valueDict objectForKey:@"Hy_BGSH"];
    NSString *zbdw  = [self.valueDict objectForKey:@"Hy_ZBDW"];
    NSString *ngr  = [self.valueDict objectForKey:@"Hy_NGR"];
    NSString *ztc  = [self.valueDict objectForKey:@"Hy_ZTC"];
    NSString *bt  = [self.valueDict objectForKey:@"Hy_Bt"];
    NSString *mmdj  = [self.valueDict objectForKey:@"Hy_MMDJ"];
    NSString *hj  = [self.valueDict objectForKey:@"Hy_hj"];
    NSString *lb  = [self.valueDict objectForKey:@"Hy_lb"];
    NSString *nf  = [self.valueDict objectForKey:@"Hy_nf"];
    NSString *bh  = [self.valueDict objectForKey:@"Hy_bh"];
    NSString *fs  = [self.valueDict objectForKey:@"Hy_FS"];
    NSString *jdr  = [self.valueDict objectForKey:@"Hy_JDR"];
    NSString *yzrq  = [self.valueDict objectForKey:@"Hy_YZRQ"];
    NSString *tbyj  = [self.valueDict objectForKey:@"Hy_Tbyj"];
    NSString *nextTacheId = [self.nextProcess objectForKey:@"id"];
    NSString *nextTacheName = [self.nextProcess objectForKey:@"name"];
    
    
    NSMutableString *nextTacheTransactor = [[NSMutableString alloc] init];
    NSMutableString *nextTachePasser = [[NSMutableString alloc] init];

        
     for (StepUserItem *aUsrItem in self.selectHandler) {
         
         if ([nextTacheTransactor isEqualToString:@""]) {
             [nextTacheTransactor appendString:aUsrItem.userId];
         }
         else {
             [nextTacheTransactor appendFormat:@"+%@",aUsrItem.userId];
         }
     }
    
    for (StepUserItem *aUsrItem in self.selectReader) {
        
        if ([nextTachePasser isEqualToString:@""]) {
            [nextTachePasser appendString:aUsrItem.userId];
        }
        else {
            [nextTachePasser appendFormat:@"+%@",aUsrItem.userId];
        }
    }

    
    
//    NSString *nextTacheId = [self.nextProcess objectForKey:@"Hy_NextTacheId"];
//    NSString *nextTacheName = [self.nextProcess objectForKey:@"Hy_NextTacheName"];
//    NSString *nextTacheTransactor = [self.processHandler objectForKey:@"Hy_NextTacheTransactor"];
    
    NSString *strUrl = [ServiceUrlString generateWebServiceUrl];
    
//    NSString *params = [WebServiceHelper createParametersWithKey:@"Hy_docid" value:docid, @"Hy_userid", @"lvhc",@"Hy_FWGZ",fwgz,@"Hy_LDQFM",ldqfm,nil];
    
    SystemConfigContext *context = [SystemConfigContext sharedInstance];
    NSDictionary *loginUsr = [context getUserInfo];
    NSString *userid = [loginUsr objectForKey:@"userId"];
    
    NSString *params = [WebServiceHelper createParametersWithKey:@"Hy_docid" value:docid,@"Hy_userid",userid,@"Hy_FWGZ",fwgz, @"Hy_LDQFM",ldqfm,@"Hy_HQ",hq,@"Hy_ZSDW",zsdw,@"Hy_CSDW",csdw,@"Hy_SFGK",sfgk,@"Hy_WZFB",wzfb,@"Hy_CSSH",cssh,@"Hy_BGSH",bgsh,@"Hy_ZBDW",zbdw,@"Hy_NGR",ngr,@"Hy_ZTC",ztc,@"Hy_Bt",bt,@"Hy_MMDJ",mmdj,@"Hy_hj",hj,@"Hy_lb",lb,@"Hy_nf",nf,@"Hy_bh",bh,@"Hy_FS",fs,@"Hy_JDR",jdr,@"Hy_YZRQ",yzrq,@"Hy_Tbyj",tbyj,@"Hy_NextTacheId",nextTacheId,@"Hy_NextTacheName",nextTacheName,@"Hy_NextTacheTransactor",nextTacheTransactor,@"Hy_NextTachePasser",nextTachePasser,nil];
    
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:@"FileOutContinuteProcess" nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
    [self.webServiceHelper runAndShowWaitingView:self.view withTipInfo:@"正在提交环节流转" andTag:2];
}

-(IBAction)btnTransferPressed:(id)sender{
    if([self.selectHandler count] < 1) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示"
                  message:@"环节处理人不能为空"
                 delegate:nil
        cancelButtonTitle:@"确定"
        otherButtonTitles:nil];
        
        [alertView show];
        return;
    }
    
    [self transferToNextStep];
}

- (IBAction)btnSelectProcess:(id)sender{
    
    NSMutableArray *listArray = [NSMutableArray arrayWithCapacity:2];
    for (NSDictionary *process in self.nextProcessArray) {
        NSString *processName = [process objectForKey:@"name"];
        [listArray addObject:processName];
    }
    
    UITextField *ctrl = self.nextProcessTxt;
    CommenWordsViewController *tmpController = [[CommenWordsViewController alloc] initWithNibName:@"CommenWordsViewController" bundle:nil ];
	tmpController.contentSizeForViewInPopover = CGSizeMake(200, 350);
	tmpController.delegate = self;
    tmpController.contentSizeForViewInPopover = CGSizeMake(200, 88);
    tmpController.wordsAry = listArray;
    
    UIPopoverController *tmppopover = [[UIPopoverController alloc] initWithContentViewController:tmpController];
    self.popController = tmppopover;
    
    [self.popController presentPopoverFromRect: ctrl.frame
                                            inView:self.view
                          permittedArrowDirections:UIPopoverArrowDirectionAny
                                          animated:YES];
 
}

- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row {
    self.nextProcessTxt.text = words;
    self.processHandler = [self.processHandlerArray objectAtIndex:row];
    [self.selectHandler removeAllObjects];
    
    [self.handlerTableView reloadData];
    
    if(self.popController){
        [self.popController dismissPopoverAnimated:YES];
    }
}

- (void)goBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)sectionHeaderView:(QQSectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)section
{
    NSNumber *opened = [self.arySectionIsOpen objectAtIndex:section];
    [self.arySectionIsOpen replaceObjectAtIndex:section withObject:[NSNumber numberWithBool:!opened.boolValue]];
	
	// 收缩+动画 (如果不需要动画直接reloaddata)
	NSInteger countOfRowsToDelete = [self.readerTableView numberOfRowsInSection:section];
    if (countOfRowsToDelete > 0)
    {
		[self.readerTableView reloadData];
        //  [self.stepTableView deleteRowsAtIndexPaths:persons.indexPaths withRowAnimation:UITableViewRowAnimationTop];
    }
}


-(void)sectionHeaderView:(QQSectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)section
{
	NSNumber *opened = [self.arySectionIsOpen objectAtIndex:section];
    [self.arySectionIsOpen replaceObjectAtIndex:section withObject:[NSNumber numberWithBool:!opened.boolValue]];
	[self.readerTableView reloadData];
	// 展开+动画 (如果不需要动画直接reloaddata)
    ///////////////////////////////////////////////////////////////fix
	//if(persons.indexPaths){
    //if ([persons.m_arrayPersons count] > 0)
    {
        
		//[self.processTable insertRowsAtIndexPaths:persons.indexPaths withRowAnimation:UITableViewRowAnimationBottom];
	}
	//persons.indexPaths = nil;
    ///////////////////////////////////////////////////////////////fix
}

#pragma mark - Handle Network Request

// -------------------------------------------------------------------------------
//	实现NSURLConnHelperDelegate委托方法
//  处理网络请求的NSData数据
// -------------------------------------------------------------------------------
- (void)processWebData:(NSData *)webData andTag:(NSInteger)tag
{
    if([webData length] <=0)
    {
        [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
    }
    
    if (tag == 0) {
        WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:@"getnextclryReturn" andWithJSONDelegate:self];
        webDataHelper.serviceTag = tag;
        [webDataHelper parseXMLData:webData];
    }
    else if(tag == 1){
        WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:@"returnPersonListReturn" andWithJSONDelegate:self];
        webDataHelper.serviceTag = tag;
        [webDataHelper parseXMLData:webData];
    }
    else {
        WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:@"FileOutContinuteProcessReturn" andWithJSONDelegate:self];
        webDataHelper.serviceTag = tag;
        [webDataHelper parseXMLData:webData];
    }
    
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

- (void)parseJSONString:(NSString *)jsonStr andTag:(NSInteger)tag
{
    NSDictionary *tmpParsedJsonDict = [jsonStr objectFromJSONString];
    BOOL bParseError = NO;
    if (tmpParsedJsonDict && jsonStr.length > 0)
    {
        if(tag == 0) {
           
        NSDictionary *processDict = [tmpParsedJsonDict objectForKey:@"getnextclry"];
        self.processHandlerArray = [processDict objectForKey:@"Hy_NextTransactor"];
        
        self.nextProcessArray = [processDict objectForKey:@"Hy_NextProcess"];
        
        self.processHandler = [self.processHandlerArray objectAtIndex:0];
        self.nextProcess    =  [self.nextProcessArray objectAtIndex:0];
        
        self.nextProcessTxt.text = [[self.nextProcessArray objectAtIndex:0] objectForKey:@"name"];
        
        [self.handlerTableView reloadData];
            
        }
        else if(tag == 1){
            NSArray *dataAry = [tmpParsedJsonDict objectForKey:@"Department"];
            self.deptList = dataAry;
            NSString *documnetPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            
            NSString *filePath = [documnetPath stringByAppendingPathComponent:@"contacts.plist"];
            
            [dataAry writeToFile:filePath atomically:YES];
            
            NSInteger count = [self.deptList count];
            if(count > 0){
                self.arySectionIsOpen = [NSMutableArray arrayWithCapacity:count];
                for (NSInteger i = 0; i < count; i++) {
                    [self.arySectionIsOpen addObject:[NSNumber numberWithBool:NO]];
                }
            }
            [self.readerTableView reloadData];
        }
        
        else {
            NSString *status = [tmpParsedJsonDict objectForKey:@"status"];
            if ([status isEqualToString:@"0"]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"流转成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];

            }
            else {
                
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
