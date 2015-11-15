//
//  TransitionActionController.h
//  NingBoOA
//
//  Created by zengjing on 13-8-12.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "WebDataParserHelper.h"
#import "HandleGWProtocol.h"

@interface TransitionActionController : BaseViewController<WebDataParserDelegate>

@property (nonatomic, strong) NSString *docId;
@property (nonatomic, strong) NSString *mdId;
@property (nonatomic, strong) NSDictionary *detailDict;
@property (nonatomic, strong) NSString *modifyFields;
@property (nonatomic, weak) id<HandleGWDelegate> delegate;

@property (strong, nonatomic) IBOutlet UILabel *txtNextStepName;
@property (strong, nonatomic) IBOutlet UILabel *txtNextStepTransitioner;
@property (strong, nonatomic) IBOutlet UILabel *txtNextStepReading;


- (IBAction)transitionClick:(id)sender;

@end
