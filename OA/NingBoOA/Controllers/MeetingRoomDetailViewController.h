//
//  MeetingRoomDetailViewController.h
//  NingBoOA
//
//  Created by 熊熙 on 13-11-11.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseContentDetailViewController.h"
#import "WebDataParserHelper.h"
#import "PopupDateViewController.h"
#import "CommenWordsViewController.h"
#import "HandleGWProtocol.h"
@interface MeetingRoomDetailViewController : BaseContentDetailViewController<WebDataParserDelegate,PopupDateDelegate,WordsDelegate,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) NSDictionary *meetngInfo;
@property (strong,nonatomic) NSArray *meetingRoomAry;
@property (strong,nonatomic) NSString *serviceName;
@property (assign,nonatomic) BOOL isCurrent;
@property (strong,nonatomic) UITextField *txtField;
@property (strong,nonatomic) IBOutlet UITableView *attachTable;
@property (strong,nonatomic) IBOutlet UILabel     *applicant;
@property (strong,nonatomic) IBOutlet UILabel     *department;
@property (strong,nonatomic) IBOutlet UILabel     *applyDate;
@property (strong,nonatomic) IBOutlet UITextField *meetingRoom;
@property (strong,nonatomic) IBOutlet UITextField *meetingName;
@property (strong,nonatomic) IBOutlet UITextField *beginTime;
@property (strong,nonatomic) IBOutlet UITextField *endTime;
@property (strong,nonatomic) IBOutlet UITextField *participance;
@property (strong,nonatomic) IBOutlet UITextView  *meetingContent;
@property (strong,nonatomic) IBOutlet UITextView  *meetingRequiry;
@property (assign,nonatomic) NSInteger currentTag;
@property (weak,nonatomic)   id<HandleGWDelegate> delegate;

- (IBAction)touchFromDate:(id)sender;
- (IBAction)getAvaliableMeetingRoom:(id)sender;

@end
