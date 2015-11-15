//
//  DangerChemicalsCategoryViewController.m
//  BoandaProject
//
//  Created by PowerData on 13-10-16.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "DangerChemicalsCategoryViewController.h"
#import "CategoryItemViewController.h"

@interface DangerChemicalsCategoryViewController ()

@end

@implementation DangerChemicalsCategoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"分类查询";
    
   
	NSArray *tmpData = [[NSArray alloc] initWithObjects:
						@"胺类",@"烃类",@"卤代烃类",@"芳烃类",@"酯类",@"醛和酮类",
						@"醇和醚类",@"酚及杂环类",@"硅烷、酰氯及肼类",@"腈及氰化物类",@"酸及酸酐类",@"氧化物及硫化物类",
						@"卤化物类",@"盐类",@"有机金属类",@"无机金属及非金属类",@"农药类",@"其它",nil];
	self.data = tmpData;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setListTableView:nil];
    [super viewDidUnload];
}

#pragma mark - UITableView DataSource & Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 18;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.font  = [UIFont systemFontOfSize:24];
    cell.textLabel.text = [self.data objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryItemViewController *detailViewController = [[CategoryItemViewController alloc] initWithNibName:@"CategoryItemViewController" bundle:nil];
	detailViewController.kindcode = [indexPath row] +1;
	detailViewController.title = [self.data objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

@end
