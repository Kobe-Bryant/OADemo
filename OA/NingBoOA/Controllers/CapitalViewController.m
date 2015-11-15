//
//  CapitalViewController.m
//  NingBoOA
//
//  Created by PowerData on 14-3-28.
//  Copyright (c) 2014年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "CapitalViewController.h"
#import "UICustomButton.h"
#import <QuartzCore/QuartzCore.h>
#import "ContentEditViewController.h"
#import "DejalActivityView.h"
#import "ContinueProcessViewController.h"
#import "SystemConfigContext.h"
#import "ServiceUrlString.h"
#import "ReturnBackViewController.h"
#import "RemindersViewController.h"
#import "LookUpProcessViewController.h"
#import "JSONKit.h"
#import "PopupDateViewController.h"
#import "UISelectSubjectVC.h"
#import "DisplayAttachFileController.h"

@interface CapitalViewController ()<UITableViewDataSource,UITableViewDelegate,ContentEditDelegate,PopupDateDelegate,UISelectSubjectDelegate>
@property (nonatomic,strong) UIPopoverController *poverController;
@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,strong) NSMutableArray *textViewArray;
@property (nonatomic,strong) NSArray *keys;
@property (nonatomic,copy) NSString *competence;
@property (nonatomic,copy) NSString *process;
@property (nonatomic,copy) NSString *docid;
@property (nonatomic,assign) NSInteger webServiceType;
@property (nonatomic,assign) NSInteger saveTag;
@property (nonatomic,assign) BOOL addTime;
@end

@implementation CapitalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIScrollView *scrollView = (UIScrollView *)self.view;
        scrollView.contentSize = CGSizeMake(768, 1150);
    }
    return self;
}

- (NSMutableDictionary *)getValueData{
    NSMutableDictionary *dicValues = [NSMutableDictionary dictionaryWithCapacity:15];
    
    NSString *isLastProcess = [self.infoDict objectForKey:@"Hy_IfLastTache"];
    NSString *modid = [self.infoDict objectForKey:@"modid"];
    NSString *docid = [self.infoDict objectForKey:@"Hy_docid"];
    
    SystemConfigContext *context = [SystemConfigContext sharedInstance];
    NSDictionary *loginUsr = [context getUserInfo];
    NSString *user = [loginUsr objectForKey:@"userId"];
    [dicValues setValue:modid forKey:@"Hy_mdid"];
    [dicValues setValue:isLastProcess forKey:@"Hy_IfLastTache"];
    [dicValues setValue:user forKey:@"Hy_userid"];
    [dicValues setValue:docid forKey:@"Hy_docid"];
    [dicValues setValue:self.sqrTextField.text forKey:@"Hy_SQR"];
    [dicValues setValue:self.sqbmTextField.text forKey:@"Hy_SQBM"];
    [dicValues setValue:self.sqrqTextField.text forKey:@"Hy_SQRQ"];
    [dicValues setValue:self.zjytTextField.text forKey:@"Hy_ZJYT"];
    [dicValues setValue:self.syrqTextField.text forKey:@"Hy_SYRQ"];
    [dicValues setValue:self.bzsrTextfield.text forKey:@"Hy_BZ"];
    [dicValues setValue:self.sqjeTextField.text forKey:@"Hy_SQED"];
    [dicValues setValue:self.pfjeTextField.text forKey:@"Hy_PFED"];
    [dicValues setValue:self.zjlykmTextField.text forKey:@"Hy_ZJLYKM1"];
    [dicValues setValue:self.zjlykm2TextField.text forKey:@"Hy_ZJLYKM2"];
    [dicValues setValue:self.zzyjsrTextfield.text forKey:@"Hy_ZZYJ"];
    [dicValues setValue:self.fzryjsrTextfield.text forKey:@"Hy_FZRYJ"];
    [dicValues setValue:self.zryjsrTextfield.text forKey:@"Hy_ZRYJ"];
    [dicValues setValue:self.zryjsrTextfield.text forKey:@"Hy_CWJBYJ"];
    [dicValues setValue:self.sqrqsyjsrTextfield.text forKey:@"Hy_SQRQSYJ"];
    
    return dicValues;
}

#pragma mark - Private Methods
- (void)removeActivityView{
    [DejalActivityView removeView];
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
}

-(void)sureContinue
{
    NSMutableDictionary *keyedArguments = [self getValueData];
    [keyedArguments setObject:@"" forKey:@"Hy_IfLastTache"];
    [keyedArguments setObject:@"" forKey:@"Hy_NextTacheId"];
    [keyedArguments setObject:@"" forKey:@"Hy_NextTacheName"];
    [keyedArguments setObject:@"" forKey:@"Hy_NextTacheTransactor"];
    [keyedArguments setObject:@"" forKey:@"Hy_NextTachePasser"];
    
    ContinueProcessViewController *continueProcessViewController = [[ContinueProcessViewController alloc] initWithNibName:@"ContinueProcessViewController" bundle:nil];
    continueProcessViewController.delegate = self;
    continueProcessViewController.parameterDictionary = keyedArguments;
    continueProcessViewController.paramsAry = self.keys;
    continueProcessViewController.currentProcessName = self.process;
    continueProcessViewController.serviceName = @"ApplicationFundsContinuteProcess";
    [self.navigationController pushViewController:continueProcessViewController animated:YES];
}

- (void)transferToNextStep{
    NSMutableDictionary *keyedValue = [self getValueData];
    [keyedValue setObject:@"*" forKey:@"Hy_NextTacheId"];
    [keyedValue setObject:@"*" forKey:@"Hy_NextTacheName"];
    [keyedValue setObject:@"" forKey:@"Hy_NextTacheTransactor"];
    [keyedValue setObject:@"" forKey:@"Hy_NextTachePasser"];
    
    NSString *strURL = [ServiceUrlString generateOAWebServiceUrl];
    NSString *params = [WebServiceHelper createParametersWithKeys:self.keys andValues:keyedValue];
    
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strURL method:@"ApplicationFundsContinuteProcess" nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
    self.webServiceType = kWebService_NextProcess;
    [self.webServiceHelper run];
}


-(void)goBackAction:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveToProcess:(id)sender{
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"正在保存数据，请稍候..." width:180];
    
    NSMutableDictionary *keyedArguments = [self getValueData];
    
    NSString *strURL = [ServiceUrlString generateOAWebServiceUrl];
    NSString *params =  [WebServiceHelper createParametersWithKeys:self.keys andValues:keyedArguments];
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strURL method:@"ApplicationFundsSaveProcess" nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
    self.webServiceType = kWebService_SaveProcess;
    [self.webServiceHelper run];
    
}

// -------------------------------------------------------------------------------
//
//  跳转到下一个流程环节选择
// -------------------------------------------------------------------------------
- (void)nextToProcess:(id)sender{
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
- (void)forwardToProcess:(id)sender{
    NSDictionary *keyedArguments = [self getValueData];
    NSString *modid = [keyedArguments objectForKey:@"Hy_mdid"];
    NSString *docid = [keyedArguments objectForKey:@"Hy_docid"];
    ReturnBackViewController *returnBack = [[ReturnBackViewController alloc] initWithNibName:@"ReturnBackViewController" bundle:nil];
    returnBack.mdId = modid;
    returnBack.docId = docid;
    returnBack.delegate = self;
    [self.navigationController pushViewController:returnBack animated:YES];
    
}

//催办
- (void)remindHandleProcess:(id)sender{
    NSDictionary *keyedArguments = [self getValueData];
    NSString *modid = [keyedArguments objectForKey:@"Hy_mdid"];
    NSString *docid = [keyedArguments objectForKey:@"Hy_docid"];
    RemindersViewController *reminder = [[RemindersViewController alloc] initWithNibName:@"RemindersViewController" bundle:nil];
    reminder.modID = modid;
    reminder.docID = docid;
    reminder.delegate = self;
    [self.navigationController pushViewController:reminder animated:YES];
}

//收回
- (void)redrawButtonClick:(id)sender
{
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"正在收回文档，请稍候..." width:180];
    
    NSDictionary *keyedArguments = [self getValueData];
    NSString *modid = [keyedArguments objectForKey:@"Hy_mdid"];
    NSString *userid = [keyedArguments objectForKey:@"Hy_userid"];
    NSString *docid = [keyedArguments objectForKey:@"Hy_docid"];
    
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
    ContentEditViewController *contentEditViewController = [[ContentEditViewController alloc] init];
    contentEditViewController.delegate = self;
    
    if(sender.tag == 1) {
        
        contentEditViewController.editorType = KEditor_Type_SRYJ;
        contentEditViewController.editorTitle = @"组长意见";
        contentEditViewController.oldValue = self.zzyjsrTextfield.text;
        contentEditViewController.serviceName = @"returnPersonOpinionList";
        self.textView = self.zzyjsrTextfield;
        
    }
    
    else if(sender.tag == 2) {
       
        contentEditViewController.editorType = KEditor_Type_SRYJ;
        contentEditViewController.editorTitle = @"副主任意见";
        contentEditViewController.oldValue = self.fzryjsrTextfield.text;
        contentEditViewController.serviceName = @"returnPersonOpinionList";
        self.textView = self.fzryjsrTextfield;
        
    }
    
    else if(sender.tag == 3) {
        
        contentEditViewController.editorType = KEditor_Type_SRYJ;
        contentEditViewController.editorTitle = @"主任意见";
        contentEditViewController.oldValue = self.zryjsrTextfield.text;
        contentEditViewController.serviceName = @"returnPersonOpinionList";
        self.textView = self.zryjsrTextfield;
        
    }
    
    else if(sender.tag == 4) {
       
        contentEditViewController.editorType = KEditor_Type_SRYJ;
        contentEditViewController.editorTitle = @"财务经办意见";
        contentEditViewController.oldValue = self.cwjbyjsrTextfield.text;
        contentEditViewController.serviceName = @"returnPersonOpinionList";
        self.textView = self.cwjbyjsrTextfield;
        
    }
    
    else if(sender.tag == 5) {
        
        contentEditViewController.editorType = KEditor_Type_SRYJ;
        contentEditViewController.editorTitle = @"申请人签收意见";
        contentEditViewController.oldValue = self.sqrqsyjsrTextfield.text;
        contentEditViewController.serviceName = @"returnPersonOpinionList";
        self.textView = self.sqrqsyjsrTextfield;
        
    }
    
    else if(sender.tag == 6) {
        
        contentEditViewController.editorType = KEditor_Type_SRYJ;
        contentEditViewController.editorTitle = @"备注";
        contentEditViewController.oldValue = self.bzsrTextfield.text;
        contentEditViewController.serviceName = @"returnPersonOpinionList";
        self.textView = self.bzsrTextfield;
        
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
            self.zzyjsrTextfield.text = @"";
            break;
        case 2:
            self.fzryjsrTextfield.text = @"";
            break;
        case 3:
            self.zryjsrTextfield.text = @"";
            break;
        case 4:
            self.cwjbyjsrTextfield.text = @"";
            break;
        case 5:
            self.sqrqsyjsrTextfield.text = @"";
            break;
        default:
            self.bzsrTextfield.text = @"";
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.textViewArray = [[NSMutableArray alloc]init];
    
    self.keys = @[ @"Hy_mdid",@"Hy_docid", @"Hy_userid", @"Hy_SQR", @"Hy_SQBM", @"Hy_SQRQ", @"Hy_ZJYT", @"Hy_SYRQ", @"Hy_BZ", @"Hy_SQED", @"Hy_PFED", @"Hy_ZJLYKM1", @"Hy_ZJLYKM2", @"Hy_ZZYJ",@"Hy_FZRYJ", @"Hy_ZRYJ", @"Hy_CWJBYJ", @"Hy_SQRQSYJ"];
    
    self.competence = [self.infoDict objectForKey:@"competence"];
    if ([self.competence isEqualToString:@"0"]) {
        UIBarButtonItem *saveItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"保存"];
        self.navigationItem.rightBarButtonItem = saveItem;
        
        UIButton *saveButton = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
        [saveButton addTarget:self action:@selector(saveToProcess:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *nextItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"下一步"];
        self.navigationItem.rightBarButtonItem = nextItem;
        
        UIButton *nextButton = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
        [nextButton addTarget:self action:@selector(nextToProcess:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *forwardItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"退回"];
        self.navigationItem.rightBarButtonItem = forwardItem;
        
        UIButton *forwardButton = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
        [forwardButton addTarget:self action:@selector(forwardToProcess:) forControlEvents:UIControlEventTouchUpInside];
        
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
        [self displayDetails];
    }
    else if([self.competence isEqualToString:@"1"]) {
        UIBarButtonItem *backItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"返回"];
        self.navigationItem.leftBarButtonItem = backItem;
        UIButton *backButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
        [backButton addTarget:self action:@selector(goBackAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIBarButtonItem *rebackItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"收回"];
        self.navigationItem.rightBarButtonItem = rebackItem;
        UIButton *rebackButton = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
        [rebackButton addTarget:self action:@selector(redrawButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *reminderItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"催办"];
        self.navigationItem.rightBarButtonItem = reminderItem;
        UIButton *reminderButton = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
        [reminderButton addTarget:self action:@selector(remindHandleProcess:) forControlEvents:UIControlEventTouchUpInside];
        
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
        [backButton addTarget:self action:@selector(goBackAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *seeItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"查看流程"];
        self.navigationItem.rightBarButtonItem = seeItem;
        
        UIButton *seeButton = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
        [seeButton addTarget:self action:@selector(lookupProcess:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.sqrTextField.text = [self.infoDict objectForKey:@"Hy_Sqr"];
    self.sqbmTextField.text = [self.infoDict objectForKey:@"Hy_Sqbm"];
    self.sqrqTextField.text = [self.infoDict objectForKey:@"Hy_Sqrq"];
    self.zjytTextField.text = [self.infoDict objectForKey:@"Hy_Bt"];
    self.syrqTextField.text = [self.infoDict objectForKey:@"Hy_syrq"];
    self.sqjeTextField.text = [self.infoDict objectForKey:@"Hy_Ysje"];
    self.pfjeTextField.text = [self.infoDict objectForKey:@"Hy_Sjje"];
    self.zjlykmTextField.text = [self.infoDict objectForKey:@"Hy_Km"];
    self.zjlykm2TextField.text = [self.infoDict objectForKey:@"Hy_Km2"];
    self.zzyjTextField.text = [self.infoDict objectForKey:@"Hy_xzfzryj"];
    self.fzryjTextField.text = [self.infoDict objectForKey:@"Hy_fzryj"];
    self.zryjTextField.text = [self.infoDict objectForKey:@"Hy_zryj"];
    self.cwjbyjTextField.text = [self.infoDict objectForKey:@"Hy_zhzyj"];
    self.sqrqsyjTextField.text = [self.infoDict objectForKey:@"Hy_sqrqsyj"];
    self.bzTextField.text = [self.infoDict objectForKey:@"Hy_Bz"];
}
- (IBAction)importButton:(UIButton *)sender {
    self.saveTag = sender.tag;
    if (sender.tag == 1 ) {
        PopupDateViewController *dateVC = [[PopupDateViewController alloc]initWithPickerMode:UIDatePickerModeDate];
        dateVC.delegate = self;
        UINavigationController *dateNav = [[UINavigationController alloc]initWithRootViewController:dateVC];
        self.poverController = [[UIPopoverController alloc]initWithContentViewController:dateNav];
        [self.poverController presentPopoverFromRect:self.sqrqTextField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else if (sender.tag == 2 ) {
        PopupDateViewController *dateVC = [[PopupDateViewController alloc]initWithPickerMode:UIDatePickerModeDate];
        dateVC.delegate = self;
        UINavigationController *dateNav = [[UINavigationController alloc]initWithRootViewController:dateVC];
        self.poverController = [[UIPopoverController alloc]initWithContentViewController:dateNav];
        [self.poverController presentPopoverFromRect:self.syrqTextField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else if (sender.tag == 3){
        UISelectSubjectVC *wordsVC = [[UISelectSubjectVC alloc]init];
        wordsVC.delegate = self;
         wordsVC.isSubject = YES;
        wordsVC.method = @"GetOneSubjects";
        self.poverController = [[UIPopoverController alloc]initWithContentViewController:wordsVC];
        [self.poverController presentPopoverFromRect:self.zjlykmTextField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
    else if (sender.tag == 4){
        UISelectSubjectVC *wordsVC = [[UISelectSubjectVC alloc]init];
        wordsVC.delegate = self;
         wordsVC.isSubject = YES;
        wordsVC.method = @"GetTwoSubjects";
        self.poverController = [[UIPopoverController alloc]initWithContentViewController:wordsVC];
        [self.poverController presentPopoverFromRect:self.zjlykm2TextField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.webServiceHelper) {
        [self.webServiceHelper cancel];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *backItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"返回"];
    UIButton *backButton = (UIButton*)backItem.customView;
    [backButton addTarget:self action:@selector(goBackAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = backItem;
}

-(void)displayDetails{
    NSString *edit = [self.infoDict objectForKey:@"edit"];
    NSArray *dataArray = [edit componentsSeparatedByString:@","];
    for (NSString *str in dataArray) {
        if ([str isEqualToString:@"Hy_Sqr"]) {
            self.sqrButton.hidden = NO;
            self.sqrButton.enabled = YES;
            
            self.sqrTextField.borderStyle = UITextBorderStyleRoundedRect;
            self.sqrTextField.enabled = YES;
        }
        else if ([str isEqualToString:@"Hy_Sqbm"]){
            self.sqbmButton.hidden = NO;
            self.sqbmButton.enabled = YES;
            
            self.sqbmTextField.borderStyle = UITextBorderStyleRoundedRect;
            self.sqbmTextField.enabled = YES;
        }
        else if ([str isEqualToString:@"Hy_Sqrq"]){
            self.sqrqButton.hidden = NO;
            self.sqrqButton.enabled = YES;
            
            self.sqrqTextField.borderStyle = UITextBorderStyleRoundedRect;
        }
        else if ([str isEqualToString:@"Hy_Bt"]){
            self.zjytButton.hidden = NO;
            self.zjytButton.enabled = YES;
            
            self.zjytTextField.borderStyle = UITextBorderStyleRoundedRect;
            self.zjytTextField.enabled = YES;
        }
        else if ([str isEqualToString:@"Hy_syrq"]){
            self.syrqButton.hidden = NO;
            self.syrqButton.enabled = YES;
            
            self.syrqTextField.borderStyle = UITextBorderStyleRoundedRect;
        }
        else if ([str isEqualToString:@"Hy_Ysje"]){
            self.sqjeButton.hidden = NO;
            self.sqjeButton.enabled = YES;
            
            self.sqjeTextField.borderStyle = UITextBorderStyleRoundedRect;
            self.sqjeTextField.enabled = YES;
        }
        else if ([str isEqualToString:@"Hy_Sjje"]){
            self.pfjeButton.hidden = NO;
            self.pfjeButton.enabled = YES;
            
            self.pfjeTextField.borderStyle = UITextBorderStyleRoundedRect;
            self.pfjeTextField.enabled = YES;
        }
        else if ([str isEqualToString:@"Hy_Km"]){
            self.zjlykmButton.hidden = NO;
            self.zjlykmButton.enabled = YES;
            
            self.zjlykmTextField.borderStyle = UITextBorderStyleRoundedRect;
        }
        else if ([str isEqualToString:@"Hy_Km2"]){
            self.zjlykm2Button.hidden = NO;
            self.zjlykm2Button.enabled = YES;
            
            self.zjlykm2TextField.borderStyle = UITextBorderStyleRoundedRect;
        }
        else if ([str isEqualToString:@"Hy_xzfzryj"]){
            self.zzyjsrButton.hidden = NO;
            self.zzyjsrButton.enabled = YES;
            self.zzyjczButton.hidden = NO;
            self.zzyjczButton.enabled = YES;
            
            self.zzyjsrTextfield.editable = YES;
            self.zzyjsrTextfield.layer.borderColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0].CGColor;
            self.zzyjsrTextfield.layer.borderWidth =1.5;
            self.zzyjsrTextfield.layer.cornerRadius =6.0;
            
            [self.textViewArray addObject:self.zzyjsrTextfield];
        }
        else if ([str isEqualToString:@"Hy_fzryj"]){
            self.fzryjsrButton.hidden = NO;
            self.fzryjsrButton.enabled = YES;
            self.fzryjczButton.hidden = NO;
            self.fzryjczButton.enabled = YES;
            
            self.fzryjsrTextfield.editable = YES;
            self.fzryjsrTextfield.layer.borderColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0].CGColor;
            self.fzryjsrTextfield.layer.borderWidth =1.5;
            self.fzryjsrTextfield.layer.cornerRadius =6.0;
            
            [self.textViewArray addObject:self.fzryjsrTextfield];
        }
        else if ([str isEqualToString:@"Hy_zryj"]){
            self.zryjsrButton.hidden = NO;
            self.zryjsrButton.enabled = YES;
            self.zryjczButton.hidden = NO;
            self.zryjczButton.enabled = YES;
            
            self.zryjsrTextfield.editable = YES;
            self.zryjsrTextfield.layer.borderColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0].CGColor;
            self.zryjsrTextfield.layer.borderWidth =1.5;
            self.zryjsrTextfield.layer.cornerRadius =6.0;
            
            [self.textViewArray addObject:self.zryjsrTextfield];
        }
        else if ([str isEqualToString:@"Hy_zhzyj"]){
            self.cwjbyjsrButton.hidden = NO;
            self.cwjbyjsrButton.enabled = YES;
            self.cwjbyjczButton.hidden = NO;
            self.cwjbyjczButton.enabled = YES;
            
            self.cwjbyjsrTextfield.editable = YES;
            self.cwjbyjsrTextfield.layer.borderColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0].CGColor;
            self.cwjbyjsrTextfield.layer.borderWidth =1.5;
            self.cwjbyjsrTextfield.layer.cornerRadius =6.0;
            
            [self.textViewArray addObject:self.cwjbyjsrTextfield];
        }
        else if ([str isEqualToString:@"Hy_sqrqsyj"]){
            self.sqrqsyjsrButton.hidden = NO;
            self.sqrqsyjsrButton.enabled = YES;
            self.sqrqsyjczButton.hidden = NO;
            self.sqrqsyjczButton.enabled = YES;
            
            self.sqrqsyjsrTextfield.editable = YES;
            self.sqrqsyjsrTextfield.layer.borderColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0].CGColor;
            self.sqrqsyjsrTextfield.layer.borderWidth =1.5;
            self.sqrqsyjsrTextfield.layer.cornerRadius =6.0;
            
            [self.textViewArray addObject:self.sqrqsyjsrTextfield];
        }
        else if ([str isEqualToString:@"Hy_Bz"]){
            self.bzsrButton.hidden = NO;
            self.bzsrButton.enabled = YES;
            self.bzczButton.hidden = NO;
            self.bzczButton.enabled = YES;
            
            self.bzsrTextfield.editable = YES;
            self.bzsrTextfield.layer.borderColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0].CGColor;
            self.bzsrTextfield.layer.borderWidth =1.5;
            self.bzsrTextfield.layer.cornerRadius =6.0;
            
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISelectSubjectDelegate

-(void)returnSelectSubjectWord:(NSString *)word{
    if (self.saveTag == 3) {
        self.zjlykmTextField.text = word;
    }
    else if (self.saveTag == 4){
        self.zjlykm2TextField.text = word;
    }
    [self.poverController dismissPopoverAnimated:YES];
}

#pragma mark - PopupDateDelegate

-(void)PopupDateController:(PopupDateViewController *)controller Saved:(BOOL)bSaved selectedDate:(NSDate *)date{
    if (bSaved) {
        NSDateFormatter *matter = [[NSDateFormatter alloc]init];
        [matter setDateFormat:@"yyyy-MM-dd"];
        NSString *time = [matter stringFromDate:date];
        if (self.saveTag == 1) {
            self.sqrqTextField.text = time;
        }
        else if (self.saveTag == 2) {
            self.syrqTextField.text = time;
        }
    }
    [self.poverController dismissPopoverAnimated:YES];
}

#pragma mark - ContentEditDelegate

-(void)passWithNewValue:(NSString *)newValue Type:(NSString *)type {
    if ([type isEqualToString:@"UITextView"]) {
        self.textView.editable = YES;
        self.textView.text = newValue;
    }
    
}

#pragma mark - UItableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2)
    {
        NSArray *otherAry = [self.infoDict objectForKey:@"Hy_Fj1"];
        if(otherAry == nil || otherAry.count == 0)
        {
            return 1;
        }
        else
        {
            return otherAry.count;
        }
    }
    return 1;
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectZero];
    headerView.font = [UIFont systemFontOfSize:19.0];
    headerView.backgroundColor = [UIColor colorWithRed:214.f/255.f green:234.f/255.f blue:254.f/255.f alpha:1.0];
    headerView.textColor = [UIColor blackColor];
    if (section == 0)  headerView.text = @"  正文信息";
    else if (section == 1)  headerView.text = @"  tif正文附件";
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if (indexPath.section == 1)
    {
        static NSString *CellIdentifier = @"FJ_Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        NSDictionary *tif = [self.infoDict objectForKey:@"Hy_Fj3"];
        if(tif == nil || [tif objectForKey:@"fileurl"] == nil)
        {
            cell.textLabel.text = @"暂无TIF附件信息";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else
        {
            cell.textLabel.text = [tif objectForKey:@"filename"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if (indexPath.section == 2)
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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

- (void)processWebData:(NSData *)webData andTag:(NSInteger)tag
{
    if([webData length] <=0)
    {
        [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
    }
    
    if (self.webServiceType == kWebService_SaveProcess) {
        WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:@"FileInSaveProcessReturn" andWithJSONDelegate:self];
        webDataHelper.serviceTag = kWebService_SaveProcess;
        [webDataHelper parseXMLData:webData];
    }
    else if (self.webServiceType == kWebService_NextProcess) {
        WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:@"FileInContinuteProcessReturn" andWithJSONDelegate:self];
        webDataHelper.serviceTag = kWebService_NextProcess;
        [webDataHelper parseXMLData:webData];
    }
    
    else  {
        WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:@"rebackReturn" andWithJSONDelegate:self];
        webDataHelper.serviceTag = kWebService_Reback;
        [webDataHelper parseXMLData:webData];
    }
    
    
}

#pragma mark - Parser Network Data

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

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setSqrTextField:nil];
    [self setSqrButton:nil];
    [self setSqbmTextField:nil];
    [self setZzyjTextField:nil];
    [self setSqrTextField:nil];
    [self setSqbmTextField:nil];
    [self setSqrqTextField:nil];
    [super viewDidUnload];
}
@end
