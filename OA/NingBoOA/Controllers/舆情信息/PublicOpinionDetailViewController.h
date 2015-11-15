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
@interface PublicOpinionDetailViewController : BaseViewController<UIAlertViewDelegate,HandleGWDelegate,UITableViewDataSource,UITableViewDelegate,PopupDateDelegate,GetOfficeDocumentSNDelegate,WordsDelegate,ContentEditDelegate>

@property (strong, nonatomic) IBOutlet UITextField *paperTxt;
@property (strong, nonatomic) IBOutlet UIButton   *paperBtn;

@property (strong, nonatomic) IBOutlet UITextField *ftsjTxt;
@property (strong, nonatomic) IBOutlet UIButton    *ftsjBtn;

@property (strong, nonatomic) IBOutlet UITextField *fbwzTxt;
@property (strong, nonatomic) IBOutlet UIButton    *fbwzBtn;

@property (strong, nonatomic) IBOutlet UITextField *yqlbTxt;
@property (strong, nonatomic) IBOutlet UITextField *yqnfTxt;
@property (strong, nonatomic) IBOutlet UITextField *yqbhTxt;
@property (strong, nonatomic) IBOutlet UIButton    *yqbhBtn;

@property (strong, nonatomic) IBOutlet UITextField *ytwzTxt;
@property (strong, nonatomic) IBOutlet UITextField *ftrTxt;

@property (strong, nonatomic) IBOutlet UILabel     *registerLabel;
@property (strong, nonatomic) IBOutlet UILabel     *registerDateLabel;

@property (strong, nonatomic) IBOutlet UITextField *locTxt;
@property (strong, nonatomic) IBOutlet UIButton    *locBtn;


@property (strong, nonatomic) IBOutlet UITextField *blqxTxt;
@property (strong, nonatomic) IBOutlet UIButton    *blqxBtn;

@property (strong, nonatomic) IBOutlet UITextField *sfgkTxt;
@property (strong, nonatomic) IBOutlet UIButton    *sfgkBtn;

@property (strong, nonatomic) IBOutlet UITextView *titleView;
@property (strong, nonatomic) IBOutlet UITextView *contentView;

@property (strong, nonatomic) IBOutlet UITextField *urgentTxt;
@property (strong, nonatomic) IBOutlet UIButton *urgentBtn;

@property (strong, nonatomic) IBOutlet UITextView *ldqfTxtView1;
@property (strong, nonatomic) IBOutlet UITextView *ldqfTxtView;
@property (strong, nonatomic) IBOutlet UIButton   *inputLdqf;
@property (strong, nonatomic) IBOutlet UIButton   *clearLdqf;

@property (strong, nonatomic) IBOutlet UITextView  *auditTxtView1;
@property (strong, nonatomic) IBOutlet UITextView  *auditTxtView;
@property (strong, nonatomic) IBOutlet UIButton    *inputAudit;
@property (strong, nonatomic) IBOutlet UIButton    *clearAudit;

@property (strong, nonatomic) IBOutlet UITextView  *officeTxtView;
@property (strong, nonatomic) IBOutlet UITextView  *officeTxtView1;
@property (strong, nonatomic) IBOutlet UIButton    *inputOffice;
@property (strong, nonatomic) IBOutlet UIButton    *clearOffice;

@property (strong, nonatomic) IBOutlet UITextView *handlerTxtView;
@property (strong, nonatomic) IBOutlet UITextView *handlerTxtView1;
@property (strong, nonatomic) IBOutlet UIButton   *inputHandler;
@property (strong, nonatomic) IBOutlet UIButton   *clearHandler;

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
