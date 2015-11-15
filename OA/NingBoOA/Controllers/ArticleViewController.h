//
//  ArticleViewController.h
//  NingBoOA
//
//  Created by PowerData on 14-3-28.
//  Copyright (c) 2014年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "HandleGWProtocol.h"

@interface ArticleViewController : BaseViewController<HandleGWDelegate>
@property (weak, nonatomic) IBOutlet UITextField *sqrTextField;
@property (weak, nonatomic) IBOutlet UIButton *sqrImportButton;

@property (weak, nonatomic) IBOutlet UITextField *sqbmTextField;
@property (weak, nonatomic) IBOutlet UIButton *sqbmImportButton;

@property (weak, nonatomic) IBOutlet UITextField *sqrqTextField;
@property (weak, nonatomic) IBOutlet UIButton *sqrqImportButton;

@property (weak, nonatomic) IBOutlet UITextField *wplbTextField;
@property (weak, nonatomic) IBOutlet UIButton *wplbImportButton;

@property (weak, nonatomic) IBOutlet UITextField *wpmcTextField;
@property (weak, nonatomic) IBOutlet UIButton *wpmcImportButton;

@property (weak, nonatomic) IBOutlet UITextField *xhTextField;
@property (weak, nonatomic) IBOutlet UIButton *xhImportButton;

@property (weak, nonatomic) IBOutlet UITextField *cgslTextField;
@property (weak, nonatomic) IBOutlet UIButton *cgslImportButton;

@property (weak, nonatomic) IBOutlet UITextField *wpsyrqTextField;
@property (weak, nonatomic) IBOutlet UIButton *wpsyrqImportButton;

@property (weak, nonatomic) IBOutlet UITextField *gjdjTextField;
@property (weak, nonatomic) IBOutlet UIButton *gjdjImportButton;

@property (weak, nonatomic) IBOutlet UITextField *sjdjTextField;
@property (weak, nonatomic) IBOutlet UIButton *sjdjImportButton;

@property (weak, nonatomic) IBOutlet UITextField *sfrkTextField;
@property (weak, nonatomic) IBOutlet UIButton *sfrkImportButton;

@property (weak, nonatomic) IBOutlet UITextField *sfycgTextField;
@property (weak, nonatomic) IBOutlet UIButton *sfycgImportButton;

@property (weak, nonatomic) IBOutlet UITextView *ytgnmsTextField;
@property (weak, nonatomic) IBOutlet UIButton *ytgnmsImportButton;

@property (weak, nonatomic) IBOutlet UITextField *yjzjeTextField;
@property (weak, nonatomic) IBOutlet UIButton *yjzjeImportButton;

@property (weak, nonatomic) IBOutlet UITextField *zjlyTextField;
@property (weak, nonatomic) IBOutlet UIButton *zjlyImportButton;

@property (weak, nonatomic) IBOutlet UITextField *zjly2TextField;
@property (weak, nonatomic) IBOutlet UIButton *zjly2ImportButton;

@property (weak, nonatomic) IBOutlet UITextField *nghdwTextField;
@property (weak, nonatomic) IBOutlet UIButton *nghdwImportButton;

@property (weak, nonatomic) IBOutlet UITextField *lxfsTextField;
@property (weak, nonatomic) IBOutlet UIButton *lxfsImportButton;

@property (strong, nonatomic) IBOutlet UITextView *zzyjTextField;
@property (strong, nonatomic) IBOutlet UITextView *zzyjsrTextfield;
@property (strong, nonatomic) IBOutlet UIButton *zzyjsrButton;
@property (strong, nonatomic) IBOutlet UIButton *zzyjczButton;

@property (strong, nonatomic) IBOutlet UITextView *fzryjTextField;
@property (strong, nonatomic) IBOutlet UITextView *fzryjsrTextfield;
@property (strong, nonatomic) IBOutlet UIButton *fzryjsrButton;
@property (strong, nonatomic) IBOutlet UIButton *fzryjczButton;

@property (strong, nonatomic) IBOutlet UITextView *zryjTextField;
@property (strong, nonatomic) IBOutlet UITextView *zryjsrTextfield;
@property (strong, nonatomic) IBOutlet UIButton *zryjsrButton;
@property (strong, nonatomic) IBOutlet UIButton *zryjczButton;

@property (strong, nonatomic) IBOutlet UITextView *zhzyjTextField;
@property (strong, nonatomic) IBOutlet UITextView *zhzyjsrTextfield;
@property (strong, nonatomic) IBOutlet UIButton *zhzyjsrButton;
@property (strong, nonatomic) IBOutlet UIButton *zhzyjczButton;

@property (strong, nonatomic) IBOutlet UITextView *cgyjTextField;
@property (strong, nonatomic) IBOutlet UITextView *cgyjsrTextfield;
@property (strong, nonatomic) IBOutlet UIButton *cgyjsrButton;
@property (strong, nonatomic) IBOutlet UIButton *cgyjczButton;

@property (strong, nonatomic) IBOutlet UITextView *sqrjhyjTextField;
@property (strong, nonatomic) IBOutlet UITextView *sqrjhyjsrTextfield;
@property (strong, nonatomic) IBOutlet UIButton *sqrjhyjsrButton;
@property (strong, nonatomic) IBOutlet UIButton *sqrjhyjczButton;

@property (strong, nonatomic) IBOutlet UITextView *bzTextField;
@property (strong, nonatomic) IBOutlet UITextView *bzsrTextfield;
@property (strong, nonatomic) IBOutlet UIButton *bzsrButton;
@property (strong, nonatomic) IBOutlet UIButton *bzczButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSDictionary *infoDict;
@property (weak,   nonatomic) id<HandleGWDelegate> delegate;

@end
