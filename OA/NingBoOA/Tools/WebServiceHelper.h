//
//  YuQingViewController.h
//  GIS
//
//  Created by yushang on 10-10-17.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "NSURLConnHelperDelegate.h"

@interface WebServiceHelper : NSObject

@property(nonatomic, copy) NSString *url;
@property(nonatomic, copy) NSString *method;
@property(nonatomic, copy) NSString *nameSpace;
@property(nonatomic, copy) NSString *parameters;
@property(nonatomic ,strong) NSArray *queueArguments;
@property(nonatomic, assign) NSInteger tagID;
@property(nonatomic, strong) NSMutableData *webData;
@property(nonatomic, strong) NSXMLParser *xmlParser;
@property(nonatomic, strong) NSURLConnection *theConnection;
@property(nonatomic, strong) MBProgressHUD *HUD;
@property(nonatomic, weak) id<NSURLConnHelperDelegate> delegate;


+ (NSString*)createParametersWithParams:(NSDictionary *)values;

+ (NSString*)createParametersWithKey:(NSString*) aKey value:(NSString*) aValue, ...;
+ (NSString*)createParametersWithKeys:(NSArray *)keys andValues:(NSDictionary *)values;
+ (NSArray *)createQueueParametersWithKeys:(NSArray *)keys queueValues:(NSArray *)queueValues;

- (WebServiceHelper*)initWithUrl:(NSString*) aUrl
						  method:(NSString*) aMethod
					   nameSpace:(NSString*) aNameSpace 
					  parameters:(NSString*) aParameters 
						delegate:(id) aDelegate;

- (WebServiceHelper*)initWithUrl:(NSString *)aUrl 
                          method:(NSString *)aMethod 
                       nameSpace:(NSString *)aNameSpace 
                        delegate:(id)aDelegate;

- (WebServiceHelper*)initWithUrl:(NSString*) aUrl
						  method:(NSString*) aMethod
					   nameSpace:(NSString*) aNameSpace
                  queueArguments:(NSArray *) arguments
						delegate:(id<NSURLConnHelperDelegate>) aDelegate;


-(void)cancel;

- (void)run;
-(void)runOperationQueueWaittingView:(UIView *)showView withTip:(NSString *)tip;
- (void)runAndShowWaitingView:(UIView*)parentView;
- (void)runAndShowWaitingView:(UIView*)parentView withTipInfo:(NSString*)tip;
- (void)runAndShowWaitingView:(UIView*)parentView andTag:(NSInteger)tag;
//tip 提示界面上显示的文字
- (void)runAndShowWaitingView:(UIView*)parentView withTipInfo:(NSString*)tip  andTag:(NSInteger)tag;

@end
