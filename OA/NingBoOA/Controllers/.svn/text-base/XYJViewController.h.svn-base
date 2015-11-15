//
//  XYJViewController.h
//  GuangXiOA
//
//  Created by apple on 13-1-9.
//
//

#import <UIKit/UIKit.h>
#import "ContactListViewController.h"
#import "CustomViewController.h"
#import "NSURLConnHelper.h"
#import "BaseViewController.h"
#define systemFont(x) [UIFont systemFontOfSize:x]

@interface XYJViewController : BaseViewController<selectLinkManDelegate,NSURLConnHelperDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *receiverLabel;
@property (strong, nonatomic) IBOutlet UITableView *fileTableView;
@property (strong,nonatomic) IBOutlet UILabel *titleLabel;
@property (strong,nonatomic) IBOutlet UITextView *titleTextView;
@property (strong,nonatomic) IBOutlet UITextView *contextTextView;
@property (strong, nonatomic) IBOutlet UILabel *contextLabel;
@property (strong,nonatomic) IBOutlet UIButton *addButton;
@property (nonatomic,assign) float animateHeight;
@property (nonatomic,strong) NSMutableArray *departmentArray;
@property (nonatomic,strong) NSMutableArray *personArray;
@property (nonatomic,assign) NSInteger typeTag;

@property (nonatomic,strong) NSString *receiverString;
@property (nonatomic,strong) NSMutableString *titleString;


@property (nonatomic,strong) UIPopoverController *popVc;

//编写1,回复2,转发3,
@property (nonatomic,strong) NSString *fjrString;
@property (nonatomic,strong) NSString *sjrString;
@property (nonatomic,strong) NSString *btString;
@property (nonatomic,strong) NSString *nrString;
@property (nonatomic,assign) NSInteger fjlxTag;
@property (nonatomic,strong) NSString *jslx;
@property (nonatomic,strong) NSString *sento;
@property (nonatomic,strong) NSString *fjbh;
@property(nonatomic,strong)NSString *mailid;
@property(nonatomic,strong) NSURLConnHelper *webHelper;
@end



