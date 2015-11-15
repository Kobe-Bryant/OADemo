//
//  MeetingRoomManagerViewController.h
//  NingBoOA
//
//  Created by 熊熙 on 13-11-11.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "WebDataParserHelper.h"
#import "FileManagerListController.h"
#import "MeetingRoomListParser.h"
#import "HandleGWProtocol.h"
@interface MeetingRoomManagerViewController : BaseViewController<WebDataParserDelegate,FileManagerDelegate,MeetingRoomDetailDelegate,UITextFieldDelegate,HandleGWDelegate>

@property (nonatomic,strong) NSString *fileServiceName;
@property (strong,nonatomic) IBOutlet UITableView *listTableView;
@property (strong,nonatomic) NSMutableArray *listDataArray;
@property (strong,nonatomic) MeetingRoomListParser *meetingroomListParser;

@end
