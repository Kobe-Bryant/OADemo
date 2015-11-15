//
//  HBSCHelper.m
//  BoandaProject
//
//  Created by PowerData on 13-10-16.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "HBSCHelper.h"

@implementation HBSCHelper

static sqlite3 *data_db;

+ (sqlite3 *)openDataBase
{
    NSString *dataDbPath = [[NSBundle mainBundle] pathForResource:HBSC_DB_NAME ofType:@"db"];
	if (sqlite3_open([dataDbPath UTF8String], &data_db)!=SQLITE_OK)
    {
		NSLog(@"open datadb sqlite db error.");
	}
    return data_db;
}

+ (NSArray *)getTableColumnData
{
    NSArray *tableColumn = [[NSArray alloc]initWithObjects:@"ITEMCODE",
				   @"ESTATECODE",@"CASCODE",@"CNAME",
				   @"ENAME",@"ITEMALIAS",@"KINDCODE",
				   @"MOLECULE",@"MOLECULEW",@"FUSIBILITY",
				   @"DENSITY",@"CRITICALITY",@"BOIL",
				   @"FLASHP",@"ASPECT",@"STEAM",
				   @"DISSOLVE",@"STABILITY",@"OPERATION",
				   @"PRIORITY",@"RATING",@"SPELLCODE",
				   @"FONTCODE",nil];
    return tableColumn;
}

@end
