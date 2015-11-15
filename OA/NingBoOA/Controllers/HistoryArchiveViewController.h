//
//  HistoryArchiveViewController.h
//  NingBoOA
//
//  Created by 熊熙 on 13-10-22.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebDataParserHelper.h"
#import "BaseViewController.h"

@protocol selectYearDirectoryDelegate <NSObject>

- (void)returnYearDirectoryWithYear:(NSString *)year Modid:(NSString *)modid;

@end

@interface HistoryArchiveViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *listTableView;
@property (weak,   nonatomic) id<selectYearDirectoryDelegate> delegate;
@property (strong, nonatomic) NSArray  *listArray;
@end
