//
//  FileOutListController.h
//  NingBoOA
//
//  Created by 熊熙 on 13-9-11.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FileManagerDelegate <NSObject>

@required

//选中公文管理列表的某一项后调用此方法
- (void)returnSelectResult:(NSString *)type selected:(NSInteger)row;

@end

@interface FileManagerListController : UITableViewController
@property (nonatomic, strong) NSArray  *fileOutList;
@property (nonatomic, strong) NSString *fileType;
@property (nonatomic, weak)   id<FileManagerDelegate> delegate;
@end
