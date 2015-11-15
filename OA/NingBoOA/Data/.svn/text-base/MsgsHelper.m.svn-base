//
//  MsgsHelper.m
//  HBBXXPT
//
//  Created by 张仁松 on 13-6-21.
//  Copyright (c) 2013年 zhang. All rights reserved.
//

#import "MsgsHelper.h"

@implementation MsgsHelper

-(BOOL)saveOneMsg:(NSString*)msg LoginUser:(NSString*)aLoginUser TalkUser:(NSString*)aTalkUser sendTime:(NSString*)cjsj{
    [self openDataBase];
   
    
    __block BOOL success = NO;
     NSString *sql = [NSString stringWithFormat:@"insert into T_MSG_RECORD(LOGINUSER,TALKUSER,MSG,CJSJ) values(\'%@\',\'%@\',\'%@\',\'%@\')",aLoginUser,aTalkUser,msg,cjsj];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        success = [db executeUpdate:sql];
        
    }];
    if (success == NO){
        NSLog(@"error###exec sql:%@",sql);
    }
    return success;
}

-(BOOL)deleteRecordMessageList:(NSString *)recipient {
    if(isDbOpening == NO){
        [self openDataBase];
    }
    
    
    NSString *sqlstr = [NSString stringWithFormat:@"delete from SendMessageList where recipient = '%@' ",recipient];
    NSLog(@"sqlStr = %@",sqlstr);
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:sqlstr];
    }];
    
    return YES;
    
}

-(NSArray *)getMessageList{
    if (isDbOpening == NO) {
        [self openDataBase];
    }
    
    NSMutableArray *__block ary = [[NSMutableArray alloc] initWithCapacity:10];
    
    NSString *sql  = @"SELECT receiver,recipient,send_info,max(send_Date) as Lately FROM SendMessageList group by recipient";
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NSMutableDictionary *dicItem = [NSMutableDictionary dictionaryWithCapacity:10];
            
            [dicItem setObject:[rs stringForColumn:@"receiver"] forKey:@"receiver"];
            [dicItem setObject:[rs stringForColumn:@"recipient"] forKey:@"recipient"];
            [dicItem setObject:[rs stringForColumn:@"send_info"] forKey:@"send_info"];
            [dicItem setObject:[rs stringForColumn:@"lately"] forKey:@"lately"];
            [ary addObject:dicItem];
        }
    }];
    
    return ary;
    
}

-(NSArray *)queryMessageInfo:(NSString *)queryTxt{
    if (isDbOpening == NO) {
        [self openDataBase];
    }
    
    NSMutableArray *__block ary = [[NSMutableArray alloc] initWithCapacity:10];
    
    NSString *sql = [NSString stringWithFormat:@"select * from SendMessageList where recipient like \'%%%@%%\' or receiver like \'%%%@%%\' ", queryTxt,queryTxt];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NSMutableDictionary *dicItem = [NSMutableDictionary dictionaryWithCapacity:10];
            
            [dicItem setObject:[rs stringForColumn:@"receiver"] forKey:@"receiver"];
            [dicItem setObject:[rs stringForColumn:@"recipient"] forKey:@"recipient"];
            [dicItem setObject:[rs stringForColumn:@"send_info"] forKey:@"send_info"];
            [dicItem setObject:[rs stringForColumn:@"send_date"] forKey:@"send_date"];
            [ary addObject:dicItem];
        }
    }];
    
    return ary;
}

-(NSArray*)queryByLoginUser:(NSString*)aLoginUser TalkUser:(NSString*)aTalkUser{
    [self openDataBase];
    NSMutableArray *__block ary = [[NSMutableArray alloc] initWithCapacity:40];
    NSString *sql = [NSString stringWithFormat:@"select * from T_MSG_RECORD where LOGINUSER = \'%@\' and TALKUSER = \'%@\'",aLoginUser,aTalkUser];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            [ary addObject:[rs resultDictionary]];
        }
        [rs close];
    }];
    
    return ary;
}

- (NSArray *)queryByLoginUser:(NSString *)aLoginUser
{
    [self openDataBase];
    NSMutableArray *__block ary = [[NSMutableArray alloc] initWithCapacity:40];
    NSString *sql = [NSString stringWithFormat:@"select * from T_MSG_RECORD where LOGINUSER = \'%@\' or TALKUSER = \'%@\'",aLoginUser, aLoginUser];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            [ary addObject:[rs resultDictionary]];
        }
        [rs close];
    }];
    return ary;
}

-(BOOL)saveMessage:(NSString *)text recipient:(NSString*)userid sender:(NSString *)name {
    if ([userid length] <= 0  ) {
        return NO;
    }
    
    if (isDbOpening == NO) {
        [self openDataBase];
    }
    
    NSMutableString * query = [NSMutableString stringWithFormat:@"INSERT INTO   SendMessageList"];
    NSMutableString * keys = [NSMutableString stringWithFormat:@" ("];
    NSMutableString * values = [NSMutableString stringWithFormat:@" ( "];
    NSMutableArray * arguments = [NSMutableArray arrayWithCapacity:4];
    
    [keys appendString:@"receiver,"];
    [values appendString:@"?,"];
    [arguments addObject:name];
    
    [keys appendString:@"recipient,"];
    [values appendString:@"?,"];
    [arguments addObject:userid];
    
    [keys appendString:@"send_info,"];
    [values appendString:@"?,"];
    [arguments addObject:text];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *sendDate = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    
    [keys appendString:@"send_date,"];
    [values appendString:@"?,"];
    [arguments addObject:sendDate];
    
    [keys appendString:@")"];
    [values appendString:@")"];
    [query appendFormat:@" %@ VALUES%@",
    [keys stringByReplacingOccurrencesOfString:@",)" withString:@")"],
    [values stringByReplacingOccurrencesOfString:@",)" withString:@")"]];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:query withArgumentsInArray:arguments];
    }];
    
    return YES;
}

@end
