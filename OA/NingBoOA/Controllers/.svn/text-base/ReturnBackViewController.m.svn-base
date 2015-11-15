//
//  ReturnBackViewController.m
//  GuangXiOA
//
//  Created by zhang on 12-9-12.
//
//

#import "ReturnBackViewController.h"
#import "UICustomButton.h"
#import "PDJsonkit.h"
#import "ServiceUrlString.h"
#import "SystemConfigContext.h"

@interface ReturnBackViewController ()
@property (nonatomic, copy) NSString *selectedTachID;
@property (nonatomic, copy) NSString *selectedTachName;
@end

@implementation ReturnBackViewController

@synthesize delegate,webServiceType;
@synthesize webServiceHelper;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.currentProcess;
    
    UIBarButtonItem *backItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"返回"];
    self.navigationItem.leftBarButtonItem = backItem;
    UIButton *backButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
    [backButton addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *seeItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"退回"];
    self.navigationItem.rightBarButtonItem = seeItem;
    
    UIButton *seeButton = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
    [seeButton addTarget:self action:@selector(returnBackAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self requestWorkFlow];
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (self.webServiceHelper)
    {
        [self.webServiceHelper cancel];
    }
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark Handle Event

- (void)goBackAction{
    [self.navigationController popViewControllerAnimated:YES];
}


//回退
-(void)returnBackAction
{
    if(self.selectedTachID == nil || self.selectedTachID.length == 0)
    {
        [self showAlertMessage:@"当前退回环节为空，请选择."];
    }
    
    SystemConfigContext *context = [SystemConfigContext sharedInstance];
    NSDictionary *loginUsr = [context getUserInfo];
    NSString *user = [loginUsr objectForKey:@"userId"];
    NSString *strUrl = [ServiceUrlString generateOAWebServiceUrl];
    NSString *params = [WebServiceHelper createParametersWithKey:@"HY_USERID" value:user, @"HY_MDID",self.mdId,@"DOCID",self.docId,@"HY_HISTORYTACHEID", self.selectedTachID, nil];
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:@"historyreturn" nameSpace:WEBSERVICE_NAMESPACE parameters:params delegate:self];
    [self.webServiceHelper runAndShowWaitingView:self.view withTipInfo:@"正在退回操作，请稍候..."];
    self.webServiceType = kWebService_ReturnBack;
}

#pragma mark - Network Hanlder Method

-(void)requestWorkFlow
{
    NSString *strUrl = [ServiceUrlString generateOAWebServiceUrl];
    NSString *params = [WebServiceHelper createParametersWithKey:@"Hy_mdid" value:self.mdId, @"docid", self.docId, nil];
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:@"getReBackProcess" nameSpace:WEBSERVICE_NAMESPACE parameters:params delegate:self];
    [self.webServiceHelper run];
    self.webServiceType = kWebService_HistoryList;
}

-(void)processWebData:(NSData*)webData
{
    if(webData.length <= 0)
    {
        [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
    }
    WebDataParserHelper *webDataParserHelper = nil;
    if(self.webServiceType == kWebService_HistoryList)
    {
        webDataParserHelper = [[WebDataParserHelper alloc] initWithFieldName:@"getReBackProcessReturn" andWithJSONDelegate:self];
        [webDataParserHelper parseXMLData:webData];
    }
    else if (self.webServiceType == kWebService_ReturnBack)
    {
        webDataParserHelper = [[WebDataParserHelper alloc] initWithFieldName:@"historyreturnReturn" andWithJSONDelegate:self];
        [webDataParserHelper parseXMLData:webData];
    }
}

-(void)processError:(NSError *)error
{
    [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
}

#pragma mark - 网络数据解析

- (void)parseJSONString:(NSString *)jsonStr
{
    if(self.webServiceType == kWebService_HistoryList)
    {
        NSDictionary *tmpParsedJsonDict = [jsonStr objectFromJSONString];
        BOOL bParseError = NO;
        if (tmpParsedJsonDict && jsonStr.length > 0)
        {
            self.historyProcessAry = [tmpParsedJsonDict objectForKey:@"HistoryTacheList"];
            
            [self.historyTableView reloadData];
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
    else if (self.webServiceType == kWebService_ReturnBack)
    {
        //0成功,1失败
        NSString *msg;
        NSDictionary *tmpDict = [jsonStr objectFromJSONString];
        NSString *status = [tmpDict objectForKey:@"status"];
        if([status isEqualToString:@"0"])
        {
            msg = @"退回成功!";
        }
        else
        {
            msg = @"退回失败!";
        }
        [self showAlertMessage:msg];
    }
}

- (void)parseWithError:(NSString *)errorString
{
    [self showAlertMessage:errorString];
}

#pragma mark - UIAlertView Delegate Method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.message isEqualToString:@"退回成功!"])
    {
        BaseViewController *documentListController = (BaseViewController *)self.delegate;
        [self.navigationController popToViewController:documentListController animated:YES];
        [delegate HandleGWResult:TRUE];
    }
}

#pragma mark - Private Methods

- (void)showAlertMessage:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    return;
}


- (void)viewDidUnload {
    [self setSelectedLabel:nil];
    [super viewDidUnload];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.historyProcessAry count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Histroy_Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *processDict = [self.historyProcessAry objectAtIndex:indexPath.row];
    
    NSString *tachName = [processDict objectForKey:@"TacheName"];
    
    cell.textLabel.text = tachName;
    
    if([self.selectedTachName isEqualToString:tachName])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *processDict = [self.historyProcessAry objectAtIndex:indexPath.row];
    NSString *teachId  = [processDict objectForKey:@"TacheId"];
    NSString *tachName = [processDict objectForKey:@"TacheName"];
    
    self.selectedTachID = teachId;
    self.selectedTachName = tachName;
    self.selectedLabel.text = self.selectedTachName;
    [self.historyTableView reloadData];
}

@end
