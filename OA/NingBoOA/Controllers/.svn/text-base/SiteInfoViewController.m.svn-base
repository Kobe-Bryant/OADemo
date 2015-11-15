//
//  SiteInfoViewController.m
//  NingBoOA
//
//  Created by PowerData on 14-3-12.
//  Copyright (c) 2014年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "SiteInfoViewController.h"
#import "SiteInfoViewCell.h"
#import "WebServiceHelper.h"
#import "UICustomButton.h"
#import "JSONKit.h"
#import "UITableViewCell+Custom.h"
#import <QuartzCore/QuartzCore.h>

@interface SiteInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSArray *titleArray1;
@property (nonatomic,strong) NSMutableArray *valueArray1;
@property (nonatomic,strong) NSArray *titleArray2;
@property (nonatomic,strong) NSMutableArray *valueArray2;

@end

@implementation SiteInfoViewController
@synthesize qyid,siteArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)goBackAction:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.webServiceHelper) {
        [self.webServiceHelper cancel];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *backItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"返回"];
    UIButton *backButton = (UIButton*)backItem.customView;
    [backButton addTarget:self action:@selector(goBackAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = backItem;
    
//    self.tableView.separatorColor = [UIColor clearColor];
    
    self.titleArray1 = [NSArray arrayWithObjects:@"站点名称",@"站点现状",@"运维单位",@"所属区域",@"所属行业",@"纳污区域", nil];
    self.titleArray2 = [NSArray arrayWithObjects:@"控制级别",@"经度",@"纬度",@"站点编码A",@"站点编码B",@"排放去向", nil];
    NSString *str = [WebServiceHelper createParametersWithKey:@"id" value:self.qyid,nil];
    self.webServiceHelper = [[WebServiceHelper alloc]initWithUrl:@"http://10.33.2.27/MobileLawService_OA/Services/TZxjkService.asmx" method:@"QueryZdxx" nameSpace:WEBSERVICE_NAMESPACE parameters:str delegate:self];
    [self.webServiceHelper runAndShowWaitingView:self.view withTipInfo:@"正在加载数据，请稍候..."];
    
    self.valueArray1 = [[NSMutableArray alloc]initWithCapacity:6];
    self.valueArray2 = [[NSMutableArray alloc]initWithCapacity:6];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.valueArray1.count;
    }
    else{
        return self.siteArray.count;   
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        SiteInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (cell == nil) {
            cell = [[SiteInfoViewCell alloc]init];
        }
        cell.titleLabel1.text = [self.titleArray1 objectAtIndex:indexPath.row];
        cell.titleLabel2.text = [self.titleArray2 objectAtIndex:indexPath.row];
        cell.valueLabel1.text = [NSString stringWithFormat:@"%@",[self.valueArray1 objectAtIndex:indexPath.row]];
        cell.valueLabel2.text = [NSString stringWithFormat:@"%@",[self.valueArray2 objectAtIndex:indexPath.row]];
        cell.valueLabel1.layer.borderColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0].CGColor;
        cell.valueLabel2.layer.borderColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0].CGColor;
        cell.titleLabel1.layer.borderColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0].CGColor;
        cell.titleLabel2.layer.borderColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0].CGColor;
        cell.valueLabel1.layer.borderWidth =1;
        cell.valueLabel2.layer.borderWidth =1;
        cell.titleLabel1.layer.borderWidth =1;
        cell.titleLabel2.layer.borderWidth =1;
        cell.titleLabel1.backgroundColor = [UIColor colorWithRed:214.f/255.f green:234.f/255.f blue:254.f/255.f alpha:1.0];
        cell.titleLabel2.backgroundColor = [UIColor colorWithRed:214.f/255.f green:234.f/255.f blue:254.f/255.f alpha:1.0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        NSDictionary *dataDic = [self.siteArray objectAtIndex:indexPath.row];
        NSString *value1 = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"MC"]];
        NSString *value2 = [NSString stringWithFormat:@"所在区域：%@",[dataDic objectForKey:@"SZQY"]];
        NSString *value3 = [NSString stringWithFormat:@"监管级别：%@",[dataDic objectForKey:@"GLJB"]];
        NSString *value4 = [NSString stringWithFormat:@"排口名称：%@",[dataDic objectForKey:@"PKMC"]];
        NSString *value5Str = [dataDic objectForKey:@"PSKLX"];
        if ([value5Str isEqual:[NSNull null]]) {
            value5Str = @"";
        }
        NSString *value5 = [NSString stringWithFormat:@"排口类型：%@",value5Str];
        NSString *value6 = [NSString stringWithFormat:@"污染物类型：%@",[dataDic objectForKey:@"LX"]];;
        UITableViewCell *cell = [UITableViewCell makeSubCell:tableView withTitle:value1 andSubvalue1:value4 andSubvalue2:value6 andSubvalue3:value2 andSubvalue4:value3 andSubvalue5:value5 andNoteCount:indexPath.row];
        return cell;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UILabel *tmpheaderView = [[UILabel alloc] initWithFrame:CGRectZero];
        tmpheaderView.font = [UIFont systemFontOfSize:17.0];
        tmpheaderView.backgroundColor = [UIColor colorWithRed:159.0/255 green:215.0/255 blue:230.0/255 alpha:1.0];
        tmpheaderView.textColor = [UIColor blackColor];
        tmpheaderView.text = @"    站点信息";
        return tmpheaderView;
    }
    else {
        UILabel *tmpheaderView = [[UILabel alloc] initWithFrame:CGRectZero];
        tmpheaderView.font = [UIFont systemFontOfSize:17.0];
        tmpheaderView.backgroundColor = [UIColor colorWithRed:159.0/255 green:215.0/255 blue:230.0/255 alpha:1.0];
        tmpheaderView.textColor = [UIColor blackColor];
        tmpheaderView.text = [NSString stringWithFormat:@"    排口数量:%d个", self.siteArray.count];
        return tmpheaderView;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}


#pragma mark - Net_requst

-(void)processWebData:(NSData *)webData{
    if ([webData length]<=0) {
        [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
    }
    NSDictionary *dic = [webData objectFromJSONData];
    [self.valueArray1 removeAllObjects];
    [self.valueArray2 removeAllObjects];
    if (dic &&dic.count) {
        NSString *ZDMC = [dic objectForKey:@"ZDMC"];
        if (![ZDMC isEqual:[NSNull null]]) {
            [self.valueArray1 addObject:ZDMC];
        }
        else{
            [self.valueArray1 addObject:@""];
        }
        NSString *ZDXZ = [dic objectForKey:@"ZDXZ"];
        if (![ZDXZ isEqual:[NSNull null]]) {
            [self.valueArray1 addObject:ZDXZ];
        }
        else{
            [self.valueArray1 addObject:@""];
        }
        NSString *YWDW = [dic objectForKey:@"YWDW"];
        if (![YWDW isEqual:[NSNull null]]) {
            [self.valueArray1 addObject:YWDW];
        }
        else{
            [self.valueArray1 addObject:@""];
        }
        NSString *SZQY = [dic objectForKey:@"SZQY"];
            if (![SZQY isEqual:[NSNull null]]) {
            [self.valueArray1 addObject:SZQY];
        }
        else{
            [self.valueArray1 addObject:@""];
        }
        NSString *HYLB = [dic objectForKey:@"HYLB"];
        if (![HYLB isEqual:[NSNull null]]) {
            [self.valueArray1 addObject:HYLB];
        }
        else{
            [self.valueArray1 addObject:@""];
        }
        NSString *NWQY = [dic objectForKey:@"NWQY"];
        if (![NWQY isEqual:[NSNull null]]) {
            [self.valueArray1 addObject:NWQY];
        }
        else{
            [self.valueArray1 addObject:@""];
        }
        NSString *GLJB = [dic objectForKey:@"GLJB"];
        if (![GLJB isEqual:[NSNull null]]) {
            [self.valueArray2 addObject:GLJB];
        }
        else{
            [self.valueArray2 addObject:@""];
        }NSString *JD = [dic objectForKey:@"JD"];
        if (![JD isEqual:[NSNull null]]) {
            [self.valueArray2 addObject:JD];
        }
        else{
            [self.valueArray2 addObject:@""];
        }NSString *WD = [dic objectForKey:@"WD"];
        if (![WD isEqual:[NSNull null]]) {
            [self.valueArray2 addObject:WD];
        }
        else{
            [self.valueArray2 addObject:@""];
        }NSString *ZDBMA = [dic objectForKey:@"ZDBMA"];
        if (![ZDBMA isEqual:[NSNull null]]) {
            [self.valueArray2 addObject:ZDBMA];
        }
        else{
            [self.valueArray2 addObject:@""];
        }NSString *ZDBMB = [dic objectForKey:@"ZDBMB"];
        if (![ZDBMB isEqual:[NSNull null]]) {
            [self.valueArray2 addObject:ZDBMB];
        }
        else{
            [self.valueArray2 addObject:@""];
        }NSString *PFQX = [dic objectForKey:@"PFQX"];
        if (![PFQX isEqual:[NSNull null]]) {
            [self.valueArray2 addObject:PFQX];
        }
        else{
            [self.valueArray2 addObject:@""];
        }
    }
    [self.tableView reloadData];
}

-(void)processError:(NSError *)error{
    [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
