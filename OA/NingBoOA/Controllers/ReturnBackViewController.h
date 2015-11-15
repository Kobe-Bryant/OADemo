//
//  ReturnBackViewController.h
//  退回操作
//
//  Created by zhang on 12-9-12.
//
//

#import <UIKit/UIKit.h>
#import "HandleGWProtocol.h"
#import "WebDataParserHelper.h"
#import "WebServiceHelper.h"
#import "BaseViewController.h"

@interface ReturnBackViewController : UIViewController<UIAlertViewDelegate,WebDataParserDelegate,UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *selectedLabel;
@property (strong, nonatomic) IBOutlet UITableView *historyTableView;
@property (strong, nonatomic) NSString *docId;//文档编号
@property (strong, nonatomic) NSString *mdId;//模块名称
@property (strong, nonatomic) NSString *currentProcess;//当前环节
@property (strong, nonatomic) NSArray *historyProcessAry;

@property (nonatomic,assign) id<HandleGWDelegate> delegate;
@property (nonatomic,assign) NSInteger webServiceType; 
@property (nonatomic,strong) WebServiceHelper *webServiceHelper;


-(IBAction)btnTransferPressed:(id)sender;

@end
