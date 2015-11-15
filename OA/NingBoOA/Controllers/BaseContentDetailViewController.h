//
//  BaseContentDetailViewController.h
//  NingBoOA
//
//  Created by PowerData on 13-11-4.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "SaveProcessModel.h"
#import "ContentEditDelegate.h"

@interface BaseContentDetailViewController : BaseViewController <ContentEditDelegate>

@property (nonatomic, strong) NSArray *toDisplayTitleAry;
@property (nonatomic, strong) NSArray *toDisplayKeyAry;
@property (nonatomic, strong) NSArray *toDisplayRowAry;
@property (nonatomic, strong) NSArray *toDisplayEditAry;
@property (strong, nonatomic) NSDictionary *docInfo;
@property (nonatomic, strong) SaveProcessModel *saveModel;

- (void)modifyData:(UIButton *)sender;

- (void)passWithNewValue:(NSString *)newValue andWithRow:(int)aRow andWithIndex:(int)aIndex andWithKey:(NSString *)aKey;

- (CGFloat)getRowHeightWithRowIndex:(NSInteger)rowIndex;

- (NSArray *)getRowDetail:(int)rowIndex;

- (void)setCanEditWithCell:(UITableViewCell *)aCell andWithTag:(int)aTag andWithIndexPath:(NSIndexPath *)indexPath;

- (void)getEditorData;

@end
