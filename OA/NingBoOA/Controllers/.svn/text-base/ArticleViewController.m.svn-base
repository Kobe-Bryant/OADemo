//
//  ArticleViewController.m
//  NingBoOA
//
//  Created by PowerData on 14-3-28.
//  Copyright (c) 2014年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "ArticleViewController.h"
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

@interface ArticleViewController ()<UITableViewDataSource,UITableViewDelegate,ContentEditDelegate,PopupDateDelegate,UISelectSubjectDelegate,WordsDelegate>
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

@implementation ArticleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIScrollView *srollView = (UIScrollView *)self.view;
        srollView.contentSize = CGSizeMake(768, 1450);
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
    [dicValues setValue:self.wplbTextField.text forKey:@"Hy_WPLB"];
    [dicValues setValue:self.wpmcTextField.text forKey:@"Hy_WP"];
    [dicValues setValue:self.ytgnmsTextField.text forKey:@"Hy_YT"];
    [dicValues setValue:self.yjzjeTextField.text forKey:@"Hy_YSZJE"];
    [dicValues setValue:self.nghdwTextField.text forKey:@"Hy_NGHDW"];
    [dicValues setValue:self.zjlyTextField.text forKey:@"Hy_ZJLYKM1"];
    [dicValues setValue:self.zjly2TextField.text forKey:@"Hy_ZJLYKM2"];
    [dicValues setValue:self.zzyjsrTextfield.text forKey:@"Hy_LXFS"];
    [dicValues setValue:self.lxfsTextField.text forKey:@"Hy_FZRYJ"];
    [dicValues setValue:self.wpsyrqTextField.text forKey:@"Hy_SYRQ"];
    [dicValues setValue:self.bzTextField.text forKey:@"Hy_BZ"];
    [dicValues setValue:self.zzyjsrTextfield.text forKey:@"Hy_ZZYJ"];
    [dicValues setValue:self.fzryjsrTextfield.text forKey:@"Hy_FZRYJ"];
    [dicValues setValue:self.zryjsrTextfield.text forKey:@"Hy_ZRYJ"];
    [dicValues setValue:self.zhzyjsrTextfield.text forKey:@"Hy_ZHZYJ"];
    [dicValues setValue:self.cgyjsrTextfield.text forKey:@"Hy_CGYJ"];
    [dicValues setValue:self.zzyjsrTextfield.text forKey:@"Hy_ZZYJ"];
    [dicValues setValue:self.sqrjhyjsrTextfield.text forKey:@"Hy_SQRJH"];
    
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
    continueProcessViewController.serviceName = @"ProcurementContinuteProcess";
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
    
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strURL method:@"ProcurementContinuteProcess" nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
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
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strURL method:@"ProcurementSaveProcess" nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
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
        contentEditViewController.editorTitle = @"综合组意见";
        contentEditViewController.oldValue = self.zhzyjsrTextfield.text;
        contentEditViewController.serviceName = @"returnPersonOpinionList";
        self.textView = self.zhzyjsrTextfield;
        
    }
    
    else if(sender.tag == 5) {
        
        contentEditViewController.editorType = KEditor_Type_SRYJ;
        contentEditViewController.editorTitle = @"采购意见";
        contentEditViewController.oldValue = self.cgyjsrTextfield.text;
        contentEditViewController.serviceName = @"returnPersonOpinionList";
        self.textView = self.cgyjsrTextfield;
        
    }
    
    else if(sender.tag == 6) {
        
        contentEditViewController.editorType = KEditor_Type_SRYJ;
        contentEditViewController.editorTitle = @"申请人校核";
        contentEditViewController.oldValue = self.sqrjhyjsrTextfield.text;
        contentEditViewController.serviceName = @"returnPersonOpinionList";
        self.textView = self.sqrjhyjsrTextfield;
        
    }
    else if(sender.tag == 7) {
        
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
            self.zhzyjsrTextfield.text = @"";
            break;
        case 5:
            self.cgyjsrTextfield.text = @"";
            break;
        case 6:
            self.sqrjhyjsrTextfield.text = @"";
            break;
        case 7:
            self.bzsrTextfield.text = @"";
            break;
        default:
            self.ytgnmsTextField.text = @"";
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.textViewArray = [[NSMutableArray alloc]init];
    
    self.keys = @[ @"Hy_mdid",@"Hy_docid", @"Hy_userid", @"Hy_SQR", @"Hy_SQBM", @"Hy_SQRQ", @"Hy_WPLB", @"Hy_WP", @"Hy_YT", @"Hy_YSZJE", @"Hy_ZJLYKM1", @"Hy_ZJLYKM2", @"Hy_NGHDW", @"Hy_LXFS",@"Hy_SYRQ", @"Hy_BZ", @"Hy_ZZYJ", @"Hy_FZRYJ", @"Hy_ZRYJ", @"Hy_ZHZYJ", @"Hy_CGYJ", @"Hy_SQRJH"];
    
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
    self.wplbTextField.text = [self.infoDict objectForKey:@"Hy_Wplb"];
    self.wpmcTextField.text = [self.infoDict objectForKey:@"Hy_Wpmc1"];
    self.xhTextField.text = [self.infoDict objectForKey:@"Hy_Xh1"];
    self.cgslTextField.text = [self.infoDict objectForKey:@""];
    self.wpsyrqTextField.text = [self.infoDict objectForKey:@"Hy_syrq"];
    self.gjdjTextField.text = [self.infoDict objectForKey:@"Hy_Ygdj1"];
    self.sjdjTextField.text = [self.infoDict objectForKey:@"Hy_Sjdj1"];
    self.sfrkTextField.text = [self.infoDict objectForKey:@"Hy_Sfrk1"];
    self.sfycgTextField.text = [self.infoDict objectForKey:@"Hy_Sfycg1"];
    self.ytgnmsTextField.text = [self.infoDict objectForKey:@"Hy_Wplx1"];
    self.yjzjeTextField.text = [self.infoDict objectForKey:@"Hy_Ysje"];
    self.nghdwTextField.text = [self.infoDict objectForKey:@"Hy_Ghdw"];
    self.lxfsTextField.text = [self.infoDict objectForKey:@"Hy_Lxfs"];
    self.zzyjTextField.text = [self.infoDict objectForKey:@"Hy_xzfzryj"];
    self.fzryjTextField.text = [self.infoDict objectForKey:@"Hy_fzryj"];
    self.zryjTextField.text = [self.infoDict objectForKey:@"Hy_zryj"];
    self.zhzyjTextField.text = [self.infoDict objectForKey:@"Hy_zhzyj"];
    self.cgyjTextField.text = [self.infoDict objectForKey:@"Hy_cgyj"];
    self.sqrjhyjTextField.text = [self.infoDict objectForKey:@"Hy_sqrqsyj"];
    self.bzTextField.text = [self.infoDict objectForKey:@"Hy_gdzcrk"];
    self.zjlyTextField.text = [self.infoDict objectForKey:@"Hy_Km"];
    self.zjly2TextField.text = [self.infoDict objectForKey:@"Hy_Km2"];
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
        [self.poverController presentPopoverFromRect:self.wpsyrqTextField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else if (sender.tag == 3){
        UISelectSubjectVC *wordsVC = [[UISelectSubjectVC alloc]init];
        wordsVC.delegate = self;
        wordsVC.isSubject = YES;
        wordsVC.method = @"GetOneSubjects";
        self.poverController = [[UIPopoverController alloc]initWithContentViewController:wordsVC];
        [self.poverController presentPopoverFromRect:self.zjlyTextField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
    else if (sender.tag == 4){
        UISelectSubjectVC *wordsVC = [[UISelectSubjectVC alloc]init];
        wordsVC.delegate = self;
        wordsVC.isSubject = YES;
        wordsVC.method = @"GetTwoSubjects";
        self.poverController = [[UIPopoverController alloc]initWithContentViewController:wordsVC];
        [self.poverController presentPopoverFromRect:self.zjly2TextField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
    else if (sender.tag == 5){
        NSArray *listArray = @[@"是",@"否"];
        CommenWordsViewController *tmpController = [[CommenWordsViewController alloc] initWithNibName:@"CommenWordsViewController" bundle:nil ];
        tmpController.contentSizeForViewInPopover = CGSizeMake(200, 44*[listArray count]);
        tmpController.delegate = self;
        tmpController.wordsAry = listArray;
        UIPopoverController *tmppopover = [[UIPopoverController alloc] initWithContentViewController:tmpController];
        self.poverController = tmppopover;
        [self.poverController presentPopoverFromRect:self.sfrkTextField.frame
                                            inView:self.view
                          permittedArrowDirections:UIPopoverArrowDirectionAny
                                          animated:YES];
    }
    else if (sender.tag == 6){
        NSArray *listArray = @[@"是",@"否"];
        CommenWordsViewController *tmpController = [[CommenWordsViewController alloc] initWithNibName:@"CommenWordsViewController" bundle:nil ];
        tmpController.contentSizeForViewInPopover = CGSizeMake(200, 44*[listArray count]);
        tmpController.delegate = self;
        tmpController.wordsAry = listArray;
        UIPopoverController *tmppopover = [[UIPopoverController alloc] initWithContentViewController:tmpController];
        self.poverController = tmppopover;
        [self.poverController presentPopoverFromRect:self.sfycgTextField.frame
                                            inView:self.view
                          permittedArrowDirections:UIPopoverArrowDirectionAny
                                          animated:YES];
    }
    else if (sender.tag == 7){
        NSArray *listArray = @[@"耗材",@"固定资产"];
        CommenWordsViewController *tmpController = [[CommenWordsViewController alloc] initWithNibName:@"CommenWordsViewController" bundle:nil ];
        tmpController.contentSizeForViewInPopover = CGSizeMake(200, 44*[listArray count]);
        tmpController.delegate = self;
        tmpController.wordsAry = listArray;
        UIPopoverController *tmppopover = [[UIPopoverController alloc] initWithContentViewController:tmpController];
        self.poverController = tmppopover;
        [self.poverController presentPopoverFromRect:self.wplbTextField.frame
                                              inView:self.view
                            permittedArrowDirections:UIPopoverArrowDirectionAny
                                            animated:YES];
    }
    else if (sender.tag == 8){
        UISelectSubjectVC *wordsVC = [[UISelectSubjectVC alloc]init];
        wordsVC.delegate = self;
        wordsVC.isType = YES;
        UINavigationController *wordsNav = [[UINavigationController alloc]initWithRootViewController:wordsVC];
        if ([self.wplbTextField.text isEqualToString:@"耗材"]) {
            wordsVC.title = @"耗材";
            wordsVC.method = @"GetConsumablesName";
        }
        else{
            wordsVC.title = @"固定资产";
            wordsVC.method = @"GetFixedAssetsName";
        }
        
        self.poverController = [[UIPopoverController alloc]initWithContentViewController:wordsNav];
        [self.poverController presentPopoverFromRect:self.wpmcImportButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
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
            self.sqrImportButton.hidden = NO;
            self.sqrImportButton.enabled = YES;
            
            self.sqrTextField.borderStyle = UITextBorderStyleRoundedRect;
            self.sqrTextField.enabled = YES;
        }
        else if ([str isEqualToString:@"Hy_Sqbm"]){
            self.sqbmImportButton.hidden = NO;
            self.sqbmImportButton.enabled = YES;
            
            self.sqbmTextField.borderStyle = UITextBorderStyleRoundedRect;
            self.sqbmTextField.enabled = YES;
        }
        else if ([str isEqualToString:@"Hy_Sqrq"]){
            self.sqrqImportButton.hidden = NO;
            self.sqrqImportButton.enabled = YES;
            
            self.sqrqTextField.borderStyle = UITextBorderStyleRoundedRect;
        }
        else if ([str isEqualToString:@"Hy_Wplb"]){
            self.wplbImportButton.hidden = NO;
            self.wplbImportButton.enabled = YES;
            
            self.wplbTextField.borderStyle = UITextBorderStyleRoundedRect;
            self.wplbTextField.enabled = YES;
        }
        else if ([str isEqualToString:@"Hy_Wpmc1"]){
            self.wpmcImportButton.hidden = NO;
            self.wpmcImportButton.enabled = YES;
            
            self.wpmcTextField.borderStyle = UITextBorderStyleRoundedRect;
        }
        else if ([str isEqualToString:@"Hy_Xh1"]){
            self.xhImportButton.hidden = NO;
            self.xhImportButton.enabled = YES;
            
            self.xhTextField.borderStyle = UITextBorderStyleRoundedRect;
            self.xhTextField.enabled = YES;
        }
        else if ([str isEqualToString:@"Hy_Sjje"]){
            self.cgslImportButton.hidden = NO;
            self.cgslImportButton.enabled = YES;
            
            self.cgslTextField.borderStyle = UITextBorderStyleRoundedRect;
            self.cgslTextField.enabled = YES;
        }
        else if ([str isEqualToString:@"Hy_syrq"]){
            self.wpsyrqImportButton.hidden = NO;
            self.wpsyrqImportButton.enabled = YES;
            
            self.wpsyrqTextField.borderStyle = UITextBorderStyleRoundedRect;
        }
        else if ([str isEqualToString:@"Hy_Ygdj1"]){
            self.gjdjImportButton.hidden = NO;
            self.gjdjImportButton.enabled = YES;
            
            self.gjdjTextField.enabled = YES;
            self.gjdjTextField.borderStyle = UITextBorderStyleRoundedRect;
        }
        else if ([str isEqualToString:@"Hy_Sjdj1"]){
            self.sjdjImportButton.hidden = NO;
            self.sjdjImportButton.enabled = YES;
            
            self.sjdjTextField.enabled = YES;
            self.sjdjTextField.borderStyle = UITextBorderStyleRoundedRect;
        }
        else if ([str isEqualToString:@"Hy_Sfrk1"]){
            self.sfrkImportButton.hidden = NO;
            self.sfrkImportButton.enabled = YES;
            
            self.sfrkTextField.enabled = YES;
            self.sfrkTextField.borderStyle = UITextBorderStyleRoundedRect;
        }
        else if ([str isEqualToString:@"Hy_Sfycg1"]){
            self.sfycgImportButton.hidden = NO;
            self.sfycgImportButton.enabled = YES;
            
            self.sfycgTextField.enabled = YES;
            self.sfycgTextField.borderStyle = UITextBorderStyleRoundedRect;
        }
        else if ([str isEqualToString:@"Hy_Ysje"]){
            self.yjzjeImportButton.hidden = NO;
            self.yjzjeImportButton.enabled = YES;
            
            self.yjzjeTextField.enabled = YES;
            self.yjzjeTextField.borderStyle = UITextBorderStyleRoundedRect;
        }
        else if ([str isEqualToString:@"Hy_Km"]){
            self.zjlyImportButton.hidden = NO;
            self.zjlyImportButton.enabled = YES;
            
            self.zjlyTextField.borderStyle = UITextBorderStyleRoundedRect;
        }
        else if ([str isEqualToString:@"Hy_Km2"]){
            self.zjly2ImportButton.hidden = NO;
            self.zjly2ImportButton.enabled = YES;
            
            self.zjly2TextField.borderStyle = UITextBorderStyleRoundedRect;
        }
        else if ([str isEqualToString:@"Hy_Ghdw"]){
            self.nghdwImportButton.hidden = NO;
            self.nghdwImportButton.enabled = YES;
            
            self.nghdwTextField.enabled = YES;
            self.nghdwTextField.borderStyle = UITextBorderStyleRoundedRect;
        }
        else if ([str isEqualToString:@"Hy_Lxfs"]){
            self.lxfsImportButton.hidden = NO;
            self.lxfsImportButton.enabled = YES;
            
            self.lxfsTextField.enabled = YES;
            self.lxfsTextField.borderStyle = UITextBorderStyleRoundedRect;
        }
        else if ([str isEqualToString:@"Hy_Wplx1"]){
            self.ytgnmsImportButton.hidden = NO;
            self.ytgnmsImportButton.enabled = YES;
            
            self.ytgnmsTextField.editable = YES;
            self.ytgnmsTextField.layer.borderColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0].CGColor;
            self.ytgnmsTextField.layer.borderWidth =1.5;
            self.ytgnmsTextField.layer.cornerRadius =6.0;
            
            [self.textViewArray addObject:self.zzyjsrTextfield];
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
            self.zhzyjsrButton.hidden = NO;
            self.zhzyjsrButton.enabled = YES;
            self.zhzyjczButton.hidden = NO;
            self.zhzyjczButton.enabled = YES;
            
            self.zhzyjsrTextfield.editable = YES;
            self.zhzyjsrTextfield.layer.borderColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0].CGColor;
            self.zhzyjsrTextfield.layer.borderWidth =1.5;
            self.zhzyjsrTextfield.layer.cornerRadius =6.0;
            
            [self.textViewArray addObject:self.zhzyjsrTextfield];
        }
        else if ([str isEqualToString:@"Hy_cgyj"]){
            self.cgyjsrButton.hidden = NO;
            self.cgyjsrButton.enabled = YES;
            self.cgyjczButton.hidden = NO;
            self.cgyjczButton.enabled = YES;
            
            self.cgyjsrTextfield.editable = YES;
            self.cgyjsrTextfield.layer.borderColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0].CGColor;
            self.cgyjsrTextfield.layer.borderWidth =1.5;
            self.cgyjsrTextfield.layer.cornerRadius =6.0;
            
            [self.textViewArray addObject:self.cgyjsrTextfield];
        }
        else if ([str isEqualToString:@"Hy_sqrqsyj"]){
            self.sqrjhyjsrButton.hidden = NO;
            self.sqrjhyjsrButton.enabled = YES;
            self.sqrjhyjczButton.hidden = NO;
            self.sqrjhyjczButton.enabled = YES;
            
            self.sqrjhyjsrTextfield.editable = YES;
            self.sqrjhyjsrTextfield.layer.borderColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0].CGColor;
            self.sqrjhyjsrTextfield.layer.borderWidth =1.5;
            self.sqrjhyjsrTextfield.layer.cornerRadius =6.0;
            
            [self.textViewArray addObject:self.sqrjhyjsrTextfield];
        }
        else if ([str isEqualToString:@"Hy_gdzcrk"]){
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
        self.zjlyTextField.text = word;
    }
    else if (self.saveTag == 4){
        self.zjly2TextField.text = word;
    }
    else if (self.saveTag == 8) {
        self.wpmcTextField.text = word;
    }
    [self.poverController dismissPopoverAnimated:YES];
}

#pragma mark - WordsDelegate

-(void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row{
    if (self.saveTag == 5) {
        self.sfrkTextField.text = words;
    }
    else if (self.saveTag == 6) {
        self.sfycgTextField.text = words;
    }
    else if (self.saveTag == 7) {
        self.wplbTextField.text = words;
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
            self.wpsyrqTextField.text = time;
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
    [self setSqrTextField:nil];
    [self setSqrImportButton:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
