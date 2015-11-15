//
//  NSAppUpdateManager.m
//  BoandaProject
//
//  Created by 张仁松 on 13-7-2.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "NSAppUpdateManager.h"
#import "PDJsonkit.h"


@interface NSAppUpdateManager ()
@property (strong,nonatomic) NSDictionary *versionInfo;
@end

@implementation NSAppUpdateManager

-(void)gotoSafari{
    NSURL *appURL = [NSURL URLWithString:[self.versionInfo objectForKey:@"XZDZ"]];
    [[UIApplication sharedApplication] openURL:appURL];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self gotoSafari];
    }
}

-(void)newVertionFound:(NSNotification *)note{
    NSString *flag = [[note userInfo] objectForKey:@"mustUpdate"];
    if ([flag isEqualToString:@"1"]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"检测到新版本的移动办公，请更新。"
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"检测到新版本的移动办公，是否更新？"
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:@"取消",nil];
        [alert show];
        return;
    }
    
}

#define kNewVertionFound      @"kNewVertionFound"

-(void)checkAndUpdate:(NSDictionary *)versionDict{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newVertionFound:)
                                                 name:kNewVertionFound
                                               object:nil];
    [self performSelectorOnMainThread:@selector(checkVersion:) withObject:versionDict waitUntilDone:NO];
    
}

-(void)checkVersion:(NSDictionary *)versionDict{
    self.versionInfo = versionDict;
    NSString *serverVer = [versionDict objectForKey:@"BUILD"];
    CGFloat verFromServer = [serverVer floatValue];
    
    NSString *settingVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    CGFloat appVer = [settingVer integerValue];
    if (verFromServer > appVer) {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:kNewVertionFound object:nil];
    }
    
}


@end
