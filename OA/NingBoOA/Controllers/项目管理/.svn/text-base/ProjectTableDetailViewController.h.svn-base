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


@interface ProjectTableDetailViewController : BaseViewController<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,WordsDelegate,GetOfficeDocumentSNDelegate,ContentEditDelegate,PopupDateDelegate> 

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


//企业基本情况
@property (strong, nonatomic) IBOutlet UITextField *jsdwmc;//建设单位名称
@property (strong, nonatomic) IBOutlet UITextField *jsdwbm;//建设单位编码
@property (strong, nonatomic) IBOutlet UITextField *jsdwlxr;//建设单位联系人
@property (strong, nonatomic) IBOutlet UITextField *jsdwdh;//建设单位电话
@property (strong, nonatomic) IBOutlet UITextField *jsdwfrdb;//法人代表
@property (strong, nonatomic) IBOutlet UITextField *jsdwfrdh;//法人电话
@property (strong, nonatomic) IBOutlet UITextField *jsdwfrdm;//法人代码
@property (strong, nonatomic) IBOutlet UITextField *jsdwyzbm;//邮政编码
@property (strong, nonatomic) IBOutlet UITextField *jsdwcz;  //传真
@property (strong, nonatomic) IBOutlet UITextField *jsdwdz;  //通讯地址

//项目基本信息
@property (strong, nonatomic) IBOutlet UITextField *xmmc;//项目名称
@property (strong, nonatomic) IBOutlet UITextField *xmsqsj;//项目申请时间
@property (strong, nonatomic) IBOutlet UITextField *xmjsdd;//项目拟建设地点
@property (strong, nonatomic) IBOutlet UITextField *xmssqy;//项目所属区域
@property (strong, nonatomic) IBOutlet UITextField *xmztz;//项目总投资
@property (strong, nonatomic) IBOutlet UIButton   *xmjsxzBtn1;//建设性质
@property (strong, nonatomic) IBOutlet UIButton   *xmjsxzBtn2;//建设性质
@property (strong, nonatomic) IBOutlet UIButton   *xmjsxzBtn3;//建设性质
@property (strong, nonatomic)          NSString *xmjsxzStr;
@property (strong, nonatomic) IBOutlet UITextField *xmssgl;//项目所属管理范围
@property (strong, nonatomic) IBOutlet UITextView  *jsnrTxtView;//主要建设内容
@property (strong, nonatomic) IBOutlet UIButton    *xmxxBtn;

//环评审批及审批登记
@property (strong, nonatomic) IBOutlet UITextField *spztz;//总投资
@property (strong, nonatomic) IBOutlet UITextField *sphbtz;//环保投资
@property (strong, nonatomic) IBOutlet UITextField *sptzbl;//投资比例
@property (strong, nonatomic) IBOutlet UITextField *sphylb;//行业类别
@property (strong, nonatomic) IBOutlet UITextField *spjsdz;//建设地点
@property (strong, nonatomic) IBOutlet UITextField *splxbm;//立项部门
@property (strong, nonatomic) IBOutlet UITextField *splxpwh;//立项批文号
@property (strong, nonatomic) IBOutlet UITextField *spxkwh;//环保行政许可文号
@property (strong, nonatomic) IBOutlet UITextField *spykgsj;//预开工时间
@property (strong, nonatomic) IBOutlet UITextField *spzdmj;//占地面积
@property (strong, nonatomic) IBOutlet UITextField *spjzmj;//建筑面积
@property (strong, nonatomic) IBOutlet UITextField *sphpjg;//环评机构
@property (strong, nonatomic) IBOutlet UITextField *spbpsj;//报批时间
@property (strong, nonatomic) IBOutlet UITextField *sppjjf;//评价经费
@property (strong, nonatomic) IBOutlet UIButton *spsflkBtn1;//是否两控区
@property (strong, nonatomic) IBOutlet UIButton *spsflkBtn2;//是否两控区
@property (strong, nonatomic) IBOutlet UITextView *bgnrTxtView;//报告内容说明


@property (strong, nonatomic) NSString *spsflkStr;

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
