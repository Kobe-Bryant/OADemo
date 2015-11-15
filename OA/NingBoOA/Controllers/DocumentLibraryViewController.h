//
//  DocumentLibraryViewController.h
//  NingBoOA
//
//  Created by 熊熙 on 13-11-8.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "DocumentLibraryListParser.h"
#import "PopupDateViewController.h"
#import "CommenWordsViewController.h"
@interface DocumentLibraryViewController : BaseViewController<DocumentLibraryDetailDelegate,PopupDateDelegate,WordsDelegate,UITextFieldDelegate>

@property (nonatomic,strong) NSString *fileServiceName;
@property (strong,nonatomic) NSMutableArray *listDataArray;
@property (strong,nonatomic) DocumentLibraryListParser *documentListParser;
@property (strong,nonatomic) IBOutlet UIView *queryView;
@property (strong,nonatomic) IBOutlet UITableView *listTableView;
@property (strong,nonatomic) IBOutlet UITextField *ngsjField;
@property (strong,nonatomic) IBOutlet UITextField *jzsjField;
@property (strong,nonatomic) IBOutlet UITextField *gwbhField;
@property (strong,nonatomic) IBOutlet UITextField *libraryField;
@property (strong,nonatomic) IBOutlet UITextField *gwbtField;
@property (strong,nonatomic) UITextField *textField;
@property (assign,nonatomic) BOOL isShowQuery;

- (IBAction)selectCommenWords:(id)sender;
- (IBAction)InquiryDocumentLibrary:(id)sender;

@end
