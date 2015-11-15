//
//  ContactListViewController.m
//  GMEPS_HZ
//
//  Created by 熊 熙 on 13-7-31.
//
//

#import "ContactListViewController.h"
#import "WebServiceHelper.h"
#import "PDJsonkit.h"
#import "QQSectionHeaderView.h"
#import "ServiceUrlString.h"
@interface ContactListViewController ()<QQSectionHeaderViewDelegate>
@property (nonatomic,strong) NSMutableArray *arySectionIsOpen;
@end

@implementation ContactListViewController
@synthesize arySectionIsOpen;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.userAry = [NSMutableArray array];
        self.nameAry = [NSMutableArray array];
        self.showPhone = YES;
    }
    return self;
}





#pragma mark - 
#pragma mark view lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"人员列表";
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshContacts)];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(DoneUserContacts)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = doneButton;
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"contacts.plist"];
    
    self.branchAry = [NSArray arrayWithContentsOfFile:filePath];
    
    for (NSDictionary *bmDict in self.branchAry) {
        NSArray *userAry = [bmDict objectForKey:@"users"];
        for (NSDictionary *userDict in userAry) {
            NSString *userid   = [userDict objectForKey:@"userid"];
            NSString *userName = [userDict objectForKey:@"name"];
            if ([self.selectItems containsObject:userid]) {
                [self.userAry addObject:userid];
                [self.nameAry addObject:userName];
            }
        }
    }
    
    
    
    NSInteger count = [self.branchAry count];
    if(count > 0){
        self.arySectionIsOpen = [NSMutableArray arrayWithCapacity:count];
        for (NSInteger i = 0; i < count; i++) {
            [arySectionIsOpen addObject:[NSNumber numberWithBool:NO]];
        }
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    if (!_branchAry)
    {
        NSString *strURL = [ServiceUrlString generateOAWebServiceUrl];
        NSString *params = nil;
        self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strURL method:@"returnPersonList" nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
        [self.webServiceHelper runAndShowWaitingView:self.view];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_branchAry count];
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section{
    return 36.0;
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat headerHeight = 36.0;
    NSDictionary *bmDict =[_branchAry objectAtIndex:section];
    NSString *bmMC = [bmDict objectForKey:@"BMMC"];
    BOOL opened = NO;
    if(section < [arySectionIsOpen count]){
        opened = [[arySectionIsOpen objectAtIndex:section] boolValue];
    }

    QQSectionHeaderView *sectionHeadView = [[QQSectionHeaderView alloc]
                                            initWithFrame:CGRectMake(0.0, 0.0, listtableView.bounds.size.width, headerHeight)
                                            title:bmMC
                                            section:section
                                            opened:opened
                                            delegate:self];
	return sectionHeadView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    NSDictionary *bmDict = [_branchAry objectAtIndex:section];
    NSArray *userAry = [bmDict objectForKey:@"users"];
    NSDictionary *userDict = [userAry objectAtIndex:row];
    
    NSString *userid   = [userDict objectForKey:@"userid"];
    NSString *userName = [userDict objectForKey:@"name"];
    
    
    cell.textLabel.text = userName;
    if(self.showPhone){
        NSString *userNumber   = [userDict objectForKey:@"mobile"];
        cell.detailTextLabel.text = userNumber;
    }
    
    if ([self.userAry containsObject:userid]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    // Configure the cell...
    
    return cell;
}

#pragma mark - QQ section header view delegate

-(void)sectionHeaderView:(QQSectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)section
{
    NSNumber *opened = [arySectionIsOpen objectAtIndex:section];
    [arySectionIsOpen replaceObjectAtIndex:section withObject:[NSNumber numberWithBool:!opened.boolValue]];
	
	// 收缩+动画 (如果不需要动画直接reloaddata)
	NSInteger countOfRowsToDelete = [listtableView numberOfRowsInSection:section];
    if (countOfRowsToDelete > 0)
    {
		[listtableView reloadData];
        //  [self.stepTableView deleteRowsAtIndexPaths:persons.indexPaths withRowAnimation:UITableViewRowAnimationTop];
    }
}


-(void)sectionHeaderView:(QQSectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)section
{
	NSNumber *opened = [arySectionIsOpen objectAtIndex:section];
    [arySectionIsOpen replaceObjectAtIndex:section withObject:[NSNumber numberWithBool:!opened.boolValue]];
	[listtableView reloadData];
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(section < [arySectionIsOpen count]){
        BOOL opened = [[arySectionIsOpen objectAtIndex:section] boolValue];
        if(opened == NO) return 0;
    }
    NSDictionary *bmDict =[_branchAry objectAtIndex:section];
    NSArray      *userAry = [bmDict objectForKey:@"users"];
    
    return [userAry count];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *bmDict = [_branchAry objectAtIndex:indexPath.section];
    NSArray *userAry = [bmDict objectForKey:@"users"];
    NSDictionary *userDict = [userAry objectAtIndex:indexPath.row];
    
    NSString *userid = [userDict objectForKey:@"userid"];
    NSString *userName = [userDict objectForKey:@"name"];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [_userAry removeObject:userid];
        [_nameAry removeObject:userName];
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [_userAry addObject:userid];
        [_nameAry addObject:userName];

    }
}

#pragma mark - UISearchBar Delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText isEqualToString:@""]) {
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *filePath = [documentPath stringByAppendingPathComponent:@"contacts.plist"];
        
        self.branchAry = [NSArray arrayWithContentsOfFile:filePath];
    }
    
    else
    {
        self.branchAry = [self search:searchText source:_branchAry];
        
        
    }
    
    NSInteger count = [self.branchAry count];
    if(count > 0){
        self.arySectionIsOpen = [NSMutableArray arrayWithCapacity:count];
        for (NSInteger i = 0; i < count; i++) {
            [arySectionIsOpen addObject:[NSNumber numberWithBool:YES]];
        }
    }
    
    [listtableView reloadData];

}

- (NSArray *)search:(NSString *)searchTxt source:(NSArray *)dataSource {
    NSMutableArray *dataArray = [NSMutableArray array];
    for (NSDictionary *bmInfo in dataSource) {
        NSMutableDictionary *bmDict = [NSMutableDictionary dictionary];
        NSString *bmBH = [bmInfo objectForKey:@"BMBH"];
        NSString *bmMC = [bmInfo objectForKey:@"BMMC"];
        
        
        NSArray *userAry = [bmInfo objectForKey:@"users"];
        NSMutableArray *users = [NSMutableArray array];
        for (NSDictionary *userDict in userAry) {
            NSString *userName = [userDict objectForKey:@"name"];
            NSString *userid   = [userDict objectForKey:@"userid"];
            if ([userName rangeOfString:searchTxt].location != NSNotFound || [userid rangeOfString:searchTxt].location != NSNotFound) {
                [users addObject:userDict];
            }
        }
        
        if ([users count] >=1) {
            [bmDict setObject:bmBH forKey:@"BMBH"];
            [bmDict setObject:bmMC forKey:@"BMMC"];
            [bmDict setObject:users forKey:@"users"];
            [dataArray addObject:bmDict];
        }
        
    }
    
    return dataArray;
}





#pragma mark -
#pragma mark Handle Event

- (void)refreshContacts{
    /*NSString *URL = [NSString  stringWithFormat: KLogIn_URL,g_appDelegate.ServerIP];
    NSString *method = @"GetAllUser_Phone";
    
    NSString *parameter = [WebServiceHelper createParametersWithKey:@"userName" value:g_logedUserInfo.userName,@"UDID",g_appDelegate.udid,nil];
    
    WebServiceHelper *webService = [[[WebServiceHelper alloc] initWithUrl:URL
                                                                   method:method
                                                                     view:self.view nameSpace:KSoapNameSpace parameters:parameter
                                                                 delegate:self] autorelease];
    webService.hudTitle =@"正在更新通讯录，请稍候...";
    [webService run];*/

}

- (void)DoneUserContacts{
   NSMutableString *idStr = [NSMutableString stringWithCapacity:1];
   NSMutableString *nameStr = [NSMutableString stringWithCapacity:1];
    for (NSString *userid in self.userAry) {
        if ([idStr length] < 1) {
            [idStr appendString:userid];
        }
        else {
            [idStr appendFormat:@",%@",userid];
        }
    }
    
    for (NSString *name in self.nameAry) {
        if ([nameStr length] < 1) {
            [nameStr appendString:name];
        }
        else {
            [nameStr appendFormat:@"、%@",name];
        }
    }

    [_contactDelegate returnContactIds:idStr Names:nameStr];
    
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
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请求数据出错,请稍后再试." delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
        [alertView show];
        
        //[self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
    }
    WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:@"returnPersonListReturn" andWithJSONDelegate:self];
    [webDataHelper parseXMLData:webData];
}

// -------------------------------------------------------------------------------
//	实现NSURLConnHelperDelegate委托方法
//  处理网络请求失败
// -------------------------------------------------------------------------------
- (void)processError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请求数据出错,请稍后再试." delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
    [alertView show];

    //[self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
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
        //NSArray *arr = self.listDataArray;
        //[self.listDataArray removeAllObjects];//文档ID
        NSArray *dataAry = [tmpParsedJsonDict objectForKey:@"Department"];
        self.branchAry = dataAry;
        NSString *documnetPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *filePath = [documnetPath stringByAppendingPathComponent:@"contacts.plist"];
        
        [dataAry writeToFile:filePath atomically:YES];
        
        NSInteger count = [self.branchAry count];
        if(count > 0){
            self.arySectionIsOpen = [NSMutableArray arrayWithCapacity:count];
            for (NSInteger i = 0; i < count; i++) {
                [arySectionIsOpen addObject:[NSNumber numberWithBool:YES]];
            }
        }
    }

    else
    {
        bParseError = YES;
    }
    
    
    if (bParseError)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请求数据出错,请稍后再试." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
    
     [listtableView reloadData];
}

// -------------------------------------------------------------------------------
//	实现WebDataParserDelegate委托方法
//  解析json字符串发生错误
// -------------------------------------------------------------------------------

- (void)parseWithError:(NSString *)errorString
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message:@"网络请求超时，请稍后重试"
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];

    
}

@end
