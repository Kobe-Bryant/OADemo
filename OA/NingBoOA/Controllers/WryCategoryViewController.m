//
//  WryCategoryViewController.m
//  NingBoOA
//
//  Created by zengjing on 13-10-19.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "WryCategoryViewController.h"
#import "WryIntroduceViewController.h"
#import "WryPollutionsViewController.h"
#import "WryProductsViewController.h"
#import "WryMaterialViewController.h"
#import "WryGsxxDetailViewController.h"

@interface WryCategoryViewController ()

@end

@implementation WryCategoryViewController

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
    
    self.listDataArray = [[NSArray alloc] initWithObjects:@"企业概况", @"产品", @"原辅材料", @"污染物排放", @"工商数据", nil];
    
    self.listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 768, 960) style:UITableViewStyleGrouped];
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    [self.view addSubview:self.listTableView];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    cell.textLabel.text = [self.listDataArray objectAtIndex:indexPath.section];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        WryIntroduceViewController *detail = [[WryIntroduceViewController alloc] init];
        detail.wrybh = self.wrymc;
        [self.navigationController pushViewController:detail animated:YES];
    }
    else if(indexPath.section == 1)
    {
        WryProductsViewController *detail = [[WryProductsViewController alloc] init];
         detail.wrybh = self.wrymc;
         detail.wrymc = self.wrymc;
        [self.navigationController pushViewController:detail animated:YES];
    }
    else if(indexPath.section == 2)
    {
        //WryMaterialViewController *detail = [[WryMaterialViewController alloc] init];
        //[self.navigationController pushViewController:detail animated:YES];
    }
    else if(indexPath.section == 3)
    {
        //WryPollutionsViewController *detail = [[WryPollutionsViewController alloc] init];
        //[self.navigationController pushViewController:detail animated:YES];
    }
    else if(indexPath.section == 4)
    {
        WryGsxxDetailViewController *detail = [[WryGsxxDetailViewController alloc] init];
        detail.wrymc = self.wrymc;
        [self.navigationController pushViewController:detail animated:YES];
    }
}

@end
