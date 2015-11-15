//
//  EditorViewController.m
//  NingBoOA
//
//  Created by Alex Jean on 13-8-12.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "EditorViewController.h"

@interface EditorViewController ()

@end

@implementation EditorViewController

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
    
    self.titleLabel.text = self.titleString;
    self.detailTextView.text = self.contentString;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setDetailTextView:nil];
    [self setTitleLabel:nil];
    [super viewDidUnload];
}

- (IBAction)saveButtonClick:(id)sender
{
    if(self.detailTextView.text.length == 0)
    {
        return;
    }
    [self.delegate passWithNewValue:self.detailTextView.text andSection:self.section andRow:self.row];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
