//
//  DangerChemicalsViewController.m
//  BoandaProject
//
//  Created by PowerData on 13-10-16.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "DangerChemicalsViewController.h"
#import "DangerChemicalsCategoryViewController.h"
#import "CnNameViewController.h"
#import "EnNameViewController.h"
#import "SearchViewController.h"
#import "UICustomButton.h"
@interface DangerChemicalsViewController ()

@end

@implementation DangerChemicalsViewController


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	if (orientation == UIInterfaceOrientationPortrait
		||orientation ==  UIInterfaceOrientationPortraitUpsideDown) {
		return YES;
	}
	NSTimeInterval animationDuration=0.30f;
	[UIView beginAnimations:@"ResizeForKeyboard" context:nil];
	[UIView setAnimationDuration:animationDuration];
	float width=self.view.frame.size.width;
	float height=self.view.frame.size.height;
	CGRect rect=CGRectMake(0.0f,-230,width,height);//上移，按实际情况设置
	self.view.frame=rect;
	[UIView commitAnimations];
	return YES;
}

- (IBAction)keyboardWillHide:(NSNotification *)note
{
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	if (orientation == UIInterfaceOrientationPortrait
		||orientation ==  UIInterfaceOrientationPortraitUpsideDown) {
		return ;
	}
	NSTimeInterval animationDuration=0.30f;
	[UIView beginAnimations:@"ResizeForKeyboard" context:nil];
	[UIView setAnimationDuration:animationDuration];
	float width=self.view.frame.size.width;
	float height=self.view.frame.size.height;
	CGRect rect=CGRectMake(0.0f,0.0f,width,height);
	self.view.frame=rect;
	[UIView commitAnimations];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //导航栏左边按钮
    UIBarButtonItem *backItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"返回"];
    self.navigationItem.leftBarButtonItem = backItem;
    UIButton *backButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
    [backButton addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    data_db = [HBSCHelper openDataBase];
    tableColumn = [HBSCHelper getTableColumnData];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide:)
												 name:UIKeyboardWillHideNotification
											   object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	[self.categoryBtn setAlpha:0.02];
	[self.cnBihuaBtn setAlpha:0.02];
	[self.enAlphaBtn setAlpha:0.02];
	[self.searchBtn setAlpha:0.02];
}

- (void)goBackAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)categoryClicked:(id)sender
{
	[self.categoryBtn setAlpha:0.5];
	[self.categoryBtn setBackgroundImage:[UIImage imageNamed:@"hightlight.png"] forState:UIControlStateNormal];
	DangerChemicalsCategoryViewController *controller = [[DangerChemicalsCategoryViewController alloc] initWithNibName:@"DangerChemicalsCategoryViewController" bundle:nil];
	[self.navigationController pushViewController:controller animated:YES];
}

-(IBAction)cnBihuaBtnClicked:(id)sender
{
	[self.cnBihuaBtn setAlpha:0.5];
	[self.cnBihuaBtn setBackgroundImage:[UIImage imageNamed:@"hightlight.png"] forState:UIControlStateNormal];
	CnNameViewController *controller = [[CnNameViewController alloc] initWithNibName:@"CnNameViewController" bundle:nil];
	[self.navigationController pushViewController:controller animated:YES];
}

-(IBAction)enAlphaBtnClicked:(id)sender
{
	[self.enAlphaBtn setAlpha:0.5];
	[self.enAlphaBtn setBackgroundImage:[UIImage imageNamed:@"hightlight.png"] forState:UIControlStateNormal];
	EnNameViewController *controller = [[EnNameViewController alloc] initWithNibName:@"EnNameViewController" bundle:nil];
	[self.navigationController pushViewController:controller animated:YES];
}

-(IBAction)searchBtnClicked:(id)sender
{
	if ([self.cnameText.text isEqualToString:@""] && [self.enameText.text isEqualToString:@""] &&[self.estatecodeText.text isEqualToString:@""] &&[self.cascodeText.text isEqualToString:@""])
    {
		NSString *msg = @"请输入搜索条件";
		[self showAlertMessage:msg];
	}
	NSMutableString *sqlStr = [NSMutableString stringWithString:@"select * from dangerchem where "];
	NSString *tmp;
	BOOL bHaveAdded = NO;
	if (![self.cnameText.text isEqualToString:@""])
    {
		tmp = [NSString stringWithFormat:@" CNAME like '%%%@%%'", self.cnameText.text];
		[sqlStr appendString:tmp];
		bHaveAdded = YES;
	}
	if (![self.enameText.text isEqualToString:@""])
    {
		if(bHaveAdded)
        {
			tmp = [NSString stringWithFormat:@" and ENAME like '%%%@%%'", self.enameText.text];
        }
		else
        {
			tmp = [NSString stringWithFormat:@" ENAME like '%%%@%%'", self.enameText.text];
		}
		[sqlStr appendString:tmp];
	}
	if (![self.estatecodeText.text isEqualToString:@""])
    {
		if(bHaveAdded)
        {
			tmp = [NSString stringWithFormat:@" and ESTATECODE like '%%%@%%'", self.estatecodeText.text];
        }
		else
        {
			tmp = [NSString stringWithFormat:@" ESTATECODE like '%%%@%%'", self.estatecodeText.text];
		}
		[sqlStr appendString:tmp];
	}
	
	if (![self.cascodeText.text isEqualToString:@""])
    {
		if(bHaveAdded)
        {
			tmp = [NSString stringWithFormat:@" and CASCODE like '%%%@%%'", self.cascodeText.text];
        }
		else
        {
			tmp = [NSString stringWithFormat:@" CASCODE like '%%%@%%'", self.cascodeText.text];
        }
		[sqlStr appendString:tmp];
	}
	
	SearchViewController *controller = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
	NSMutableArray *ary = [[NSMutableArray alloc] initWithCapacity:130];
	controller.dataResultArray = ary;
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
	const char *utfsql = [sqlStr cStringUsingEncoding:enc];
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(data_db, utfsql, -1, &statement, nil) == SQLITE_OK)
    {
		NSLog(@"select ok.");
	}
	
	NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithCapacity:20];
	int i =0;
	char *name;
	NSString *text;
    
	[controller.dataResultArray removeAllObjects];
	while (sqlite3_step(statement)==SQLITE_ROW) {
		
		for ( i= 0; i<6; i++) {
			name=(char *)sqlite3_column_text(statement,i );
			text = [NSString stringWithCString:name  encoding:enc];
            if (text == nil) text = @"";
            
			[dictionary setObject:text forKey:[tableColumn objectAtIndex:i]];
			
		}
		
		for ( i= 7; i<19; i++) {
			name=(char *)sqlite3_column_text(statement, i);
			text = [NSString stringWithCString:name  encoding:enc];
            if (text == nil) text = @"";
			[dictionary setObject:text forKey:[tableColumn objectAtIndex:i]];
		}
        
		[controller.dataResultArray addObject:[dictionary copy]];
	}
	
	sqlite3_finalize(statement);
	
	[self.searchBtn setAlpha:0.5];
	[self.searchBtn setBackgroundImage:[UIImage imageNamed:@"hightlight.png"] forState:UIControlStateNormal];
	
	[self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
