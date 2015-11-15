//
//  SystemConfigContext.h
//  HBBXXPT
//
//  Created by 张仁松 on 13-6-21.
//  Copyright (c) 2013年 zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemConfigContext : NSObject
{
    //当前用户信息
    NSMutableDictionary *userInfo;

}

+(SystemConfigContext *)sharedInstance;

//初始化偏好设置
- (void)initSettings;

//设置用户信息
- (void)setUser:(NSMutableDictionary *)userinfo;


//获得应用版本号
- (NSString*)getAppVersion;

//获得设备版本号
- (NSString*)getDeviceID;

//获得OA服务地址
- (NSString*)getOaAddress;

//获取配置信息的值
- (NSString *)getString:(NSString *)key;

//返回普通用户权限的功能配置
- (NSArray*)getCommonUserConfigs;

//返回监察支队权限的功能配置
- (NSArray*)getJCZDUserConfigs;

//返回宣教中心权限的功能配置
- (NSArray*)getXJZXConfigs;

//获取配置信息的多条
- (NSArray *)getResultItems:(NSString *)key;

//获取用户信息
- (NSMutableDictionary *)getUserInfo;

@end
