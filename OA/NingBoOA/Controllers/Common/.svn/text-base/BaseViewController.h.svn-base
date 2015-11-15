//
//  BaseViewController.h
//  BoandaProject
//
//  Created by 张仁松 on 13-7-2.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//  所以UIViewController的基类，默认是竖屏的

#import <UIKit/UIKit.h>
#import "WebServiceHelper.h"
#import "NSURLConnHelperDelegate.h"
#import "HandleGWProtocol.h"
@interface BaseViewController : UIViewController<NSURLConnHelperDelegate,HandleGWDelegate>

@property(nonatomic,strong) WebServiceHelper *webServiceHelper;

-(void)showAlertMessage:(NSString*)msg;

@end
