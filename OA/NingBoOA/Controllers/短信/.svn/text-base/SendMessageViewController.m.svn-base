//
//  SendMessageViewController.m
//  GMEPS_HZ
//
//  Created by 熊 熙 on 13-7-18.
//
//

#import "SendMessageViewController.h"
#import "UIBubbleTableView.h"
#import "UICustomButton.h"
#import "UIBubbleTableViewDataSource.h"
#import "NSBubbleData.h"
#import "MessageInputView.h"
#import "NSString+MessagesView.h"
#import "WebServiceHelper.h"
#import "MsgsHelper.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "SystemConfigContext.h"


#define MOBILE  @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"
#define CM      @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
#define CU      @"^1(3[0-2]|5[256]|8[56])\\d{8}$"
#define CT      @"^1((33|53|8[09])[0-9]|349)\\d{7}$"

#define INPUT_DATA 0
#define SELECT_DATA 1

#define INPUT_HEIGHT 40.0f
@interface SendMessageViewController ()

@property (nonatomic, retain) UIPopoverController *popController;
@end

@implementation SendMessageViewController

- (void)backItemPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendPressed:(id)sender {
    NSString *sendText = [self.inputView.textView.text trimWhitespace];
    NSString *recipient = @"";
    NSString *type = @"";

    if(data_type ==SELECT_DATA)
    {
        NSIndexPath *indexPath = [_listTableView indexPathForSelectedRow];
        NSDictionary *listDict = [_listData objectAtIndex:indexPath.row];
        recipient = [listDict objectForKey:@"recipient"];

    }
    else
    {
        if ([self.contactTxt.text isEqualToString:@""]) {
            [self showAlertMessage:@"收件人号码不能为空"];
            return ;
        }

        NSString *regex = @"^[\u4e00-\u9fa5、]+$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        BOOL isMatch = [pred evaluateWithObject:self.contactTxt.text];
        BOOL isVailed = [self verifyPhoneNumber:self.contactTxt.text];
        
        self.messageTxt = sendText;
        
        if (isMatch) {
            self.receiver = self.contactTxt.text;
            recipient = self.recipient;
            type = @"userid";
        }
        else if (isVailed) {
            self.receiver = @"";
            recipient = self.contactTxt.text;
            self.recipient = recipient;
            type = @"number";
        }
        else {
            [self showAlertMessage:@"输入手机号码无效"];
            self.contactTxt.text = @"";
            return;
        }
        
    }

    [self sendMessage:recipient withText:sendText Type:type];
}

- (void)sendMessage:(NSString *)recipient withText:(NSString *)text Type:(NSString *)type
{    
    NSDictionary *userInfo  = [[SystemConfigContext sharedInstance] getUserInfo];
    NSString *userid = [userInfo objectForKey:@"userId"];
    
    NSString *URL = [ServiceUrlString generateOAWebServiceUrl];
    NSString *params = [WebServiceHelper createParametersWithKey:@"Message_sender" value:userid, @"Message_Recipient",recipient,@"Recipient_Type",type,@"Message_Content",text,nil];
    webService = [[WebServiceHelper alloc] initWithUrl:URL method:@"SendMessage" nameSpace:WEBSERVICE_NAMESPACE parameters:params delegate:self];
    [webService runAndShowWaitingView:self.view withTipInfo:@"正在发送信息，请稍候..."];
}

- (BOOL)verifyPhoneNumber:(NSString *)mobileNum
{
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CT];
    
    //        NSPredicate *regextestPHS = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",PHS];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)handleSwipe:(UIGestureRecognizer *)guestureRecognizer
{
    [self.inputView.textView resignFirstResponder];
}

- (void)addAddressee:(id)sender {

    NSArray *selectAry = [self.recipient componentsSeparatedByString:@","];

    NSString *regex = @"^[\u4e00-\u9fa5、]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isMatch = [pred evaluateWithObject:self.contactTxt.text];
    if (!isMatch) {
        selectAry = nil;
        self.contactTxt.text = @"";
    }
    
    UIButton *btn = (UIButton *)sender;
    
    if (self.popController)
        [self.popController dismissPopoverAnimated:YES];
    
    ContactListViewController *contactViewController = [[ContactListViewController alloc] initWithNibName:@"ContactListViewController" bundle:nil];
    contactViewController.contactDelegate = self;
    contactViewController.showPhone = NO;
    //contactViewController.contentSizeForViewInPopover = CGSizeMake(320, 480);
    
    contactViewController.selectItems = selectAry;
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:contactViewController];
    
    UIPopoverController *tmpPopover = [[UIPopoverController alloc] initWithContentViewController:controller];
    tmpPopover.popoverContentSize = CGSizeMake(240, 480);
    self.popController = tmpPopover;
    
    [self.popController presentPopoverFromRect:[btn bounds] inView:btn permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
}

- (void)addMessageInfo:(id)sender {
    if (isAdd) {
        return;
    }
    
    data_type = INPUT_DATA;
    _contactTxt.text = @"";
    NSMutableDictionary *newItem = [NSMutableDictionary dictionaryWithCapacity:3];
    [newItem setObject:@"新消息" forKey:@"receiver"];
    
    if (_listData == nil || [_listData count] < 1) {
        self.listData = [NSMutableArray arrayWithObject:newItem];
    }
    
    
    else {
        [self.listData insertObject:newItem atIndex:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        
        [self.listTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [self.listTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
    self.bubbleData  = [NSMutableArray arrayWithCapacity:1];
    [_bubbleTable reloadData];
    
    self.detailItem.title = @"新消息";
    [self.contactTxt becomeFirstResponder];
    
//    self.detailItem.rightBarButtonItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"取消"];
    
    UIBarButtonItem *cancelItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"取消"];
    UIButton *cancelButton = (UIButton *)cancelItem.customView;
    [cancelButton addTarget:self action:@selector(cancelAddMessage:) forControlEvents:UIControlEventTouchUpInside];
    
    self.detailItem.rightBarButtonItem = cancelItem;
    
    [self addAnimation];
    isAdd = YES;
    [self.listTableView reloadData];
}

- (void)addAnimation{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"NewMessage" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    float orignY = self.addContactView.frame.origin.y;
    CGRect rect = CGRectMake(281, orignY+132, 488, 44);
    self.addContactView.frame =rect;
    //self.addContactView.alpha = 1;
    
    orignY = _bubbleTable.frame.origin.y;
    rect = CGRectMake(0, orignY+44, 488, 960);
    self.bubbleTable.frame = rect;
    
    [UIView commitAnimations];
    
}

- (void)cancelAnimation{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"NewMessage" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    float orignY = self.addContactView.frame.origin.y;
    CGRect rect = CGRectMake(281, orignY-132, 488, 44);
    self.addContactView.frame =rect;
    
    orignY = _bubbleTable.frame.origin.y;
    rect = CGRectMake(0, orignY-44, 488, 960);
    self.bubbleTable.frame = rect;
    
    [UIView commitAnimations];
    
    
    self.inputView.sendButton.enabled = NO;
    
}

- (void)cancelAddMessage:(id)sender {
    
    [self cancelAnimation];
    [self.contactTxt resignFirstResponder];
    [self.inputView.textView resignFirstResponder];
    
    [self.listData removeObjectAtIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    [self.listTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    
    self.detailItem.rightBarButtonItem = nil;

    if ([_listData count] >= 1) {
        NSDictionary *msgDict = [_listData objectAtIndex:indexPath.row];
        NSString *numberStr = [msgDict objectForKey:@"send_number"];
        NSString *senderStr = [msgDict objectForKey:@"receiver"];
        if ([senderStr isEqualToString:@""] || senderStr == nil) {
            _detailItem.title = numberStr;
        }
        else {
            _detailItem.title = senderStr;
        }
        self.inputView.hidden = NO;
        [self.listTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
    else {
        self.inputView.hidden = YES;
        self.detailItem.title = @"";
    }
    
    isAdd = NO;
}

// -------------------------------------------------------------------------------
//	initWithNibName:bundle:
// -------------------------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initMessageData];
        data_type = INPUT_DATA;
    }
    return self;
}

- (void)initMessageData{
    MsgsHelper *helper = [[MsgsHelper alloc] init];
    NSArray *resultData  = [helper getMessageList];
    
    if ([resultData count] < 1) {
        return;
    }
    
    self.listData = [NSMutableArray arrayWithArray:resultData];
    
    NSDictionary *msgDict = [_listData objectAtIndex:0];
    NSString *numberStr = [msgDict objectForKey:@"recipient"];
    
    resultData  = [helper queryMessageInfo:numberStr];
    
    NSMutableArray *bubbleAry =  [NSMutableArray arrayWithCapacity:1];
//    for (NSDictionary *resultDict in resultData) {
//        NSString *dateStr = [resultDict objectForKey:@"send_date"];
//        NSString *infoStr  = [resultDict objectForKey:@"send_info"];
//        
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        NSDate *date = [dateFormatter dateFromString:dateStr];
//        [bubbleAry addObject:[NSBubbleData dataWithText:infoStr date:date type:BubbleTypeMine]];
//    }
    
    self.bubbleData = bubbleAry;
    
    
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINavigationItem *masterItem =  [[UINavigationItem alloc] init];
    masterItem.title = @"信息";
    
    masterItem.leftBarButtonItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"返回"];

    UIButton* leftButton = (UIButton*)masterItem.leftBarButtonItem.customView;
    [leftButton addTarget:self action:@selector(backItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *composeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(addMessageInfo:)];
    
    masterItem.rightBarButtonItem = composeButton;
    
    _masterNavBar.items = [NSArray arrayWithObject:masterItem];
    
   
    _detailItem =  [[UINavigationItem alloc] init];
    _detailNavBar.items = [NSArray arrayWithObject:_detailItem];
    
    CGSize size = self.messageView.frame.size;
    CGRect inputFrame = CGRectMake(0.0f, size.height - INPUT_HEIGHT, size.width, INPUT_HEIGHT);
    _inputView = [[MessageInputView alloc] initWithFrame:inputFrame];
    self.inputView.textView.delegate = self;
    [self.inputView.sendButton addTarget:self action:@selector(sendPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.messageView addSubview:self.inputView];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipe.direction = UISwipeGestureRecognizerDirectionDown;
    swipe.numberOfTouchesRequired = 1;
    [self.inputView addGestureRecognizer:swipe];
    
    self.bubbleTable.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:226.0/255.0 blue:226.0/255.0 alpha:1.0];
    
    _bubbleTable.bubbleDataSource = self;
    
    [_bubbleTable reloadData];
    
    self.inputView.hidden = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [self viewDidAppear:YES];
    [self scrollToBottomAnimated:NO];
    self.navigationController.navigationBarHidden = YES;
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillShowKeyboard:)
												 name:UIKeyboardWillShowNotification
                                               object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillHideKeyboard:)
												 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark selectLinkManDelegate

- (void)returnContactIds:(NSString *)users Names:(NSString *)names{
    //data_type = SELECT_DATA;
    self.contactTxt.text = names;
    self.receiver = names;
    self.recipient = users;

    if (_popController) {
        [_popController dismissPopoverAnimated:YES];
    }
}

#pragma mark -
#pragma mark UIBubbleTableViewDataSource implementation

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [_bubbleData count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [_bubbleData objectAtIndex:row];
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
    if ([_bubbleTable numberOfSections] < 1) {
        return;
    }
    
    NSInteger lastSection =  [_bubbleTable numberOfSections] - 1;
    NSInteger rows = [_bubbleTable numberOfRowsInSection:lastSection];
    
    if(rows > 0) {
        [_bubbleTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1  inSection:lastSection]
                            atScrollPosition:UITableViewScrollPositionBottom
                                    animated:animated];
        //        float width = _bubbleTable.frame.size.width;
        //        float height= _bubbleTable.frame.size.height;
        //        float originX = _bubbleTable.frame.origin.x;
        //        float originY = _bubbleTable.frame.origin.y;
        //        if (originY == 0) {
        //            CGRect rect=CGRectMake(originX,originY-40,width,height);
        //            _bubbleTable.frame = rect;
        //        }
        
    }
}


#pragma mark -
#pragma mark UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_listData count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 916.0/11;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myIdentifier = @"myIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
        UILabel *sender = [[UILabel alloc] initWithFrame:CGRectMake(20, 4, 160, 30)];
        sender.lineBreakMode = NSLineBreakByTruncatingTail;
        sender.font  = [UIFont boldSystemFontOfSize:17];
        sender.tag = 101;
        [cell.contentView addSubview:sender];
        UILabel *detailInfo = [[UILabel alloc] initWithFrame:CGRectMake(20, 26, 240, 52)];
        detailInfo.textColor = [UIColor grayColor];
        detailInfo.backgroundColor = [UIColor clearColor];
        detailInfo.font = [UIFont systemFontOfSize:15];
        detailInfo.tag  = 103;
        detailInfo.numberOfLines = 0;
        [cell.contentView addSubview:detailInfo];
        UILabel *sendDate = [[UILabel alloc] initWithFrame:CGRectMake(210, 4, 60, 30)];
        sendDate.textColor = [UIColor colorWithRed:68.0/255.0 green:155.0/255.0 blue:1.0 alpha:1.0];
        sendDate.font = [UIFont systemFontOfSize:14];
        sendDate.tag = 102;
        [cell.contentView addSubview:sendDate];
    }
    
    NSDictionary *messageDict = [_listData objectAtIndex:indexPath.row];
    NSString *receiver =[messageDict objectForKey:@"receiver"];
    NSString *recipient = [messageDict objectForKey:@"recipient"];
    NSString *messageStr = [messageDict objectForKey:@"send_info"];
    NSString *latelyStr = [messageDict objectForKey:@"lately"];
    latelyStr = [latelyStr substringWithRange:NSMakeRange(2, 8)];
    
    
    if ([latelyStr isEqualToString:@""] || latelyStr == nil)
    {
        latelyStr = [messageDict objectForKey:@"send_date"];
        latelyStr = [latelyStr substringWithRange:NSMakeRange(2, 8)];
    }
    
    UILabel *receiverLabel = (UILabel *)[cell viewWithTag:101];
    receiverLabel.text = receiver;
    if ([receiver length] < 1) {
        receiverLabel.text = recipient;
    }
    
    UILabel *sendDate = (UILabel *)[cell viewWithTag:102];
    sendDate.text = latelyStr;
    
    UILabel *detailInfo = (UILabel *)[cell viewWithTag:103];
    detailInfo.text = messageStr;
    
    if ([messageStr length] < 1) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;

    }
    
    return cell;
}

//  滑动删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *itemDict = [self.listData objectAtIndex:indexPath.row];
    NSString *recipient = [itemDict objectForKey:@"recipient"];
    MsgsHelper *helper = [[MsgsHelper alloc] init];
    [helper deleteRecordMessageList:recipient];
    
    if (isAdd) {
        [self cancelAnimation];
        [self.contactTxt resignFirstResponder];
        isAdd = NO;
    }
    
    [self.inputView.textView resignFirstResponder];
    self.inputView.hidden = YES;
    [self.listData removeObjectAtIndex:indexPath.row];
    
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    [self.listTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    
    [self.bubbleData removeAllObjects];
    [self.bubbleTable reloadData];
    self.detailItem.rightBarButtonItem = nil;
    _detailItem.title = @"";
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isAdd) {
        return NO;
    }
    else{
        return YES;
    }
}

#pragma mark -
#pragma mark tableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.inputView.hidden = NO;
    
    NSDictionary *msgDict = nil;
    if (isAdd) {
        [self cancelAddMessage:nil];
        if ([_listData count]) {
           msgDict = [_listData objectAtIndex:0]; 
        }
        else{
            self.inputView.hidden = YES;
        }
    }
    else{
        msgDict = [_listData objectAtIndex:indexPath.row];
        self.contactTxt.text = [msgDict objectForKey:@"receiver"];
        self.recipient = [msgDict objectForKey:@"recipient"];
        
    }
    
    NSString *recipient = [msgDict objectForKey:@"recipient"];
    NSString *receiver  = [msgDict objectForKey:@"receiver"];
    
    
    MsgsHelper *helper = [[MsgsHelper alloc] init];
    NSArray *resultData  = [helper queryMessageInfo:recipient];
    
    NSMutableArray *bubbleAry =  [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary *resultDict in resultData) {
        NSString *dateStr = [resultDict objectForKey:@"send_date"];
        NSString *infoStr  = [resultDict objectForKey:@"send_info"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [dateFormatter dateFromString:dateStr];
        [bubbleAry addObject:[NSBubbleData dataWithText:infoStr date:date type:BubbleTypeMine]];
        
    }
    
    self.bubbleData = bubbleAry;
    _detailItem.title = receiver;
    
    if ([receiver length] < 1) {
        _detailItem.title = recipient;
    }
    
    [_bubbleTable reloadData];
}

#pragma mark -
#pragma mark UISearchBarDelegate-

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    MsgsHelper *helper = [[MsgsHelper alloc] init];
    NSArray *resultData  = [helper queryMessageInfo:searchText];
    self.listData = [NSMutableArray arrayWithArray:resultData];
    [_listTableView reloadData];
}

#pragma mark - Text Field delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.inputView.hidden) {
        self.inputView.hidden = NO;
    }
}

#pragma mark - Text view delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
	
    if(!self.previousTextViewContentHeight)
		self.previousTextViewContentHeight = textView.contentSize.height;
    
    [self scrollToBottomAnimated:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat maxHeight = [MessageInputView maxHeight];
    CGFloat textViewContentHeight = textView.contentSize.height;
    CGFloat changeInHeight = textViewContentHeight - self.previousTextViewContentHeight;
    
    changeInHeight = (textViewContentHeight + changeInHeight >= maxHeight) ? 0.0f : changeInHeight;
    
    if(changeInHeight != 0.0f) {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 0.0f,   _bubbleTable.contentInset.bottom +  changeInHeight, 0.0f);
                             _bubbleTable.contentInset = insets;
                             _bubbleTable.scrollIndicatorInsets = insets;
                             
                             [self scrollToBottomAnimated:NO];
                             
                             CGRect inputViewFrame = self.inputView.frame;
                             self.inputView.frame = CGRectMake(0.0f,
                                                               inputViewFrame.origin.y - changeInHeight,
                                                               inputViewFrame.size.width,
                                                               inputViewFrame.size.height + changeInHeight);
                         }
                         completion:^(BOOL finished) {
                         }];
        
        self.previousTextViewContentHeight = MIN(textViewContentHeight, maxHeight);
    }
    
    self.inputView.sendButton.enabled = ([textView.text trimWhitespace].length > 0) ? YES : NO;
}

#pragma mark - Keyboard notifications

- (void)handleWillShowKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}

- (void)handleWillHideKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}

- (void)keyboardWillShowHide:(NSNotification *)notification
{
    
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	
	double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGFloat keyboardY = [self.messageView convertRect:keyboardRect fromView:nil].origin.y;
                         
                         CGRect inputViewFrame = self.inputView.frame;
                         self.inputView.frame = CGRectMake(inputViewFrame.origin.x,
                                                           keyboardY - inputViewFrame.size.height,
                                                           inputViewFrame.size.width,
                                                           inputViewFrame.size.height);
                         
                         UIEdgeInsets insets = UIEdgeInsetsMake(0.0f,
                                                                0.0f,
                                                                self.messageView .frame.size.height - self.inputView.frame.origin.y - INPUT_HEIGHT,
                                                                0.0f);
                         
                         _bubbleTable.contentInset = insets;
                         _bubbleTable.scrollIndicatorInsets = insets;
                     }
                     completion:^(BOOL finished) {
                     }];
}

#pragma mark - Network Handler Methods

- (void)processWebData:(NSData *)webData
{
    if([webData length] <=0)
    {
        [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
        return;
    }
    WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:@"SendMessageReturn" andWithJSONDelegate:self];
    [webDataHelper parseXMLData:webData];
}

- (void)processError:(NSError *)error
{
    [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
    return;
}

- (void)parseJSONString:(NSString *)jsonStr 
{
    
    NSDictionary *resultDict = [jsonStr objectFromJSONString];
    NSString *status = [resultDict objectForKey:@"status"];
    
    if([status isEqualToString:@"0"])
    {
        if (isAdd)
        {
            [self cancelAnimation];
            isAdd = NO;
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *dateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
            
            NSDictionary *itemDict = [NSDictionary dictionaryWithObjectsAndKeys:self.recipient,@"recipient",_messageTxt,@"send_info",dateStr,@"send_date",self.receiver,@"receiver",nil];
            
            [_listData replaceObjectAtIndex:0 withObject:itemDict];
            [_listTableView reloadData];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [_listTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
        
        [_bubbleData addObject:[NSBubbleData dataWithText:self.messageTxt date:[NSDate dateWithTimeIntervalSinceNow:400] type:BubbleTypeMine]];
        
        MsgsHelper *helper = [[MsgsHelper alloc] init];
       
        [helper saveMessage:self.messageTxt recipient:self.recipient sender:self.receiver];
        
        [_bubbleTable reloadData];
        
        [self showAlertMessage:@"信息发送成功"];
        
        self.inputView.textView.text = @"";
        [self.inputView.textView resignFirstResponder];
        _detailItem.rightBarButtonItem = nil;
        _detailItem.title = self.receiver;
        
        if ([self.receiver length] < 1) {
            _detailItem.title = self.recipient;
        }
    }
    
    else {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"错误"
                              message:@"信息发送失败！"  delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [[[alert subviews] objectAtIndex:2] setBackgroundColor:[UIColor colorWithRed:0.5 green:0.0f blue:0.0f alpha:1.0f]];
        [alert show];
    }
}

- (void)parseWithError:(NSString *)errorString
{
    [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
    return;
}

-(void)showAlertMessage:(NSString*)msg{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message:msg
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];
}

@end
