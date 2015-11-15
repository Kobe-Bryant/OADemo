//
//  MainMenuViewController.m
//  BoandaProject
//
//  Created by 张仁松 on 13-7-2.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "MainMenuViewController.h"
#import "SystemConfigContext.h"
#import "MenuPageView.h"
#import "MenuControl.h"
#import "PDJsonkit.h"

#import "NSExceptionSender.h"
#import "DataSyncManager.h"
#import "ServiceUrlString.h"
#import "LocationManager.h"

@interface MainMenuViewController ()
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIPageControl *pageControl;
@property(nonatomic,strong)NSExceptionSender *exceptionSender;
@property(nonatomic,strong)DataSyncManager *syncManager;
@property(nonatomic,strong)NSMutableArray *pageViewAry;
@property(nonatomic,strong)NSURLConnHelper *webHelper;
@end

@implementation MainMenuViewController
@synthesize scrollView,pageControl,exceptionSender,dicBadgeInfo,syncManager,pageViewAry,webHelper;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
        [notification addObserver:self selector:@selector(showBageIcons) name:@"updateBdages" object:nil];
    }
    return self;
}

-(void)toggleMenuControl:(id)sender
{
    MenuControl *ctrl  = (MenuControl*)sender;
    NSDictionary *menuItemInfo = ctrl.menuInfo;
    NSString *classStr = [menuItemInfo objectForKey:@"ViewController"];
    if([classStr length] > 0)
    {
        NSString *nibName = [menuItemInfo objectForKey:@"NibName"];
        UIViewController *controller = nil;
        if([nibName length] > 0)
        {
            controller = (UIViewController*)[[NSClassFromString(classStr) alloc] initWithNibName:nibName bundle:nil];
        }
        else
        {
            controller = (UIViewController*)[[NSClassFromString(classStr) alloc] init];
        }
        if(controller)
        {
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

- (void)logout:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addUIViews
{
    UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menuBg.png"]];
    [self.view addSubview:bgImgView];
    
    NSDictionary *loginUsr = [[SystemConfigContext sharedInstance] getUserInfo];
    NSString *name = [loginUsr objectForKey:@"name"];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 14, 156, 21)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.text = [NSString stringWithFormat:@"当前用户：%@",name];

    [self.view addSubview:nameLabel];
    
    UIButton *logOutButton = [[UIButton alloc] initWithFrame:CGRectMake(568, 0, 210, 80)];
    [logOutButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [logOutButton addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logOutButton];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, 768, 850)];
    scrollView.delegate = self;
	
	[self.scrollView setBackgroundColor:[UIColor blackColor]];
	[scrollView setCanCancelContentTouches:NO];
	scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
	scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	scrollView.clipsToBounds = YES;
	scrollView.scrollEnabled = YES;
	scrollView.pagingEnabled = YES;
	scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(284, 935, 200, 36)];
    [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pageControl];
    
    //判断当前用户的部门，加载不同的配置文件
    NSDictionary *userInfo = [[SystemConfigContext sharedInstance] getUserInfo];
    NSString *department = [userInfo objectForKey:@"department"];
     NSArray *menuConfigs = [[SystemConfigContext sharedInstance] getCommonUserConfigs];
    if ([department isEqualToString:@"监察支队"]) {
       menuConfigs = [[SystemConfigContext sharedInstance] getJCZDUserConfigs];
    }
    else if([department isEqualToString:@"宣教信息中心"]){
         menuConfigs = [[SystemConfigContext sharedInstance] getXJZXConfigs];
    }

    int menuIndex = 0;
    self.pageViewAry = [NSMutableArray arrayWithCapacity:5];
    for(NSDictionary *menuPage in menuConfigs){
        MenuPageView *pageView = [[MenuPageView alloc] initWithFrame:CGRectMake(menuIndex*768, 0, 768, 850) andMenuPageInfo:menuPage andTarget:self andAction:@selector(toggleMenuControl:)];
        
        [scrollView addSubview:pageView];
        [pageViewAry addObject:pageView];
        menuIndex++;
    }
    if(menuIndex <=1)pageControl.hidden = YES;
    self.pageControl.numberOfPages = menuIndex;
	[scrollView setContentSize:CGSizeMake(menuIndex*768, 850)];
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 962, 156, 21)];
    versionLabel.backgroundColor = [UIColor clearColor];
    versionLabel.textColor = [UIColor whiteColor];
    

    
    versionLabel.text = [NSString stringWithFormat:@"当前版本：%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [self.view addSubview:versionLabel];
}

-(void)showBageIcons{
    
    NSUserDefaults *preference = [NSUserDefaults standardUserDefaults];
    NSString *todo = [preference objectForKey:@"todo"];
    NSString *inbox = [preference objectForKey:@"unread"];

    for(MenuPageView *aPageView in pageViewAry){
        NSArray *allChildViews = [aPageView subviews];
        for(UIView *aView in allChildViews){
            
            if([aView isKindOfClass:[MenuControl class]]){
                MenuControl* ctrl =  (MenuControl*)aView;
                NSDictionary *menuInfo = [ctrl menuInfo];
                NSString *title = [menuInfo objectForKey:@"MenuTitle"];
                if([title isEqualToString:@"待办事宜"]){
                    
                    [ctrl showIconBadge:todo];
                }
                if([title isEqualToString:@"内部邮件"]){
                    [ctrl showIconBadge:inbox];
                }
            }
        }
    }

}

-(void)requestSysDatas{
    
    //发送错误报告
    self.exceptionSender = [[NSExceptionSender alloc] init];
    [exceptionSender sendExceptions];
    
    //显示待办个数
    [self showBageIcons];
    /*
    self.syncManager = [[DataSyncManager alloc] init];
    [syncManager syncAllTables:NO];*/
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self addUIViews];
    [self requestSysDatas];
    
    //LocationManager *lm = [[LocationManager alloc] init];
    //[lm scheduledLocationWithTimeInterval:1];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [webHelper cancel];
}

//更新button上的数字
-(void)updateBadges{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"QUERY_INDEX" forKey:@"service"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:nil delegate:self];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //[self updateBadges];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UIScrollViewDelegate stuff
- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    if (pageControlIsChangingPage) {
        return;
    }
	
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView
{
    pageControlIsChangingPage = NO;
}

#pragma mark - PageControl stuff

- (void)changePage:(id)sender
{
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * pageControl.currentPage;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    pageControlIsChangingPage = YES;
}

-(void)processWebData:(NSData*)webData
{
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];

    NSArray *jsonAry = [resultJSON objectFromJSONString];
    if (jsonAry && [jsonAry count] > 0)
    {
        NSDictionary *dicInfo = [jsonAry objectAtIndex:0];
        int status = [[dicInfo objectForKey:@"status"] intValue];
        if (status == 1) {
            NSArray *aryDatas = [dicInfo objectForKey:@"datas"];
            
            NSMutableDictionary *dicTmpBadgeInfo = [NSMutableDictionary dictionaryWithCapacity:5];
            [dicTmpBadgeInfo setObject:@"55" forKey:@"待办公文"];
            if([aryDatas count] > 0){
                for(NSDictionary *dicItem in aryDatas){
                    NSString *lx = [dicItem objectForKey:@"LX"];
                    NSString *num = [NSString stringWithFormat:@"%@",[dicItem objectForKey:@"NUM"]];
                    if([lx isEqualToString:@"LW"]){
                        
                        [dicTmpBadgeInfo setObject:num forKey:@"来文"];
                    }
                    else if([lx isEqualToString:@"FW"]){
                        [dicTmpBadgeInfo setObject:num forKey:@"发文"];
                    }
                    else if([lx isEqualToString:@"NBYJ"]){
                        [dicTmpBadgeInfo setObject:num forKey:@"移动邮箱"];
                    }
                    else if([lx isEqualToString:@"TZGG"]){
                        [dicTmpBadgeInfo setObject:num forKey:@"通知"];
                    }else if([lx isEqualToString:@"WLWZ"]){
                        [dicTmpBadgeInfo setObject:num forKey:@"网络问政"];
                    }
                    else if([lx isEqualToString:@"WBFW"]){
                        [dicTmpBadgeInfo setObject:num forKey:@"微博发文"];
                    }
                    else if([lx isEqualToString:@"RWDB"]){
                        [dicTmpBadgeInfo setObject:num forKey:@"任务督办"];
                    }
                }
            }
            //待办公文 = 来文+发文
            NSString *lw = [dicBadgeInfo objectForKey:@"来文"];
            NSString *fw = [dicBadgeInfo objectForKey:@"发文"];
            NSInteger all = 0;
            if([lw length] > 0)all += [lw integerValue];
            if([fw length] > 0)all += [fw integerValue];
            [dicTmpBadgeInfo setObject:[NSString stringWithFormat:@"%d",all] forKey:@"待办公文"];
            self.dicBadgeInfo = dicTmpBadgeInfo;
            [self showBageIcons];
        }
    }
}

-(void)processError:(NSError *)error{
}

@end
