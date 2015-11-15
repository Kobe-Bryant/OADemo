//
//  SendMessageViewController.h
//  GMEPS_HZ
//
//  Created by 熊 熙 on 13-7-18.
//
//

#import <UIKit/UIKit.h>
#import "UIBubbleTableViewDataSource.h"
#import "ContactListViewController.h"
#import "WebDataParserHelper.h"
#import "NSURLConnHelperDelegate.h"

@class MessageInputView;
@class UIBubbleTableView;
@class WebServiceHelper;

@interface SendMessageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIBubbleTableViewDataSource,UITextViewDelegate,UITextFieldDelegate,UISearchBarDelegate,selectLinkManDelegate,WebDataParserDelegate,NSURLConnHelperDelegate>{
    
    WebServiceHelper *webService;
    BOOL isAdd;
    NSMutableString *currentData;
    NSInteger data_type;
}

@property (nonatomic, retain) UINavigationItem *detailItem;
@property (nonatomic, retain) NSMutableArray *bubbleData;
@property (nonatomic, retain) NSMutableArray *listData;
@property (nonatomic, retain) IBOutlet UINavigationBar *masterNavBar;
@property (nonatomic, retain) IBOutlet UINavigationBar *detailNavBar;
@property (nonatomic, retain) IBOutlet UITableView *listTableView;
@property (nonatomic, retain) IBOutlet UIBubbleTableView *bubbleTable;
@property (nonatomic, retain) IBOutlet UIView *messageView;
@property (nonatomic, retain) IBOutlet UIView *addContactView;
@property (nonatomic, retain) IBOutlet UITextField *contactTxt;//收件人
@property (nonatomic, retain) MessageInputView *inputView;
@property (nonatomic, assign) CGFloat previousTextViewContentHeight;

@property (nonatomic, copy) NSString *receiver;   //短信接收人姓名
@property (nonatomic, copy) NSString *recipient;  //短信接收人ID
@property (nonatomic, copy) NSString *messageTxt;



- (IBAction)addAddressee:(id)sender;

@end
