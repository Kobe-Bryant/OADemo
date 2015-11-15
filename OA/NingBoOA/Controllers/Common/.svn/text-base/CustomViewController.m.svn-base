//
//  CustomViewController.m
//  GuangXiOA
//
//  Created by zhang on 12-10-31.
//
//

#import "CustomViewController.h"
#import "UICustomButton.h"

@interface CustomViewController ()

@end

@implementation CustomViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)goBackAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"返回"];
    UIButton* leftButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
    [leftButton addTarget:self action:@selector(goBackAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
