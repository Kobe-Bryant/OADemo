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
#import "SNSelectViewController.h"
#import "ContentEditViewController.h"
#import "HandleGWProtocol.h"

@interface SignDocDetailViewController : BaseViewController<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,WordsDelegate,ContentEditDelegate,PopupDateDelegate,GetOfficeDocumentSNDelegate,UITextViewDelegate> {
}

@property (strong, nonatomic) IBOutlet UITextField *paperTxt;
@property (strong, nonatomic) IBOutlet UIButton   *paperBtn;

@property (strong, nonatomic) IBOutlet UITextField *sendDWTxt;
@property (strong, nonatomic) IBOutlet UIButton    *sendDWBtn;
@property (strong, nonatomic) IBOutlet UITextField *csDWTxt;
@property (strong, nonatomic) IBOutlet UIButton    *csDWBtn;
@property (strong, nonatomic) IBOutlet UITextField *publicTypeTxt;
@property (strong, nonatomic) IBOutlet UIButton    *publicTypeBtn;
@property (strong, nonatomic) IBOutlet UIButton *sitePublicBtn1;
@property (strong, nonatomic) IBOutlet UIButton *sitePublicBtn2;
@property (strong, nonatomic)          NSString *sitePublishWay;
@property (strong, nonatomic)          NSMutableArray *sitePublicAry;
@property (strong, nonatomic) IBOutlet UILabel     *draftDWLabel;
@property (strong, nonatomic) IBOutlet UILabel     *drafterLabel;
@property (strong, nonatomic) IBOutlet UITextView  *titleView;
@property (strong, nonatomic) IBOutlet UITextField *scretLevelTxt;
@property (strong, nonatomic) IBOutlet UITextField *urgentTxt;
@property (strong, nonatomic) IBOutlet UIButton    *urgentBtn;

@property (strong, nonatomic)  NSString *type;
@property (strong, nonatomic)  NSString *year;
@property (strong, nonatomic)  NSString *serial;

@property (strong, nonatomic) IBOutlet UITextField *dateTxt;
@property (strong, nonatomic) IBOutlet UIButton    *dateBtn;
@property (strong, nonatomic) IBOutlet UITextField *pagesTxt;
@property (strong, nonatomic) IBOutlet UITextField *fwlbTxt;
@property (strong, nonatomic) IBOutlet UILabel     *fwnfLabel;
@property (strong, nonatomic) IBOutlet UITextField *fwnfTxt;
@property (strong, nonatomic) IBOutlet UILabel     *fwbhLabel;
@property (strong, nonatomic) IBOutlet UITextField *fwbhTxt;
@property (strong, nonatomic) IBOutlet UIButton    *fwbhBtn;
@property (strong, nonatomic) IBOutlet UITextView  *ldqfTxtView;
@property (strong, nonatomic) IBOutlet UITextView  *ldqfTextView1;
@property (strong, nonatomic) IBOutlet UIButton    *inputLdqf;
@property (strong, nonatomic) IBOutlet UIButton    *clearLdqf;

@property (strong, nonatomic) IBOutlet UITextView  *hqTxtView;
@property (strong, nonatomic) IBOutlet UITextView  *hqTxtView1;
@property (strong, nonatomic) IBOutlet UIButton    *inputHq;
@property (strong, nonatomic) IBOutlet UIButton    *clearHq;

@property (strong, nonatomic) IBOutlet UITextView  *auditTxtView;
@property (strong, nonatomic) IBOutlet UITextView  *auditTxtView1;
@property (strong, nonatomic) IBOutlet UIButton    *inputAudit;
@property (strong, nonatomic) IBOutlet UIButton    *clearAudit;

@property (strong, nonatomic) IBOutlet UITextView  *officeTxtView;
@property (strong, nonatomic) IBOutlet UITextView  *officeTxtView1;
@property (strong, nonatomic) IBOutlet UIButton    *inputOffice;
@property (strong, nonatomic) IBOutlet UIButton    *clearOffice;
@property (strong, nonatomic) IBOutlet UITextField *reviewerTxt;

@property (strong, nonatomic) IBOutlet UITextView *opinionTxtView;
@property (strong, nonatomic) IBOutlet UITextView *opinionTxtView1;
@property (strong, nonatomic) IBOutlet UIButton   *inputOpinion;
@property (strong, nonatomic) IBOutlet UIButton   *clearOpinion;
@property (strong, nonatomic) UITextField *txtCtrl;
@property (strong, nonatomic) UITextView  *txtView;

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
- (IBAction)selectOfficeDocumentSN:(id)sender;
- (IBAction)selectCommenWords:(id)sender;
- (IBAction)touchFromDate:(id)sender;
- (IBAction)multiBtnSelect:(UIButton *)btn;

@end
