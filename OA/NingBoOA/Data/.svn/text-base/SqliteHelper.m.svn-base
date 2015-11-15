//
//  SqliteHelper.m
//  HBBXXPT
//
//  Created by 张仁松 on 13-6-21.
//  Copyright (c) 2013年 zhang. All rights reserved.
//

#import "SqliteHelper.h"
#import "SystemConfigContext.h"
#import "FMDatabaseAdditions.h"
@implementation SqliteHelper
@synthesize dbQueue;
//打开数据源

-(BOOL)openDataBase{
    if (isDbOpening)
        return YES;
    NSArray *documentsPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory
                                                                , NSUserDomainMask
                                                                , YES);
    NSString *dbName = [[SystemConfigContext sharedInstance] getString:@"DBName"];
    NSString *databaseFilePath=[[documentsPaths objectAtIndex:0] stringByAppendingPathComponent:dbName];
    
    self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:databaseFilePath];
    if (dbQueue == nil) {
        return NO;
    }
    
    isDbOpening = YES;
    //数据库表创建检测
    [self checkSystemTables];

    
    return YES;
}

//关闭数据源
-(void)closeDataBase{
    if (isDbOpening) {
        [dbQueue close];
    }
}

//数据库表创建检测
-(void)checkSystemTables{
    
    NSArray *sqlAry = [[SystemConfigContext sharedInstance] getResultItems:@"DbTables"];
    int counts = sqlAry.count;

    __block BOOL success = NO;
    for(int i = 0 ;i < counts;i++){
        NSString *sql = [sqlAry objectAtIndex:i];
        
        [dbQueue inDatabase:^(FMDatabase *db) {
            success = [db executeUpdate:sql];
            
        }];
        if (success == NO){
            NSLog(@"error###exec sql:%@",sql);
        }
        success = NO;
    }
}


-(NSString*)queryLastSyncTimeByTable:(NSString*)table{
    NSString *__block result = @"2000-01-01 10:00:00";//如果查找不到更新时间，就用这个时间
    if(isDbOpening == NO){
        [self openDataBase];
    }
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT ifnull(MAX(XGSJ),'') as LASTSYNC FROM  %@",table];
        
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            result = [rs stringForColumn:@"LASTSYNC"];
        }
        [rs close];
    }];
    
    
    if([result isEqualToString:@""])
        result = @"2000-01-01 10:00:00";
    return result;
}

-(void)insertTable:(NSString*)tableName andDatas:(NSArray*)aryItems{
    if(isDbOpening == NO){
        [self openDataBase];
    }
    if(aryItems == nil || [aryItems count] == 0 )
        return;
    NSMutableString *sqlstr = [NSMutableString stringWithCapacity:100];
    NSMutableString *fieldStr = [NSMutableString stringWithCapacity:50];
    NSMutableString *valueStr = [NSMutableString stringWithCapacity:50];
    FMDatabase *db = [dbQueue database];
    if(db == nil)return;
    for(NSDictionary *dic in aryItems){
        
        NSArray *aryKeys = [dic allKeys];
        //NSInteger *fieldCount = [aryKeys count];
        
        for(NSString *field in aryKeys){
            //查看是否有该列
            if([db columnExists:field inTableWithName:tableName]){
                [fieldStr appendFormat:@"%@,",field];
                [valueStr appendFormat:@"'%@',",[dic objectForKey:field]];
            }
            
        }
        if([fieldStr length] >0 && [valueStr length] >0){
            [sqlstr appendFormat:@"insert into %@(%@) values(%@)",tableName,[fieldStr substringToIndex:([fieldStr length]-1)],[valueStr substringToIndex:([valueStr length]-1)]];
            [dbQueue inDatabase:^(FMDatabase *db) {
                [db executeUpdate:sqlstr];
            }];
        }
        
        
        
        [fieldStr setString:@""];
        [valueStr setString:@""];
        [sqlstr setString:@""];
        
    }
    
    
}

//delete from t_admin_rms_zzjg where zzbh in (select ZZBH from  t_admin_rms_zzjg group by ZZBH) and rowid not in (select max(rowid) from  t_admin_rms_zzjg group by ZZBH)
-(void)deleteDupRecords:(NSString*)tableName byKeyColumn:(NSString*)column{
    if(isDbOpening == NO){
        [self openDataBase];
    }
    __block BOOL success = NO;
    
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where %@ in (select %@ from  %@ group by %@) and rowid not in (select max(rowid) from  %@ group by %@)",tableName,column,column,tableName,column,tableName,column];
    
    [dbQueue inDatabase:^(FMDatabase *db) {

        success = [db executeUpdate:sql];
        
    }];
    if (success == NO){
        NSLog(@"error###exec sql:%@",sql);
    }
    
}

-(BOOL)reStoreRecordsFromTable:(NSString*)fromName toTable:(NSString*)toName{
    if(isDbOpening == NO){
        [self openDataBase];
    }
    __block BOOL success = NO;
    
    NSString *sql01 = [NSString stringWithFormat:@"delete from %@", toName];
    NSString *sql02 = [NSString stringWithFormat:@"insert into %@ select * from %@", toName, fromName];
    NSString *sql03 = [NSString stringWithFormat:@"delete from %@", fromName];
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL ret01 = [db executeUpdate:sql01];//清空目标表
        BOOL ret02 = [db executeUpdate:sql02];//复制表
        BOOL ret03 = [db executeUpdate:sql03];//清空临时表
        success = ret01 & ret02 & ret03;
    }];
    return success;
}

- (BOOL)checkRecords:(NSString *)tableName
{
    if(isDbOpening == NO){
        [self openDataBase];
    }
    __block BOOL success = NO;
    
    NSString *sql = [NSString stringWithFormat:@"select * from %@", tableName];
    [dbQueue inDatabase:^(FMDatabase *db) {
        //FMResultSet *rs = [db executeQuery:sql];
        FMResultSet *rs =[db executeQuery:sql];
        success = rs.next;
        //[rs close];
    }];
    return success;
}

@end
