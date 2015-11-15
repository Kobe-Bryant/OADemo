//
//  SystemConfigContext.m
//  HBBXXPT
//
//  Created by 张仁松 on 13-6-21.
//  Copyright (c) 2013年 zhang. All rights reserved.
//

#import "SystemConfigContext.h"
#import "SettingsInfo.h"
#import "UIDevice+IdentifierAddition.h"
#import "sys/utsname.h"

@implementation SystemConfigContext
static NSMutableDictionary *config;
static SystemConfigContext *_sharedSingleton = nil;
+ (SystemConfigContext *) sharedInstance
{
    @synchronized(self)
    {
        if(_sharedSingleton == nil)
        {
            _sharedSingleton = [[SystemConfigContext alloc] init];
            
            NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
            config = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        }
    }
    
    return _sharedSingleton;
}

/**
 *  初始化偏好设置
 */
-(void)initSettings{
    [[SettingsInfo sharedInstance] loadPreferences];
}

/**
 *  设置用户信息
 *
 *  @param userinfo 
 */
-(void)setUser:(NSMutableDictionary *)userinfo{
    userInfo = userinfo;
}

/**
 *  获得应用版本号
 *
 *  @return 应用版本号字符串
 */
-(NSString*)getAppVersion{
    return [NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
}

/**
 *  获得设备版本号
 *
 *  @return 设备版本号字符串
 */
- (NSString*)deviceString
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3 (CDMA)";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    NSLog(@"NOTE: Unknown device type: %@", deviceString);
    return deviceString;
}

/**
 *  获得OA服务地址
 *
 *  @return OA服务URL字符串
 */
-(NSString*)getOaAddress{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *oa_ip = [userDefaults stringForKey:@"OA_IP"];
    return oa_ip;
}

/**
 *  获取设备的id
 *
 *  @return 设备的id字符串
 */
-(NSString*)getDeviceID{
    NSString *udid=nil;
    NSString *platform =  [self deviceString];
    if ([platform isEqualToString:@"Simulator"]) {
        udid = @"powerdatamobileios";
    }
    else {
        UIDevice *device =  [UIDevice currentDevice];
        udid = [device macaddress];
    }
    return udid;
}

/**
 *  返回普通用户权限的功能配置
 *
 *  @return 功能配置数组
 */
-(NSArray*)getCommonUserConfigs{
    return [config objectForKey:@"CommonUser"];
}

/**
 *  返回监察支队权限的功能配置
 *
 *  @return 功能配置数组
 */
-(NSArray*)getJCZDUserConfigs{
    return [config objectForKey:@"JCZDUser"];
}

/**
 *  返回宣教中心权限的功能配置
 *
 *  @return 功能配置数组
 */
-(NSArray*)getXJZXConfigs{
    return [config objectForKey:@"XJZXUser"];
}

/**
 *  获取用户信息
 *
 *  @return 用户信息字典
 */
-(NSDictionary *)getUserInfo{
    return userInfo;
}

/**
 *  获取配置信息的值
 *
 *  @param key
 *
 *  @return 
 */
-(NSString *)getString:(NSString *)key{
    return [config objectForKey:key];
}

/**
 *  //获取配置信息的多条
 *
 *  @param key
 *
 *  @return 
 */
-(NSArray *)getResultItems:(NSString *)key{
    return [config objectForKey:key];
}

@end
