//
//  DocumentLibraryViewController.m
//  NingBoOA
//
//  Created by 熊熙 on 13-11-8.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "DocumentLibraryViewController.h"
#import "UICustomButton.h"
#import "DocumentLibraryListParser.h"
#import "DocumentLatestListParser.h"
#import "DocumentFileInListParser.h"
#import "DocumentFileOutListParser.h"
#import "DocumentSignDocListParser.h"
#import "DocumentInnerFileListParser.h"
#import "DocumentDeptFileListParser.h"
#import "DocumentDetailViewController.h"


@interface DocumentLibraryViewController ()
@property (nonatomic,strong) UIPopoverController *popController;
@end

@implementation DocumentLibraryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"公文库查询";
    
    UIBarButtonItem *backItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"返回"];
    self.navigationItem.leftBarButtonItem = backItem;
    UIButton *backButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
    [backButton addTarget:self action:@selector(goBackAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *inquiryItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"查询"];
    self.navigationItem.rightBarButtonItem = inquiryItem;
    UIButton *inquiryButton = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
    [inquiryButton addTarget:self action:@selector(showInquiryView:) forControlEvents:UIControlEventTouchUpInside];

    
    
    self.documentListParser = [[DocumentLatestListParser alloc] init];
    self.documentListParser.delegate = self;
    self.documentListParser.serviceName = @"LastDoucumentList";
    self.documentListParser.showView = self.view;
    self.documentListParser.listTableView = self.listTableView;
    self.listTableView.dataSource = self.documentListParser;
    self.listTableView.delegate = self.documentListParser;
    [self.documentListParser requestData];
    
    self.ngsjField.text = @"";
    self.jzsjField.text = @"";
    self.gwbhField.text= @"";
    self.libraryField.text = @"";
    self.gwbhField.text = @"";

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Event Handle
- (void)goBackAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)touchFromDate:(id)sender{
     self.textField = (UITextField *)sender;
    PopupDateViewController *dateController = [[PopupDateViewController alloc] initWithPickerMode:UIDatePickerModeDate];
    dateController.delegate = self;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dateController];
    
    
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
    
    self.popController = popover;
    
    [self.popController presentPopoverFromRect:self.textField.bounds
                                        inView:self.textField
                      permittedArrowDirections:UIPopoverArrowDirectionAny
                                      animated:YES];

}

- (IBAction)selectCommenWords:(id)sender{
    
    self.textField = (UITextField *)sender;
    
    NSArray *listArray = @[@"收文库",@"发文库",@"签报库",@"内部文件库",@"处室文件库"];
    
    CommenWordsViewController *tmpController = [[CommenWordsViewController alloc] initWithNibName:@"CommenWordsViewController" bundle:nil ];
	tmpController.contentSizeForViewInPopover = CGSizeMake(200, [listArray count]*44);
	tmpController.delegate = self;
    tmpController.wordsAry = listArray;
    UIPopoverController *tmppopover = [[UIPopoverController alloc] initWithContentViewController:tmpController];
    self.popController = tmppopover;
    [self.popController presentPopoverFromRect:self.textField.bounds
                                        inView:self.textField
                      permittedArrowDirections:UIPopoverArrowDirectionAny
                                      animated:YES];
}

- (void)selectDocumentLibrary:(NSInteger)row
{
    [self.documentListParser.aryItems removeAllObjects];
    //[self.listTableView reloadData];
    [self.popController dismissPopoverAnimated:YES];
    
    switch (row) {
        case 0:
            self.documentListParser = [[DocumentFileInListParser alloc] init];
            self.documentListParser.serviceName = @"InquiryDoucument";
            self.documentListParser.showView = self.view;
            self.documentListParser.type = @"sw";
            self.documentListParser.delegate = self;
            break;
            
        case 1:
            self.documentListParser = [[DocumentFileOutListParser alloc] init];
            self.documentListParser.type = @"fw";
            self.documentListParser.serviceName = @"InquiryDoucument";
            self.documentListParser.showView = self.view;
            self.documentListParser.delegate = self;
            break;

        case 2:
            
            self.documentListParser = [[DocumentSignDocListParser alloc] init];
            self.documentListParser.type = @"qb";
            self.documentListParser.serviceName = @"InquiryDoucument";
            self.documentListParser.showView = self.view;
            self.documentListParser.delegate = self;
            
            break;

            
        case 3:
            
            self.documentListParser = [[DocumentInnerFileListParser alloc] init];
            self.documentListParser.type = @"nb";
            self.documentListParser.serviceName = @"InquiryDoucument";
            self.documentListParser.showView = self.view;
            self.documentListParser.delegate = self;
            
            
            break;
        case 4:
            
            self.documentListParser = [[DocumentDeptFileListParser alloc] init];
            self.documentListParser.type = @"cs";
            self.documentListParser.serviceName = @"InquiryDoucument";
            self.documentListParser.showView = self.view;
            self.documentListParser.delegate = self;
            break;

        default:
            break;
    }
    
    self.documentListParser.listTableView = self.listTableView;
    self.listTableView.dataSource = self.documentListParser;
    self.listTableView.delegate = self.documentListParser;
    
}


- (void)showInquiryView:(id)sender {
    if (self.isShowQuery == NO) {
        [self QueryViewAnimation:YES];
    }
    else {
        [self QueryViewAnimation:NO];
    }
    
}
- (IBAction)InquiryDocumentLibrary:(id)sender{
    NSString *errMsg = @"";
    if ([self.libraryField.text length] <= 0) {
        errMsg = @"请选择查询数据库";
    }
    else if([self.ngsjField.text length] <= 0 &&
            [self.jzsjField.text length] <= 0 &&
            [self.gwbhField.text length] <= 0 &&
            [self.gwbtField.text length] <= 0 ){
        errMsg = @"请输入查询条件";
    }
    
    if ([errMsg length] > 0) {
        [self showAlertMessage:errMsg];
        return;
    }
    
    NSString *kssj = self.ngsjField.text;
    NSString *jzsj = self.jzsjField.text;
    NSString *gwbh = self.gwbhField.text;
    NSString *gwbt = self.gwbtField.text;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:kssj forKey:@"kssj"];
    [params setObject:jzsj forKey:@"jzsj"];
    [params setObject:gwbh forKey:@"gwbh"];
    [params setObject:gwbt forKey:@"gwbt"];
    
    self.documentListParser.paramDict = params;
    [self.documentListParser requestData];
}

- (void)QueryViewAnimation:(BOOL)isShow{
    self.isShowQuery = isShow;
    if(isShow) {
        CGRect frame = self.listTableView.frame;
        [UIView beginAnimations:@"ShowListTable" context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        CGFloat x = CGRectGetMinX(frame);
        //CGFloat y = CGRectGetMinY(frame);
        CGFloat width = CGRectGetWidth(frame);
        CGFloat height = CGRectGetHeight(frame);
        
        self.listTableView.frame = CGRectMake(x, 260, width, height-236);
        [UIView commitAnimations];
    }
    else {
        CGRect frame = self.listTableView.frame;
        [UIView beginAnimations:@"HIdeListTable" context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        CGFloat x = CGRectGetMinX(frame);
        //CGFloat y = CGRectGetMinY(frame);
        CGFloat width = CGRectGetWidth(frame);
        CGFloat height = CGRectGetHeight(frame);
        if (height < 916) {
            height = height +236;
        }
        self.listTableView.frame = CGRectMake(x, 24, width, height);
        [UIView commitAnimations];
    }
}


#pragma mark -
#pragma mark DocumentLibraryDetailDelegate

- (void)didSelectDocumentLibraryListInfo:(NSDictionary *)infoDict {
    DocumentDetailViewController *documentDetailViewController = [[DocumentDetailViewController alloc] initWithNibName:@"DocumentDetailViewController" bundle:nil];
    documentDetailViewController.attachDict = infoDict;
    [self.navigationController pushViewController:documentDetailViewController animated:YES];
}

- (void)loadMoreList{
    self.documentListParser.isRefresh = NO;
    [self.documentListParser requestData];
}

#pragma mark -
#pragma mark WordsDelegate
- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row {
    
    if(self.popController.popoverVisible) {
        [self.popController dismissPopoverAnimated:YES];
    }
    self.textField.text = words;
    [self selectDocumentLibrary:row];
}

#pragma mark -
#pragma mark PopupDateDelegate
- (void)PopupDateController:(PopupDateViewController *)controller Saved:(BOOL)bSaved selectedDate:(NSDate*)date {
    [self.popController dismissPopoverAnimated:YES];
	if (bSaved) {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd"];
		NSString *dateString = [dateFormatter stringFromDate:date];
        self.textField.text =  dateString;
	}
}

#pragma mark -
#pragma mark textfield delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

@end
