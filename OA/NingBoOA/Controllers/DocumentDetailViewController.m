//
//  DocumentDetailViewController.m
//  NingBoOA
//
//  Created by 熊熙 on 13-11-12.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "DocumentDetailViewController.h"
#import "DisplayAttachFileController.h"
#import "UICustomButton.h"
@interface DocumentDetailViewController ()

@end

@implementation DocumentDetailViewController

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
    self.title = @"公文附件";
    UIBarButtonItem *backItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"返回"];
    self.navigationItem.leftBarButtonItem = backItem;
    UIButton *backButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
    [backButton addTarget:self action:@selector(goBackAction:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Event Handle
- (void)goBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        NSArray *docArray = [self.attachDict objectForKey:@"doc"];
        return [docArray count];
    }
    else if (section == 2) {
        NSArray *tifArray = [self.attachDict objectForKey:@"tif"];
        return [tifArray count];
    }
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSArray *tifArray = [self.attachDict objectForKey:@"tif"];
    if ([tifArray count] < 1) {
        return 2;
    }
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectZero];
    headerView.font = [UIFont systemFontOfSize:17.0];
    headerView.backgroundColor = [UIColor colorWithRed:159.0/255 green:215.0/255 blue:230.0/255 alpha:1.0];
    headerView.textColor = [UIColor blackColor];
    
    if (section == 0)  headerView.text = @"  标    题";
    else if (section == 1)  headerView.text = @"  正文附件";
    else headerView.text = @"  其他附件";
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    static NSString *cellIdentifer = @"mycell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    
    if (section == 0) {
        cell.textLabel.text = [self.attachDict objectForKey:@"bt"];
    }
    else if(section == 1){
        NSArray *docAry = [self.attachDict objectForKey:@"doc"];
        NSDictionary *docDict= [docAry objectAtIndex:row];
        cell.textLabel.text = [docDict objectForKey:@"filename"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else {
        NSArray *tifAry = [self.attachDict objectForKey:@"tif"];
        NSDictionary *tifDict= [tifAry objectAtIndex:row];
        cell.textLabel.text = [tifDict objectForKey:@"filename"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark -
#pragma mark tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    NSString *filename = @"";
    NSString *fileurl  = @"";
    
    if (section == 0) {
        return;
    }
    if (section == 1) {
        NSArray *docAry = [self.attachDict objectForKey:@"doc"];
        NSDictionary *docDict= [docAry objectAtIndex:row];
        filename = [docDict objectForKey:@"filename"];
        fileurl  = [docDict objectForKey:@"fileurl"];
    }
    else if(section == 2) {
        NSArray *tifAry = [self.attachDict objectForKey:@"tif"];
        NSDictionary *tifDict= [tifAry objectAtIndex:row];
        filename = [tifDict objectForKey:@"filename"];
        fileurl  = [tifDict objectForKey:@"fileurl"];
    }
    
    DisplayAttachFileController *display = [[DisplayAttachFileController alloc] initWithNibName:@"DisplayAttachFileController" fileURL:fileurl andFileName:filename];
    [self.navigationController pushViewController:display animated:YES];

}

@end
