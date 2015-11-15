//
//  MeetingRoomDetailViewController.m
//  NingBoOA
//
//  Created by 熊熙 on 13-11-11.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MeetingRoomDetailViewController.h"
#import "DisplayAttachFileController.h"
#import "UICustomButton.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "SystemConfigContext.h"
@interface MeetingRoomDetailViewController ()
@property (strong, nonatomic) UIPopoverController *popController;
@end

@implementation MeetingRoomDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)setControlEdit{
    
    if (self.isCurrent) {
        SystemConfigContext *context = [SystemConfigContext sharedInstance];
        NSDictionary *loginUsr = [context getUserInfo];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSDate *date =[NSDate date];
        
        NSString *moment = [dateFormatter stringFromDate:date];

        
        self.applicant.text = [loginUsr objectForKey:@"name"];
        self.department.text = [loginUsr objectForKey:@"department"];
        self.applyDate.text = moment;
        
        UIBarButtonItem *backItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"返回"];
        self.navigationItem.leftBarButtonItem = backItem;
        UIButton *backButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
        [backButton addTarget:self action:@selector(goBackAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *saveItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"保存"];
        self.navigationItem.rightBarButtonItem = saveItem;
        UIButton *saveButton = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
        [saveButton addTarget:self action:@selector(saveApplyMeetingRoom:) forControlEvents:UIControlEventTouchUpInside];
        

        
        self.meetingRoom.borderStyle = UITextBorderStyleRoundedRect;
        self.meetingRoom.enabled = YES;
        
        self.meetingName.borderStyle = UITextBorderStyleRoundedRect;
        self.meetingName.enabled = YES;
        
        self.beginTime.borderStyle = UITextBorderStyleRoundedRect;
        self.beginTime.enabled = YES;
        
        self.endTime.borderStyle = UITextBorderStyleRoundedRect;
        self.endTime.enabled = YES;
        
        self.participance.borderStyle = UITextBorderStyleRoundedRect;
        self.participance.enabled = YES;
        
        self.meetingContent.layer.borderColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0].CGColor;
        
        self.meetingContent.layer.borderWidth =1.5;
        
        self.meetingContent.layer.cornerRadius =6.0;
        
        self.meetingRequiry.layer.borderColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0].CGColor;
        
        self.meetingRequiry.layer.borderWidth =1.5;
        
        self.meetingRequiry.layer.cornerRadius =6.0;
    }
    else {
                
        UIBarButtonItem *backItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"返回"];
        self.navigationItem.leftBarButtonItem = backItem;
        UIButton *backButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
        [backButton addTarget:self action:@selector(goBackAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"会议安排";
    
    self.applicant.text = [self.meetngInfo objectForKey:@"applicant"];
    self.department.text = [self.meetngInfo objectForKey:@"department"];
    self.applyDate.text = [self.meetngInfo objectForKey:@"applydate"];
    self.meetingRoom.text = [self.meetngInfo objectForKey:@"meetingroom"];
    self.meetingName.text = [self.meetngInfo objectForKey:@"title"];
    self.beginTime.text   = [self.meetngInfo objectForKey:@"begintime"];
    self.endTime.text     = [self.meetngInfo objectForKey:@"endtime"];
    self.participance.text = [self.meetngInfo objectForKey:@"staff"];
    self.meetingContent.text = [self.meetngInfo objectForKey:@"meetingContent"];
    self.meetingRequiry.text = [self.meetngInfo objectForKey:@"roomRequiry"];
    
    [self setControlEdit];
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

- (void)saveApplyMeetingRoom:(id)sender{
    NSString *errMsg = @"";
    if ([self.meetingRoom.text length] <=0)
        errMsg = @"请选择会议室。";
    else if ([self.meetingName.text length] <=0)
        errMsg = @"请输入会议名称。";
    else if ([self.beginTime.text length] <=0)
        errMsg = @"请选择会议开始时间。";
    else if ([self.endTime.text length] <=0)
        errMsg = @"请选择会议结束时间。";
    
    if([errMsg length]>0){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:errMsg
                              delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }

    self.serviceName = @"registerMeetingRoom";
    SystemConfigContext *context = [SystemConfigContext sharedInstance];
    NSDictionary *loginUsr = [context getUserInfo];
    NSString *user = [loginUsr objectForKey:@"userId"];
    NSString *strUrl = [ServiceUrlString generateOAWebServiceUrl];
    NSString *params = [WebServiceHelper createParametersWithKey:@"HY_userid" value:user,@"applicant",self.applicant.text,@"department",self.department.text,@"applydate",self.applyDate.text,@"meetingroom",self.meetingRoom.text,@"title",self.meetingName.text,@"begintime",self.beginTime.text,@"endtime",self.endTime.text,@"staff",self.participance.text,@"meetingContent",self.meetingContent.text,@"roomRequiry",self.meetingRequiry.text,nil];
    
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:self.serviceName nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
    
    [self.webServiceHelper runAndShowWaitingView:self.view withTipInfo:@"正在加载会议详情，请稍候..."];
}

-(IBAction)touchFromDate:(id)sender{
    self.currentTag = [sender tag];
    self.txtField = (UITextField*)sender;
    
    PopupDateViewController *dateController = [[PopupDateViewController alloc] initWithPickerMode:UIDatePickerModeDateAndTime];
    dateController.delegate = self;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dateController];
    
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
    
    self.popController = popover;
    
    [self.popController presentPopoverFromRect:self.txtField.bounds inView:self.txtField permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)selectCommenWords:(NSArray *)words{
    self.txtField = self.meetingRoom;
    CommenWordsViewController *tmpController = [[CommenWordsViewController alloc] initWithNibName:@"CommenWordsViewController" bundle:nil ];
	tmpController.contentSizeForViewInPopover = CGSizeMake(200, [words count]*44);
	tmpController.delegate = self;
    tmpController.wordsAry = words;
    UIPopoverController *tmppopover = [[UIPopoverController alloc] initWithContentViewController:tmpController];
    self.popController = tmppopover;
    [self.popController presentPopoverFromRect:self.txtField.frame
                                        inView:self.view
                      permittedArrowDirections:UIPopoverArrowDirectionAny
                                      animated:YES];
}

- (IBAction)getAvaliableMeetingRoom:(id)sender{
    self.serviceName = @"avaliableMeetingroom";
    NSString *strUrl = [ServiceUrlString generateOAWebServiceUrl];
    NSString *params = nil;
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:self.serviceName nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
    [self.webServiceHelper run];
}

#pragma mark -
#pragma mark UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

#pragma mark -
#pragma mark WordsDelegate
- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row {
    
    if(self.popController.popoverVisible) {
        [self.popController dismissPopoverAnimated:YES];
    }
    self.txtField.text = words;
}

#pragma mark -
#pragma mark PopupDateDelegate
- (void)PopupDateController:(PopupDateViewController *)controller Saved:(BOOL)Saved selectedDate:(NSDate*)date{
	[self.popController dismissPopoverAnimated:YES];
	if (Saved) {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
		NSString *dateString = [dateFormatter stringFromDate:date];
		
        if (self.currentTag == 101) {
            self.beginTime.text =  dateString;
        }
        if (self.currentTag == 102) {
            self.endTime.text =  dateString;
            if (([self.beginTime.text compare:self.endTime.text] == NSOrderedDescending)||
                [self.beginTime.text compare:self.endTime.text] == NSOrderedSame)
            {
                
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"提示"
                                      message:@"截止时间不能早于等于开始时间"
                                      delegate:nil
                                      cancelButtonTitle:@"确定"
                                      otherButtonTitles:nil];
                [alert show];
                
                [self.endTime becomeFirstResponder];
                self.endTime.text=@"";
                
            }
        }
	}
    
}

#pragma mark -
#pragma mark alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView.message isEqualToString:@"保存成功!"]) {
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
    
    NSString *method = [NSString stringWithFormat:@"%@Return",self.serviceName];
    
    WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:method andWithJSONDelegate:self];
    [webDataHelper parseXMLData:webData];
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
        if ([self.serviceName isEqualToString:@"registerMeetingRoom"]) {
            NSString *status = [tmpParsedJsonDict objectForKey:@"status"];
            if ([status isEqualToString:@"0"]) {
                [self showAlertMessage:@"保存成功!"];
            }
            else {
                [self showAlertMessage:@"保存失败!"];
            }
        }
        else {
            NSMutableArray *meetingArray = [[NSMutableArray alloc] init];
            NSArray *listArray = [tmpParsedJsonDict objectForKey:@"listinfo"];
            if ([listArray count] > 0) {
                for (NSDictionary *info in listArray) {
                    NSString *name = [info objectForKey:@"name"];
                    [meetingArray addObject:name];
                }
                
                [self selectCommenWords:meetingArray];
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

#pragma mark -
#pragma mark tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *attachAry = [self.meetngInfo objectForKey:@"attach_file"];
    if ([attachAry count] < 1) {
        return 1;
    }
    return [attachAry count];
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectZero];
    headerView.font = [UIFont systemFontOfSize:19.0];
    headerView.backgroundColor = [UIColor colorWithRed:214.f/255.f green:234.f/255.f blue:254.f/255.f alpha:1.0];
    headerView.textColor = [UIColor blackColor];
    
    headerView.text = @"  附件";
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdenfier = @"attach_Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdenfier];
    }
    
    NSArray *attachAry = [self.meetngInfo objectForKey:@"attach_file"];
    if(attachAry == nil || [attachAry count] < 1 )
    {
        cell.textLabel.text = @"没有上传附件";
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else
    {
        cell.textLabel.text = [[attachAry objectAtIndex:indexPath.row] objectForKey:@"name"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark -
#pragma mark tableview delegate 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //查看文件
    NSArray *attachAry = [self.meetngInfo objectForKey:@"attach_file"];
    if ([attachAry count] > 0) {
        NSDictionary *attachDict = [attachAry objectAtIndex:indexPath.row];
        if(attachDict != nil && [attachDict objectForKey:@"name"] != nil)
        {
            NSString *fileName = [attachDict objectForKey:@"name"];
            NSString *fileUrl = [attachDict objectForKey:@"url"];
            
            DisplayAttachFileController *display = [[DisplayAttachFileController alloc] initWithNibName:@"DisplayAttachFileController" fileURL:fileUrl andFileName:fileName];
            [self.navigationController pushViewController:display animated:YES];
        }
    }
}

@end
