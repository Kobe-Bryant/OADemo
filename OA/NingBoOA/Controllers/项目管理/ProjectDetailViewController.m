//
//  FileOutDetailViewController.m
//  NingBoOA
//
//  Created by 熊熙 on 13-9-29.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ProjectDetailViewController.h"
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

@interface ProjectDetailViewController ()

@property (strong, nonatomic) UIPopoverController *popController;

@end

@implementation ProjectDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


- (void)setControlEdit{
    UIScrollView *scrollView = (UIScrollView *)self.view;
    [scrollView setContentSize:CGSizeMake(768, 2250)];
    
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
            else if([ctrlEdit isEqualToString:@"Hy_WZFB"]){
                for (int n=0; n < self.sitePublicCtr.numberOfSegments; n++) {
                    [self.sitePublicCtr setEnabled:YES forSegmentAtIndex:n];
                    
                }
            }
            else if([ctrlEdit isEqualToString:@"Hy_ZTC"]){
                self.topicTxt.borderStyle = UITextBorderStyleRoundedRect;
                
                
                self.topicBtn.hidden = NO;
                self.topicBtn.enabled = YES;
            }
            else if([ctrlEdit isEqualToString:@"Hy_Bt"]){
                self.titleTxt.borderStyle = UITextBorderStyleRoundedRect;
                self.titleTxt.enabled = YES;
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
            else if([ctrlEdit isEqualToString:@"Hy_YZRQ"]){
                self.dateTxt.borderStyle = UITextBorderStyleRoundedRect;
                self.dateTxt.enabled = YES;
                
                self.dateBtn.hidden = NO;
                self.dateBtn.enabled = YES;
            }
            else if([ctrlEdit isEqualToString:@"Hy_LDQFM"]) {
                CGRect frame = CGRectMake(170, 71, 204, 70);
                
                self.ldqfTextView1.frame = frame;
                
                self.ldqfTxtView.layer.borderColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0].CGColor;
                
                self.ldqfTxtView.layer.borderWidth =1.5;
                
                self.ldqfTxtView.layer.cornerRadius =6.0;
                
                self.ldqfTxtView.editable = YES;
                
                self.inputLdqf.hidden = NO;
                self.inputLdqf.enabled = YES;
                
                self.clearLdqf.hidden = NO;
                self.clearLdqf.enabled = YES;
                
            }
            else if([ctrlEdit isEqualToString:@"Hy_HQ"]) {
                CGRect frame = CGRectMake(534, 95, 146, 110);
                
                self.hqTxtView.frame = frame;
                
                self.hqTxtView.layer.borderColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0].CGColor;
                
                self.hqTxtView.layer.borderWidth =1.5;
                
                self.hqTxtView.layer.cornerRadius =6.0;
                
                self.hqTxtView.editable = YES;
                
                self.inputHq.hidden = NO;
                self.inputHq.enabled = YES;
                
                self.clearHq.hidden = NO;
                self.clearHq.enabled = YES;
                
            }
            else if([ctrlEdit isEqualToString:@"Hy_CSSH"]) {
                CGRect frame = CGRectMake(170, 351, 204, 70);
                
                self.auditTxtView1.frame = frame;
                
                self.auditTxtView.layer.borderColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0].CGColor;
                
                self.auditTxtView.layer.borderWidth =1.5;
                
                self.auditTxtView.layer.cornerRadius =6.0;
                
                self.auditTxtView.editable = YES;
                
                self.inputAudit.hidden = NO;
                self.inputAudit.enabled = YES;
                
                self.clearAudit.hidden = NO;
                self.clearAudit.enabled = YES;
                
            }
            
            else if([ctrlEdit isEqualToString:@"Hy_ZRSH"]) {
                
                CGRect frame = CGRectMake(534, 375, 146, 110);
                
                self.officeTxtView.frame = frame;
                self.officeTxtView.layer.borderColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0].CGColor;
                
                self.officeTxtView.layer.borderWidth =1.5;
                
                self.officeTxtView.layer.cornerRadius =6.0;
                
                self.officeTxtView.editable = YES;
                
                
                self.inputOffice.hidden = NO;
                self.inputOffice.enabled = YES;
                
                self.clearOffice.hidden = NO;
                self.clearOffice.enabled = YES;
            }
            
            else if([ctrlEdit isEqualToString:@"Hy_Tbyj"]) {
                
                self.opinionTxtView.layer.borderColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0].CGColor;
                
                self.opinionTxtView.layer.borderWidth =1.5;
                
                self.opinionTxtView.layer.cornerRadius =6.0;
                self.opinionTxtView.editable = YES;
                
                
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
        
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:seeItem,rebackItem,reminderItem,nil];
        
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
    [dicValues setValue:self.docid forKey:@"Hy_docid"];
    [dicValues setValue:self.process forKey:@"Hy_process"];
    NSString *modidStr = [self.infoDict objectForKey:@"modid"];
    [dicValues setValue:modidStr forKey:@"Hy_modid"];
    
    [dicValues setValue:self.paperTxt.text forKey:@"Hy_FWGZ"];
    [dicValues setValue:self.ldqfTxtView.text forKey:@"Hy_LDQFM"];
    [dicValues setValue:self.hqTxtView.text forKey:@"Hy_HQ"];
    [dicValues setValue:self.sendDWTxt.text forKey:@"Hy_ZSDW"];
    [dicValues setValue:self.csDWTxt.text forKey:@"Hy_CSDW"];
    [dicValues setValue:self.publicTypeTxt.text forKey:@"Hy_SFGK"];
    [dicValues setValue:[self.sitePublicCtr titleForSegmentAtIndex:self.sitePublicCtr.selectedSegmentIndex] forKey:@"Hy_WZFB"];
    [dicValues setValue:self.auditTxtView.text forKey:@"Hy_CSSH"];
    [dicValues setValue:self.officeTxtView.text forKey:@"Hy_BGSH"];
    [dicValues setValue:self.draftDWLabel.text forKey:@"Hy_ZBDW"];
    
    [dicValues setValue:self.drafterLabel.text forKey:@"Hy_NGR"];
    [dicValues setValue:self.topicTxt.text forKey:@"Hy_ZTC"];
    
    [dicValues setValue:self.titleTxt.text forKey:@"Hy_Bt"];
    [dicValues setValue:self.scretLevelTxt.text forKey:@"Hy_MMDJ"];
    [dicValues setValue:self.urgentTxt.text forKey:@"Hy_hj"];
    
    NSString *lbStr = [self.infoDict objectForKey:@"Hy_lb"];
    [dicValues setValue:lbStr forKey:@"Hy_lb"];
    
    NSString *nfStr = [self.infoDict objectForKey:@"Hy_nf"];
    [dicValues setValue:nfStr forKey:@"Hy_nf"];
    
    NSString *bhStr = [self.infoDict objectForKey:@"Hy_bh"];
    [dicValues setValue:bhStr forKey:@"Hy_bh"];
    
    [dicValues setValue:self.pagesTxt.text forKey:@"Hy_FS"];
    [dicValues setValue:@"" forKey:@"Hy_JDR"];
    [dicValues setValue:self.dateTxt.text forKey:@"Hy_YZRQ"];
    
    [dicValues setValue:self.opinionTxtView.text forKey:@"Hy_Tbyj"];
    
    return dicValues;
}

- (void)viewDidAppear:(BOOL)animated {
    self.navigationItem.backBarButtonItem = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setControlEdit];
    
    self.title = self.process;
    
    self.paperTxt.text = [self.infoDict objectForKey:@"Hy_FWGZ"];
    self.ldqfTextView1.text = [self.infoDict objectForKey:@"Hy_LDQFM_Histroy"];
    
    self.hqTxtView.text = [self.infoDict objectForKey:@"Hy_HQ_Histroy"];

    self.sendDWTxt.text = [self.infoDict objectForKey:@"Hy_ZSDW"];
    
    self.csDWTxt.text = [self.infoDict objectForKey:@"Hy_CSDW"];
    self.publicTypeTxt.text = [self.infoDict objectForKey:@"Hy_SFGK"];
    
    NSString *sitePublic = [self.infoDict objectForKey:@"Hy_WZFB"];
    for (int n=0; n < self.sitePublicCtr.numberOfSegments; n++) {
        NSString *title = [self.sitePublicCtr titleForSegmentAtIndex:n];
        if ([title isEqualToString:sitePublic]) {
            self.sitePublicCtr.selectedSegmentIndex = n;
        }
    }

    self.drafterLabel.text = [self.infoDict objectForKey:@"Hy_NGR"];
    self.draftDWLabel.text = [self.infoDict objectForKey:@"Hy_ZBDW"];
    self.topicTxt.text = [self.infoDict objectForKey:@"Hy_ZTC"];
    self.titleTxt.text = [self.infoDict objectForKey:@"Hy_Bt"];
    self.scretLevelTxt.text = [self.infoDict objectForKey:@"Hy_MMDJ"];
    self.dateTxt.text = [self.infoDict objectForKey:@"Hy_YZRQ"];
    self.urgentTxt.text = [self.infoDict objectForKey:@"Hy_hj"];
    self.pagesTxt.text = [self.infoDict objectForKey:@"Hy_FS"];
    self.reviewerTxt.text = [self.infoDict objectForKey:@"Hy_JDR"];
    
    self.auditTxtView1.text = [self.infoDict objectForKey:@"Hy_CSSH_Histroy"];
   

    self.officeTxtView.text = [self.infoDict objectForKey:@"Hy_ZRSH_Histroy"];
    
    
    self.postId.text = [self.infoDict objectForKey:@"Hy_Allbh"];

   
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
    
    NSDictionary *valueDict = [self getValueData];
    SystemConfigContext *context = [SystemConfigContext sharedInstance];
    NSDictionary *loginUsr = [context getUserInfo];
    NSString *usr = [loginUsr objectForKey:@"userId"];
    
    NSString *docid = [valueDict objectForKey:@"Hy_docid"];
    NSString *modid = [valueDict objectForKey:@"Hy_modid"];
    NSString *isLastTache = [self.infoDict objectForKey:@"Hy_IfLastTache"];
    
    ContinueProcessViewController *continueProcessViewController = [[ContinueProcessViewController alloc] initWithNibName:@"ContinueProcessViewController" bundle:nil];
    continueProcessViewController.docID = docid;
    continueProcessViewController.modID = modid;
    
    NSArray *keys = [[NSArray alloc] initWithObjects:@"Hy_IfLastTache",@"HY_DOCID", @"HY_USERID", @"HY_FWGZ", @"HY_LDQFM", @"HY_HQ", @"HY_ZSDW", @"HY_CSDW", @"HY_SFGK", @"HY_WZFB", @"HY_CSSH", @"HY_BGSH", @"HY_ZBDW", @"HY_NGR",@"HY_ZTC", @"HY_BT", @"HY_MMDJ", @"HY_HJ", @"HY_LB", @"HY_NF", @"HY_BH", @"HY_FS", @"HY_JDR", @"HY_YZRQ", @"HY_TBYJ",@"HY_NEXTTACHEID",@"HY_NEXTTACHENAME",@"HY_NEXTTACHETRANSACTOR",@"HY_NEXTTACHEPASSER",nil];
    
    NSMutableDictionary *values = [[NSMutableDictionary alloc] init];
    [values setObject:isLastTache forKey:@"HY_IFLASTTACHE"];
    [values setObject:docid forKey:@"HY_DOCID"];
    [values setObject:usr forKey:@"HY_USERID"];
    [values setObject:[valueDict objectForKey:@"Hy_FWGZ"] forKey:@"HY_FWGZ"];
    [values setObject:[valueDict objectForKey:@"Hy_LDQFM"] forKey:@"HY_LDQFM"];
    [values setObject:[valueDict objectForKey:@"Hy_HQ"] forKey:@"HY_HQ"];
    [values setObject:[valueDict objectForKey:@"Hy_ZSDW"] forKey:@"HY_ZSDW"];
    [values setObject:[valueDict objectForKey:@"Hy_CSDW"] forKey:@"HY_CSDW"];
    [values setObject:[valueDict objectForKey:@"Hy_SFGK"] forKey:@"HY_SFGK"];
    [values setObject:[valueDict objectForKey:@"Hy_WZFB"] forKey:@"HY_WZFB"];
    [values setObject:[valueDict objectForKey:@"Hy_CSSH"] forKey:@"HY_CSSH"];
    [values setObject:[valueDict objectForKey:@"Hy_BGSH"] forKey:@"HY_BGSH"];
    [values setObject:[valueDict objectForKey:@"Hy_ZBDW"] forKey:@"HY_ZBDW"];
    [values setObject:[valueDict objectForKey:@"Hy_NGR"] forKey:@"HY_NGR"];
    [values setObject:[valueDict objectForKey:@"Hy_ZTC"] forKey:@"HY_ZTC"];
    [values setObject:[valueDict objectForKey:@"Hy_Bt"] forKey:@"HY_BT"];
    [values setObject:[valueDict objectForKey:@"Hy_MMDJ"] forKey:@"HY_MMDJ"];
    [values setObject:[valueDict objectForKey:@"Hy_hj"] forKey:@"HY_HJ"];
    [values setObject:[valueDict objectForKey:@"Hy_lb"] forKey:@"HY_LB"];
    [values setObject:[valueDict objectForKey:@"Hy_nf"] forKey:@"HY_NF"];
    [values setObject:[valueDict objectForKey:@"Hy_bh"] forKey:@"HY_BH"];
    [values setObject:[valueDict objectForKey:@"Hy_FS"] forKey:@"HY_FS"];
    [values setObject:[valueDict objectForKey:@"Hy_JDR"] forKey:@"HY_JDR"];
    [values setObject:[valueDict objectForKey:@"Hy_YZRQ"] forKey:@"HY_YZRQ"];
    [values setObject:[valueDict objectForKey:@"Hy_Tbyj"] forKey:@"HY_TBYJ"];
    
    continueProcessViewController.delegate = self.responder;
    continueProcessViewController.paramsDict = values;
    continueProcessViewController.paramsAry = keys;
    continueProcessViewController.currentProcessName = self.process;
    continueProcessViewController.serviceName = @"FileOutContinuteProcess";
    [self.navigationController pushViewController:continueProcessViewController animated:YES];
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
    NSDictionary *valueDict = [self getValueData];
    
    NSString *docid = [valueDict objectForKey:@"Hy_docid"];
    NSString *fwgz  = [valueDict objectForKey:@"Hy_FWGZ"];
    NSString *ldqfm  = [valueDict objectForKey:@"Hy_LDQFM"];
    NSString *hq  = [valueDict objectForKey:@"Hy_HQ"];
    NSString *zsdw  = [valueDict objectForKey:@"Hy_ZSDW"];
    NSString *csdw  = [valueDict objectForKey:@"Hy_CSDW"];
    NSString *sfgk  = [valueDict objectForKey:@"Hy_SFGK"];
    NSString *wzfb  = [valueDict objectForKey:@"Hy_WZFB"];
    NSString *cssh  = [valueDict objectForKey:@"Hy_CSSH"];
    NSString *bgsh  = [valueDict objectForKey:@"Hy_BGSH"];
    NSString *zbdw  = [valueDict objectForKey:@"Hy_ZBDW"];
    NSString *ngr  = [valueDict objectForKey:@"Hy_NGR"];
    NSString *ztc  = [valueDict objectForKey:@"Hy_ZTC"];
    NSString *bt  = [valueDict objectForKey:@"Hy_Bt"];
    NSString *mmdj  = [valueDict objectForKey:@"Hy_MMDJ"];
    NSString *hj  = [valueDict objectForKey:@"Hy_hj"];
    NSString *lb  = [valueDict objectForKey:@"Hy_lb"];
    NSString *nf  = [valueDict objectForKey:@"Hy_nf"];
    NSString *bh  = [valueDict objectForKey:@"Hy_bh"];
    NSString *fs  = [valueDict objectForKey:@"Hy_FS"];
    NSString *jdr  = [valueDict objectForKey:@"Hy_JDR"];
    NSString *yzrq  = [valueDict objectForKey:@"Hy_YZRQ"];
    NSString *tbyj  = [valueDict objectForKey:@"Hy_Tbyj"];
    
    SystemConfigContext *context = [SystemConfigContext sharedInstance];
    NSDictionary *loginUsr = [context getUserInfo];
    NSString *userid = [loginUsr objectForKey:@"userId"];
    
    NSString *strURL = [ServiceUrlString generateWebServiceUrl];
    NSString *params = [WebServiceHelper createParametersWithKey:@"Hy_docid" value:docid,@"Hy_userid",userid,@"Hy_FWGZ",fwgz, @"Hy_LDQFM",ldqfm,@"Hy_HQ",hq,@"Hy_ZSDW",zsdw,@"Hy_CSDW",csdw,@"Hy_SFGK",sfgk,@"Hy_WZFB",wzfb,@"Hy_CSSH",cssh,@"Hy_BGSH",bgsh,@"Hy_ZBDW",zbdw,@"Hy_NGR",ngr,@"Hy_ZTC",ztc,@"Hy_Bt",bt,@"Hy_MMDJ",mmdj,@"Hy_hj",hj,@"Hy_lb",lb,@"Hy_nf",nf,@"Hy_bh",bh,@"Hy_FS",fs,@"Hy_JDR",jdr,@"Hy_YZRQ",yzrq,@"Hy_Tbyj",tbyj,nil];
    
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strURL method:@"FileOutSaveProcess" nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
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
    NSDictionary *valueDict = [self getValueData];
    NSString *docid = [valueDict objectForKey:@"Hy_docid"];
    NSString *modid = [valueDict objectForKey:@"Hy_modid"];
    ReturnBackViewController *returnBack = [[ReturnBackViewController alloc] initWithNibName:@"ReturnBackViewController" bundle:nil];
    returnBack.mdId = modid;
    returnBack.docId = docid;
    returnBack.delegate = self.responder;
    returnBack.currentProcess = self.process;
    [self.navigationController pushViewController:returnBack animated:YES];
}

- (void)remindHandleProcess{
    NSDictionary *valueDict = [self getValueData];
    NSString *docid = [valueDict objectForKey:@"Hy_docid"];
    NSString *modid = [valueDict objectForKey:@"Hy_modid"];
    
    
    RemindersViewController *reminder = [[RemindersViewController alloc] initWithNibName:@"RemindersViewController" bundle:nil];
    reminder.modID = modid;
    reminder.docID = docid;
    reminder.delegate = self.responder;
    [self.navigationController pushViewController:reminder animated:YES];
}

- (void)redrawButtonClick:(id)sender
{
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"正在收文文档，请稍候..." width:180];
    
    SystemConfigContext *context = [SystemConfigContext sharedInstance];
    NSDictionary *loginUsr = [context getUserInfo];
    NSString *userid = [loginUsr objectForKey:@"userId"];
    
    NSDictionary *valueDict = [self getValueData];
    
    NSString *modid = [valueDict objectForKey:@"Hy_modid"];
    NSString *docid = [valueDict objectForKey:@"Hy_docid"];

    NSString *strURL = [ServiceUrlString generateWebServiceUrl];
    NSString *params = [WebServiceHelper createParametersWithKey:@"Hy_userid" value:userid,@"Hy_mdid",modid,@"docid",docid,nil];
    
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strURL method:@"reback" nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
    self.webServiceType = kWebService_Reback;
    [self.webServiceHelper run];
}

- (void)transferToNextStep{
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"正在保存数据，请稍候..." width:180];
    
    NSDictionary *valueDict = [self getValueData];
    NSString *docid = [valueDict objectForKey:@"Hy_docid"];
    NSString *fwgz  = [valueDict objectForKey:@"Hy_FWGZ"];
    NSString *ldqfm  = [valueDict objectForKey:@"Hy_LDQFM"];
    NSString *hq  = [valueDict objectForKey:@"Hy_HQ"];
    NSString *zsdw  = [valueDict objectForKey:@"Hy_ZSDW"];
    NSString *csdw  = [valueDict objectForKey:@"Hy_CSDW"];
    NSString *sfgk  = [valueDict objectForKey:@"Hy_SFGK"];
    NSString *wzfb  = [valueDict objectForKey:@"Hy_WZFB"];
    NSString *cssh  = [valueDict objectForKey:@"Hy_CSSH"];
    NSString *bgsh  = [valueDict objectForKey:@"Hy_BGSH"];
    NSString *zbdw  = [valueDict objectForKey:@"Hy_ZBDW"];
    NSString *ngr  = [valueDict objectForKey:@"Hy_NGR"];
    NSString *ztc  = [valueDict objectForKey:@"Hy_ZTC"];
    NSString *bt  = [valueDict objectForKey:@"Hy_Bt"];
    NSString *mmdj  = [valueDict objectForKey:@"Hy_MMDJ"];
    NSString *hj  = [valueDict objectForKey:@"Hy_hj"];
    NSString *lb  = [valueDict objectForKey:@"Hy_lb"];
    NSString *nf  = [valueDict objectForKey:@"Hy_nf"];
    NSString *bh  = [valueDict objectForKey:@"Hy_bh"];
    NSString *fs  = [valueDict objectForKey:@"Hy_FS"];
    NSString *jdr  = [valueDict objectForKey:@"Hy_JDR"];
    NSString *yzrq  = [valueDict objectForKey:@"Hy_YZRQ"];
    NSString *tbyj  = [valueDict objectForKey:@"Hy_Tbyj"];
    
    
    NSString *strUrl = [ServiceUrlString generateWebServiceUrl];
    
    SystemConfigContext *context = [SystemConfigContext sharedInstance];
    NSDictionary *loginUsr = [context getUserInfo];
    NSString *userid = [loginUsr objectForKey:@"userId"];
    
    NSString *params = [WebServiceHelper createParametersWithKey:@"Hy_docid" value:docid,@"Hy_IfLastTache",@"1",@"Hy_userid",userid,@"Hy_FWGZ",fwgz, @"Hy_LDQFM",ldqfm,@"Hy_HQ",hq,@"Hy_ZSDW",zsdw,@"Hy_CSDW",csdw,@"Hy_SFGK",sfgk,@"Hy_WZFB",wzfb,@"Hy_CSSH",cssh,@"Hy_BGSH",bgsh,@"Hy_ZBDW",zbdw,@"Hy_NGR",ngr,@"Hy_ZTC",ztc,@"Hy_Bt",bt,@"Hy_MMDJ",mmdj,@"Hy_hj",hj,@"Hy_lb",lb,@"Hy_nf",nf,@"Hy_bh",bh,@"Hy_FS",fs,@"Hy_JDR",jdr,@"Hy_YZRQ",yzrq,@"Hy_Tbyj",tbyj,@"Hy_NextTacheId",@"*",@"Hy_NextTacheName",@"*",@"Hy_NextTacheTransactor",@"",@"Hy_NextTachePasser",@"",nil];
    
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:@"FileOutContinuteProcess" nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
    self.webServiceType = kWebService_NextProcess;
    [self.webServiceHelper run];
    
    
}

- (void)lookupProcess:(id)sender {
    
    NSDictionary *valueDict = [self getValueData];

    NSString *modid = [valueDict objectForKey:@"Hy_modid"];
    NSString *docid = [valueDict objectForKey:@"Hy_docid"];
    
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
        contentEditViewController.editorType = KEditor_Type_FWGZ;
        contentEditViewController.oldValue = self.paperTxt.text;
        self.txtCtrl = self.paperTxt;

    }
    
    else if(tag == 1 )
    {
        //主送单位
        contentEditViewController.editorTitle = @"主送单位";
        contentEditViewController.editorType = kEditor_Type_Dept;
        contentEditViewController.oldValue = self.sendDWTxt.text;
        self.txtCtrl = self.sendDWTxt;
    }
    else if(tag == 2){
        //抄送单位
        contentEditViewController.editorTitle = @"抄送单位";
        contentEditViewController.editorType = kEditor_Type_Dept;
        contentEditViewController.oldValue = self.csDWTxt.text;
        self.txtCtrl = self.csDWTxt;
    }
    
    else if(tag == 3){
        //主题词
        contentEditViewController.editorType = kEditor_Type_ZTC;
        contentEditViewController.editorTitle = @"主题词";
        contentEditViewController.oldValue = self.topicTxt.text;
        self.txtCtrl = self.topicTxt;
    }
    
    else if(tag == 4) {
        //领导签发
        contentEditViewController.editorType = KEditor_Type_SRYJ;
        contentEditViewController.editorTitle = @"领导签发";
        contentEditViewController.oldValue = self.ldqfTxtView.text;
        self.txtView = self.ldqfTxtView;
    }
    
    else if(tag == 5) {
        //处室会签
        contentEditViewController.editorType = KEditor_Type_SRYJ;
        contentEditViewController.editorTitle = @"处室会签";
        contentEditViewController.oldValue = self.hqTxtView.text;
        self.txtView = self.hqTxtView;
    }
    else if(tag == 6) {
        //处室审核
        contentEditViewController.editorType = KEditor_Type_SRYJ;
        contentEditViewController.editorTitle = @"处室审核";
        contentEditViewController.oldValue = self.auditTxtView.text;
        self.txtView = self.auditTxtView;
    }

    else if(tag == 7) {
        contentEditViewController.editorType = KEditor_Type_SRYJ;
        contentEditViewController.editorTitle = @"办公室审核";
        contentEditViewController.oldValue = self.officeTxtView.text;
        self.txtView = self.officeTxtView;
    }
    
        
    else if(tag == 8) {
        contentEditViewController.editorType = KEditor_Type_SRYJ;
        contentEditViewController.editorTitle = @"退办意见";
        contentEditViewController.oldValue = self.opinionTxtView.text;
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
    if(indexPath.section == 0)
    {
        //查看文件
        NSDictionary *docDict = [self.infoDict objectForKey:@"Hy_newdoc"];
        if(docDict != nil && [docDict objectForKey:@"fileurl"] != nil)
        {
            fileName = [docDict objectForKey:@"filename"];
            fileUrl = [docDict objectForKey:@"fileurl"];
            
            DisplayAttachFileController *display = [[DisplayAttachFileController alloc] initWithNibName:@"DisplayAttachFileController" fileURL:fileUrl andFileName:fileName];
            [self.navigationController pushViewController:display animated:YES];
        }
    }
    else if (indexPath.section == 1)
    {
        NSDictionary *docDict = [self.infoDict objectForKey:@"Hy_Fj3"];
        if(docDict != nil && [docDict objectForKey:@"fileurl"] != nil)
        {
            fileName = [docDict objectForKey:@"filename"];
            fileUrl = [docDict objectForKey:@"fileurl"];
            DisplayAttachFileController *display = [[DisplayAttachFileController alloc] initWithNibName:@"DisplayAttachFileController" fileURL:fileUrl andFileName:fileName];
            [self.navigationController pushViewController:display animated:YES];
        }
    }
    else if(indexPath.section == 2)
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

        
    
        self.txtView.text = opinionStr;
        
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
#pragma mark WordsDelegate
- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row {
    
    if(self.popController.popoverVisible) {
        [self.popController dismissPopoverAnimated:YES];
    }
    self.txtCtrl.text = words;
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
        WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:@"FileOutSaveProcessReturn" andWithJSONDelegate:self];
        webDataHelper.serviceTag = kWebService_SaveProcess;
        [webDataHelper parseXMLData:webData];
    }
    else if (self.webServiceType == kWebService_NextProcess) {
        WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:@"FileOutContinuteProcessReturn" andWithJSONDelegate:self];
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
