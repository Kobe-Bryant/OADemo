//
//  HandleFileController.h
//  GuangXiOA
//
//  Created by 张 仁松 on 12-3-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//  主任、处长的流转

#import <UIKit/UIKit.h>
#import "CommenWordsViewController.h"
#import "UISelectPersonVC.h"
#import "HandleGWProtocol.h"
#import "NSURLConnHelper.h"
#import "QQSectionHeaderView.h"

#define kWebService_WorkFlow 0
#define kWebService_Transfer 1
#define NOT_SELECTED -1

@interface SelectedPersonItem : NSObject
@property (nonatomic,copy) NSArray *arySelectedMainUsers;
@property (nonatomic,copy) NSArray *arySelectedHelperUsers;
@property (nonatomic,copy) NSArray *arySelectedReaderUsers;
@property(nonatomic,assign) BOOL showHelper;
@property(nonatomic,assign) BOOL showReader;
@property(nonatomic,assign) BOOL multiMuster;
@end

@interface TransitionActionControllerNew : UIViewController<UISelPeronViewDelegate,UIAlertViewDelegate,WordsDelegate>

@property (nonatomic,strong) IBOutlet UITableView *stepTableView;
@property (nonatomic,strong) IBOutlet UITableView *usrTableView;

@property (nonatomic,strong) IBOutlet UITextView *opinionView;

@property(nonatomic,copy)NSString *bzbh;
@property(nonatomic,assign) BOOL canSignature;
@property(nonatomic,copy)NSString *processType;
@property (nonatomic,assign) id<HandleGWDelegate> delegate;
-(IBAction)btnTransferPressed:(id)sender;

-(IBAction)btnPersonShortCutPressed:(id)sender;

-(IBAction)btnStepShortCutPressed:(id)sender;

-(void)updateSelectStep;

@end
