//
//  FileOutDetailViewController.h
//  NingBoOA
//
//  Created by 熊熙 on 13-9-29.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "FileInManagerController.h"
#import "FileInDetailViewController.h"
#import "ContentEditViewController.h"
#import "PopupDateViewController.h"
#import "CommenWordsViewController.h"
#import "SNSelectViewController.h"
#import "HandleGWProtocol.h"
@interface XJZXFileInDetailViewController : BaseViewController<UIAlertViewDelegate,HandleGWDelegate,UITableViewDataSource,UITableViewDelegate,PopupDateDelegate,GetOfficeDocumentSNDelegate,WordsDelegate,ContentEditDelegate,UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *paperTxt;
@property (strong, nonatomic) IBOutlet UIButton   *paperBtn;

@property (strong, nonatomic) IBOutlet UITextField *swrqTxt;
@property (strong, nonatomic) IBOutlet UIButton    *swrqBtn;

@property (strong, nonatomic) IBOutlet UITextField *swlxTxt;
@property (strong, nonatomic) IBOutlet UITextField *swnfTxt;
@property (strong, nonatomic) IBOutlet UITextField *swbhTxt;
@property (strong, nonatomic) IBOutlet UIButton    *swwhBtn;

@property (strong, nonatomic) IBOutlet UITextField *lwlxTxt;
@property (strong, nonatomic) IBOutlet UILabel     *lwnfLabel;
@property (strong, nonatomic) IBOutlet UITextField *lwnfTxt;
@property (strong, nonatomic) IBOutlet UILabel     *lwwhLabel;
@property (strong, nonatomic) IBOutlet UITextField *lwwhTxt;

@property (strong, nonatomic) IBOutlet UILabel     *registerLabel;
@property (strong, nonatomic) IBOutlet UILabel     *registerDateLabel;

@property (strong, nonatomic) IBOutlet UITextField *deadlineTxt;
@property (strong, nonatomic) IBOutlet UIButton    *deadlineBtn;

@property (strong, nonatomic) IBOutlet UITextField *archiveTxt;
@property (strong, nonatomic) IBOutlet UIButton    *archiveBtn;

@property (strong, nonatomic) IBOutlet UITextView *titleView;

@property (strong, nonatomic) IBOutlet UITextField *scretLevelTxt;
@property (strong, nonatomic) IBOutlet UIButton    *scretLevelBtn;


@property (strong, nonatomic) IBOutlet UITextField *urgentTxt;
@property (strong, nonatomic) IBOutlet UIButton *urgentBtn;

@property (strong, nonatomic) IBOutlet UITextField *numbersTxt;
@property (strong, nonatomic) IBOutlet UITextField *pagesTxt;

@property (strong, nonatomic) IBOutlet UITextField *typeTxt;
@property (strong, nonatomic) IBOutlet UIButton    *typeBtn;

@property (strong, nonatomic) IBOutlet UITextField *waysTxt;
@property (strong, nonatomic) IBOutlet UIButton    *waysBtn;

@property (strong, nonatomic) IBOutlet UITextView *ldqfTxtView1;
@property (strong, nonatomic) IBOutlet UITextView *ldqfTxtView;
@property (strong, nonatomic) IBOutlet UIButton   *inputLdqf;
@property (strong, nonatomic) IBOutlet UIButton   *clearLdqf;

@property (strong, nonatomic) IBOutlet UITextView  *auditTxtView1;
@property (strong, nonatomic) IBOutlet UITextView  *auditTxtView;
@property (strong, nonatomic) IBOutlet UIButton    *inputAudit;
@property (strong, nonatomic) IBOutlet UIButton    *clearAudit;

@property (strong, nonatomic) IBOutlet UITextView *distriTxtView;
@property (strong, nonatomic) IBOutlet UITextView *distriTxtView1;
@property (strong, nonatomic) IBOutlet UIButton   *inputDistri;
@property (strong, nonatomic) IBOutlet UIButton   *clearDistri;


@property (strong, nonatomic) IBOutlet UITextView  *opinionTxtView;
@property (strong, nonatomic) IBOutlet UITextView  *opinionTxtView1;
@property (strong, nonatomic) IBOutlet UIButton    *inputOpinion;
@property (strong, nonatomic) IBOutlet UIButton    *clearOpinion;

@property (strong, nonatomic) UITextField *txtCtrl;
@property (strong, nonatomic) UITextView  *txtView;
@property (assign, nonatomic) NSString *competence;
@property (strong, nonatomic) NSString *process;
@property (strong, nonatomic) NSString *docid;
@property (strong, nonatomic) NSDictionary *infoDict;

@property (weak,   nonatomic) id<HandleGWDelegate> delegate;
@property (strong, nonatomic) BaseViewController *responder;

@property (nonatomic,assign) NSInteger webServiceType;


- (IBAction)modifyData:(UIButton *)sender;
- (IBAction)clearInputOpinion:(id)sender;
- (IBAction)selectCommenWords:(id)sender;
- (IBAction)touchFromDate:(id)sender;

@end
