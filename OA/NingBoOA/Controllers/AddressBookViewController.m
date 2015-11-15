//
//  ScheduleViewController.m
//  NingBoOA
//
//  Created by PowerData on 13-10-18.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "AddressBookViewController.h"

@interface AddressBookViewController ()

@end

@implementation AddressBookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
   
    if (self) {
        self.title = @"通讯录";
        //self.urlString = @"http://10.33.2.14/nbhb/officelist.asp";
        self.urlString = @"http://10.33.2.14/Info_More.aspx?ClassID=6a577ab2-b2a4-45a3-a8bf-ba5ebb4c5390";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end