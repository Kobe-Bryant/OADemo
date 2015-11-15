//
//  ServiceUrlString.m
//  HNYDZF
//
//  Created by 张 仁松 on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ServiceUrlString.h"
#import "SystemConfigContext.h"
#import "OperateLogHelper.h"

@implementation ServiceUrlString

#pragma mark -
#pragma mark generate webservice url

/**
 *  按照参数生成URL地址
 *
 *  @param params 参数字典
 *
 *  @return 服务地址的URL字符串
 */
+ (NSString *)generateUrlByParameters:(NSDictionary*)params
{
    if(params == nil)return @"";
    NSArray *aryKeys = [params allKeys];
    if(aryKeys == nil)return @"";
    
    NSMutableString *paramsStr = [NSMutableString stringWithCapacity:100];
    for(NSString *str in aryKeys){
        [paramsStr appendFormat:@"&%@=%@",str,[params objectForKey:str]];
    }
    
    SystemConfigContext *context = [SystemConfigContext sharedInstance];
    NSDictionary *loginUsr = [context getUserInfo];
    NSString *strUrl = [NSString stringWithFormat:@"http://%@/invoke?version=%@&imei=%@&clientType=IPAD&userid=%@&password=%@%@",[context getOaAddress], [context getAppVersion], [context getDeviceID],[loginUsr objectForKey:@"userId"],[loginUsr objectForKey:@"password"], paramsStr];
    
    NSString *modifiedUrl = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)strUrl, nil, nil,kCFStringEncodingUTF8));
    
    
    OperateLogHelper *helper = [[OperateLogHelper alloc] init];
    
    [helper saveOperate:[params objectForKey:@"service"] andUserID:[loginUsr objectForKey:@"userId"]];
    
    return modifiedUrl;
}

/**
 *  生成OA服务的URL地址
 *
 *  @return 服务地址的URL字符串
 */
+ (NSString *)generateOAWebServiceUrl
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *oa_ip = [defaults stringForKey:@"OA_IP"];
    BOOL enabled = [defaults boolForKey:@"enabled_debug"];
    if (enabled) {
        oa_ip = @"http://60.190.57.228";
    }
    NSString *oa_webservice = [NSString stringWithFormat:@"%@/WebserviceByApp.nsf/UserInfor?WSDL",oa_ip];
    NSString *modifiedUrl = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)oa_webservice, nil, nil,kCFStringEncodingUTF8));
    return modifiedUrl;
}

/**
 *  生成移移动执法与污染源查询的URL
 *
 *  @param serviceName webservice服务名称
 *
 *  @return 服务地址的URL字符串
 */
+ (NSString *)generateMobileLawServiceUrl:(NSString *)serviceName
{
    //NSString *strUrl = [NSString stringWithFormat:@"http://218.108.6.118/MobileLawService_OA/Services/%@", serviceName];
    NSString *strUrl = [NSString stringWithFormat:Inquiry_WebService,serviceName];
    NSString *modifiedUrl = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)strUrl, nil, nil,kCFStringEncodingUTF8));
    return modifiedUrl;
}

/**
 *  生成内网门户信息浏览浏览服务的URL
 *
 *  @param serviceName webservice服务名称
 *
 *  @return 服务地址的URL字符串
 */
+ (NSString *)generateNewsWebServiceUrl
{
    //SystemConfigContext *context = [SystemConfigContext sharedInstance];
    //NSString *strUrl = [NSString stringWithFormat:@"http://%@/WebserviceByApp.nsf/UserInfor",[context getSeviceHeader]];
    //NSString *strUrl = @"http://60.12.19.228/WebserviceByApp.nsf/UserInfor";
    NSString *modifiedUrl = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)News_WebService, nil, nil,kCFStringEncodingUTF8));
    return modifiedUrl;
}

/**
 *  生成附件上传服务的URL
 *
 *  @return 服务地址的URL字符串
 */
+ (NSString *)generateUploadAttachUrl{
    NSString *modifiedUrl = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)UploadAttach_WebService, nil, nil,kCFStringEncodingUTF8));
    return modifiedUrl;
}

+ (NSString *)generateFileUrl:(NSString *)path
{
    SystemConfigContext *context = [SystemConfigContext sharedInstance];
    NSString *strUrl = [NSString stringWithFormat:@"http://%@%@",[context getOaAddress],path];
    NSString *modifiedUrl = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)strUrl, nil, nil,kCFStringEncodingUTF8));
    return modifiedUrl;
}

@end
