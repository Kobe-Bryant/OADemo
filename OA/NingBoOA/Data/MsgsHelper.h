//
//  MsgsHelper.h
//  HBBXXPT
//
//  Created by 张仁松 on 13-6-21.
//  Copyright (c) 2013年 zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SqliteHelper.h"

@interface MsgsHelper : SqliteHelper
-(BOOL)saveOneMsg:(NSString*)msg LoginUser:(NSString*)aLoginUser TalkUser:(NSString*)aTalkUser sendTime:(NSString*)cjsj;
-(NSArray*)queryByLoginUser:(NSString*)aLoginUser TalkUser:(NSString*)aTalkUser;
-(NSArray*)queryByLoginUser:(NSString*)aLoginUser;
-(NSArray *)getMessageList;
-(NSArray *)queryMessageInfo:(NSString *)sender;
-(BOOL)deleteRecordMessageList:(NSString *)recipient;
-(BOOL)saveMessage:(NSString *)text recipient:(NSString*)userid sender:(NSString *)name;
@end
