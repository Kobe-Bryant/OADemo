//
//  YouJianGuanLiController.m
//  GuangXiOA
//
//  Created by  on 11-12-21.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "YouJianGuanLiController.h"
#import "DisplayAttachFileController.h"
#import "JSONKit.h"
#import "UICustomButton.h"
#import "XYJViewController.h"
#import "ASIHTTPRequest.h"
#import "ServiceUrlString.h"
#import "SystemConfigContext.h"

#define PageSize 12

@interface YouJianGuanLiController ()
- (void)addRightButtons;
- (void)writeEmail:(id)sender;
- (void)replyEmail:(id)sender;
- (void)transmitEmail:(id)sender;

@property (nonatomic,strong) NSString *fjrString;
@property (nonatomic,strong) NSString *btString;
@property (nonatomic,strong) NSString *nrString;
@property (nonatomic,strong) NSString *fjrID;
@property (nonatomic,strong) NSString *fjbh;
@property (nonatomic,strong) NSString *mailid;
@property (nonatomic,strong) NSIndexPath *indexPath;
@end

@implementation YouJianGuanLiController
@synthesize parsedOutBoxItemAry,parsedInBoxItemAry,listTableView,listDataType,fileTableView,nWebDataType,parsedFileItemAry;
@synthesize titleLabel,fromLabel,sendTimeLabel,mainTextView,curEmaiJBXXDic;
@synthesize isLoading,curPageOfSend,curPageOfRecv,pagesumOfSend,pagesumOfRecv;
@synthesize webHelper,segmentControlTitles;
@synthesize urlRecv,urlSend,readedSet,mailid;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        curPageOfRecv = 1;
        curPageOfSend = 1;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)dealloc{
    
}

#pragma mark -
#pragma mark Handle Event

-(void)goBackAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)writeEmail:(id)sender {
    XYJViewController *vc = [[XYJViewController alloc] initWithNibName:@"XYJViewController" bundle:nil];
    vc.title = @"编写邮件";
    vc.fjlxTag = 1;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)replyEmail:(id)sender {
    if (!_choosed) {
        return;
    }
    XYJViewController *vc = [[XYJViewController alloc] initWithNibName:@"XYJViewController" bundle:nil];
    vc.sjrString = self.fjrString;
    vc.btString = [NSString stringWithFormat:@"回复：%@",self.btString];
    vc.nrString = [NSString stringWithFormat:@"原始邮件:%@",self.nrString];
    vc.receiverString = self.fjrID;
    vc.fjlxTag = 2;
    vc.title = @"回复邮件";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)transmitEmail:(id)sender {
    if (!_choosed) {
        return;
    }

    XYJViewController *vc = [[XYJViewController alloc] initWithNibName:@"XYJViewController" bundle:nil];
    vc.fjrString = self.fjrString;
    vc.btString = self.btString;
    vc.nrString = self.nrString;
    vc.fjlxTag = 3;
    vc.fjbh = self.fjbh;
    vc.title = @"转发邮件";
    vc.mailid = mailid;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark CustomSegmentedControlDelegate
- (UIButton*) buttonFor:(CustomSegmentedControl*)segmentedControl atIndex:(NSUInteger)segmentIndex;
{
    CapLocation location;
    if (segmentIndex == 0)
        location = CapLeft;
    else if (segmentIndex == segmentControlTitles.count - 1)
        location = CapRight;
    else
        location = CapMiddle;
    
    UIButton* button = [UICustomButton woodButtonWithText:[segmentControlTitles objectAtIndex:segmentIndex] stretch:location];
    if (segmentIndex == 0)
        button.selected = YES;
    return button;
}

- (void)touchDownAtSegmentIndex:(NSUInteger)segmentIndex
{ 
    listDataType = segmentIndex;
    if (listDataType == 0) {
        if([parsedInBoxItemAry count] == 0 && curPageOfRecv == 1)
            [self getListDatas:listDataType];
        
    }
    else{
        if([parsedOutBoxItemAry count] == 0 && curPageOfSend == 1)
            [self getListDatas:listDataType];

    }
    [listTableView reloadData];

}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    _choosed = NO;
    self.title = @"邮件";
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.leftBarButtonItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"返回"];
    UIButton* leftButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
    [leftButton addTarget:self action:@selector(goBackAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addRightButtons];
    
    segmentControlTitles = [[NSArray alloc] initWithObjects:@"收件箱",@"发件箱", nil];
    UIImage* dividerImage = [UIImage imageNamed:@"view-control-divider.png"];
    CustomSegmentedControl *segctrl = [[CustomSegmentedControl alloc] initWithSegmentCount:segmentControlTitles.count segmentsize:CGSizeMake(BUTTON_SEGMENT_WIDTH, dividerImage.size.height) dividerImage:dividerImage tag:0 delegate:self] ;
    segctrl.frame = CGRectMake(50,17,156,30);
    listDataType = 0;
    [self.view addSubview:segctrl];
    
    
    NSString *backgroundImagePath = [[NSBundle mainBundle] pathForResource:@"white" ofType:@"png"];
	UIImage *backgroundImage = [[UIImage imageWithContentsOfFile:backgroundImagePath] stretchableImageWithLeftCapWidth:0.0 topCapHeight:1.0];
	fileTableView.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage] ;
    self.parsedInBoxItemAry = [NSMutableArray arrayWithCapacity:10];
    self.parsedOutBoxItemAry = [NSMutableArray arrayWithCapacity:10];
    [self getListDatas:listDataType];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillDisappear:(BOOL)animated{
    if (webHelper) {
        [webHelper cancel];
    }
    [super viewWillDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (void)viewWillAppear:(BOOL)animated {
	//self.navigationItem.hidesBackButton = YES;
	[self.navigationController setNavigationBarHidden:NO animated:YES];
}



-(void) getListDatas:(NSInteger)type{
   
    NSString *method= nil;
    NSString *curPage = @"";
    if (type == 0) {
        
        
        method = @"MailBox";
        curPage = [NSString stringWithFormat:@"%d",(curPageOfRecv-1)*PageSize +1];
        
    }
    else{
       
        method = @"SendMailBox";
        curPage = [NSString stringWithFormat:@"%d",(curPageOfSend-1)*PageSize +1];
    }
    
    isLoading = YES;
    nWebDataType = nWebDataForEmailList;
    
    NSString *strURL = [ServiceUrlString generateOAWebServiceUrl];
    SystemConfigContext *context = [SystemConfigContext sharedInstance];
    NSDictionary *loginUsr = [context getUserInfo];
    NSString *params = [WebServiceHelper createParametersWithKey:@"Hy_ts" value:[NSString stringWithFormat:@"%d",PageSize],@"Hy_start", curPage, @"Mail_user",[loginUsr objectForKey:@"userId"],nil];
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strURL method:method nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
    [self.webServiceHelper runAndShowWaitingView:self.view withTipInfo:@"正在加载..."];
    
}


- (void)addRightButtons {
    UIBarButtonItem *aItem1 = [UICustomBarButtonItem woodBarButtonItemWithText:@"新建"];
    self.navigationItem.rightBarButtonItem = aItem1;
    UIButton* rightButton1 = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
    [rightButton1 addTarget:self action:@selector(writeEmail:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *aItem2 = [UICustomBarButtonItem woodBarButtonItemWithText:@"回复"];
    self.navigationItem.rightBarButtonItem = aItem2;
    UIButton* rightButton2 = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
    [rightButton2 addTarget:self action:@selector(replyEmail:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *aItem3 = [UICustomBarButtonItem woodBarButtonItemWithText:@"转发"];
    self.navigationItem.rightBarButtonItem = aItem3;
    UIButton* rightButton3 = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
    [rightButton3 addTarget:self action:@selector(transmitEmail:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:aItem3,aItem2,aItem1, nil];
}

#pragma mark - Handle Network Request

// -------------------------------------------------------------------------------
//	实现NSURLConnHelperDelegate委托方法
//  处理网络请求的NSData数据
// -------------------------------------------------------------------------------
-(void)processWebData:(NSData *)webData andTag:(NSInteger)tag{
    isLoading = NO;
    
    if([webData length] <=0)
    {
        [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
        return;
    }
    
    NSString *fieldName = @"";
    if (tag == 1) {
        fieldName = @"UpdateEmailStatusReturn";
    }
    else{
        if (listDataType == 0) {
            fieldName = @"MailBoxReturn";
        }
        else {
            fieldName = @"SendMailBoxReturn";
        }
    }
    WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:fieldName andWithJSONDelegate:self andTag:tag];
    [webDataHelper parseXMLData:webData];
}

// -------------------------------------------------------------------------------
//	实现NSURLConnHelperDelegate委托方法
//  处理网络请求失败
// -------------------------------------------------------------------------------
-(void)processError:(NSError *)error{
    isLoading = NO;
    [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
    return;
}

#pragma mark - Parser Network Data

// -------------------------------------------------------------------------------
//	实现WebDataParserDelegate委托方法
//  解析json字符串
// -------------------------------------------------------------------------------
- (void)parseJSONString:(NSString *)jsonStr andTag:(NSInteger)tag
{
    self.isLoading = NO;
   
    NSDictionary *tmpParsedJsonDict = [jsonStr objectFromJSONString];
    BOOL bParseError = NO;
    BOOL selFirst = NO;
    if (tmpParsedJsonDict && jsonStr.length > 0)
    {
        if (tag == 1) {
            NSString *status = [NSString stringWithFormat:@"%@",[tmpParsedJsonDict objectForKey:@"status"]];
            if ([status isEqualToString:@"0"]) {
                UITableViewCell *cell = [listTableView cellForRowAtIndexPath:self.indexPath];
                cell.imageView.image = [UIImage imageNamed:@"mail_readed.png"];
                
                NSUserDefaults *preference = [NSUserDefaults standardUserDefaults];
                
                int inbox = [[preference objectForKey:@"unread"] intValue];
                inbox--;
                [preference setObject:[NSString stringWithFormat:@"%d",inbox] forKey:@"unread"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBdages" object:nil];
                return;
            }
        }
        else{
            NSArray *tmpAry = [tmpParsedJsonDict objectForKey:@"listinfo"];
            
            if ([tmpAry count] > 0) {
                
                if (listDataType == 0 ) {
                    if([parsedInBoxItemAry count] == 0)
                        selFirst = YES;
                    [parsedInBoxItemAry  addObjectsFromArray: tmpAry];
                }
                else {
                    if([parsedOutBoxItemAry count] == 0)
                        selFirst = YES;
                    [parsedOutBoxItemAry  addObjectsFromArray: tmpAry];
                }
                
                if(selFirst){
                    NSDictionary *tmpDict = [tmpAry objectAtIndex:0];
                    self.fjrString = fromLabel.text = [tmpDict objectForKey:@"sender"];
                    sendTimeLabel.text = [tmpDict objectForKey:@"sendDate"];
                    self.btString = titleLabel.text = [tmpDict objectForKey:@"title"];
                    self.nrString = mainTextView.text = [tmpDict objectForKey:@"content"];
                    self.fjrID = [tmpDict objectForKey:@"senderID"];
                    self.mailid = [tmpDict objectForKey:@"mailid"];
                    if ([tmpDict objectForKey:@"attach"] &&  [[tmpDict objectForKey:@"attach"] count] > 0) {
                        NSArray *attachArray = [tmpDict objectForKey:@"attach"];
                        self.parsedFileItemAry =attachArray;
                    }
                    _choosed = YES;
                }
                else {
                    fromLabel.text = @"";
                    sendTimeLabel.text = @"";
                    titleLabel.text = @"";
                    mainTextView.text = @"";
                }
                
        }
        //NSArray *arr = self.listDataArray;
        //[self.listDataArray removeAllObjects];//文档ID 
        }
    }    
    else
    {
        bParseError = YES;
    }
    
    [self.listTableView reloadData];
    [self.fileTableView reloadData];
    
    if(selFirst && _choosed){//第一次进入邮箱，默认选择第一封邮件
        NSIndexPath *indexpath=[NSIndexPath indexPathForRow:0 inSection:0];
        [self.listTableView selectRowAtIndexPath:indexpath animated:YES scrollPosition:UITableViewScrollPositionBottom];
        _choosed = YES;
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
    self.isLoading = NO;
    [self showAlertMessage:errorString];
}

#pragma mark -
#pragma mark TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (tableView.tag == 1) {
        return [parsedFileItemAry count];
    }
    else{
        if (listDataType == 0)
            return [self.parsedInBoxItemAry count];
        else
            return [self.parsedOutBoxItemAry count];
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 90;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row%2 == 1)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell = nil;
    NSArray *tmpAry = nil;
    if (tableView.tag == 1) {
        static NSString *identifier = @"fileIdentifier";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] ;
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
            cell.textLabel.numberOfLines = 2;
        }
        
        if (parsedFileItemAry ==nil||[parsedFileItemAry count] == 0) {
            cell.textLabel.text = @"没有相关附件";
        }
        
        else{
            NSDictionary *dicTmp = [parsedFileItemAry   objectAtIndex:indexPath.row];
            cell.textLabel.text = [dicTmp objectForKey:@"filename"];
            cell.detailTextLabel.text =
            [dicTmp objectForKey:@"wddx"];
            cell.textLabel.numberOfLines = 3;
            
            NSString *pathExt = [[dicTmp objectForKey:@"filename"] pathExtension];
            if([pathExt compare:@"pdf" options:NSCaseInsensitiveSearch] == NSOrderedSame )
                cell.imageView.image = [UIImage imageNamed:@"pdf_file.png"];
            else if([pathExt compare:@"doc" options:NSCaseInsensitiveSearch] == NSOrderedSame)
                cell.imageView.image = [UIImage imageNamed:@"doc_file.png"];
            else if([pathExt compare:@"xls" options:NSCaseInsensitiveSearch] == NSOrderedSame)
                cell.imageView.image = [UIImage imageNamed:@"xls_file.png"];
            else if([pathExt compare:@"zip" options:NSCaseInsensitiveSearch] == NSOrderedSame || [pathExt compare:@"rar" options:NSCaseInsensitiveSearch] == NSOrderedSame)
                cell.imageView.image = [UIImage imageNamed:@"rar_file.png"];
            else
                cell.imageView.image = [UIImage imageNamed:@"default_file.png"];
            
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        
    }
    else{
        static NSString *identifier = @"listIdentifier";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] ;
        }
        
        if (listDataType == 0)
            tmpAry = parsedInBoxItemAry;
        else
            tmpAry = parsedOutBoxItemAry;
        
        NSDictionary *tmpDic = [tmpAry objectAtIndex:indexPath.row];
        NSString *title = nil;
        NSString *deliverTime = nil;
        NSString *sendPerson = nil;
        if (tmpDic) {
            title = [tmpDic objectForKey:@"title"];
            deliverTime = [tmpDic objectForKey:@"sendDate"];
            if ([deliverTime length] > 9) {
                deliverTime = [deliverTime substringFromIndex:5];
            }
            
            sendPerson = [tmpDic objectForKey:@"sender"];
        }
        if (title == nil )
            title = @"";
        
        if (deliverTime == nil )
            deliverTime = @"";
        
        if (sendPerson == nil )
            sendPerson = @"";
        
        
        NSString *detail = [NSString stringWithFormat:@"发件人:%@  时间:%@",sendPerson,deliverTime];
        
        cell.textLabel.text = title ;
        cell.textLabel.numberOfLines = 3;
        
        cell.detailTextLabel.text = detail;
        cell.imageView.image = [UIImage imageNamed:@"mail_unread.png"];
        if([[tmpDic objectForKey:@"status"] isEqualToString:@"read"])//unread是未读。 read是已读
            cell.imageView.image = [UIImage imageNamed:@"mail_readed.png"];
        else if (readedSet) {
            if ([readedSet containsObject: [NSNumber numberWithInt:indexPath.row] ]) {
                cell.imageView.image =[UIImage imageNamed:@"mail_readed.png"];
            }
        }
        
        //发件箱都用已读图标
        if (listDataType == 1)
            cell.imageView.image = [UIImage imageNamed:@"mail_readed.png"];
    }
    
    UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
    bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
    cell.selectedBackgroundView = bgview;
    
	return cell;
    
}


#pragma mark -
#pragma mark TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    
    _choosed = YES;
    if (tableView.tag == 1) {//打开附件
        if ([parsedFileItemAry count] <= 0) {
            return;
        }
        
        NSDictionary *dicTmp = [parsedFileItemAry objectAtIndex:indexPath.row];
        
        NSString *fileName = [dicTmp objectForKey:@"filename"];
        NSString *fileURL = [dicTmp objectForKey:@"fileURL"];
        if (fileName == nil ) {
            return;
        }
        
        DisplayAttachFileController *controller = [[DisplayAttachFileController alloc] initWithNibName:@"DisplayAttachFileController"  fileURL:fileURL andFileName:fileName];
        
        [self.navigationController pushViewController:controller animated:YES];
    }
    else{
        
        NSDictionary *tmpDict = nil;
        if (listDataType == 0 ) {
            tmpDict = [self.parsedInBoxItemAry objectAtIndex:row];
        }
        else {
            tmpDict = [self.parsedOutBoxItemAry objectAtIndex:row];
        }
        if([[tmpDict objectForKey:@"status"] isEqualToString:@"unread"]){
            //unread是未读。 read是已读
            self.indexPath = indexPath;
            NSString *strURL = [ServiceUrlString generateOAWebServiceUrl];
            SystemConfigContext *context = [SystemConfigContext sharedInstance];
            NSDictionary *loginUsr = [context getUserInfo];
            NSString *params = [WebServiceHelper createParametersWithKey:@"Hy_userid" value:[loginUsr objectForKey:@"userId"],@"Mail_Id",[tmpDict objectForKey:@"mailid"],nil];
            self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strURL method:@"UpdateEmailStatus" nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
            [self.webServiceHelper runAndShowWaitingView:self.view withTipInfo:@"正在更新邮件状态..." andTag:1];
        }
        
        self.fjrString = fromLabel.text = [tmpDict objectForKey:@"sender"];
        sendTimeLabel.text = [tmpDict objectForKey:@"sendDate"];
        self.btString = titleLabel.text = [tmpDict objectForKey:@"title"];
        self.nrString = mainTextView.text = [tmpDict objectForKey:@"content"];
        self.fjrID = [tmpDict objectForKey:@"senderID"];
        self.mailid = [tmpDict objectForKey:@"mailid"];
        if ([tmpDict objectForKey:@"attach"] &&  [[tmpDict objectForKey:@"attach"] count] > 0) {
            NSArray *attachArray = [tmpDict objectForKey:@"attach"];
            self.parsedFileItemAry =attachArray;
        }
        [self.fileTableView reloadData];
        
    }
    
    //[self.listTableView reloadData];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	
    if (isLoading) {
        return;
    }
    
    if(scrollView.tag == 1)
        return;//是附件表格在拉动
	
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 850 ) {
        // Released above the header
		
        if (listDataType == 0) {//收件箱只去未读
            if(curPageOfRecv*PageSize > [parsedInBoxItemAry count ])
                return;
            curPageOfRecv++;
            
            
        }
        else{
            if(curPageOfSend*PageSize > [parsedOutBoxItemAry count ])
                return;
            curPageOfSend++;
            
        }
        isLoading = YES;
        [self getListDatas:listDataType];
    }
    
}


@end
