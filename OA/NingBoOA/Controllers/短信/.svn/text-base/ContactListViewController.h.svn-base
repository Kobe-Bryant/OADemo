//
//  ContactListViewController.h
//  GMEPS_HZ
//
//  Created by 熊 熙 on 13-7-31.
//
//

#import <UIKit/UIKit.h>
#import "WebServiceHelper.h"
#import "WebDataParserHelper.h"
@protocol selectLinkManDelegate <NSObject>

- (void)returnContactIds:(NSString *)users Names:(NSString *)names;

@end

@interface ContactListViewController : UIViewController <UISearchBarDelegate,WebDataParserDelegate>{
    IBOutlet UITableView *listtableView;
    IBOutlet UISearchBar *searchBar;
}

@property (nonatomic, strong) WebServiceHelper *webServiceHelper;
@property (nonatomic, strong) NSMutableArray *userAry;
@property (nonatomic, strong) NSArray *branchAry;
@property (nonatomic, strong) NSString *contactStr;
@property (nonatomic, strong) NSMutableArray *nameAry;
@property (nonatomic, strong) NSMutableString *currentData;
@property (nonatomic, weak) NSArray  *selectItems;
@property (nonatomic, weak) id <selectLinkManDelegate> contactDelegate;
@property(nonatomic,assign) BOOL showPhone;//显示手机号
@end
