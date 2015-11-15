//
//  CnNameItemController.m
//  handbook
//
//  Created by chen on 11-4-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CnNameItemController.h"
#import "SearchDetaiViewController.h"

@implementation CnNameItemController

@synthesize dataResultArray;
@synthesize fontcode;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];

    data_db = [HBSCHelper openDataBase];
    tableColumn = [HBSCHelper getTableColumnData];
    
    NSMutableArray *ary = [[NSMutableArray alloc] initWithCapacity:130];	
	self.dataResultArray = ary;
	
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
	NSString *sqlStr = [NSString stringWithFormat:@"select * from dangerchem where fontcode = %d",fontcode];
	const char *utfsql = [sqlStr cStringUsingEncoding:enc];
	
	sqlite3_stmt *statement; 
	if (sqlite3_prepare_v2(data_db, utfsql, -1, &statement, nil)==SQLITE_OK)
    {
		NSLog(@"select ok."); 
	}
	
	NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithCapacity:20];
	
	int i =0;
	char *name;
	NSString *text;
	[dataResultArray removeAllObjects];
	while (sqlite3_step(statement)==SQLITE_ROW)
    {
		for ( i= 0; i<6; i++)
        {
			name=(char *)sqlite3_column_text(statement,i ); 		  
			text = [NSString stringWithCString:name  encoding:enc];
			[dictionary setObject:text forKey:[tableColumn objectAtIndex:i]];
		}
		for ( i= 7; i<19; i++)
        {
			name=(char *)sqlite3_column_text(statement, i); 		  
			text = [NSString stringWithCString:name  encoding:enc];
			[dictionary setObject:text forKey:[tableColumn objectAtIndex:i]];
		}
		[dataResultArray addObject:[dictionary copy]];
	}
	sqlite3_finalize(statement);
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [dataResultArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 72;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	NSDictionary *dic =[dataResultArray objectAtIndex:[indexPath row]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)",
						   [dic objectForKey:[tableColumn objectAtIndex:3]],
						   [dic objectForKey:[tableColumn objectAtIndex:4]]];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"  国标编号%@ cas编号%@ 危险标记：%@ ",
								 [dic objectForKey:[tableColumn objectAtIndex:1]],
								 [dic objectForKey:[tableColumn objectAtIndex:2]],
								 [dic objectForKey:[tableColumn objectAtIndex:11]]];
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    SearchDetaiViewController *detailViewController = [[SearchDetaiViewController alloc] initWithNibName:@"SearchDetaiViewController" bundle:nil];
	detailViewController.titleDic = [dataResultArray objectAtIndex:[indexPath row]];
	// Pass the selected object to the new view controller.
	[self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
