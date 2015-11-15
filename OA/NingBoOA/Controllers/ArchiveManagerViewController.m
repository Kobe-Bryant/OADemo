//
//  ToDoFileViewController.m
//  NingBoOA
//
//  Created by ZHONGWEN on 13-9-15.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "ArchiveManagerViewController.h"
#import "FileDirectoryListParser.h"
#import "InquiryDocListParser.h"
#import "InquiryFileListParser.h"
#import "FileInfoViewController.h"
#import "DocInfoViewController.h"
#import "PDJsonkit.h"
#import "UICustomButton.h"
#import "ZrsUtils.h"
#import "ServiceUrlString.h"
#import "SystemConfigContext.h"
#import "CommenWordsViewController.h"

@interface ArchiveManagerViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) UIPopoverController *popController;
@end

@implementation ArchiveManagerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)showHistoryList{
    
    UIBarButtonItem *historyItem = self.navigationItem.rightBarButtonItem;
        NSArray *listArray =@[@"一般",@"急件",@"特急"];
    
    CommenWordsViewController *tmpController = [[CommenWordsViewController alloc] initWithNibName:@"CommenWordsViewController" bundle:nil ];
	tmpController.contentSizeForViewInPopover = CGSizeMake(200, [listArray count]*44);
	//tmpController.delegate = self;
    tmpController.wordsAry = listArray;
    UIPopoverController *tmppopover = [[UIPopoverController alloc] initWithContentViewController:tmpController];
    self.popController = tmppopover;
    
    [self.popController presentPopoverFromBarButtonItem:historyItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark -
#pragma mark Handle Event
// -------------------------------------------------------------------------------
//	实现事件处托方法
//  响应返回按钮
// -------------------------------------------------------------------------------

- (void)goBackAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)touchFromDate:(id)sender{
     self.currentTag = [sender tag];
    
    UITextField *txtField = (UITextField*)sender;
    PopupDateViewController *dateController = [[PopupDateViewController alloc] initWithPickerMode:UIDatePickerModeDate];
    dateController.delegate = self;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dateController];
    
    
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
    
    self.popController = popover;
    
    [self.popController presentPopoverFromRect:txtField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)selectCommenWords:(id)sender{
    UITextField *txtField = (UITextField *)sender;
    self.currentPage = txtField.tag;
    if ([txtField.placeholder hasPrefix:@"请输入"]) {
        return;
    }
    NSArray *listArray = @[@"永久",@"长期",@"短期"];

    CommenWordsViewController *tmpController = [[CommenWordsViewController alloc] initWithNibName:@"CommenWordsViewController" bundle:nil ];
    tmpController.contentSizeForViewInPopover = CGSizeMake(200, 44*[listArray count]);
    tmpController.delegate = self;
    tmpController.wordsAry = listArray;
    UIPopoverController *tmppopover = [[UIPopoverController alloc] initWithContentViewController:tmpController];
    self.popController = tmppopover;
    [self.popController presentPopoverFromRect:txtField.bounds
                                        inView:txtField
                      permittedArrowDirections:UIPopoverArrowDirectionAny
                                      animated:YES];
}

- (void)docManagerList:(id)sender{
    UIButton *button = (UIButton *)sender;
    FileManagerListController *fileManagerListController = [[FileManagerListController alloc] initWithStyle:UITableViewStylePlain];
    fileManagerListController.fileOutList = @[@"案卷查询",@"卷内查询"];
    fileManagerListController.fileType = @"ArchiveFile";
    fileManagerListController.delegate = self;
    
    UIPopoverController* tmpController = [[UIPopoverController alloc] initWithContentViewController:fileManagerListController];
    
    tmpController.popoverContentSize = CGSizeMake(240,88);
    self.popController = tmpController;
    [self.popController presentPopoverFromRect:button.bounds inView:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)historyManagerList:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    HistoryArchiveViewController *historyArchiveViewController = [[HistoryArchiveViewController alloc] initWithNibName:@"HistoryArchiveViewController" bundle:nil];
    historyArchiveViewController.delegate = self;
    
    UIPopoverController* tmpController = [[UIPopoverController alloc] initWithContentViewController:historyArchiveViewController];
    
//    tmpController.popoverContentSize = CGSizeMake(240,132);
    self.popController = tmpController;
    [self.popController presentPopoverFromRect:button.bounds inView:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

}

- (IBAction)inquiryArchiveDirectory:(id)sender{
    
    NSMutableArray *params = [NSMutableArray arrayWithCapacity:4];
    [params addObject:self.text1.text];
     [params addObject:self.text2.text];
     [params addObject:self.text3.text];
     [params addObject:self.text4.text];
    [params addObject:self.modid];

    NSString *errMsg = @"";

     if([self.text1.text length] <= 0 &&
            [self.text2.text length] <= 0 &&
            [self.text3.text length] <= 0 &&
            [self.text4.text length] <= 0 ){
        errMsg = @"请输入查询条件";
    }
    
    if ([errMsg length] > 0) {
        [self showAlertMessage:errMsg];
        return;
    }

    
    self.archiveListParser = [[InquiryFileListParser alloc] init];
    self.archiveListParser.serviceName = @"FilesInquery";
    self.archiveListParser.showView = self.view;
    self.archiveListParser.delegate = self;
    
    self.archiveListParser.listTableView = self.listTableView;
    self.listTableView.dataSource = self.archiveListParser;
    self.listTableView.delegate = self.archiveListParser;
    
    self.archiveListParser.paramAry = params;
    self.archiveListParser.isRefresh = YES;
    [self.archiveListParser requestData];
}

#pragma mark -
#pragma mark PopupDateDelegate
- (void)PopupDateController:(PopupDateViewController *)controller Saved:(BOOL)Saved selectedDate:(NSDate*)date{
	[self.popController dismissPopoverAnimated:YES];
	if (Saved) {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd"];
		NSString *dateString = [dateFormatter stringFromDate:date];
		
        if (self.currentTag == 101) {
            self.text1.text =  dateString;
        }
        if (self.currentTag == 102) {
            self.text2.text =  dateString;
            if (([self.text1.text compare:self.text2.text] == NSOrderedDescending)||
                [self.text1.text compare:self.text2.text] == NSOrderedSame)
            {
                
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"提示"
                                      message:@"开始时间不能早于等于截止时间"
                                      delegate:nil
                                      cancelButtonTitle:@"确定"
                                      otherButtonTitles:nil];
                [alert show];
                
                [self.text2 becomeFirstResponder];
                self.text2.text=@"";
            }
        }
        
       
	}
}

#pragma mark -
#pragma mark WordsDelegate
- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row {
    [self.popController dismissPopoverAnimated:YES];
    self.text4.text = words;
}

- (void)QueryViewAnimation:(BOOL)isShow{
    if(isShow) {
        self.queryView.hidden = NO;
        CGRect frame = self.listTableView.frame;
        [UIView beginAnimations:@"ShowListTable" context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        CGFloat x = CGRectGetMinX(frame);
        //CGFloat y = CGRectGetMinY(frame);
        CGFloat width = CGRectGetWidth(frame);
        CGFloat height = CGRectGetHeight(frame);
        
        if (height > 720) {
            height = height-196;
        }
        self.listTableView.frame = CGRectMake(x, 220, width, height);
        [UIView commitAnimations];
    }
    else {
        self.queryView.hidden = YES;
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
            height = height + 196;
        }
        self.listTableView.frame = CGRectMake(x, 24, width, height);
        [UIView commitAnimations];
    }
}


#pragma mark -
#pragma mark ArchiveFileDetailDelegate
- (void)didSelectArchiveListInfo:(NSDictionary *)infoDict Type:(NSString *)type{
    if ([type isEqualToString:@"file"]) {
        FileInfoViewController *fileInfoViewController = [[FileInfoViewController alloc] initWithNibName:@"FileInfoViewController" bundle:nil];
        fileInfoViewController.fileid = [infoDict objectForKey:@"fileid"];
        fileInfoViewController.modId = self.modid;
        [self.navigationController pushViewController:fileInfoViewController animated:YES];
    }
    
    else {
        DocInfoViewController *docInfoViewController = [[DocInfoViewController alloc] initWithNibName:@"DocInfoViewController" bundle:nil];
        docInfoViewController.docid = [infoDict objectForKey:@"docid"];
        docInfoViewController.modid = self.modid;
        [self.navigationController pushViewController:docInfoViewController animated:YES];
        
        
    }
}

- (void)loadMoreList{
    self.archiveListParser.isRefresh = NO;
    [self.archiveListParser requestData];
}

#pragma mark - FileManager Delegate

// -------------------------------------------------------------------------------
//	实现FileManager Delegate委托方法
//  选中公文管理列表后调用此方法
// -------------------------------------------------------------------------------

- (void)returnSelectResult:(NSString *)type selected:(NSInteger)row
{
    BOOL isShow=NO;
    
    [self.popController dismissPopoverAnimated:YES];
    
    [self.archiveListParser.aryItems removeAllObjects];
    [self.archiveListParser.listTableView reloadData];
    
    switch (row) {
        case 0:
            self.title = @"案卷查询";
            isShow = YES;
            self.label1.text = @"组卷时间：";
            self.label2.text = @"截至时间：";
            self.label3.text = @"案卷标题：";
            self.label4.text = @"保管期限：";
            
            self.text1.placeholder = @"请选择组卷时间";
            self.text2.placeholder = @"请选择截至时间";
            self.text3.placeholder = @"请输入案卷标题";
            self.text4.placeholder = @"请选择保管期限";
            
            self.text1.text = @"";
            self.text2.text = @"";
            self.text3.text = @"";
            self.text4.text = @"";

            self.archiveListParser = [[InquiryFileListParser alloc] init];
            self.archiveListParser.serviceName = @"FilesInquery";
            self.archiveListParser.showView = self.view;
            self.archiveListParser.delegate = self;
            
            self.archiveListParser.listTableView = self.listTableView;
            self.listTableView.dataSource = self.archiveListParser;
            self.listTableView.delegate = self.archiveListParser;
            //[self.archiveListParser requestData];
            break;
            
        case 1:
            self.title = @"卷内查询";
            isShow = YES;
            self.label1.text = @"登记时间：";
            self.label2.text = @"截至时间：";
            self.label3.text = @"文件文号：";
            self.label4.text = @"文件标题：";
            
            self.text1.placeholder = @"请选择登记时间";
            self.text2.placeholder = @"请选择截至时间";
            self.text3.placeholder = @"请输入文件文号";
            self.text4.placeholder = @"请输入文件标题";
            
            self.text1.text = @"";
            self.text2.text = @"";
            self.text3.text = @"";
            self.text4.text = @"";

            self.archiveListParser = [[InquiryDocListParser alloc] init];
            self.archiveListParser.serviceName = @"PagesInquery";
            self.archiveListParser.showView = self.view;
            self.archiveListParser.delegate = self;
            self.archiveListParser.listTableView = self.listTableView;
            self.listTableView.dataSource = self.archiveListParser;
            self.listTableView.delegate = self.archiveListParser;
            break;
        default:;
    }
    
    [self QueryViewAnimation:isShow];


}

#pragma mark - 
#pragma mark selectYearDirectoryDelegate
- (void)returnYearDirectoryWithYear:(NSString *)year Modid:(NSString *)modid {
    
    [self.archiveListParser.aryItems removeAllObjects];
    [self.listTableView reloadData];

    [self.popController dismissPopoverAnimated:YES];
    self.modid = modid;
    
    self.title = @"案卷目录";
    self.archiveListParser = [[FileDirectoryListParser alloc] init];
    self.archiveListParser.paramAry = [NSArray arrayWithObjects:year,modid,nil];
    self.archiveListParser.serviceName = @"ArchivesDirectory";
    self.archiveListParser.showView = self.view;
     self.archiveListParser.delegate = self;
    self.archiveListParser.listTableView = self.listTableView;
    self.listTableView.dataSource = self.archiveListParser;
    self.listTableView.delegate = self.archiveListParser;
    [self QueryViewAnimation:NO];
    [self.archiveListParser requestData];
    
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"案卷查询";
    self.modid = @"";
    UIBarButtonItem *backItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"返回"];
    self.navigationItem.leftBarButtonItem = backItem;
    UIButton *backButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
    [backButton addTarget:self action:@selector(goBackAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *listItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"档案管理"];
    self.navigationItem.leftBarButtonItem = listItem;
    
    UIButton *listButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
    [listButton addTarget:self action:@selector(docManagerList:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem,listItem, nil];
    
    
    UIBarButtonItem *historyItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"历史案卷"];
    self.navigationItem.rightBarButtonItem = historyItem;
    
    UIButton *historyButton = (UIButton *)self.navigationItem.rightBarButtonItem.customView;
    [historyButton addTarget:self action:@selector(historyManagerList:) forControlEvents:UIControlEventTouchUpInside];
    
    self.archiveListParser = [[FileDirectoryListParser alloc] init];
    self.archiveListParser.serviceName = @"ArchivesDirectory";
    self.archiveListParser.showView = self.view;
    self.archiveListParser.delegate = self;
    self.archiveListParser.listTableView = self.listTableView;
    self.listTableView.dataSource = self.archiveListParser;
    self.listTableView.delegate = self.archiveListParser;
    [self.archiveListParser requestData];
    
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
