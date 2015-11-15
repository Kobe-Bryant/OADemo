//
//  SettingsInfo.h
//  HNYDZF
//
//  Created by 张 仁松 on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  应用偏好设置单例
 */

@interface SettingsInfo : NSObject
+ (SettingsInfo *)sharedInstance;
- (void)loadPreferences;

@property (strong,nonatomic) NSString *ipHeader;


@end
