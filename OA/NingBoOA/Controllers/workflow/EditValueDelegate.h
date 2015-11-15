//
//  EditValueDelegate.h
//  NingBoOA
//
//  Created by Alex Jean on 13-8-12.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EditValueDelegate <NSObject>

- (void)passWithNewValue:(NSString *)aValue andSection:(int)aSection andRow:(int)aRow;

@end
