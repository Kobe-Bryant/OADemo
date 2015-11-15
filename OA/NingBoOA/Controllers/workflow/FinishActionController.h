//
//  FinishActionController.h
//  TaskTransfer
//
//  Created by zhang on 12-11-15.
//  Copyright (c) 2012年 zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURLConnHelper.h"
#import "HandleGWProtocol.h"

@interface FinishActionController : UIViewController

@property (nonatomic,strong) IBOutlet UITextView *txtView;
@property (nonatomic,strong) IBOutlet UISegmentedControl *segCtrl;
@property (nonatomic,strong) IBOutlet UILabel *signLabel;
@property(nonatomic,copy)NSString *bzbh;
@property(nonatomic,assign) BOOL canSignature;
@property (nonatomic,assign) id<HandleGWDelegate> delegate;   
-(IBAction)finish:(id)sender;

@end
