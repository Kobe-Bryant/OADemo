//
//  FileOutDetailViewController.m
//  NingBoOA
//
//  Created by 熊熙 on 13-9-29.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "JCZDFileOutDetailViewController.h"
#import "ContinueProcessViewController.h"
#import "RemindersViewController.h"
#import "LookUpProcessViewController.h"
#import "ReturnBackViewController.h"
#import "RebackViewController.h"
#import "DisplayAttachFileController.h"
#import "UICustomButton.h"
#import "HandleGWProtocol.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "SystemConfigContext.h"
#import "DejalActivityView.h"

@interface JCZDFileOutDetailViewController ()
@property (nonatomic,strong) NSMutableArray *textViewArray;
@property (nonatomic,assign) BOOL addTime;
@property (strong, nonatomic) UIPopoverController *popController;

@end

@implementation JCZDFileOutDetailViewController

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
    self.titleView.layer.borderColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0].CGColor;
    
    self.titleView.layer.borderWidth =1.5;
    
    self.titleView.layer.cornerRadius =6.0;
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
        
        
        if ([self.process isEqualToString:@"拟稿"]) {
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
            else if ([ctrlEdit isEqualToString:@"Hy_ZSDW"]) {
                self.sendDWTxt.borderStyle = UITextBorderStyleRoundedRect;
                [self.sendDWBtn setImage:[UIImage imageNamed:@"editing.png"] forState:UIControlStateNormal];
            }
            else if([ctrlEdit isEqualToString:@"Hy_CSDW"]){
                self.csDWTxt.borderStyle = UITextBorderStyleRoundedRect;
                
                [self.csDWBtn setImage:[UIImage imageNamed:@"editing.png"] forState:UIControlStateNormal];
            }
            else if([ctrlEdit isEqualToString:@"Hy_SFGK"]){
                self.publicTypeTxt.borderStyle = UITextBorderStyleRoundedRect;
                
                self.publicTypeBtn.hidden = NO;
                self.publicTypeBtn.enabled = YES;
            }

            else if([ctrlEdit isEqualToString:@"Hy_ZTC"]){
//                CGRect frame = self.topicTxt.frame;
//                CGFloat x = CGRectGetMinX(frame);
//                CGFloat y = CGRectGetMinY(frame);
//                CGFloat height = CGRectGetHeight(frame);
//                self.topicTxt.frame = CGRectMake(x, y, 568, height);
                self.topicTxt.borderStyle = UITextBorderStyleRoundedRect;
                
                self.topicBtn.hidden = NO;
                self.topicBtn.enabled = YES;
            }
            else if([ctrlEdit isEqualToString:@"Hy_Bt"]){

                
                self.titleView.editable = YES;
            }
            else if([ctrlEdit isEqualToString:@"Hy_MMDJ"]){
                self.scretLevelTxt.borderStyle = UITextBorderStyleRoundedRect;
                self.scretLevelTxt.enabled = YES;
            }
            else if([ctrlEdit isEqualToString:@"Hy_hj"]){
                self.urgentTxt.borderStyle = UITextBorderStyleRoundedRect;
                self.urgentBtn.enabled =YES;
                
                self.urgentBtn.hidden = NO;
                self.urgentBtn.enabled = YES;
            }
            else if([ctrlEdit isEqualToString:@"Hy_FS"]){
                self.pagesTxt.borderStyle = UITextBorderStyleRoundedRect;
                self.pagesTxt.enabled = YES;
            }
            else if([ctrlEdit isEqualToString:@"Hy_lb"]) {

                self.fwlbTxt.enabled = YES;
                self.fwnfTxt.enabled = YES;
                self.fwbhTxt.enabled = YES;
                
                self.fwbhBtn.enabled = YES;
                self.fwbhBtn.hidden  = NO;

            }
            
            else if([ctrlEdit isEqualToString:@"Hy_YZRQ"]){
                self.dateTxt.borderStyle = UITextBorderStyleRoundedRect;
                
                self.dateBtn.hidden = NO;
                self.dateBtn.enabled = YES;
            }
            else if([ctrlEdit isEqualToString:@"Hy_LDQFM"]) {
                CGRect frame = CGRectMake(170, 72, 204, 68);
                
                self.ldqfTextView1.frame = frame;
                
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
            else if([ctrlEdit isEqualToString:@"Hy_HQ"]) {
                CGRect frame = CGRectMake(534, 72, 204, 68);
                
                self.hqTxtView1.frame = frame;
                
                self.hqTxtView.layer.borderColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0].CGColor;
                
                self.hqTxtView.layer.borderWidth =1.5;
                self.hqTxtView.layer.cornerRadius =6.0;
                self.hqTxtView.editable = YES;
                
                self.inputHq.hidden = NO;
                self.inputHq.enabled = YES;
                
                self.clearHq.hidden = NO;
                self.clearHq.enabled = YES;
                
                [self.textViewArray addObject:self.hqTxtView];
                
            }
            else if([ctrlEdit isEqualToString:@"Hy_CSSH"]) {
                CGRect frame = CGRectMake(170, 352, 204, 68);
                
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
            
            else if([ctrlEdit isEqualToString:@"Hy_ZRSH"]) {
                CGRect frame = CGRectMake(534, 352, 204, 68);
                
                self.officeTxtView1.frame = frame;
                
                self.officeTxtView.layer.borderColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0].CGColor;
                
                self.officeTxtView.layer.borderWidth =1.5;
                self.officeTxtView.layer.cornerRadius =6.0;
                self.officeTxtView.editable = YES;
                
                self.inputOffice.hidden = NO;
                self.inputOffice.enabled = YES;
                
                self.clearOffice.hidden = NO;
                self.clearOffice.enabled = YES;
                
                [self.textViewArray addObject:self.officeTxtView];
            }
            
            else if([ctrlEdit isEqualToString:@"Hy_Tbyj"]) {
                CGRect frame = CGRectMake(530, 758, 208, 100);
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
    [dicValues setValue:self.paperTxt.text forKey:@"Hy_FWGZ"];
    [dicValues setValue:self.ldqfTxtView.text forKey:@"Hy_LDQFM"];
    [dicValues setValue:self.hqTxtView.text forKey:@"Hy_HQ"];
    [dicValues setValue:self.sendDWTxt.text forKey:@"Hy_ZSDW"];
    [dicValues setValue:self.csDWTxt.text forKey:@"Hy_CSDW"];
    [dicValues setValue:self.publicTypeTxt.text forKey:@"Hy_SFGK"];
    [dicValues setValue:self.auditTxtView.text forKey:@"Hy_KSSH"];
    [dicValues setValue:self.officeTxtView.text forKey:@"Hy_BGSH"];
    [dicValues setValue:self.draftDWLabel.text forKey:@"Hy_ZBDW"];
    
    [dicValues setValue:self.drafterLabel.text forKey:@"Hy_NGR"];
    [dicValues setValue:self.topicTxt.text forKey:@"Hy_ZTC"];
    
    [dicValues setValue:self.titleView.text forKey:@"Hy_BT"];
    [dicValues setValue:self.scretLevelTxt.text forKey:@"Hy_MMDJ"];
    [dicValues setValue:self.urgentTxt.text forKey:@"Hy_HJ"];
    [dicValues setValue:self.fwlbTxt.text forKey:@"Hy_LB"];
    [dicValues setValue:self.fwnfTxt.text forKey:@"Hy_NF"];
    [dicValues setValue:self.fwbhTxt.text forKey:@"Hy_BH"];
    [dicValues setValue:self.pagesTxt.text forKey:@"Hy_FS"];
    [dicValues setValue:self.reviewerTxt.text forKey:@"Hy_JDR"];
    [dicValues setValue:self.dateTxt.text forKey:@"Hy_YZRQ"];
    [dicValues setValue:self.opinionTxtView.text forKey:@"Hy_TBYJ"];
    
    return dicValues;
}

- (void)viewDidAppear:(BOOL)animated {
    self.navigationItem.backBarButtonItem = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = self.process;
    
    self.fwlbTxt.text = [self.infoDict objectForKey:@"Hy_lb"];
    self.fwnfTxt.text = [self.infoDict objectForKey:@"Hy_nf"];
    self.fwbhTxt.text = [self.infoDict objectForKey:@"Hy_bh"];
    self.paperTxt.text = [self.infoDict objectForKey:@"Hy_FWGZ"];
    self.ldqfTextView1.text = [self.infoDict objectForKey:@"Hy_LDQFM_Histroy"];
    self.hqTxtView.text = [self.infoDict objectForKey:@"Hy_HQ_Histroy"];
    self.sendDWTxt.text = [self.infoDict objectForKey:@"Hy_ZSDW"];
    self.csDWTxt.text = [self.infoDict objectForKey:@"Hy_CSDW"];
    self.publicTypeTxt.text = [self.infoDict objectForKey:@"Hy_SFGK"];
    self.drafterLabel.text = [self.infoDict objectForKey:@"Hy_NGR"];
    self.draftDWLabel.text = [self.infoDict objectForKey:@"Hy_ZBDW"];
    self.topicTxt.text = [self.infoDict objectForKey:@"Hy_ZTC"];
    self.titleView.text = [self.infoDict objectForKey:@"Hy_Bt"];
    self.scretLevelTxt.text = [self.infoDict objectForKey:@"Hy_MMDJ"];
    self.dateTxt.text = [self.infoDict objectForKey:@"Hy_YZRQ"];
    self.urgentTxt.text = [self.infoDict objectForKey:@"Hy_hj"];
    self.pagesTxt.text = [self.infoDict objectForKey:@"Hy_FS"];
    self.reviewerTxt.text = [self.infoDict objectForKey:@"Hy_JDR"];
    self.auditTxtView1.text = [self.infoDict objectForKey:@"Hy_CSSH_Histroy"];
    self.officeTxtView1.text = [self.infoDict objectForKey:@"Hy_ZRSH_Histroy"];
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
    NSArray *keys = @[ @"Hy_mdid", @"Hy_IfLastTache", @"Hy_docid", @"Hy_userid", @"Hy_FWGZ", @"Hy_LDQFM", @"Hy_HQ", @"Hy_ZSDW", @"Hy_CSDW", @"Hy_SFGK",  @"Hy_KSSH", @"Hy_BGSH", @"Hy_ZBDW", @"Hy_NGR", @"Hy_ZTC", @"Hy_BT", @"Hy_MMDJ", @"Hy_HJ", @"Hy_LB", @"Hy_NF", @"Hy_BH", @"Hy_FS", @"Hy_JDR", @"Hy_YZRQ", @"Hy_TBYJ", @"Hy_NextTacheId", @"Hy_NextTacheName", @"Hy_NextTacheTransactor", @"Hy_NextTachePasser" ];
    
    ContinueProcessViewController *continueProcessViewController = [[ContinueProcessViewController alloc] initWithNibName:@"ContinueProcessViewController" bundle:nil];
    continueProcessViewController.delegate = self.responder;
    continueProcessViewController.parameterDictionary = keyedArguments;
    continueProcessViewController.paramsAry = keys;
    continueProcessViewController.currentProcessName = self.process;
    continueProcessViewController.serviceName = @"JCZDFileOutContinuteProcess";
    [self.navigationController pushViewController:continueProcessViewController animated:YES];
}

- (void)transferToNextStep{
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"正在保存数据，请稍候..." width:180];
    
    NSDictionary *keyedValue = [self getValueData];
    NSArray *keys = @[ @"Hy_mdid", @"Hy_IfLastTache", @"Hy_docid", @"Hy_userid", @"Hy_FWGZ", @"Hy_LDQFM", @"Hy_HQ", @"Hy_ZSDW", @"Hy_CSDW", @"Hy_SFGK",  @"Hy_KSSH", @"Hy_BGSH", @"Hy_ZBDW", @"Hy_NGR", @"Hy_ZTC", @"Hy_BT", @"Hy_MMDJ", @"Hy_HJ", @"Hy_LB", @"Hy_NF", @"Hy_BH", @"Hy_FS", @"Hy_JDR", @"Hy_YZRQ", @"Hy_TBYJ", @"Hy_NextTacheId", @"Hy_NextTacheName", @"Hy_NextTacheTransactor", @"Hy_NextTachePasser" ];
    
    NSString *strUrl = [ServiceUrlString generateOAWebServiceUrl];
    
    NSMutableDictionary *keyedArguments = [[NSMutableDictionary alloc] initWithDictionary:keyedValue];
    [keyedArguments setObject:@"*" forKey:@"Hy_NextTacheId"];
    [keyedArguments setObject:@"*" forKey:@"Hy_NextTacheName"];
    [keyedArguments setObject:@"" forKey:@"Hy_NextTacheTransactor"];
    [keyedArguments setObject:@"" forKey:@"Hy_NextTachePasser"];
    
    NSString *params = [WebServiceHelper createParametersWithKeys:keys andValues:keyedArguments];
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:@"JCZDFileOutContinuteProcess" nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
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
    
    NSArray *keys = @[ @"Hy_mdid", @"Hy_docid", @"Hy_userid", @"Hy_FWGZ", @"Hy_LDQFM", @"Hy_HQ", @"Hy_ZSDW", @"Hy_CSDW", @"Hy_SFGK", @"Hy_KSSH", @"Hy_BGSH", @"Hy_ZBDW", @"Hy_NGR", @"Hy_ZTC", @"Hy_BT", @"Hy_MMDJ", @"Hy_HJ", @"Hy_LB", @"Hy_NF", @"Hy_BH", @"Hy_FS", @"Hy_JDR", @"Hy_YZRQ", @"Hy_TBYJ" ];
    
    
    NSString *strURL = [ServiceUrlString generateOAWebServiceUrl];
    NSString *params = [WebServiceHelper createParametersWithKeys:keys andValues:keyedArguments];
    
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strURL method:@"JCZDFileOutSaveProcess" nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
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
//  公文流转退回到上一环节
// -------------------------------------------------------------------------------
- (void)forwardToProcess{
    NSDictionary *keyedArguments = [self getValueData];
    NSString *modid = [keyedArguments objectForKey:@"Hy_mdid"];
    NSString *docid = [keyedArguments objectForKey:@"Hy_docid"];
    
    ReturnBackViewController *returnBack = [[ReturnBackViewController alloc] initWithNibName:@"ReturnBackViewController" bundle:nil];
    returnBack.mdId = modid;
    returnBack.docId = docid;
    returnBack.delegate = self.responder;
    returnBack.currentProcess = self.process;
    [self.navigationController pushViewController:returnBack animated:YES];
}

// -------------------------------------------------------------------------------
//  公文流转发送催办消息
// -------------------------------------------------------------------------------
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

// -------------------------------------------------------------------------------
//  公文流转收回当前公文
// -------------------------------------------------------------------------------
- (void)redrawButtonClick:(id)sender
{
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"正在收回文档..." width:180];
    
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

// -------------------------------------------------------------------------------
//  查看公文流转历史环节
// -------------------------------------------------------------------------------
- (void)lookupProcess:(id)sender {
    NSDictionary *keyedArguments = [self getValueData];
    NSString *modid = [keyedArguments objectForKey:@"Hy_mdid"];
    NSString *docid = [keyedArguments objectForKey:@"Hy_docid"];
    
    LookUpProcessViewController *lookup = [[LookUpProcessViewController alloc] initWithNibName:@"LookUpProcessViewController" bundle:nil];
    lookup.modid = modid;
    lookup.docid = docid;
    [self.navigationController pushViewController:lookup animated:YES];
}

-(IBAction)touchFromDate:(id)sender{
    PopupDateViewController *dateController = [[PopupDateViewController alloc] initWithPickerMode:UIDatePickerModeDate];
    dateController.delegate = self;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dateController];
    
    
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
    
    self.popController = popover;
    
	[self.popController presentPopoverFromRect:self.dateTxt.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)modifyData:(UIButton *)sender
{
    NSInteger tag = sender.tag;
    
    ContentEditViewController *contentEditViewController = [[ContentEditViewController alloc] init];
    contentEditViewController.delegate = self;
    
    if (tag == 0) {
        //发文稿纸
        contentEditViewController.editorTitle = @"发文稿纸";
        contentEditViewController.editorType = KEditor_Type_GWGZ;
        contentEditViewController.oldValue = self.paperTxt.text;
        contentEditViewController.serviceName = @"JCZDGetFileOutPaper";
        self.txtCtrl = self.paperTxt;
    }
    
    else if(tag == 1 ){
        //主送单位
        contentEditViewController.editorTitle = @"主送单位";
        contentEditViewController.editorType = kEditor_Type_Dept;
        contentEditViewController.oldValue = self.sendDWTxt.text;
        contentEditViewController.serviceName = @"JCZDGetFileOutUnit";
        self.txtCtrl = self.sendDWTxt;
    }
    else if(tag == 2){
        //抄送单位
        contentEditViewController.editorTitle = @"抄送单位";
        contentEditViewController.editorType = kEditor_Type_Dept;
        contentEditViewController.oldValue = self.csDWTxt.text;
        contentEditViewController.serviceName = @"JCZDGetFileOutUnit";
        self.txtCtrl = self.csDWTxt;
    }
    
    else if(tag == 3){
        //主题词
        contentEditViewController.editorType = kEditor_Type_ZTC;
        contentEditViewController.editorTitle = @"主题词";
        contentEditViewController.oldValue = self.topicTxt.text;
        contentEditViewController.serviceName = @"JCZDGetFileOutTopic";
        self.txtCtrl = self.topicTxt;
    }
    
    else if(tag == 4) {
        //领导签发
        contentEditViewController.editorType = KEditor_Type_SRYJ;
        contentEditViewController.editorTitle = @"领导签发";
        contentEditViewController.oldValue = self.ldqfTxtView.text;
        contentEditViewController.serviceName = @"returnPersonOpinionList";
        self.txtView = self.ldqfTxtView;
    }
    
    else if(tag == 5) {
        //处室会签
        contentEditViewController.editorType = KEditor_Type_SRYJ;
        contentEditViewController.editorTitle = @"处室会签";
        contentEditViewController.oldValue = self.hqTxtView.text;
        contentEditViewController.serviceName = @"returnPersonOpinionList";
        self.txtView = self.hqTxtView;
    }
    else if(tag == 6) {
        //科室审核
        contentEditViewController.editorType = KEditor_Type_SRYJ;
        contentEditViewController.editorTitle = @"科室审核";
        contentEditViewController.oldValue = self.auditTxtView.text;
        contentEditViewController.serviceName = @"returnPersonOpinionList";
        self.txtView = self.auditTxtView;
    }

    else if(tag == 7) {
        //办公室审核
        contentEditViewController.editorType = KEditor_Type_SRYJ;
        contentEditViewController.editorTitle = @"办公室审核";
        contentEditViewController.oldValue = self.officeTxtView.text;
        contentEditViewController.serviceName = @"returnPersonOpinionList";
        self.txtView = self.officeTxtView;
    }
    
    else if(tag == 8) {
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
        case 4:
            self.ldqfTxtView.text = @"";
            break;
        case 5:
             self.hqTxtView.text = @"";
            break;
        case 6:
             self.auditTxtView.text = @"";
        case 7:
             self.officeTxtView.text = @"";
        default:
            self.opinionTxtView.text = @"";
            break;
    }
}

- (IBAction)selectOfficeDocumentSN:(id)sender{
    SNSelectViewController *snSelectViewController = [[SNSelectViewController alloc] init];
    snSelectViewController.contentSizeForViewInPopover = CGSizeMake(360, 216);
    snSelectViewController.serviceName = @"JCZDGetFileOutType";
    snSelectViewController.delegate = self;
    
     UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:snSelectViewController];
    
    UIPopoverController *tmppopover = [[UIPopoverController alloc] initWithContentViewController:navigationController];
    self.popController = tmppopover;
    [self.popController presentPopoverFromRect:self.fwbhTxt.frame
                                        inView:self.view
                      permittedArrowDirections:UIPopoverArrowDirectionAny
                                      animated:YES];
}

- (IBAction)selectCommenWords:(id)sender{
    NSArray *listArray = nil;
    if ([sender tag] == 101) {
        self.txtCtrl = self.publicTypeTxt;
        listArray = @[@"主动公开",@"依申请公开",@"免于公开"];
    }
    else {
        self.txtCtrl = self.urgentTxt;
        listArray = @[@"一般",@"急件",@"特急"];
    }
    
    CommenWordsViewController *tmpController = [[CommenWordsViewController alloc] initWithNibName:@"CommenWordsViewController" bundle:nil ];
	tmpController.contentSizeForViewInPopover = CGSizeMake(200, [listArray count]*44);
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
#pragma mark PopupDateDelegate
- (void)PopupDateController:(PopupDateViewController *)controller Saved:(BOOL)bSaved selectedDate:(NSDate*)date {
    [self.popController dismissPopoverAnimated:YES];
	if (bSaved) {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd"];
		NSString *dateString = [dateFormatter stringFromDate:date];
      self.dateTxt.text =  dateString;
	}
}


#pragma mark -
#pragma mark GetOfficeDocumentSNDelegate
- (void)returnOfficeDocumnetSave:(BOOL)isSave Type:(NSString *)lb Year:(NSString *)nf Serial:(NSString *)lsh{
    [self.popController dismissPopoverAnimated:YES];
    if (!isSave) {
        return;
    }
    
    self.fwlbTxt.text = lb;
    self.fwnfTxt.text = nf;
    self.fwbhTxt.text = lsh;
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
#pragma mark UITextView Delegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    UIScrollView *scrollView = (UIScrollView *)self.view;
    CGRect frame = scrollView.frame;
    CGFloat x = CGRectGetMinX(frame);
    CGFloat y = CGRectGetMinY(frame);
    [scrollView setContentOffset:CGPointMake(x, y+160) animated:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    UIScrollView *scrollView = (UIScrollView *)self.view;
    CGRect frame = scrollView.frame;
    CGFloat x = CGRectGetMinX(frame);
    CGFloat y = CGRectGetMinY(frame);
    [scrollView setContentOffset:CGPointMake(x, y) animated:YES];

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
- (void)processWebData:(NSData *)webData
{
    if([webData length] <=0)
    {
        [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
    }
    
    if (self.webServiceType == kWebService_SaveProcess) {
        WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:@"JCZDFileOutSaveProcessReturn" andWithJSONDelegate:self];
        webDataHelper.serviceTag = kWebService_SaveProcess;
        [webDataHelper parseXMLData:webData];
    }
    else if (self.webServiceType == kWebService_NextProcess) {
        WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:@"JCZDFileOutContinuteProcessReturn" andWithJSONDelegate:self];
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

- (void)parseJSONString:(NSString *)jsonStr
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
                [self showAlertMessage:@"保存操作失败，请稍候重试!"];
            }
 
        }
        else if(self.webServiceType == kWebService_Reback) {
            [self removeActivityView];
            if ([status isEqualToString:@"0"]) {
                [self showAlertMessage:@"收回操作成功!"];
            }
            else {
                [self showAlertMessage:@"收回操作失败，请稍候重试!"];
            }
        }
        
        else {
            
            [self removeActivityView];
            if ([status isEqualToString:@"0"]) {
                [self showAlertMessage:@"文档流转结束!"];
                
            }
            else {
                [self showAlertMessage:@"流转操作失败，请稍候重试!"];
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
