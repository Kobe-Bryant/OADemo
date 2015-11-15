//
//  EditorViewController.h
//  NingBoOA
//
//  Created by Alex Jean on 13-8-12.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditValueDelegate.h"

@interface EditorViewController : UIViewController

@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, strong) NSString *contentString;
@property (nonatomic, assign) int section;
@property (nonatomic, assign) int row;
@property (nonatomic, weak) id<EditValueDelegate> delegate;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextView *detailTextView;
- (IBAction)saveButtonClick:(id)sender;
@end
