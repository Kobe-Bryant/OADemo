//
//  FileOutDetailViewController.m
//  NingBoOA
//
//  Created by 熊熙 on 13-9-29.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PublicOpinionDetailViewController.h"
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

@interface PublicOpinionDetailViewController ()

@property (strong, nonatomic) UIPopoverController *popController;
@end

@implementation PublicOpinionDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)setControlEdit{
    UIScrollView *scrollView = (UIScrollView *)self.view;
    [scrollView setContentSize:CGSizeMake(768, 1880)];
    
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
        
        
        if ([self.process isEqualToString:@"舆情登记"]) {
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
            
            else if([ctrlEdit isEqualToString:@"Hy_Swbh"]){
                self.yqbhBtn.enabled = YES;
                self.yqbhBtn.hidden = NO;
            }

            else if([ctrlEdit isEqualToString:@"Hy_Ftsj"]){
                self.ftsjTxt.borderStyle = UITextBorderStyleRoundedRect;
                self.ftsjBtn.enabled = YES;
                self.ftsjBtn.hidden  = NO;
            }
            
            else if([ctrlEdit isEqualToString:@"Hy_Fbwz"]) {
                self.fbwzTxt.borderStyle = UITextBorderStyleRoundedRect;
                self.fbwzBtn.enabled = YES;
                self.fbwzBtn.hidden  = NO;
            }


            else if([ctrlEdit isEqualToString:@"Hy_Blqx"]){
                self.blqxTxt.borderStyle = UITextBorderStyleRoundedRect;
        
                self.blqxBtn.hidden = NO;
                self.blqxBtn.enabled = YES;
            }
            
            else if([ctrlEdit isEqualToString:@"Hy_Ytwz"]){
                self.ytwzTxt.borderStyle = UITextBorderStyleRoundedRect;
                self.ytwzTxt.enabled = YES;
            }
            
            else if([ctrlEdit isEqualToString:@"Hy_Ftrwm"]){
                self.ftrTxt.borderStyle = UITextBorderStyleRoundedRect;
                self.ftrTxt.enabled = YES;
            }
            
            else if([ctrlEdit isEqualToString:@"Hy_Qy"]) {
                self.locTxt.borderStyle = UITextBorderStyleRoundedRect;
            
                self.locBtn.enabled = YES;
                self.locBtn.hidden = NO;
            }
            
            else if([ctrlEdit isEqualToString:@"Hy_Sfgk"]) {
                self.sfgkTxt.borderStyle = UITextBorderStyleRoundedRect;
                
                self.sfgkBtn.hidden = NO;
                self.sfgkBtn.enabled = YES;
            }
            
            else if([ctrlEdit isEqualToString:@"Hy_Bt"]){
                self.titleView.layer.borderColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0].CGColor;
                
                self.titleView.layer.borderWidth =1.5;
                self.titleView.layer.cornerRadius =6.0;
                self.titleView.editable = YES;

            }
            
            else if([ctrlEdit isEqualToString:@"Hy_Zynr"]){
                self.contentView.layer.borderColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0].CGColor;
                
                self.contentView.layer.borderWidth =1.5;
                self.contentView.layer.cornerRadius =6.0;
                self.contentView.editable = YES;
                
            }
            
            else if([ctrlEdit isEqualToString:@"Hy_Hj"]){
                self.urgentTxt.borderStyle = UITextBorderStyleRoundedRect;
                
                self.urgentBtn.hidden = NO;
                self.urgentBtn.enabled = YES;
            }
            
            else if([ctrlEdit isEqualToString:@"Hy_Xjxxzxybyj"]) {
                CGRect frame = CGRectMake(530, 558, 204, 58);
                self.officeTxtView1.frame = frame;
                
                self.officeTxtView.layer.borderColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0].CGColor;
                
                self.officeTxtView.layer.borderWidth =1.5;
                self.officeTxtView.layer.cornerRadius =6.0;
                
                self.inputOffice.hidden = NO;
                self.inputOffice.enabled = YES;
                
                self.clearOffice.hidden = NO;
                self.clearOffice.enabled = YES;
            }
   
            
            else if([ctrlEdit isEqualToString:@"Hy_Ldyj"]) {
                
                CGRect frame = CGRectMake(530, 708, 204, 58);
                
                self.ldqfTxtView1.frame = frame;
                
                self.ldqfTxtView.layer.borderColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0].CGColor;
                
                self.ldqfTxtView.layer.borderWidth =1.5;
                self.ldqfTxtView.layer.cornerRadius =6.0;
                
                self.inputLdqf.hidden = NO;
                self.inputLdqf.enabled = YES;
                self.clearLdqf.hidden = NO;
                self.clearLdqf.enabled = YES;
            }
            
            else if([ctrlEdit isEqualToString:@"Hy_Yqffyj"]) {
                CGRect frame = CGRectMake(530, 858, 204, 58);
                
                self.distriTxtView1.frame = frame;
                
                self.distriTxtView.layer.borderColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0].CGColor;
                
                self.distriTxtView.layer.borderWidth =1.5;
                self.distriTxtView.layer.cornerRadius =6.0;
                
                self.inputDistri.hidden = NO;
                self.inputDistri.enabled = YES;
                
                self.clearDistri.hidden = NO;
                self.clearDistri.enabled = YES;

            }
            
            else if([ctrlEdit isEqualToString:@"Hy_Yqblyj"]) {
                CGRect frame = CGRectMake(530, 1008, 204, 58);
                self.handlerTxtView1.frame = frame;
                
                self.handlerTxtView.layer.borderColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0].CGColor;
                
                self.handlerTxtView.layer.borderWidth =1.5;
                self.handlerTxtView.layer.cornerRadius =6.0;
                
                self.inputHandler.hidden = NO;
                self.inputHandler.enabled = YES;
                
                self.clearHandler.hidden = NO;
                self.clearHandler.enabled = YES;
            }

            
            else if([ctrlEdit isEqualToString:@"Hy_Csryyj"]) {
                CGRect frame = CGRectMake(530, 1158, 204, 58);
                
                self.auditTxtView1.frame = frame;
                
                self.auditTxtView.layer.borderColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0].CGColor;
                
                self.auditTxtView.layer.borderWidth =1.5;
                self.auditTxtView.layer.cornerRadius =6.0;
                
                self.inputAudit.hidden = NO;
                self.inputAudit.enabled = YES;
                
                self.clearAudit.hidden = NO;
                self.clearAudit.enabled = YES;
            }
            
            else if([ctrlEdit isEqualToString:@"Hy_Tbyj"]) {
                CGRect frame = CGRectMake(530, 1308, 208, 100);
                self.opinionTxtView1.frame = frame;
                
                self.opinionTxtView.layer.borderColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0].CGColor;
                
                self.opinionTxtView.layer.borderWidth =1.5;
                self.opinionTxtView.layer.cornerRadius =6.0;
                
                self.inputOpinion.hidden = NO;
                self.inputOpinion.enabled = YES;
                
                self.clearOpinion.hidden = NO;
                self.clearOpinion.enabled = YES;
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
    
    [dicValues setValue:self.yqlbTxt.text forKey:@"Hy_LB"];
    [dicValues setValue:self.yqnfTxt.text forKey:@"Hy_NF"];
    [dicValues setValue:self.yqbhTxt.text forKey:@"Hy_BH"];
    [dicValues setValue:self.registerLabel.text forKey:@"Hy_DJR"];
    [dicValues setValue:self.registerDateLabel.text forKey:@"Hy_DJRQ"];
    [dicValues setValue:self.sfgkTxt.text forKey:@"Hy_SFGK"];
    [dicValues setValue:self.locTxt.text forKey:@"Hy_QY"];
    [dicValues setValue:self.ftsjTxt.text forKey:@"Hy_FTSJ"];
    [dicValues setValue:self.fbwzTxt.text forKey:@"Hy_FBWZ"];
    [dicValues setValue:self.titleView.text forKey:@"Hy_BT"];
    [dicValues setValue:self.ftrTxt.text forKey:@"Hy_FTRWM"];
    [dicValues setValue:self.ytwzTxt.text forKey:@"Hy_YTWZ"];
    [dicValues setValue:self.urgentTxt.text forKey:@"Hy_HJ"];
    [dicValues setValue:self.blqxTxt.text forKey:@"Hy_BLQX"];
    [dicValues setValue:self.contentView.text forKey:@"Hy_ZYNR"];
    [dicValues setValue:self.officeTxtView.text forKey:@"Hy_XJZXYBYJ"];
    
    [dicValues setValue:self.ldqfTxtView.text forKey:@"Hy_LDYH"];
    [dicValues setValue:self.distriTxtView.text forKey:@"Hy_YQFFYJ"];
    [dicValues setValue:self.handlerTxtView.text forKey:@"Hy_YQCLYJ"];
    [dicValues setValue:self.auditTxtView.text forKey:@"Hy_CSRYYJ"];
    [dicValues setValue:self.opinionTxtView.text forKey:@"Hy_TBYJ"];
    
    return dicValues;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
       
    self.title = self.process;
    
    self.yqlbTxt.text = [self.infoDict objectForKey:@"Hy_Swlx"];
    self.yqnfTxt.text = [self.infoDict objectForKey:@"Hy_Swnf"];
    self.yqbhTxt.text = [self.infoDict objectForKey:@"Hy_Swbh"];
    self.ftsjTxt.text = [self.infoDict objectForKey:@"Hy_Ftsj"];
    self.fbwzTxt.text = [self.infoDict objectForKey:@"Hy_Fbwz"];
    self.ytwzTxt.text = [self.infoDict objectForKey:@"Hy_Ytwz"];
    self.ftrTxt.text  = [self.infoDict objectForKey:@"Hy_Ftrwm"];
    self.locTxt.text  = [self.infoDict objectForKey:@"Hy_Qy"];
    
    self.registerLabel.text = [self.infoDict objectForKey:@"Hy_Djr"];
    self.registerDateLabel.text = [self.infoDict objectForKey:@"Hy_Djrq"];
    self.blqxTxt.text = [self.infoDict objectForKey:@"Hy_Blqx"];
    self.titleView.text = [self.infoDict objectForKey:@"Hy_Bt"];
    self.contentView.text = [self.infoDict objectForKey:@"Hy_Zynr"];
    self.sfgkTxt.text = [self.infoDict objectForKey:@"Hy_Sfgk"];
    self.urgentTxt.text = [self.infoDict objectForKey:@"Hy_Hj"];
    
    
    self.ldqfTxtView1.text = [self.infoDict objectForKey:@"Hy_Ldyj_Histroy"];
    self.distriTxtView1.text = [self.infoDict objectForKey:@"Hy_Yqffyj_Histroy"];
    self.handlerTxtView.text = [self.infoDict objectForKey:@"Hy_Yqblyj_Histroy"];
    self.auditTxtView1.text = [self.infoDict objectForKey:@"Hy_Csryyj_Histroy"];
    self.officeTxtView1.text = [self.infoDict objectForKey:@"Hy_Xjxxzxybyj_Histroy"];
    self.opinionTxtView1.text = [self.infoDict objectForKey:@"Hy_Tbyj_Histroy"];
    
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
    NSArray *keys = @[ @"Hy_mdid",@"Hy_IfLastTache", @"Hy_docid", @"Hy_userid", @"Hy_LB", @"Hy_NF", @"Hy_BH", @"Hy_DJR", @"Hy_DJRQ", @"Hy_SFGK", @"Hy_QY", @"Hy_FTSJ", @"Hy_FBWZ", @"Hy_BT", @"Hy_FTRWM", @"Hy_YTWZ", @"Hy_HJ", @"Hy_BLQX", @"Hy_ZYNR", @"Hy_XJZXYBYJ", @"Hy_LDYH", @"Hy_YQFFYJ", @"Hy_YQCLYJ", @"Hy_CSRYYJ", @"Hy_TBYJ", @"Hy_NextTacheId", @"Hy_NextTacheName", @"Hy_NextTacheTransactor", @"Hy_NextTachePasser" ];
    
    ContinueProcessViewController *continueProcessViewController = [[ContinueProcessViewController alloc] initWithNibName:@"ContinueProcessViewController" bundle:nil];
    continueProcessViewController.delegate = self.responder;
    continueProcessViewController.parameterDictionary = keyedArguments;
    continueProcessViewController.paramsAry = keys;
    continueProcessViewController.currentProcessName = self.process;
    continueProcessViewController.serviceName = @"PublicOpinionContinuteProcess";
    [self.navigationController pushViewController:continueProcessViewController animated:YES];
}

- (void)transferToNextStep{
    NSDictionary *keyedValue = [self getValueData];
    NSArray *keys = @[ @"Hy_mdid",@"Hy_IfLastTache", @"Hy_docid", @"Hy_userid", @"Hy_LB", @"Hy_NF", @"Hy_BH", @"Hy_DJR", @"Hy_DJRQ", @"Hy_SFGK", @"Hy_QY", @"Hy_FTSJ", @"Hy_FBWZ", @"Hy_BT", @"Hy_FTRWM", @"Hy_YTWZ", @"Hy_HJ", @"Hy_BLQX", @"Hy_ZYNR", @"Hy_XJZXYBYJ", @"Hy_LDYH", @"Hy_YQFFYJ", @"Hy_YQCLYJ", @"Hy_CSRYYJ", @"Hy_TBYJ", @"Hy_NextTacheId", @"Hy_NextTacheName", @"Hy_NextTacheTransactor", @"Hy_NextTachePasser" ];
    
    NSMutableDictionary *keyedArguments = [[NSMutableDictionary alloc] initWithDictionary:keyedValue];
    [keyedArguments setObject:@"*" forKey:@"Hy_NextTacheId"];
    [keyedArguments setObject:@"*" forKey:@"Hy_NextTacheName"];
    [keyedArguments setObject:@"" forKey:@"Hy_NextTacheTransactor"];
    [keyedArguments setObject:@"" forKey:@"Hy_NextTachePasser"];
    
    NSString *strURL = [ServiceUrlString generateOAWebServiceUrl];
    NSString *params = [WebServiceHelper createParametersWithKeys:keys andValues:keyedArguments];
    
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strURL method:@"PublicOpinionContinuteProcess" nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
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
    NSArray *keys = @[ @"Hy_mdid", @"Hy_docid", @"Hy_userid", @"Hy_LB", @"Hy_NF", @"Hy_BH", @"Hy_DJR", @"Hy_DJRQ", @"Hy_SFGK", @"Hy_QY", @"Hy_FTSJ", @"Hy_FBWZ", @"Hy_BT", @"Hy_FTRWM", @"Hy_YTWZ", @"Hy_HJ", @"Hy_BLQX", @"Hy_ZYNR", @"Hy_XJZXYBYJ", @"Hy_LDYH", @"Hy_YQFFYJ", @"Hy_YQCLYJ", @"Hy_CSRYYJ", @"Hy_TBYJ" ];
      
    NSString *strURL = [ServiceUrlString generateOAWebServiceUrl];
    NSString *params =  [WebServiceHelper createParametersWithKeys:keys andValues:keyedArguments];
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strURL method:@"PublicOpinionSaveProcess" nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
    self.webServiceType = kWebService_SaveProcess;
    [self.webServiceHelper run];
    
}

// -------------------------------------------------------------------------------
//
//  跳转到下一个流程环节选择
// -------------------------------------------------------------------------------
- (void)nextToProcess{
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

//催办
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

//收回
- (void)redrawButtonClick:(id)sender
{
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"正在收回文档，请稍候..." width:180];
    
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

//查看流程
- (void)lookupProcess:(id)sender {
    NSDictionary *keyedArguments = [self getValueData];
    NSString *modid = [keyedArguments objectForKey:@"Hy_mdid"];
    NSString *docid = [keyedArguments objectForKey:@"Hy_docid"];
    
    LookUpProcessViewController *lookup = [[LookUpProcessViewController alloc] initWithNibName:@"LookUpProcessViewController" bundle:nil];
    lookup.modid = modid;
    lookup.docid = docid;
    [self.navigationController pushViewController:lookup animated:YES];
}

- (IBAction)modifyData:(UIButton *)sender
{
    NSInteger tag = sender.tag;
    ContentEditViewController *contentEditViewController = [[ContentEditViewController alloc] init];
    contentEditViewController.delegate = self;
    
    if(tag == 0) {
        //发布网站
        contentEditViewController.editorType = kEditor_Type_FBWZ;
        contentEditViewController.editorTitle = @"发布网站";
        contentEditViewController.oldValue = self.fbwzTxt.text;
        contentEditViewController.serviceName = @"GetPublicOpinionSite";
        self.txtCtrl = self.fbwzTxt;
    }
    
    else if(tag == 1) {
        //区域
        contentEditViewController.editorType = kEditor_Type_SSQY;
        contentEditViewController.editorTitle = @"所属区域";
        contentEditViewController.oldValue = self.locTxt.text;
        contentEditViewController.serviceName = @"GetPublicOpinionLocation";
        self.txtCtrl = self.locTxt;
    }

     else if(tag == 2) {
        //办公室阅办意见
        contentEditViewController.editorType = KEditor_Type_SRYJ;
        contentEditViewController.editorTitle = @"办公室阅办意见";
        contentEditViewController.oldValue = self.officeTxtView.text;
         contentEditViewController.serviceName = @"returnPersonOpinionList";
        self.txtView = self.officeTxtView;
    }
    
    else if(tag == 3) {
        //领导意见
        contentEditViewController.editorType = KEditor_Type_SRYJ;
        contentEditViewController.editorTitle = @"领导意见";
        contentEditViewController.oldValue = self.ldqfTxtView.text;
        contentEditViewController.serviceName = @"returnPersonOpinionList";
        self.txtView = self.ldqfTxtView;
    }
    
    else if(tag == 4) {
        //舆情分发意见
        contentEditViewController.editorType = KEditor_Type_SRYJ;
        contentEditViewController.editorTitle = @"舆情分发意见";
        contentEditViewController.oldValue = self.distriTxtView.text;
        contentEditViewController.serviceName = @"returnPersonOpinionList";
        self.txtView = self.distriTxtView;
    }
    
    else if(tag == 5) {
        //舆情办理意见
        contentEditViewController.editorType = KEditor_Type_SRYJ;
        contentEditViewController.editorTitle = @"舆情办理意见";
        contentEditViewController.oldValue = self.handlerTxtView.text;
        contentEditViewController.serviceName = @"returnPersonOpinionList";
        self.txtView = self.handlerTxtView;
    }

    else if(tag == 6) {
        //处室人员意见
        contentEditViewController.editorType = KEditor_Type_SRYJ;
        contentEditViewController.editorTitle = @"处室人员意见";
        contentEditViewController.oldValue = self.auditTxtView.text;
        contentEditViewController.serviceName = @"returnPersonOpinionList";
        self.txtView = self.auditTxtView;
    }
    
    else if(tag == 7) {
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
        case 2:
            self.officeTxtView.text = @"";
            break;
        case 3:
            self.ldqfTxtView.text = @"";
            break;
        case 4:
            self.distriTxtView.text = @"";
            break;
        case 5:
            self.handlerTxtView.text = @"";
            break;
        case 6:
            self.auditTxtView.text = @"";
            break;
        default:
            self.opinionTxtView.text = @"";
    }
}

- (IBAction)selectOfficeDocumentSN:(id)sender{
    SNSelectViewController *snSelectViewController = [[SNSelectViewController alloc] init];
    snSelectViewController.contentSizeForViewInPopover = CGSizeMake(360, 216);
    snSelectViewController.serviceName = @"GetPublicOpinionType";
    snSelectViewController.delegate = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:snSelectViewController];
    
    UIPopoverController *tmppopover = [[UIPopoverController alloc] initWithContentViewController:navigationController];
    self.popController = tmppopover;
    [self.popController presentPopoverFromRect:self.yqbhTxt.frame
                                        inView:self.view
                      permittedArrowDirections:UIPopoverArrowDirectionAny
                                      animated:YES];
}

-(IBAction)touchFromDate:(id)sender{
    NSInteger tag = [sender tag];
    if (tag == 101) {
        self.txtCtrl = self.ftsjTxt;
    }
    if (tag == 102) {
        self.txtCtrl = self.blqxTxt;
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
    if ([sender tag] == 201) {
        self.txtCtrl = self.sfgkTxt;
        listArray = @[@"是",@"否"];
    }

    else if([sender tag] == 202){
        self.txtCtrl = self.urgentTxt;
        listArray = @[@"一般",@"急件",@"特急"];
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
    
    self.yqlbTxt.text = lb;
    self.yqnfTxt.text = nf;
    self.yqbhTxt.text = lsh;
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
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *date = [NSDate date];
        NSString *moment =  [dateFormatter stringFromDate:date];
        
        SystemConfigContext *context = [SystemConfigContext sharedInstance];
        NSDictionary *loginUsr = [context getUserInfo];
        NSString *user = [loginUsr objectForKey:@"name"];
        
        NSString *opinionStr = [NSString stringWithFormat:@"\n%@  (%@ %@)\n",newValue,user,moment];
        
        NSError *error;
        
        //检测日期的正则表达式
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:DATE options:0 error:&error];
        
        if (regex != nil) {
            NSTextCheckingResult *firstMatch = [regex firstMatchInString:newValue options:0 range:NSMakeRange(0, [newValue length])];
            
            if (!firstMatch) {
                opinionStr = [NSString stringWithFormat:@"%@  (%@ %@)\n",newValue,user,moment];
            }
        }
        
        self.txtView.editable = YES;
        self.txtView.text = opinionStr;
        [self.txtView becomeFirstResponder];
        
    }
    else {
        
        
        self.txtCtrl.text = newValue;
    }
}


#pragma mark -
#pragma mark UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        NSArray *otherAry = [self.infoDict objectForKey:@"Hy_Fj1"];
        if(otherAry == nil || otherAry.count == 0)
        {
            return 1;
        }
        else {
            return otherAry.count;
        }
    }
    
    return 1;
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
    if (section == 0)  headerView.text = @"  正文信息";
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
        static NSString *CellIdentifier = @"ZW_Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        NSDictionary *doc = [self.infoDict objectForKey:@"Hy_newdoc"];
        if(doc == nil || [doc objectForKey:@"fileurl"] == nil)
        {
            cell.textLabel.text = @"暂无正文信息";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else
        {
            cell.textLabel.text = [doc objectForKey:@"filename"];
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
        NSArray *docAry = [self.infoDict objectForKey:@"Hy_Fj1"];
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
        NSArray *ary = [self.infoDict objectForKey:@"Hy_newdoc"];
        if(ary.count == 0 || ary == nil)
        {
            return;
        }
        
        NSDictionary *doc = [self.infoDict objectForKey:@"Hy_newdoc"];
        if(doc != nil || [doc objectForKey:@"fileurl"] != nil)
        {
            fileName = [doc objectForKey:@"filename"];
            fileUrl = [doc objectForKey:@"fileurl"];
            DisplayAttachFileController *display = [[DisplayAttachFileController alloc] initWithNibName:@"DisplayAttachFileController" fileURL:fileUrl andFileName:fileName];
            [self.navigationController pushViewController:display animated:YES];
        }
        
    }
    else
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
        WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:@"PublicOpinionSaveProcessReturn" andWithJSONDelegate:self];
        webDataHelper.serviceTag = kWebService_SaveProcess;
        [webDataHelper parseXMLData:webData];
    }
    else if (self.webServiceType == kWebService_NextProcess) {
        WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:@"PublicOpinionContinuteProcessReturn" andWithJSONDelegate:self];
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
