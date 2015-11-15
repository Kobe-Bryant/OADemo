//
//  XYJViewController.m
//  GuangXiOA
//
//  Created by apple on 13-1-9.
//
//

#import "XYJViewController.h"
#import "UICustomButton.h"
#import "QuartzCore/QuartzCore.h"
#import "JSONKit.h"
#import "ZrsUtils.h"
#import "ServiceUrlString.h"
#import "SystemConfigContext.h"
#import "TakePhotoViewController.h"

@interface XYJViewController (){
    BOOL sendSuccess;
}
- (void)initDefault;
- (void)initCome;
- (void)addSendButton;
- (void)addPopView;

- (IBAction)addButtonClick:(id)sender;
- (void)sendButtonClick:(id)sender;
- (void)animateUp;
- (void)animateDown;

@property(nonatomic,copy)NSString *serviceName;

@end

@implementation XYJViewController
@synthesize webHelper,serviceName,mailid;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        sendSuccess = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initDefault];
//    [self addPopView];
    [self addSendButton];
    
    NSString *backgroundImagePath = [[NSBundle mainBundle] pathForResource:@"white" ofType:@"png"];
	UIImage *backgroundImage = [[UIImage imageWithContentsOfFile:backgroundImagePath] stretchableImageWithLeftCapWidth:0.0 topCapHeight:1.0];
	self.fileTableView.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage] ;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTitleLabel:nil];
    [self setTitleTextView:nil];
    [self setContextTextView:nil];
    [self setAddButton:nil];
    [self setReceiverLabel:nil];
    [self setContextLabel:nil];
    [super viewDidUnload];
}
-(void)viewWillDisappear:(BOOL)animated{
    if (webHelper) {
        [webHelper cancel];
    }
    [super viewWillDisappear:animated];
}


#pragma mark -
#pragma mark self私有----------------------
- (void)initDefault {
    
    
    self.animateHeight = 0.0;
    _departmentArray = [[NSMutableArray alloc] init];
    _personArray = [[NSMutableArray alloc] init];
    self.typeTag = 0;
//    _receiverString = [[NSString alloc] init];
    
    _receiverLabel.text = nil;
    _receiverLabel.layer.borderWidth = 0.5;
    _receiverLabel.layer.cornerRadius = 3;
    _receiverLabel.layer.borderColor = [UIColor grayColor].CGColor;
    
    _titleTextView.text = nil;
    _titleTextView.layer.borderWidth = 0.5;
    _titleTextView.layer.cornerRadius = 3;
    _titleTextView.layer.borderColor = [UIColor grayColor].CGColor;
    
    _contextTextView.text = nil;
    _contextTextView.layer.borderWidth = 0.5;
    _contextTextView.layer.cornerRadius = 3;
    _contextTextView.layer.borderColor = [UIColor grayColor].CGColor;
    
    [self initCome];
}
- (void)initCome {
    switch (self.fjlxTag) {
        case 1:{
            //可以注释,编写邮件
//            _receiverLabel.text = nil;
//            _titleTextView.text = nil;
//            _contextTextView.text = nil;
            self.jslx = @"C";
        }
            break;
        case 2:{
            //可以注释,回复邮件
            _receiverLabel.text = self.sjrString;
            _titleTextView.text = self.btString;
             _contextTextView.text = self.nrString;
            self.jslx = @"R";
        }
            break;
        case 3:{
            //可以注释,转发邮件
//            _receiverLabel.text = self.sjrString;
            _titleTextView.text = [NSString stringWithFormat:@"转发“%@”", self.btString];
            _contextTextView.text = self.nrString;
            self.jslx = @"Z";
        }
            break;
        default:
            break;
    }
}

+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

- (void)addSendButton {
    UIBarButtonItem *backItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"返回"];
    self.navigationItem.leftBarButtonItem = backItem;
    UIButton *backButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
    [backButton addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *uploadItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"上传附件"];
    self.navigationItem.rightBarButtonItem = uploadItem;
    UIButton* uploadButton = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
    [uploadButton addTarget:self action:@selector(uploadAttachImage:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *sendItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"发送"];
    self.navigationItem.rightBarButtonItem = sendItem;
    UIButton* sendButton = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
    [sendButton addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:sendItem,uploadItem,nil];
}

- (void)returnContactIds:(NSString *)users Names:(NSString *)names{

    _receiverLabel.text = names;
    self.receiverString = users;
    
    if (_popVc) {
        [_popVc dismissPopoverAnimated:YES];
    }
}

- (void)goBackAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addButtonClick:(id)sender {
    UIButton *btn = (UIButton *)sender;

    if (_popVc)
        [_popVc dismissPopoverAnimated:YES];
    
   ContactListViewController *contactViewController = [[ContactListViewController alloc] initWithNibName:@"ContactListViewController" bundle:nil];
    contactViewController.contactDelegate = self;
    contactViewController.showPhone = NO;
    contactViewController.contentSizeForViewInPopover = CGSizeMake(320, 480);
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:contactViewController];
    
    UIPopoverController *tmpPopover = [[UIPopoverController alloc] initWithContentViewController:controller];
    self.popVc = tmpPopover;
    
    
    [_popVc presentPopoverFromRect:[btn bounds] inView:btn permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

- (void)sendButtonClick:(id)sender {

    if ([_receiverString length] <= 0) {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"请填写收件人。"
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert show];
        return;
        
    };
    if ([_titleTextView.text length] <= 0) {        UIAlertView *alert = [[UIAlertView alloc]
                                                                          initWithTitle:@"提示"
                                                                          message:@"请填写标题"
                                                                          delegate:self
                                                                          cancelButtonTitle:@"确定"
                                                                          otherButtonTitles:nil];
        [alert show];
        return;
        
    };
    if ([_contextTextView.text length] <= 0) {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"请填写内容"
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert show];
        
        return;
        
    };
    
    SystemConfigContext *context = [SystemConfigContext sharedInstance];
    NSDictionary *loginUsr = [context getUserInfo];
    NSString *params = nil;
    if(self.fjlxTag == 3 ){//邮件转发
        
        params = [WebServiceHelper createParametersWithKey:@"MAIL_SENDER" value:[loginUsr objectForKey:@"userId"],@"MAIL_RECIPIENT", _receiverString, @"MAIL_TITLE",_titleTextView.text,@"MAIL_CONTENT",_contextTextView.text,@"MAIL_ID",mailid,nil];
        self.serviceName = @"ForwardEmail";
        
    }else{
        params = [WebServiceHelper createParametersWithKey:@"MAIL_SENDER" value:[loginUsr objectForKey:@"userId"],@"MAIL_RECIPIENT", _receiverString, @"MAIL_TITLE",_titleTextView.text,@"MAIL_CONTENT",_contextTextView.text,@"Attach_file",@"",@"Attach_size",@"",@"Attach_type",@"",nil];
        self.serviceName = @"SendMail";
    }
    
    NSString *strURL = [ServiceUrlString generateOAWebServiceUrl];
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strURL method:serviceName nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
    [self.webServiceHelper runAndShowWaitingView:self.view];
}

- (void)uploadAttachImage:(id)sender {
    TakePhotoViewController *takePhotViewController = [[TakePhotoViewController alloc] init];
    [self.navigationController pushViewController:takePhotViewController animated:YES];
}

#pragma mark NSURLConnHelperDelegate------------------
-(void)processWebData:(NSData*)webData{
    
    if([webData length] <=0)
    {
        [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
        return;
    }
    
    NSString *fieldName = [NSString stringWithFormat: @"%@Return",serviceName];
    
    WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:fieldName andWithJSONDelegate:self];
    [webDataHelper parseXMLData:webData];
   
}

-(void)processError:(NSError *)error{
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message:@"请求数据失败."
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];
    return;
}

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
        NSString *status = [tmpParsedJsonDict objectForKey:@"status"];
            
        if([status isEqualToString:@"0"]){
            [self showAlertMessage:@"邮件发送成功。"];
            sendSuccess = YES;
        }else{
            [self showAlertMessage:@"邮件发送失败！"];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(sendSuccess){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -
#pragma mark TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"上传附件";
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row%2 == 1)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell = nil;
    if (tableView.tag == 1) {
        static NSString *identifier = @"fileIdentifier";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] ;
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
            cell.textLabel.numberOfLines = 2;
        }
        
        cell.textLabel.text = @"环境街景";
        cell.detailTextLabel.text = @"测试邮件附件发送";
        cell.textLabel.numberOfLines = 3;
        
        cell.imageView.image = [UIImage imageNamed:@"default_file.png"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
	return cell;
}

#pragma mark -
#pragma mark TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end
