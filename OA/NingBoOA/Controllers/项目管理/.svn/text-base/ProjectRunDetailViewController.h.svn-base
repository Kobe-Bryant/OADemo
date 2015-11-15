//
//  FileOutDetailViewController.h
//  NingBoOA
//
//  Created by 熊熙 on 13-9-29.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileOutManagerController.h"
#import "BaseViewController.h"
#import "CommenWordsViewController.h"
#import "ContentEditViewController.h"
#import "SNSelectViewController.h"
#import "HandleGWProtocol.h"


@interface ProjectRunDetailViewController : BaseViewController<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,WordsDelegate,GetOfficeDocumentSNDelegate,ContentEditDelegate,PopupDateDelegate> 

@property (strong, nonatomic) IBOutlet UITextField *paperTxt;
@property (strong, nonatomic) IBOutlet UIButton   *paperBtn;
@property (strong, nonatomic) IBOutlet UITextField *sendDWTxt;
@property (strong, nonatomic) IBOutlet UIButton    *sendDWBtn;
@property (strong, nonatomic) IBOutlet UITextField *csDWTxt;
@property (strong, nonatomic) IBOutlet UIButton    *csDWBtn;
@property (strong, nonatomic) IBOutlet UILabel     *qcrqLabel;;
@property (strong, nonatomic) IBOutlet UITextField *publicTypeTxt;
@property (strong, nonatomic) IBOutlet UIButton    *publicTypeBtn;
@property (strong, nonatomic) IBOutlet UILabel     *draftDWLabel;
@property (strong, nonatomic) IBOutlet UILabel     *drafterLabel;
@property (strong, nonatomic) IBOutlet UITextView  *titleTxtView;
@property (strong, nonatomic) IBOutlet UITextField *scretLevelTxt;
@property (strong, nonatomic) IBOutlet UITextField *urgentTxt;
@property (strong, nonatomic) IBOutlet UIButton    *urgentBtn;
@property (strong, nonatomic) IBOutlet UITextField *dateTxt;
@property (strong, nonatomic) IBOutlet UIButton    *dateBtn;
@property (strong, nonatomic) IBOutlet UITextField *pagesTxt;

@property (strong, nonatomic) IBOutlet UITextField *fwlbTxt;
@property (strong, nonatomic) IBOutlet UILabel     *fwnfLabel;
@property (strong, nonatomic) IBOutlet UITextField *fwnfTxt;
@property (strong, nonatomic) IBOutlet UILabel     *fwbhLabel;
@property (strong, nonatomic) IBOutlet UITextField *fwbhTxt;
@property (strong, nonatomic) IBOutlet UIButton    *fwbhBtn;


@property (strong, nonatomic) IBOutlet UITextView  *auditTxtView;
@property (strong, nonatomic) IBOutlet UITextView  *auditTxtView1;
@property (strong, nonatomic) IBOutlet UIButton    *inputAudit;
@property (strong, nonatomic) IBOutlet UIButton    *clearAudit;
@property (strong, nonatomic) IBOutlet UILabel    *reviewerLabel;

@property (strong, nonatomic) IBOutlet UITextView *opinionTxtView;
@property (strong, nonatomic) IBOutlet UITextView *opinionTxtView1;
@property (strong, nonatomic) IBOutlet UIButton   *inputOpinion;
@property (strong, nonatomic) IBOutlet UIButton   *clearOpinion;
@property (strong, nonatomic) UITextField *txtCtrl;
@property (strong, nonatomic) UITextView  *txtView;

@property (strong, nonatomic) IBOutlet UITextField *sprTxt;
@property (strong, nonatomic) IBOutlet UITextField *spsjTxt;
@property (strong, nonatomic) IBOutlet UITextField *spjgTxt;
@property (strong, nonatomic) IBOutlet UITextView  *spyjTxtView;
@property (strong, nonatomic) IBOutlet UITextView  *spyjTxtView1;
@property (strong, nonatomic) IBOutlet UIButton   *inputSpyj;
@property (strong, nonatomic) IBOutlet UIButton   *clearSpyj;
@property (strong, nonatomic) IBOutlet UIButton    *xmxxBtn;

//申请信息
@property (strong, nonatomic) IBOutlet UITextField *xmjsmc;//项目建设名称
@property (strong, nonatomic) IBOutlet UITextField *jsdd;//项目拟建设地点
@property (strong, nonatomic) IBOutlet UITextField *ssqy;//项目所属区域
@property (strong, nonatomic) IBOutlet UITextField *xmztz;//项目总投资
@property (strong, nonatomic) IBOutlet UITextField *syxsqmc;//试运行申请名称
@property (strong, nonatomic) IBOutlet UITextField *syxsqrq;//试运行申请日期
@property (strong, nonatomic) IBOutlet UITextField *trsyxrq;//投入试运行日期
@property (strong, nonatomic) IBOutlet UITextView  *sqbgTxtView;//申请报告内容



@property (assign, nonatomic) NSString *competence;
@property (strong, nonatomic) NSString *process;
@property (strong, nonatomic) NSString *docid;
@property (strong, nonatomic) NSDictionary *infoDict;
@property (strong, nonatomic) NSArray *editCtlArray;
@property (weak,   nonatomic) id<HandleGWDelegate> delegate;
@property (strong, nonatomic) BaseViewController *responder;
@property (nonatomic,assign) NSInteger webServiceType; 

- (IBAction)clearInputOpinion:(id)sender;
- (IBAction)modifyData:(UIButton *)sender;
- (IBAction)selectCommenWords:(id)sender;
- (IBAction)selectOfficeDocumentSN:(id)sender;
- (IBAction)touchFromDate:(id)sender;
- (IBAction)loadProjectInfo:(id)sender;

@end
