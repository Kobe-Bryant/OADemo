//
//  FileOutDetailViewController.m
//  NingBoOA
//
//  Created by 熊熙 on 13-9-29.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "XJZXFileInDetailViewController.h"
#import "ContinueProcessViewController.h"
#import "RemindersViewController.h"
#import "LookUpProcessViewController.h"
#import "ReturnBackViewController.h"
#import "DisplayAttachFileController.h"
#import "UICustomButton.h"
#import "HandleGWProtocol.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "SystemConfigContext.h"
#import "DejalActivityView.h"

@interface XJZXFileInDetailViewController ()
@property (nonatomic,strong) NSMutableArray *textViewArray;
@property (nonatomic,assign) BOOL addTime;
@property (strong, nonatomic) UIPopoverController *popController;
@end

@implementation XJZXFileInDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)setControlEdit{
    UIScrollView *scrollView = (UIScrollView *)self.view;
    [scrollView setContentSize:CGSizeMake(768, 1280)];
    
    if ([self.competence isEqualToString:@"0"]) {
        UIBarButtonItem *backItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"返回"];
        self.navigationItem.leftBarButtonItem = backItem;
        UIButton *backButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
        [backButton addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *saveItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"保存"];
        self.navigationItem.rightBarButtonItem = saveItem;
        
        UIButton *saveButton = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
        [saveButton addTarget:self action:@selector(saveToProcess) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *nextItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"下一步"];
        self.navigationItem.rightBarButtonItem = nextItem;
        
        UIButton *nextButton = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
        [nextButton addTarget:self action:@selector(nextToProcess) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *forwardItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"退回"];
        self.navigationItem.rightBarButtonItem = forwardItem;
        
        UIButton *forwardButton = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
        [forwardButton addTarget:self action:@selector(forwardToProcess) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *seeItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"查看流程"];
        self.navigationItem.rightBarButtonItem = seeItem;
        
        UIButton *seeButton = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
        [seeButton addTarget:self action:@selector(lookupProcess:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if ([self.process isEqualToString:@"收文登记"]) {
            self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:seeItem,nextItem,saveItem,nil];
        }
        
        else {
            self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:seeItem,nextItem,forwardItem,saveItem,nil];
        }
        
        NSString *editStr = [self.infoDict objectForKey:@"edit"];
        NSArray *editAry = [editStr componentsSeparatedByString:@","];
        
        for (NSString *ctrlEdit in editAry) {
            
            if ([ctrlEdit isEqualToString:@"Hy_FWGZ"]) {
                self.paperTxt.borderStyle = UITextBorderStyleRoundedRect;
                self.paperBtn.hidden = NO;
                self.paperBtn.enabled = YES;
            }
            else if([ctrlEdit isEqualToString:@"Hy_Swrq"]){
                self.swrqTxt.borderStyle = UITextBorderStyleRoundedRect;
                
                self.swrqBtn.enabled = YES;
                self.swrqBtn.hidden  = NO;
            }
            else if ([ctrlEdit isEqualToString:@"Hy_Swlx"]) {
                self.swlxTxt.borderStyle = UITextBorderStyleRoundedRect;
                
            }
            
            else if([ctrlEdit isEqualToString:@"Hy_Swnf"]){
                self.swnfTxt.borderStyle = UITextBorderStyleRoundedRect;
                
                
            }
            else if([ctrlEdit isEqualToString:@"Hy_Swbh"]){
                self.swbhTxt.borderStyle = UITextBorderStyleRoundedRect;
                self.swwhBtn.enabled = YES;
                self.swwhBtn.hidden = NO;
                
            }

            else if([ctrlEdit isEqualToString:@"Hy_Lwwh"]){
                self.lwlxTxt.enabled = YES;
                self.lwnfTxt.enabled = YES;
                self.lwwhTxt.enabled = YES;
            }

            else if([ctrlEdit isEqualToString:@"Hy_Cbqx"]){
                self.deadlineTxt.borderStyle = UITextBorderStyleRoundedRect;
        
                self.deadlineBtn.hidden = NO;
                self.deadlineBtn.enabled = YES;
            }
            else if([ctrlEdit isEqualToString:@"Hy_Xygdf"]) {
                self.archiveTxt.borderStyle = UITextBorderStyleRoundedRect;
                
                self.archiveBtn.hidden = NO;
                self.archiveBtn.enabled = YES;
            }
            
            else if([ctrlEdit isEqualToString:@"Hy_Bt"]){
                self.titleView.layer.borderColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0].CGColor;
                
                self.titleView.layer.borderWidth =1.5;
                self.titleView.layer.cornerRadius =6.0;
                self.titleView.editable = YES;
            }
            else if([ctrlEdit isEqualToString:@"Hy_Mj"]){
                self.scretLevelTxt.borderStyle = UITextBorderStyleRoundedRect;
                
                self.scretLevelBtn.hidden = NO;
                self.scretLevelBtn.enabled = YES;
                
            }
            else if([ctrlEdit isEqualToString:@"Hy_Hj"]){
                self.urgentTxt.borderStyle = UITextBorderStyleRoundedRect;
                
                self.urgentBtn.hidden = NO;
                self.urgentBtn.enabled = YES;
            }
            
            else if([ctrlEdit isEqualToString:@"Hy_Ys"]){
                self.pagesTxt.borderStyle = UITextBorderStyleRoundedRect;
                self.pagesTxt.enabled = YES;
            }
            
            else if([ctrlEdit isEqualToString:@"Hy_Fs"]){
                self.numbersTxt.borderStyle = UITextBorderStyleRoundedRect;
                self.numbersTxt.enabled = YES;
            }
            
            else if([ctrlEdit isEqualToString:@"Hy_Lb"]) {
                self.typeTxt.borderStyle = UITextBorderStyleRoundedRect;
                
                self.typeBtn.hidden = NO;
                self.typeBtn.enabled = YES;
            }
            
            else if([ctrlEdit isEqualToString:@"Hy_Lzfs"]) {
                self.waysTxt.borderStyle = UITextBorderStyleRoundedRect;
                
                self.waysBtn.enabled = YES;
                self.waysBtn.hidden = NO;
            }
            
            else if([ctrlEdit isEqualToString:@"Hy_Ldyj"]) {
                
                CGRect frame = CGRectMake(170, 72, 204, 58);
                
                self.ldqfTxtView1.frame = frame;
                
                self.ldqfTxtView.layer.borderColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0].CGColor;
                
                self.ldqfTxtView.layer.borderWidth =1.5;
                self.ldqfTxtView.layer.cornerRadius =6.0;
                self.ldqfTxtView.editable = YES;
                
                self.inputLdqf.hidden = NO;
                self.inputLdqf.enabled = YES;
                
                self.clearLdqf.hidden = NO;
                self.clearLdqf.enabled = YES;
            
                [self.textViewArray addObject:self.ldqfTxtView];
            }
            else if([ctrlEdit isEqualToString:@"Hy_Swffyj"]) {
                CGRect frame = CGRectMake(534, 72, 204, 58);
                self.distriTxtView1.frame = frame;
                
                self.distriTxtView.layer.borderColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0].CGColor;
                
                self.distriTxtView.layer.borderWidth =1.5;
                self.distriTxtView.layer.cornerRadius =6.0;
                self.distriTxtView.editable = YES;
                
                self.inputDistri.hidden = NO;
                self.inputDistri.enabled = YES;
                
                self.clearDistri.hidden = NO;
                self.clearDistri.enabled = YES;
                
                [self.textViewArray addObject:self.distriTxtView];

            }
            
            else if([ctrlEdit isEqualToString:@"Hy_Csryyj"]) {
                CGRect frame = CGRectMake(530, 388, 208, 100);
                self.auditTxtView1.frame = frame;
                
                self.auditTxtView.layer.borderColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0].CGColor;
    
                self.auditTxtView.layer.borderWidth =1.5;
                self.auditTxtView.layer.cornerRadius =6.0;
                self.auditTxtView.editable = YES;
                
                self.inputAudit.hidden = NO;
                self.inputAudit.enabled = YES;
                
                self.clearAudit.hidden = NO;
                self.clearAudit.enabled = YES;
                
                [self.textViewArray addObject:self.auditTxtView];
            }
            
            else if([ctrlEdit isEqualToString:@"Hy_Tbyj"]) {
                
                CGRect frame = CGRectMake(530, 778, 208, 100);
                self.opinionTxtView1.frame = frame;
                
                self.opinionTxtView.layer.borderColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0].CGColor;
                
                self.opinionTxtView.layer.borderWidth =1.5;
                self.opinionTxtView.layer.cornerRadius =6.0;
                self.opinionTxtView.editable = YES;
                
                self.inputOpinion.hidden = NO;
                self.inputOpinion.enabled = YES;
                
                self.clearOpinion.hidden = NO;
                self.clearOpinion.enabled = YES;
                
                [self.textViewArray addObject:self.opinionTxtView];
            }
        }
    }
    else if([self.competence isEqualToString:@"1"]) {
        UIBarButtonItem *backItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"返回"];
        self.navigationItem.leftBarButtonItem = backItem;
        UIButton *backButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
        [backButton addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIBarButtonItem *rebackItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"收回"];
        self.navigationItem.rightBarButtonItem = rebackItem;
        UIButton *rebackButton = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
        [rebackButton addTarget:self action:@selector(redrawButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *reminderItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"催办"];
        self.navigationItem.rightBarButtonItem = reminderItem;
        UIButton *reminderButton = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
        [reminderButton addTarget:self action:@selector(remindHandleProcess) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *seeItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"查看流程"];
        self.navigationItem.rightBarButtonItem = seeItem;
        
        UIButton *seeButton = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
        [seeButton addTarget:self action:@selector(lookupProcess:) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:seeItem,reminderItem,rebackItem,nil];
        
    }
    
    else {
        UIBarButtonItem *backItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"返回"];
        self.navigationItem.leftBarButtonItem = backItem;
        UIButton *backButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
        [backButton addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *seeItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"查看流程"];
        self.navigationItem.rightBarButtonItem = seeItem;
        
        UIButton *seeButton = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
        [seeButton addTarget:self action:@selector(lookupProcess:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (NSDictionary *)getValueData{
    NSMutableDictionary *dicValues = [NSMutableDictionary dictionaryWithCapacity:15];

    NSString *isLastProcess = [self.infoDict objectForKey:@"Hy_IfLastTache"];
    NSString *modid = [self.infoDict objectForKey:@"modid"];
    
    SystemConfigContext *context = [SystemConfigContext sharedInstance];
    NSDictionary *loginUsr = [context getUserInfo];
    NSString *user = [loginUsr objectForKey:@"userId"];
    
    [dicValues setValue:modid forKey:@"Hy_mdid"];
    [dicValues setValue:isLastProcess forKey:@"Hy_IfLastTache"];
    [dicValues setValue:user forKey:@"Hy_userid"];
    [dicValues setValue:self.docid forKey:@"Hy_docid"];
    [dicValues setValue:self.swlxTxt.text forKey:@"Hy_SWLY"];
    [dicValues setValue:self.swnfTxt.text forKey:@"Hy_YEAR"];
    [dicValues setValue:self.swbhTxt.text forKey:@"Hy_BH"];
    [dicValues setValue:self.registerLabel.text forKey:@"Hy_DJR"];
    [dicValues setValue:self.registerDateLabel.text forKey:@"Hy_DJRQ"];
    [dicValues setValue:self.scretLevelTxt.text forKey:@"Hy_MJ"];
    [dicValues setValue:self.swrqTxt.text forKey:@"Hy_SWRQ"];
    [dicValues setValue:self.urgentTxt.text forKey:@"Hy_HJ"];
    [dicValues setValue:self.typeTxt.text forKey:@"Hy_LB"];
    [dicValues setValue:self.titleView.text forKey:@"Hy_BT"];
    [dicValues setValue:self.waysTxt.text forKey:@"Hy_LZFS"];
    [dicValues setValue:self.lwlxTxt.text forKey:@"Hy_LWLB"];
    [dicValues setValue:self.lwnfTxt.text forKey:@"Hy_LWNF"];
    [dicValues setValue:self.lwwhTxt.text forKey:@"Hy_LWBH"];    
    [dicValues setValue:self.numbersTxt.text forKey:@"Hy_numbers"];
    [dicValues setValue:self.pagesTxt.text forKey:@"Hy_pages"];
    [dicValues setValue:self.archiveTxt.text forKey:@"Hy_SFGD"];
    [dicValues setValue:self.deadlineTxt.text forKey:@"Hy_BLQX"];
    [dicValues setValue:self.ldqfTxtView.text forKey:@"Hy_LDYJ"];
    [dicValues setValue:self.distriTxtView.text forKey:@"Hy_SWFFYJ"];
    [dicValues setValue:self.auditTxtView.text forKey:@"Hy_XZYJ"];
    [dicValues setValue:self.opinionTxtView.text forKey:@"Hy_TBYJ"];
    
    return dicValues;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
       
    self.title = self.process;
    self.ldqfTxtView1.text = [self.infoDict objectForKey:@"Hy_Ldyj_Histroy"];
self.distriTxtView1.text = [self.infoDict objectForKey:@"Hy_Swffyj_Histroy"];
    
    self.swrqTxt.text = [self.infoDict objectForKey:@"Hy_Swrq"];
    self.swlxTxt.text = [self.infoDict objectForKey:@"Hy_Swlx"];
    self.swnfTxt.text = [self.infoDict objectForKey:@"Hy_Swnf"];
    self.swbhTxt.text = [self.infoDict objectForKey:@"Hy_Swbh"];
    
    self.lwlxTxt.text = [self.infoDict objectForKey:@"Hy_Lwlx"];
    self.lwnfTxt.text = [self.infoDict objectForKey:@"Hy_Lwnf"];
    self.lwwhTxt.text = [self.infoDict objectForKey:@"Hy_Lwwh"];
    
    self.registerLabel.text = [self.infoDict objectForKey:@"Hy_Djr"];
    self.registerDateLabel.text = [self.infoDict objectForKey:@"Hy_Djrq"];
    self.deadlineTxt.text = [self.infoDict objectForKey:@"Hy_Cbqx"];
    self.archiveTxt.text = [self.infoDict objectForKey:@"Hy_Xygdf"];
    
    
    self.titleView.text = [self.infoDict objectForKey:@"Hy_Bt"];
    self.scretLevelTxt.text = [self.infoDict objectForKey:@"Hy_Mj"];
    self.urgentTxt.text = [self.infoDict objectForKey:@"Hy_Hj"];
    self.numbersTxt.text = [self.infoDict objectForKey:@"Hy_Fs"];
    self.pagesTxt.text = [self.infoDict objectForKey:@"Hy_Ys"];
    self.typeTxt.text = [self.infoDict objectForKey:@"Hy_Lb"];
    self.waysTxt.text = [self.infoDict objectForKey:@"Hy_Lzfs"];
    
    
    self.auditTxtView1.text = [self.infoDict objectForKey:@"Hy_Csryyj_Histroy"];
    self.opinionTxtView1.text = [self.infoDict objectForKey:@"Hy_Tbyj_Histroy"];
    
    self.textViewArray = [[NSMutableArray alloc]init];
    
    [self setControlEdit];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Private Methods
- (void)removeActivityView{
    [DejalActivityView removeView];
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
}

-(void)sureContinue
{
    NSDictionary *keyedArguments = [self getValueData];

    NSArray *keys = @[ @"Hy_mdid",@"Hy_IfLastTache",@"Hy_docid", @"Hy_userid", @"Hy_SWLY", @"Hy_YEAR", @"Hy_BH", @"Hy_DJR", @"Hy_DJRQ", @"Hy_MJ", @"Hy_SWRQ", @"Hy_HJ", @"Hy_LB", @"Hy_BT", @"Hy_LZFS",@"Hy_LWLB", @"Hy_LWNF", @"Hy_LWBH", @"Hy_pages", @"Hy_numbers", @"Hy_SFGD", @"Hy_BLQX", @"Hy_XZYJ", @"Hy_LDYJ", @"Hy_SWFFYJ", @"Hy_TBYJ", @"Hy_NextTacheId", @"Hy_NextTacheName", @"Hy_NextTacheTransactor", @"Hy_NextTachePasser" ];
    
    ContinueProcessViewController *continueProcessViewController = [[ContinueProcessViewController alloc] initWithNibName:@"ContinueProcessViewController" bundle:nil];
    continueProcessViewController.delegate = self.responder;
    continueProcessViewController.parameterDictionary = keyedArguments;
    continueProcessViewController.paramsAry = keys;
    continueProcessViewController.currentProcessName = self.process;
    continueProcessViewController.serviceName = @"XJZXReceiveContinuteProcess";
    [self.navigationController pushViewController:continueProcessViewController animated:YES];
}

- (void)transferToNextStep{
    
    NSDictionary *keyedValue = [self getValueData];
    NSArray *keys = @[ @"Hy_mdid",@"Hy_IfLastTache",@"Hy_docid", @"Hy_userid", @"Hy_SWLY", @"Hy_YEAR", @"Hy_BH", @"Hy_DJR", @"Hy_DJRQ", @"Hy_MJ", @"Hy_SWRQ", @"Hy_HJ", @"Hy_LB", @"Hy_BT", @"Hy_LZFS",@"Hy_LWLB", @"Hy_LWNF", @"Hy_LWBH", @"Hy_pages", @"Hy_numbers", @"Hy_SFGD", @"Hy_BLQX", @"Hy_XZYJ", @"Hy_LDYJ", @"Hy_SWFFYJ",@"Hy_TBYJ",@"Hy_NextTacheId",@"Hy_NextTacheName",@"Hy_NextTacheTransactor",@"Hy_NextTachePasser" ];
    
    NSString *strUrl = [ServiceUrlString generateOAWebServiceUrl];
    NSMutableDictionary *keyedArguments = [[NSMutableDictionary alloc] initWithDictionary:keyedValue];
    [keyedArguments setObject:@"*" forKey:@"Hy_NextTacheId"];
    [keyedArguments setObject:@"*" forKey:@"Hy_NextTacheName"];
    [keyedArguments setObject:@"" forKey:@"Hy_NextTacheTransactor"];
    [keyedArguments setObject:@"" forKey:@"Hy_NextTachePasser"];
    NSString *params = [WebServiceHelper createParametersWithKeys:keys andValues:keyedArguments];
    
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:@"XJZXReceiveContinuteProcess" nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
    self.webServiceType = kWebService_NextProcess;
    [self.webServiceHelper run];
}


#pragma mark -
#pragma mark Handle Event

// -------------------------------------------------------------------------------
//
//  返回导航控制器上一个视图
// -------------------------------------------------------------------------------
- (void)goBackAction{
    [self.navigationController popViewControllerAnimated:YES];
}

// -------------------------------------------------------------------------------
//
//  保存当前流程环节
// -------------------------------------------------------------------------------
- (void)saveToProcess{
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"正在保存数据，请稍候..." width:180];
    
    NSDictionary *keyedArguments = [self getValueData];
    
    NSArray *keys = @[ @"Hy_mdid", @"Hy_docid", @"Hy_userid", @"Hy_SWLY", @"HY_YEAR", @"Hy_bh", @"Hy_DJR", @"Hy_DJRQ", @"Hy_MJ", @"Hy_SWRQ", @"Hy_HJ", @"Hy_LB", @"Hy_BT", @"Hy_LZFS", @"Hy_LWLB", @"Hy_LWNF", @"Hy_LWBH", @"Hy_pages", @"Hy_numbers", @"Hy_SFGD", @"Hy_BLQX", @"Hy_XZYJ", @"Hy_LDYJ", @"Hy_SWFFYJ", @"Hy_TBYJ" ];
    
    NSString *strURL = [ServiceUrlString generateOAWebServiceUrl];
    NSString *params = [WebServiceHelper createParametersWithKeys:keys andValues:keyedArguments ];    
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strURL method:@"XJZXReceiveSaveProcess" nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
    self.webServiceType = kWebService_SaveProcess;
    [self.webServiceHelper run];
    
}

// -------------------------------------------------------------------------------
//
//  跳转到下一个流程环节选择
// -------------------------------------------------------------------------------
- (void)nextToProcess{
    if (self.addTime == NO) {
        for (UITextView *textView in self.textViewArray) {
            if ([textView.text length]) {
                NSString *textStr = [NSString stringWithString:textView.text];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                NSDate *date = [NSDate date];
                NSString *moment =  [dateFormatter stringFromDate:date];
                
                SystemConfigContext *context = [SystemConfigContext sharedInstance];
                NSDictionary *loginUsr = [context getUserInfo];
                NSString *user = [loginUsr objectForKey:@"name"];
                
                NSString *opinionStr = [NSString stringWithFormat:@"%@  (%@ %@)\n",textStr,user,moment];
                
                NSError *error;
                
                //检测日期的正则表达式
                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:DATE options:0 error:&error];
                
                if (regex != nil) {
                    NSTextCheckingResult *firstMatch = [regex firstMatchInString:textStr options:0 range:NSMakeRange(0, [textStr length])];
                    
                    if (!firstMatch) {
                        opinionStr = [NSString stringWithFormat:@"%@  (%@ %@)\n",textStr,user,moment];
                    }
                }
                textView.text = opinionStr;
                [textView resignFirstResponder];
            }
        }
        self.addTime = YES;
    }
    NSString *isLastProcess = [self.infoDict objectForKey:@"Hy_IfLastTache"];
    
    if ([isLastProcess isEqualToString:@"1"]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"点击确定按钮，该文档流转结束。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
        alertView.tag = 101;
        [alertView show];
    }
    
    else {
        [self sureContinue];
    }
}

// -------------------------------------------------------------------------------
//
//  退回当前发文到上一个环节
// -------------------------------------------------------------------------------
- (void)forwardToProcess{
    NSDictionary *keyedArguments = [self getValueData];
    NSString *modid = [keyedArguments objectForKey:@"Hy_mdid"];
    NSString *docid = [keyedArguments objectForKey:@"Hy_docid"];
    
    ReturnBackViewController *returnBack = [[ReturnBackViewController alloc] initWithNibName:@"ReturnBackViewController" bundle:nil];
    returnBack.mdId = modid;
    returnBack.docId = docid;
    returnBack.delegate = self.responder;
    [self.navigationController pushViewController:returnBack animated:YES];
    
}

//环节催办
- (void)remindHandleProcess{
    NSDictionary *keyedArguments = [self getValueData];
    NSString *modid = [keyedArguments objectForKey:@"Hy_mdid"];
    NSString *docid = [keyedArguments objectForKey:@"Hy_docid"];
    
    RemindersViewController *reminder = [[RemindersViewController alloc] initWithNibName:@"RemindersViewController" bundle:nil];
    reminder.modID = modid;
    reminder.docID = docid;
    reminder.delegate = self.responder;
    [self.navigationController pushViewController:reminder animated:YES];
}


- (void)redrawButtonClick:(id)sender
{
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"正在收回，请稍候..." width:180];
    
    NSDictionary *keyedArguments = [self getValueData];
    NSString *modid = [keyedArguments objectForKey:@"Hy_mdid"];
    NSString *docid = [keyedArguments objectForKey:@"Hy_docid"];
    NSString *userid = [keyedArguments objectForKey:@"Hy_userid"];
        
    NSString *strURL = [ServiceUrlString generateOAWebServiceUrl];
    NSString *params = [WebServiceHelper createParametersWithKey:@"Hy_userid" value:userid,@"Hy_mdid",modid,@"docid",docid,nil];
    
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strURL method:@"reback" nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
    self.webServiceType = kWebService_Reback;
    [self.webServiceHelper run];
    
}

- (void)lookupProcess:(id)sender {
    NSString *modid = [self.infoDict objectForKey:@"modid"];
    LookUpProcessViewController *lookup = [[LookUpProcessViewController alloc] initWithNibName:@"LookUpProcessViewController" bundle:nil];
    lookup.modid = modid;
    lookup.docid = self.docid;
    [self.navigationController pushViewController:lookup animated:YES];
}


- (IBAction)modifyData:(UIButton *)sender
{
    NSInteger tag = sender.tag;
    
    ContentEditViewController *contentEditViewController = [[ContentEditViewController alloc] init];
    contentEditViewController.delegate = self;
        
     if(tag == 1) {
        //领导签发
        contentEditViewController.editorType = KEditor_Type_SRYJ;
        contentEditViewController.editorTitle = @"领导签发";
        contentEditViewController.oldValue = self.ldqfTxtView.text;
        contentEditViewController.serviceName = @"returnPersonOpinionList";
        self.txtView = self.ldqfTxtView;
    }
    
    else if(tag == 2) {
        //收文分发
        contentEditViewController.editorType = KEditor_Type_SRYJ;
        contentEditViewController.editorTitle = @"收文分发意见";
        contentEditViewController.oldValue = self.distriTxtView.text;
        contentEditViewController.serviceName = @"returnPersonOpinionList";
        self.txtView = self.distriTxtView;
    }
    
    else if(tag == 3) {
        //小组意见
        contentEditViewController.editorType = KEditor_Type_SRYJ;
        contentEditViewController.editorTitle = @"小组人员意见";
        contentEditViewController.oldValue = self.auditTxtView.text;
        contentEditViewController.serviceName = @"returnPersonOpinionList";
        self.txtView = self.auditTxtView;
    }
    
    else if(tag == 4) {
        //退办意见
        contentEditViewController.editorType = KEditor_Type_SRYJ;
        contentEditViewController.editorTitle = @"退办意见";
        contentEditViewController.oldValue = self.opinionTxtView.text;
        contentEditViewController.serviceName = @"returnPersonOpinionList";
        self.txtView = self.opinionTxtView;
    }
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:contentEditViewController];
    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    navigationController.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:navigationController animated:YES];
}

- (IBAction)clearInputOpinion:(id)sender {
    NSInteger tag = [sender tag];
    switch (tag) {
        case 1:
            self.ldqfTxtView.text = @"";
            break;
        case 2:
            self.distriTxtView.text = @"";
            break;
        case 3:
            self.auditTxtView.text = @"";
            break;
        default:
            self.opinionTxtView.text = @"";
    }
}

- (IBAction)selectOfficeDocumentSN:(id)sender{
    
    SNSelectViewController *snSelectViewController = [[SNSelectViewController alloc] init];
    snSelectViewController.contentSizeForViewInPopover = CGSizeMake(360, 216);
    snSelectViewController.serviceName = @"XJZXFileInResource";
    snSelectViewController.delegate = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:snSelectViewController];
    
    UIPopoverController *tmppopover = [[UIPopoverController alloc] initWithContentViewController:navigationController];
    self.popController = tmppopover;
    [self.popController presentPopoverFromRect:self.swbhTxt.frame
                                        inView:self.view
                      permittedArrowDirections:UIPopoverArrowDirectionAny
                                      animated:YES];
}
-(IBAction)touchFromDate:(id)sender{
    
    NSInteger tag = [sender tag];
    if (tag == 201) {
        self.txtCtrl = self.swrqTxt;
    }
    if (tag == 202) {
        self.txtCtrl = self.deadlineTxt;
    }
    
    PopupDateViewController *dateController = [[PopupDateViewController alloc] initWithPickerMode:UIDatePickerModeDate];
    dateController.delegate = self;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dateController];
    
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
    
    self.popController = popover;
    
	[self.popController presentPopoverFromRect:self.txtCtrl.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)selectCommenWords:(id)sender{
    
    NSArray *listArray = nil;
    if ([sender tag] == 301) {
        self.txtCtrl = self.archiveTxt;
        listArray = @[@"是",@"否"];
    }
    else if([sender tag] == 302){
        self.txtCtrl = self.scretLevelTxt;
        listArray = @[@"普通",@"秘密",@"机密",@"绝密"];
    }
    else if([sender tag] == 303){
        self.txtCtrl = self.urgentTxt;
        listArray = @[@"一般",@"急件",@"特急"];
    }
    else if([sender tag] == 304){
        self.txtCtrl = self.typeTxt;
        listArray = @[@"办件",@"阅件",@"传阅件"];
    }
    else{
        self.txtCtrl = self.waysTxt;
        listArray = @[@"电子流转",@"纸质流转"];
    }

    CommenWordsViewController *tmpController = [[CommenWordsViewController alloc] initWithNibName:@"CommenWordsViewController" bundle:nil ];
	tmpController.contentSizeForViewInPopover = CGSizeMake(200, 44*[listArray count]);
	tmpController.delegate = self;
    tmpController.wordsAry = listArray;
    UIPopoverController *tmppopover = [[UIPopoverController alloc] initWithContentViewController:tmpController];
    self.popController = tmppopover;
    [self.popController presentPopoverFromRect:self.txtCtrl.frame
                                        inView:self.view
                      permittedArrowDirections:UIPopoverArrowDirectionAny
                                      animated:YES];
}


#pragma mark -
#pragma mark PopupDateDelegate
- (void)PopupDateController:(PopupDateViewController *)controller Saved:(BOOL)bSaved selectedDate:(NSDate*)date {
    [self.popController dismissPopoverAnimated:YES];
	if (bSaved) {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd"];
		NSString *dateString = [dateFormatter stringFromDate:date];
        self.txtCtrl.text =  dateString;
	}
}

#pragma mark -
#pragma mark GetOfficeDocumentSNDelegate
- (void)returnOfficeDocumnetSave:(BOOL)isSave Type:(NSString *)lb Year:(NSString *)nf Serial:(NSString *)lsh{
    [self.popController dismissPopoverAnimated:YES];
    if (!isSave) {
        return;
    }
    
    self.swlxTxt.text = lb;
    self.swnfTxt.text = nf;
    self.swbhTxt.text = lsh;
}

#pragma mark -
#pragma mark WordsDelegate
- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row {
    
    if(self.popController.popoverVisible) {
        [self.popController dismissPopoverAnimated:YES];
    }
    self.txtCtrl.text = words;
}

#pragma mark -
#pragma mark ContentEditDelegate

- (void)passWithNewValue:(NSString *)newValue Type:(NSString *)type {
    if ([type isEqualToString:@"UITextView"]) {
        
        self.txtView.editable = YES;
        self.txtView.text = newValue;
    }
    else {
        
        self.txtCtrl.text = newValue;
    }
}

#pragma mark -
#pragma mark UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *otherAry = nil;
    if (section == 0) {
        otherAry = [self.infoDict objectForKey:@"Hy_Fj1"];
        if(otherAry == nil || otherAry.count == 0)
        {
            return 1;
        }
 
    }
    
    else {
        otherAry = [self.infoDict objectForKey:@"Hy_Fj2"];
        if(otherAry == nil || otherAry.count == 0)
        {
            return 1;
        }

    }
    
    return otherAry.count;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectZero];
    headerView.font = [UIFont systemFontOfSize:19.0];
    headerView.backgroundColor = [UIColor colorWithRed:214.f/255.f green:234.f/255.f blue:254.f/255.f alpha:1.0];
    headerView.textColor = [UIColor blackColor];
    if (section == 0)  headerView.text = @"  正文附件";
    else headerView.text = @"  其他附件";
    return headerView;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0)
    {
        static NSString *CellIdentifier = @"FJ_Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        NSArray *tifAry = [self.infoDict objectForKey:@"Hy_Fj1"];
        if(tifAry == nil || tifAry.count == 0)
        {
            cell.textLabel.text = @"暂无TIF附件信息";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else
        {
            cell.textLabel.text = [[tifAry objectAtIndex:indexPath.row] objectForKey:@"filename"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    else 
    {
        static NSString *CellIdentifier = @"QT_Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        NSArray *docAry = [self.infoDict objectForKey:@"Hy_Fj2"];
        if(docAry == nil || docAry.count == 0)
        {
            cell.textLabel.text = @"暂无其他非Word附件信息";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else
        {
            cell.textLabel.text = [[docAry objectAtIndex:indexPath.row] objectForKey:@"filename"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    
    return cell;
    
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *fileName = @"";
    NSString *fileUrl = @"";
   if (indexPath.section == 0)
    {
        NSArray *ary = [self.infoDict objectForKey:@"Hy_Fj1"];
        if(ary.count == 0 || ary == nil)
        {
            return;
        }
        
        NSDictionary *docDict = [[self.infoDict objectForKey:@"Hy_Fj1"] objectAtIndex:indexPath.row];
        if(docDict != nil && [docDict objectForKey:@"fileurl"] != nil)
        {
            fileName = [docDict objectForKey:@"filename"];
            fileUrl = [docDict objectForKey:@"fileurl"];
            DisplayAttachFileController *display = [[DisplayAttachFileController alloc] initWithNibName:@"DisplayAttachFileController" fileURL:fileUrl andFileName:fileName];
            [self.navigationController pushViewController:display animated:YES];
        }
    }
    
    else 
    {
        NSArray *ary = [self.infoDict objectForKey:@"Hy_Fj2"];
        if(ary.count == 0 || ary == nil)
        {
            return;
        }
        
        NSDictionary *docDict = [[self.infoDict objectForKey:@"Hy_Fj2"] objectAtIndex:indexPath.row];
        if(docDict != nil && [docDict objectForKey:@"fileurl"] != nil)
        {
            fileName = [docDict objectForKey:@"filename"];
            fileUrl = [docDict objectForKey:@"fileurl"];
            DisplayAttachFileController *display = [[DisplayAttachFileController alloc] initWithNibName:@"DisplayAttachFileController" fileURL:fileUrl andFileName:fileName];
            [self.navigationController pushViewController:display animated:YES];
        }
    }
}


#pragma mark -
#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 101) {
        if (buttonIndex == 0) {
            [self transferToNextStep];
        }
    }
    else if ([alertView.message isEqualToString:@"文档流转结束!"] || [alertView.message isEqualToString:@"收回操作成功!"]) {
        
        [self.delegate HandleGWResult:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }

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
    
    if (self.webServiceType == kWebService_SaveProcess) {
        WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:@"XJZXReceiveSaveProcessReturn" andWithJSONDelegate:self];
        webDataHelper.serviceTag = kWebService_SaveProcess;
        [webDataHelper parseXMLData:webData];
    }
    else if (self.webServiceType == kWebService_NextProcess) {
        WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:@"XJZXReceiveContinuteProcessReturn" andWithJSONDelegate:self];
        webDataHelper.serviceTag = kWebService_NextProcess;
        [webDataHelper parseXMLData:webData];
    }
    
    else  {
        WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:@"rebackReturn" andWithJSONDelegate:self];
        webDataHelper.serviceTag = kWebService_Reback;
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
        NSString *status = [tmpParsedJsonDict objectForKey:@"status"];
        if (self.webServiceType == kWebService_SaveProcess) {
            [self removeActivityView];
            if ([status isEqualToString:@"0"]) {
                [self showAlertMessage:@"保存操作成功!"];            }
            else {
                [self showAlertMessage:@"收回操作失败，请稍候重试!"];
            }
            
        }
        else if(self.webServiceType == kWebService_NextProcess) {
            
            [self removeActivityView];
            if ([status isEqualToString:@"0"]) {
                [self showAlertMessage:@"文档流转结束!"];
                
            }
            else {
                [self showAlertMessage:@"流转操作失败，请稍候重试!"];
            }
        }
        
        else {
            
            [self removeActivityView];
            if ([status isEqualToString:@"0"]) {
                [self showAlertMessage:@"收回操作成功!"];
            }
            else {
                [self showAlertMessage:@"收回操作失败，请稍候重试!"];
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
