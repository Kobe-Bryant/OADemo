//
//  CookieContext.m
//  NingBoOA
//
//  Created by 张仁松 on 13-9-16.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "CookieContext.h"
#import "ASIHTTPRequest.h"
#import "SystemConfigContext.h"
@implementation CookieContext

static CookieContext *_sharedSingleton = nil;
+ (CookieContext *) sharedInstance
{
    @synchronized(self)
    {
        if(_sharedSingleton == nil)
        {
            _sharedSingleton = [[CookieContext alloc] init];
            
          
        }
    }
    
    return _sharedSingleton;
}

-(void)requestCookies{
  //  if(haveRequested)
 //       return;
    
    SystemConfigContext *context = [SystemConfigContext sharedInstance];
    NSDictionary *loginUsr = [context getUserInfo];
    
    NSString *oa_ip = [context getOaAddress];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@/index.nsf?login&username=%@&password=%@",oa_ip,[loginUsr objectForKey:@"userId"],[loginUsr objectForKey:@"password"]];
    ASIHTTPRequest *request1 = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:strUrl] ];
    
    [request1 startSynchronous];
    haveRequested = YES;
}

@end
