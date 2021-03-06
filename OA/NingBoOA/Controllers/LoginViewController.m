//
//  LoginViewController.m
//  BoandaProject
//
//  Created by 张仁松 on 13-7-1.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "LoginViewController.h"
#import "MainMenuViewController.h"
#import "ServiceUrlString.h"
#import "SystemConfigContext.h"
#import "PDJsonkit.h"
#import "NSAppUpdateManager.h"

#define KUserName @"KUserName"
#define KUserSave @"KUserSave"
#define KUserPassword @"KUserPassword"


@interface LoginViewController ()
@property (nonatomic,strong) NSString *serviceName;
@property (nonatomic,strong) NSAppUpdateManager *updater;
@property (nonatomic,strong) UITextField *usrField;
@property (nonatomic,strong) UITextField *pwdField;
@property (nonatomic,strong) UISwitch *pwdSwitch;

@end

@implementation LoginViewController

@synthesize updater,usrField,pwdField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)checkVersion{
    
    NSString *URLString = [ServiceUrlString generateMobileLawServiceUrl:@"TYdzfService.asmx"];
    
    NSString *method = @"GetVersion";
    NSString *params = nil;
    
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:URLString method:method nameSpace:@"http://tempuri.org/" parameters:params delegate:self];
    [self.webServiceHelper run];
    self.serviceName = method;
}

-(void)addUIViews
{
    UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginBg.png"]];
    [self.view addSubview:bgImgView];
    
    UILabel *usrLabel = [[UILabel alloc] initWithFrame:CGRectMake(246, 443, 92, 37)];
    usrLabel.backgroundColor = [UIColor clearColor];
    usrLabel.textColor = [UIColor blackColor];
    usrLabel.font = [UIFont systemFontOfSize:22.0];
    usrLabel.text = @"用户名:";
    [self.view addSubview:usrLabel];
    
    UILabel *pwdLabel = [[UILabel alloc] initWithFrame:CGRectMake(246, 488, 92, 37)];
    pwdLabel.backgroundColor = [UIColor clearColor];
    pwdLabel.textColor = [UIColor blackColor];
    pwdLabel.font = [UIFont systemFontOfSize:22.0];
    pwdLabel.text = @"密    码:";
    [self.view addSubview:pwdLabel];
    
    self.usrField = [[UITextField alloc]  initWithFrame:CGRectMake(330, 446, 192, 31)];
    self.usrField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.usrField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.usrField.autocorrectionType  = UITextAutocorrectionTypeNo;
    usrField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:usrField];
    
    self.pwdField = [[UITextField alloc] initWithFrame:CGRectMake(330, 492, 192, 31)];
    pwdField.borderStyle = UITextBorderStyleRoundedRect;
    pwdField.secureTextEntry = YES;
    self.pwdField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:pwdField];
    
    UILabel *saveLabel = [[UILabel alloc] initWithFrame:CGRectMake(285, 538, 276, 38)];
    saveLabel.backgroundColor = [UIColor clearColor];
    saveLabel.textColor = [UIColor blackColor];
    saveLabel.font = [UIFont systemFontOfSize:18.0];
    saveLabel.text = @"保存密码";
    [self.view addSubview:saveLabel];
    
    self.pwdSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(380, 543, 276, 38)];
    [self.view addSubview:self.pwdSwitch];
    
    UIButton *btnLogin = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnLogin setTitle:@"登    录" forState:UIControlStateNormal];
    btnLogin.titleLabel.font = [UIFont systemFontOfSize:20.0];
    [btnLogin addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    btnLogin.frame = CGRectMake(248, 597, 276, 38);
    [self.view addSubview:btnLogin];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化视图组件
    [self addUIViews];
    //读取并设置默认用户名
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *usr = [defaults objectForKey:KUserName];
    NSString *pwd = nil;
    if ([[defaults objectForKey:KUserSave]isEqualToString:@"YES"]) {
        pwd = [defaults objectForKey:KUserPassword];
        self.pwdSwitch.on = YES;
    }
	if (usr == nil) usr= @"";
	usrField.text = usr;
    if (pwd == nil) pwd= @"";
	pwdField.text = pwd;
    [self checkVersion];
  //  usrField.text = @"测试使用";
  //  pwdField.text = @"1";
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.usrField becomeFirstResponder];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.usrField.text = @"";
    self.pwdField.text = @"";
}

-(void)login:(id)sender
{
    
    NSString *msg = @"";
    if ([usrField.text isEqualToString:@""])
    {
        msg = @"用户名不能为空";
    }
    else if([pwdField.text isEqualToString:@""])
    {
        msg = @"密码不能为空";
    }
    if([msg length] > 0)
    {
        [self showAlertMessage:msg];
		return;
    }

    NSString *strURL = [ServiceUrlString generateOAWebServiceUrl];
    NSString *method = @"AuthorizedLogin";
    NSString *params = [WebServiceHelper createParametersWithKey:@"user" value:usrField.text,@"pwd", pwdField.text, @"udid",@"powerdatamobileios",nil];
    
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strURL method:method nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
    [self.webServiceHelper runAndShowWaitingView:self.view withTipInfo:@"正在登录中,请稍候..." andTag:0];
    self.serviceName = method;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)gotoMainMenu
{
    MainMenuViewController *menuController = [[MainMenuViewController alloc] init];
    [self.navigationController pushViewController:menuController animated:YES];
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
    
    NSString *method = [NSString stringWithFormat:@"%@Return",self.serviceName];
    
    WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:method andWithJSONDelegate:self];
    if ([method isEqualToString:@"GetVersionReturn"]) {
        [webDataHelper parseJSONData:webData];
    }
    
    else {
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
        if ([self.serviceName isEqualToString:@"GetVersion"]) {
            //程序版本检查
            self.updater = [[NSAppUpdateManager alloc] init];
            [updater checkAndUpdate:tmpParsedJsonDict];
        }  else {
           
        NSString *status = [tmpParsedJsonDict objectForKey:@"status"];
        NSString *name =  [tmpParsedJsonDict objectForKey:@"name"];
        NSString *department = [tmpParsedJsonDict objectForKey:@"department"];
        NSString *deptid = [tmpParsedJsonDict objectForKey:@"deptid"];
           
        if ([status isEqualToString:@"0"]) {
            
            NSMutableDictionary *dicUser = [NSMutableDictionary dictionaryWithCapacity:5];
            [dicUser setObject:usrField.text forKey:@"userId"];
            [dicUser setObject:name forKey:@"name"];
            [dicUser setObject:deptid forKey:@"deptid"];
            [dicUser setObject:department forKey:@"department"];
            [dicUser setObject:pwdField.text forKey:@"password"];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [[SystemConfigContext sharedInstance] setUser:dicUser];
            
            [defaults setObject:usrField.text forKey:KUserName];
            if (self.pwdSwitch.on) {
                [defaults setObject:@"YES" forKey:KUserSave];
                [defaults setObject:pwdField.text forKey:KUserPassword];
            }
            else{
                [defaults setObject:@"NO" forKey:KUserSave];
            }
            
            int todo = [[tmpParsedJsonDict objectForKey:@"todo"] intValue];
    
            int unread = [[tmpParsedJsonDict objectForKey:@"unread"] intValue];

            [defaults setObject:[NSString stringWithFormat:@"%d",todo] forKey:@"todo"];
            [defaults setObject:[NSString stringWithFormat:@"%d",unread] forKey:@"unread"];
            
            MainMenuViewController *menuController = [[MainMenuViewController alloc] init];
    
            [self.navigationController pushViewController:menuController animated:YES];
        }
        else {
            [self showAlertMessage:@"用户名帐号或密码错误"];
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
