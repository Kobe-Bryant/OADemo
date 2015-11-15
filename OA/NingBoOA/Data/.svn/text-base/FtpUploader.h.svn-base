//
//  FtpUploader.h
//  NingBoOA
//
//  Created by 张仁松 on 13-8-9.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FtpUploaderDelegate <NSObject>

-(void)sendFileFinished:(NSString*)errMsg;

@end
@interface FtpUploader : NSObject
-(void)sendFile:(NSString*)filePath withServerIp:(NSString*)ipAddr UserName:(NSString*)user Password:(NSString*)pwd delegate:(id<FtpUploaderDelegate>)del;
@end
