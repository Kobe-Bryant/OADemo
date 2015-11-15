    //
//  SearchViewController.m
//  handbook
//
//  Created by chen on 11-4-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchDetaiViewController.h"

@implementation SearchViewController
@synthesize resultTableView;
@synthesize dataResultArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    data_db = [HBSCHelper openDataBase];
    tableColumn = [HBSCHelper getTableColumnData];

	self.title = @"模糊查询";
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"查询结果"; 
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 72;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end
