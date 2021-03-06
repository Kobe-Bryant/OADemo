//
//  FileOutDetailViewController.m
//  NingBoOA
//
//  Created by 熊熙 on 13-9-29.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ProjectCheckDetailViewController.h"
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
#import "UIButton+Bootstrap.h"
#import "SystemConfigContext.h"
#import "DejalActivityView.h"
#import "ShowWebViewController.h"
#import "SNSelectViewController.h"
@interface ProjectCheckDetailViewController ()

@property (strong, nonatomic) UIPopoverController *popController;

@end

@implementation ProjectCheckDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {}
    return self;
}


- (void)setControlEdit{
    UIScrollView *scrollView = (UIScrollView *)self.view; 
    [scrollView setContentSize:CGSizeMake(768, 2360)];
    
    self.jsnrTxtView.layer.borderColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0].CGColor;
    self.jsnrTxtView.layer.borderWidth =1.5;
    self.jsnrTxtView.layer.cornerRadius =6.0;
    
    self.bgnrTxtView.layer.borderColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0].CGColor;
    self.bgnrTxtView.layer.borderWidth =1.5;
    self.bgnrTxtView.layer.cornerRadius =6.0;
    
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

            else if([ctrlEdit isEqualToString:@"Hy_Bt"]){
                self.titleTxtView.layer.borderColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0].CGColor;
                
                self.titleTxtView.layer.borderWidth =1.5;
                
                self.titleTxtView.layer.cornerRadius =6.0;
                
                self.titleTxtView.editable = YES;

                
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
                self.fwlbTxt.text = [self.infoDict objectForKey:@"Hy_lb"];
                self.fwlbTxt.frame = CGRectMake(170, 676, 280, 30);
                self.fwlbTxt.borderStyle = UITextBorderStyleRoundedRect;
                
                self.fwnfLabel.hidden = NO;
                self.fwnfTxt.hidden = NO;
                
                self.fwbhLabel.hidden = NO;
                self.fwbhTxt.hidden = NO;
                
                self.fwbhBtn.enabled = YES;
                self.fwbhBtn.hidden  = NO;
            }
            else if([ctrlEdit isEqualToString:@"Hy_YZRQ"]){
                self.dateTxt.borderStyle = UITextBorderStyleRoundedRect;
                self.dateTxt.enabled = YES;
                
                self.dateBtn.hidden = NO;
                self.dateBtn.enabled = YES;
            }
            
            else if([ctrlEdit isEqualToString:@"Hy_CSSH"]) {
                CGRect frame = CGRectMake(530, 198, 204, 70);
                
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
            
            else if([ctrlEdit isEqualToString:@"Hy_Tbyj"]) {
                CGRect frame = CGRectMake(530, 588, 204, 70);
                self.opinionTxtView1.frame = frame;
                
                self.opinionTxtView.layer.borderColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0].CGColor;
                
                self.opinionTxtView.layer.borderWidth =1.5;
                self.opinionTxtView.layer.cornerRadius =6.0;
                self.opinionTxtView.editable = YES;
                
                self.inputOpinion.hidden = NO;
                self.inputOpinion.enabled = YES;
                
                self.clearOpinion.hidden = NO;
                self.clearOpinion.enabled = YES;
            }
            else if([ctrlEdit isEqualToString:@"Hy_Spyj"]) {
                CGRect frame = CGRectMake(530, 818, 204, 70);
                self.opinionTxtView1.frame = frame;
                
                self.spyjTxtView.layer.borderColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0].CGColor;

                self.spyjTxtView.layer.borderWidth =1.5;
                self.spyjTxtView.layer.cornerRadius =6.0;
                self.spyjTxtView.userInteractionEnabled = YES;
               
                self.inputSpyj.hidden = NO;
                self.inputSpyj.enabled = YES;
                
                self.clearSpyj.hidden = NO;
                self.clearSpyj.enabled = YES;
                
            }
            
            else if([ctrlEdit isEqualToString:@"Hy_Spr"]) {
                self.sprTxt.borderStyle = UITextBorderStyleRoundedRect;
                self.sprTxt.enabled = YES;
                
            }
            else if([ctrlEdit isEqualToString:@"Hy_Spsj"]) {
                self.spsjTxt.borderStyle = UITextBorderStyleRoundedRect;
                self.spsjTxt.enabled = YES;
            }
            else if([ctrlEdit isEqualToString:@"Hy_Spjg"]) {
                self.spjgTxt.borderStyle = UITextBorderStyleRoundedRect;
                self.spjgTxt.enabled = YES;
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
    NSString *isLastProcess = [self.infoDict objectForKey:@"Hy_IfLastTache"];
    NSString *modid = [self.infoDict objectForKey:@"modid"];
    
    SystemConfigContext *context = [SystemConfigContext sharedInstance];
    NSDictionary *loginUsr = [context getUserInfo];
    NSString *user = [loginUsr objectForKey:@"userId"];
    
    NSString *mmhj = [NSString stringWithFormat:@"%@+%@",self.scretLevelTxt.text,self.urgentTxt.text];
    
    [dicValues setValue:modid forKey:@"Hy_mdid"];
    [dicValues setValue:isLastProcess forKey:@"Hy_IfLastTache"];
    [dicValues setValue:user forKey:@"Hy_userid"];
    [dicValues setValue:self.docid forKey:@"Hy_docid"];
    
    [dicValues setValue:self.paperTxt.text forKey:@"Hy_FWGZ"];
    [dicValues setValue:self.sendDWTxt.text forKey:@"Hy_ZSDW"];
    [dicValues setValue:self.csDWTxt.text forKey:@"Hy_CSDW"];
    [dicValues setValue:self.publicTypeTxt.text forKey:@"Hy_SFGK"];
    [dicValues setValue:self.qcrqLabel.text forKey:@"Hy_QCRQ"];
    [dicValues setValue:self.auditTxtView.text forKey:@"Hy_CSHG"];
    [dicValues setValue:self.draftDWLabel.text forKey:@"Hy_ZBDW"];
    [dicValues setValue:self.drafterLabel.text forKey:@"Hy_NGR"];
    [dicValues setValue:self.titleTxtView.text forKey:@"Hy_BT"];
    [dicValues setValue:mmhj forKey:@"Hy_MMHJ"];
    [dicValues setValue:self.urgentTxt.text forKey:@"Hy_HJ"];
    [dicValues setValue:self.fwlbTxt.text forKey:@"Hy_LB"];
    [dicValues setValue:self.fwnfTxt.text forKey:@"Hy_NF"];
    [dicValues setValue:self.fwbhTxt.text forKey:@"Hy_BH"];
    [dicValues setValue:self.pagesTxt.text forKey:@"Hy_FS"];
    [dicValues setValue:self.reviewerLabel.text forKey:@"Hy_JDR"];
    [dicValues setValue:self.dateTxt.text forKey:@"Hy_YZRQ"];
    [dicValues setValue:self.opinionTxtView.text forKey:@"Hy_TBYJ"];
    [dicValues setValue:self.spyjTxtView.text forKey:@"Hy_SPYJ"];
    NSString *spxx = [NSString stringWithFormat:@"%@+%@+%@",self.sprTxt.text,self.spsjTxt.text,self.spjgTxt.text];
    [dicValues setValue:spxx forKey:@"Hy_SPXX"];
    return dicValues;
}

- (void)loadCheckInfo{
    self.jsdwmc.text = [self.infoDict objectForKey:@"Hy_Jsdwmc"];
    self.jsdwbm.text = [self.infoDict objectForKey:@"Hy_Jsdwbm"];
    self.jsdwlxr.text = [self.infoDict objectForKey:@"Hy_Lxr"];
    self.jsdwdh.text = [self.infoDict objectForKey:@"Hy_Dwdh"];
    self.jsdwfrdb.text = [self.infoDict objectForKey:@"Hy_Frdb"];
    self.jsdwfrdh.text = [self.infoDict objectForKey:@"Hy_Frlxdh"];
    self.jsdwfrdm.text = [self.infoDict objectForKey:@"Hy_Frdm"];
    self.jsdwyzbm.text = [self.infoDict objectForKey:@"Hy_Yzbm"];
    self.jsdwcz.text = [self.infoDict objectForKey:@"Hy_Cz"];
    self.jsdwdz.text = [self.infoDict objectForKey:@"Hy_Txdz"];
    self.xmmc.text = [self.infoDict objectForKey:@"Hy_Xmjsmc"];
    self.xmsqsj.text = [self.infoDict objectForKey:@"Hy_Xmsqsj"];
    self.xmjsdd.text = [self.infoDict objectForKey:@"Hy_Nxjdd"];
    self.xmssqy.text = [self.infoDict objectForKey:@"Hy_Ssqy"];
    self.xmztz.text = [self.infoDict objectForKey:@"Hy_Xmztz"];
    self.xmjsxzStr = [self.infoDict objectForKey:@"Hy_Jsxz"];
    
    NSString *title1 = self.xmjsxzBtn1.titleLabel.text;
    NSString *title2 = self.xmjsxzBtn2.titleLabel.text;
    NSString *title3 = self.xmjsxzBtn3.titleLabel.text;
    
    if ([self.xmjsxzStr isEqualToString:title1]) {
        [self.xmjsxzBtn1 setImage:[UIImage imageNamed:@"RadioButton-Selected.png"] forState:UIControlStateNormal];
    }
    
    if ([self.xmjsxzStr isEqualToString:title2]) {
        [self.xmjsxzBtn2 setImage:[UIImage imageNamed:@"RadioButton-Selected.png"] forState:UIControlStateNormal];
    }
    
    if ([self.xmjsxzStr isEqualToString:title3]) {
        [self.xmjsxzBtn3 setImage:[UIImage imageNamed:@"RadioButton-Selected.png"] forState:UIControlStateNormal];
    }
    
    self.xmssgl.text = [self.infoDict objectForKey:@"Hy_Ssglfw"];
}

- (void)loadProjectApprovalInfo {
    self.spztz.text = [self.infoDict objectForKey:@"Hy_Ztz"];
    self.sphbtz.text = [self.infoDict objectForKey:@"Hy_Hbtz"];
    self.sptzbl.text = [self.infoDict objectForKey:@"Hy_Tzbl"];
    self.sphylb.text = [self.infoDict objectForKey:@"Hy_Hylb"];
    self.spjsdz.text = [self.infoDict objectForKey:@"Hy_Jsdd"];
    self.splxbm.text = [self.infoDict objectForKey:@"Hy_Lxbm"];
    self.splxpwh.text = [self.infoDict objectForKey:@"Hy_Lxpwh"];
    self.spxkwh.text = [self.infoDict objectForKey:@"Hy_Hbxzxkwh"];
    self.spykgsj.text = [self.infoDict objectForKey:@"Hy_Ykgsj"];
    self.spzdmj.text = [self.infoDict objectForKey:@"Hy_Hy_Xmzdmj"];
    self.spjzmj.text = [self.infoDict objectForKey:@"Hy_Jzmj"];
    self.sphpjg.text = [self.infoDict objectForKey:@"Hy_Hpjg"];
    self.spbpsj.text = [self.infoDict objectForKey:@"Hy_Bpsj"];
    self.sppjjf.text = [self.infoDict objectForKey:@"Hy_Pjjf"];
    self.spsflkStr = [self.infoDict objectForKey:@"Hy_Sflkq"];
    
    NSString *title1 = self.spsflkBtn1.titleLabel.text;
    NSString *title2 = self.spsflkBtn2.titleLabel.text;
    if ([self.spsflkStr isEqualToString:title1]) {
        [self.spsflkBtn1 setImage:[UIImage imageNamed:@"RadioButton-Selected.png"] forState:UIControlStateNormal];
    }
    if ([self.spsflkStr isEqualToString:title2]) {
        [self.spsflkBtn2 setImage:[UIImage imageNamed:@"RadioButton-Selected.png"] forState:UIControlStateNormal];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    self.navigationItem.backBarButtonItem = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = self.process;
    [self.xmxxBtn infoStyle];
    
    self.fwlbTxt.text = [self.infoDict objectForKey:@"Hy_lb"];
    self.fwnfTxt.text = [self.infoDict objectForKey:@"Hy_nf"];
    self.fwbhTxt.text = [self.infoDict objectForKey:@"Hy_bh"];
    
    self.paperTxt.text = [self.infoDict objectForKey:@"Hy_FWGZ"];
  
    self.sendDWTxt.text = [self.infoDict objectForKey:@"Hy_ZSDW"];
    
    self.csDWTxt.text = [self.infoDict objectForKey:@"Hy_CSDW"];
    self.publicTypeTxt.text = [self.infoDict objectForKey:@"Hy_SFGK"];
    
    self.qcrqLabel.text = [self.infoDict objectForKey:@"Hy_QCRQ"];

    self.drafterLabel.text = [self.infoDict objectForKey:@"Hy_NGR"];
    self.draftDWLabel.text = [self.infoDict objectForKey:@"Hy_ZBDW"];
    self.titleTxtView.text = [self.infoDict objectForKey:@"Hy_Bt"];
    self.scretLevelTxt.text = [self.infoDict objectForKey:@"Hy_MMDJ"];
    self.dateTxt.text = [self.infoDict objectForKey:@"Hy_YZRQ"];
    self.urgentTxt.text = [self.infoDict objectForKey:@"Hy_hj"];
    self.pagesTxt.text = [self.infoDict objectForKey:@"Hy_FS"];
    self.reviewerLabel.text = [self.infoDict objectForKey:@"Hy_JDR"];
    
    self.auditTxtView1.text = [self.infoDict objectForKey:@"Hy_CSSH_Histroy"];
   
    self.sprTxt.text = [self.infoDict objectForKey:@"Hy_Spr"];
    self.spsjTxt.text = [self.infoDict objectForKey:@"Hy_Spsj"];
    self.spjgTxt.text = [self.infoDict objectForKey:@"Hy_Spjg"];
    self.spyjTxtView.text = [self.infoDict objectForKey:@"Hy_Spyj"];
    
    [self loadProjectApprovalInfo];
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
    NSArray *keys =  @[ @"Hy_mdid", @"Hy_IfLastTache", @"Hy_docid", @"Hy_userid",@"Hy_FWGZ", @"Hy_CSHG", @"Hy_ZSDW", @"Hy_CSDW", @"Hy_SFGK", @"Hy_QCRQ", @"Hy_ZBDW", @"Hy_NGR", @"Hy_BT", @"Hy_MMHJ", @"Hy_LB", @"Hy_NF", @"Hy_BH", @"Hy_FS", @"Hy_JDR", @"Hy_YZRQ", @"Hy_TBYJ", @"Hy_SPXX", @"Hy_SPYJ", @"Hy_NextTacheId", @"Hy_NextTacheName", @"Hy_NextTacheTransactor", @"Hy_NextTachePasser" ];
    
    ContinueProcessViewController *continueProcessViewController = [[ContinueProcessViewController alloc] initWithNibName:@"ContinueProcessViewController" bundle:nil];
    continueProcessViewController.delegate = self.responder;
    continueProcessViewController.parameterDictionary = keyedArguments;
    continueProcessViewController.paramsAry = keys;
    continueProcessViewController.currentProcessName = self.process;
    continueProcessViewController.serviceName = @"reportTableContinuteProcess";
    [self.navigationController pushViewController:continueProcessViewController animated:YES];
}

- (void)transferToNextStep{
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"正在保存数据，请稍候..." width:180];
    
    NSDictionary *keyedValue = [self getValueData];
    NSArray *keys = @[ @"Hy_mdid", @"Hy_IfLastTache", @"Hy_docid", @"Hy_userid",@"Hy_FWGZ", @"Hy_CSHG", @"Hy_ZSDW", @"Hy_CSDW", @"Hy_SFGK", @"Hy_QCRQ", @"Hy_ZBDW", @"Hy_NGR", @"Hy_BT", @"Hy_MMHJ", @"Hy_LB", @"Hy_NF", @"Hy_BH", @"Hy_FS", @"Hy_JDR", @"Hy_YZRQ", @"Hy_TBYJ", @"Hy_SPXX", @"Hy_SPYJ" @"Hy_NextTacheId", @"Hy_NextTacheName", @"Hy_NextTacheTransactor", @"Hy_NextTachePasser" ];
    
    NSMutableDictionary *keyedArguments = [[NSMutableDictionary alloc] initWithDictionary:keyedValue];
    [keyedArguments setObject:@"*" forKey:@"Hy_NextTacheId"];
    [keyedArguments setObject:@"*" forKey:@"Hy_NextTacheName"];
    [keyedArguments setObject:@"" forKey:@"Hy_NextTacheTransactor"];
    [keyedArguments setObject:@"" forKey:@"Hy_NextTachePasser"];
   
    NSString *strUrl = [ServiceUrlString generateOAWebServiceUrl];
    NSString *params = [WebServiceHelper createParametersWithKeys:keys andValues:keyedArguments];
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:@"reportTableContinuteProcess" nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
    self.webServiceType = kWebService_NextProcess;
    [self.webServiceHelper run];
}

#pragma mark -
#pragma mark Handle Event
- (IBAction)loadProjectInfo:(id)sender{
    
    NSString *URLString = [self.infoDict objectForKey:@"Hy_xmxxurl"];
    ShowWebViewController *showWebViewController =[[ShowWebViewController alloc] initWithURLString:URLString Title:@"详细信息"];
    [self.navigationController pushViewController:showWebViewController animated:YES];
}


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
    NSArray *keys = @[ @"Hy_mdid", @"Hy_docid", @"Hy_userid", @"Hy_FWGZ", @"Hy_CSHG", @"Hy_ZSDW", @"Hy_CSDW", @"Hy_SFGK", @"Hy_QCRQ", @"Hy_ZBDW", @"Hy_NGR", @"Hy_BT", @"Hy_MMHJ", @"Hy_LB", @"Hy_NF", @"Hy_BH", @"Hy_FS", @"Hy_JDR", @"Hy_YZRQ", @"Hy_TBYJ", @"Hy_SPXX", @"Hy_SPYJ" ];
    
    NSString *strURL = [ServiceUrlString generateOAWebServiceUrl];
    NSString *params = [WebServiceHelper createParametersWithKeys:keys andValues:keyedArguments];
    
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strURL method:@"reportTableSaveProcess" nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
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
    NSString *docid = [keyedArguments objectForKey:@"Hy_docid"];
    NSString *modid = [keyedArguments objectForKey:@"Hy_mdid"];

    ReturnBackViewController *returnBack = [[ReturnBackViewController alloc] initWithNibName:@"ReturnBackViewController" bundle:nil];
    returnBack.mdId = modid;
    returnBack.docId = docid;
    returnBack.delegate = self.responder;
    returnBack.currentProcess = self.process;
    [self.navigationController pushViewController:returnBack animated:YES];
}

- (void)remindHandleProcess{
    NSDictionary *keyedArguments = [self getValueData];
    NSString *docid = [keyedArguments objectForKey:@"Hy_docid"];
    NSString *modid = [keyedArguments objectForKey:@"Hy_mdid"];

    RemindersViewController *reminder = [[RemindersViewController alloc] initWithNibName:@"RemindersViewController" bundle:nil];
    reminder.modID = modid;
    reminder.docID = docid;
    reminder.delegate = self.responder;
    [self.navigationController pushViewController:reminder animated:YES];
}

- (void)redrawButtonClick:(id)sender
{
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"正在收文文档，请稍候..." width:180];
    
    NSDictionary *keyedArguments = [self getValueData];
    NSString *userid = [keyedArguments objectForKey:@"Hy_userid"];
    NSString *docid = [keyedArguments objectForKey:@"Hy_docid"];
    NSString *modid = [keyedArguments objectForKey:@"Hy_mdid"];

    NSString *strURL = [ServiceUrlString generateOAWebServiceUrl];
    NSString *params = [WebServiceHelper createParametersWithKey:@"Hy_userid" value:userid,@"Hy_mdid",modid,@"docid",docid,nil];
    
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strURL method:@"reback" nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
    self.webServiceType = kWebService_Reback;
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
        contentEditViewController.editorType = KEditor_Type_GWGZ;
        contentEditViewController.oldValue = self.paperTxt.text;
        contentEditViewController.serviceName = @"registryPaper";
        self.txtCtrl = self.paperTxt;

    }
    
    else if(tag == 1 )
    {
        //主送单位
        contentEditViewController.editorTitle = @"主送单位";
        contentEditViewController.editorType = kEditor_Type_Dept;
        contentEditViewController.oldValue = self.sendDWTxt.text;
        contentEditViewController.serviceName = @"registryUnit";
        self.txtCtrl = self.sendDWTxt;
    }
    else if(tag == 2){
        //抄送单位
        contentEditViewController.editorTitle = @"抄送单位";
        contentEditViewController.editorType = kEditor_Type_Dept;
        contentEditViewController.oldValue = self.csDWTxt.text;
        contentEditViewController.serviceName = @"registryUnit";
        self.txtCtrl = self.csDWTxt;
    }
    
    
    else if(tag == 3) {
        //处室审核
        contentEditViewController.editorType = KEditor_Type_SRYJ;
        contentEditViewController.editorTitle = @"处室审核";
        contentEditViewController.oldValue = self.auditTxtView.text;
        contentEditViewController.serviceName = @"returnPersonOpinionList";
        self.txtView = self.auditTxtView;
    }

    else if(tag == 4) {
        contentEditViewController.editorType = KEditor_Type_SRYJ;
        contentEditViewController.editorTitle = @"退办意见";
        contentEditViewController.oldValue = self.opinionTxtView.text;
        contentEditViewController.serviceName = @"returnPersonOpinionList";
        self.txtView = self.opinionTxtView;
    }
    else {
        contentEditViewController.editorType = KEditor_Type_SRYJ;
        contentEditViewController.editorTitle = @"审批意见";
        contentEditViewController.oldValue = self.spyjTxtView.text;
        contentEditViewController.serviceName = @"returnPersonOpinionList";
        self.txtView = self.spyjTxtView;
    }
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:contentEditViewController];
    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    navigationController.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:navigationController animated:YES];
}

- (IBAction)selectOfficeDocumentSN:(id)sender{
    SNSelectViewController *snSelectViewController = [[SNSelectViewController alloc] init];
    snSelectViewController.contentSizeForViewInPopover = CGSizeMake(360, 216);
    snSelectViewController.serviceName = @"registryFileType";
    snSelectViewController.delegate = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:snSelectViewController];
    
    UIPopoverController *tmppopover = [[UIPopoverController alloc] initWithContentViewController:navigationController];
    self.popController = tmppopover;
    [self.popController presentPopoverFromRect:self.fwbhTxt.frame
                                        inView:self.view
                      permittedArrowDirections:UIPopoverArrowDirectionAny
                                      animated:YES];
}


- (IBAction)clearInputOpinion:(id)sender {
    NSInteger tag = [sender tag];
    switch (tag) {
        case 4:
            
            break;
        case 5:
            break;
        case 6:
             self.auditTxtView.text = @"";
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
        WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:@"reportTableSaveProcessReturn" andWithJSONDelegate:self];
        webDataHelper.serviceTag = kWebService_SaveProcess;
        [webDataHelper parseXMLData:webData];
    }
    else if (self.webServiceType == kWebService_NextProcess) {
        WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:@"reportTableContinuteProcessReturn" andWithJSONDelegate:self];
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
