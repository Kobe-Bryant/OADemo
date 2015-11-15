//
//  XJZXViewController.m
//  NingBoOA
//
//  Created by ZHONGWEN on 13-12-6.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "XJZXViewController.h"
#import "JMTabView.h"
#import "XJZXFileInManagerController.h"
#import "XJZXFileOutManagerController.h"
#import "XJZXSignDocumentController.h"
#import "XJZXPMDocumentController.h"

@interface XJZXViewController ()<JMTabViewDelegate> 
@property(nonatomic,strong)NSMutableArray *aryVC;
@property(nonatomic,strong)UIView* curShowView;
@property(nonatomic,strong)JMTabView *tabBarView;
@end

@implementation XJZXViewController
@synthesize aryVC,curShowView,tabBarView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addStandardTabView;
{
    JMTabView * tabView = [[JMTabView alloc] initWithFrame:CGRectMake(0, 944, self.view.bounds.size.width,  60.)];
    
    [tabView setDelegate:self];
    
    [tabView addTabItemWithTitle:@"收文管理" icon:nil];
    [tabView addTabItemWithTitle:@"发文管理" icon:nil];
    [tabView addTabItemWithTitle:@"签报管理" icon:nil];
    [tabView addTabItemWithTitle:@"项目管理" icon:nil];

    [tabView setSelectedIndex:0];
    self.tabBarView = tabView;
    [self.view addSubview:tabView];
}



-(void)switchViewController:(NSInteger)index{
    if (index < [aryVC count]) {
        [curShowView removeFromSuperview];
        UIView *aView = [[aryVC objectAtIndex:index] view];
        aView.frame = CGRectMake(0,0,768,1004-60);
        [self.view insertSubview:aView atIndex:index];
        self.curShowView = aView;
       
    }
}

-(void)tabView:(JMTabView *)tabView didSelectTabAtIndex:(NSUInteger)itemIndex;
{
    [self switchViewController:itemIndex];
    
}

-(void)initDatas{
    self.aryVC = [NSMutableArray arrayWithCapacity:6];
    
    XJZXFileInManagerController *fileInViewController = [[XJZXFileInManagerController alloc] initWithNibName:@"XJZXFileInManagerController" bundle:nil];
    fileInViewController.delegate = self;
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:fileInViewController]; 
    [aryVC addObject:nav1];
    
    XJZXFileOutManagerController *fileOutViewController = [[XJZXFileOutManagerController alloc] initWithNibName:@"XJZXFileOutManagerController" bundle:nil];
    fileOutViewController.delegate = self;
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:fileOutViewController];
    
    [aryVC addObject:nav2];
    
    XJZXSignDocumentController *signDocViewController = [[XJZXSignDocumentController alloc] initWithNibName:@"XJZXSignDocumentController" bundle:nil];
    signDocViewController.delegate = self;
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:signDocViewController];
    
    [aryVC addObject:nav3];
    
    XJZXPMDocumentController *pmDocumentViewController = [[XJZXPMDocumentController alloc] initWithNibName:@"XJZXPMDocumentController" bundle:nil];
    pmDocumentViewController.delegate = self;
    
    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:pmDocumentViewController];
    [aryVC addObject:nav4];
    

    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initDatas];
    
   [self switchViewController:0];
    
     [self addStandardTabView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    tabBarView.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

#pragma mark - BackProtocol
- (void)backMainMenu:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//隐藏tabbar
-(void)changeToNextView{
    tabBarView.hidden = YES;
    curShowView.frame = CGRectMake(0,0,768,1004);
}

-(void)changeBackView{
    tabBarView.hidden = NO;
    curShowView.frame = CGRectMake(0,0,768,1004-60);
}

@end
