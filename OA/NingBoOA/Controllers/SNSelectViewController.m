//
//  ViewController.m
//  NingBoOA
//
//  Created by ZHONGWEN on 13-11-20.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "SNSelectViewController.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
@interface SNSelectViewController ()

@end

@implementation SNSelectViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissSNSelectView)];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(DoneSNSelect)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = doneButton;
    
    NSString *strUrl = [ServiceUrlString generateOAWebServiceUrl];
    NSString *params = nil;
    self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:self.serviceName nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
    [self.webServiceHelper run];
    
    self.SNPickerView = [[UIPickerView alloc] initWithFrame: CGRectMake(0, 0, 360, 216)];
    self.SNPickerView.dataSource = self;
    self.SNPickerView.delegate = self;
    self.SNPickerView.showsSelectionIndicator = YES;

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Event Handle
- (void)dismissSNSelectView {
    [self.delegate returnOfficeDocumnetSave:NO Type:@"" Year:@""Serial:@""];
}

- (void)DoneSNSelect{
    NSInteger  typeRow = [self.SNPickerView selectedRowInComponent:0];
    NSInteger yearRow = [self.SNPickerView selectedRowInComponent:1];
    NSString *year = [self.yearArray objectAtIndex:yearRow];
    NSString *type = [self.typeArray objectAtIndex:typeRow];
    
    [self.delegate returnOfficeDocumnetSave:YES Type:type Year:year Serial:self.serial];
}

#pragma mark -
#pragma mark UIPickerViewController DataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
     return [self.typeArray count];
         
    }
    else if(component == 1) {
        return [self.yearArray count];
    }
    
    return 1;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [self.typeArray objectAtIndex:row];
    }
    else if(component == 1) {
        return [self.yearArray objectAtIndex:row];
    }
    
    return self.serial;
}

//返回三列各列宽度
-(CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if(component==0)
    {
        return 200.0f;}
    else if(component==1)
    {
        return 80.0f;
        
    }
    else if(component ==2)
    {
        return 60.0f;
    }
    return 0.0f;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        NSInteger yearRow = [pickerView selectedRowInComponent:1];
        NSString *year = [self.yearArray objectAtIndex:yearRow];
        NSString *type = [self.typeArray objectAtIndex:row];
        for (NSDictionary *snDict in self.listArray) {
            
            NSString *typeStr = [snDict objectForKey:@"fwlb"];
            NSString *yearStr = [snDict objectForKey:@"year"];
            NSString *snStr  = [snDict objectForKey:@"serial"];
            
            if ([year isEqualToString:yearStr] && [type isEqualToString:typeStr]) {
                self.serial = snStr;
            }
        }
        
        
        [self.SNPickerView reloadComponent:1];
        [self.SNPickerView reloadComponent:2];
    }
    return;
}

#pragma mark - Handle Network Request

// -------------------------------------------------------------------------------
//	实现NSURLConnHelperDelegate委托方法
//  处理网络请求的NSData数据
// -------------------------------------------------------------------------------
- (void)processWebData:(NSData *)webData
{
    if([webData length] <=0)
    {
        [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
    }
    NSString *params = [NSString stringWithFormat:@"%@Return",self.serviceName];
    
    WebDataParserHelper *webDataHelper = [[WebDataParserHelper alloc] initWithFieldName:params andWithJSONDelegate:self];
    [webDataHelper parseXMLData:webData];
}

// -------------------------------------------------------------------------------
//	实现NSURLConnHelperDelegate委托方法
//  处理网络请求失败
// -------------------------------------------------------------------------------
- (void)processError:(NSError *)error
{
    [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
}

#pragma mark - Parser Network Data

// -------------------------------------------------------------------------------
//	实现WebDataParserDelegate委托方法
//  解析json字符串
// -------------------------------------------------------------------------------

- (void)parseJSONString:(NSString *)jsonStr 
{
    NSDictionary *tmpParsedJsonDict = [jsonStr objectFromJSONString];
    BOOL bParseError = NO;
    if (tmpParsedJsonDict && jsonStr.length > 0)
    {
        self.listArray = [tmpParsedJsonDict objectForKey:@"listinfo"];
        
        NSMutableArray *typeAry = [NSMutableArray array];
        NSMutableArray *yearAry = [NSMutableArray array];
        for (NSDictionary *snDict in self.listArray) {
            NSString *typeStr = [snDict objectForKey:@"fwlb"];
            NSString *yearStr = [snDict objectForKey:@"year"];
            
                if (![typeAry containsObject:typeStr]) {
                    [typeAry addObject:typeStr];
                }
                if (![yearAry containsObject:yearStr]) {
                    [yearAry addObject:yearStr];
                }
            }
        
         self.yearArray=[yearAry sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        
        
        self.typeArray = typeAry;
        
        [self.view addSubview:self.SNPickerView];
        //[self.SNPickerView reloadAllComponents];
        
        NSInteger typeRow = [typeAry count]/2;
        NSInteger yearRow = [yearAry count]/2;
    
        NSString *year = [self.yearArray objectAtIndex:yearRow];
        NSString *type = [self.typeArray objectAtIndex:typeRow];
        for (NSDictionary *snDict in self.listArray) {
            
            NSString *typeStr = [snDict objectForKey:@"fwlb"];
            NSString *yearStr = [snDict objectForKey:@"year"];
            NSString *snStr  = [snDict objectForKey:@"serial"];
            
            if ([year isEqualToString:yearStr] && [type isEqualToString:typeStr]) {
                self.serial = snStr;
            }
        }
        
        [self.SNPickerView selectRow:typeRow inComponent:0 animated:YES];
        [self.SNPickerView selectRow:yearRow inComponent:1 animated:YES];
    
    }
    else
    {
        bParseError = YES;
    }
    
    
    if (bParseError)
    {
        [self showAlertMessage:NETWORK_PARSE_ERROR_MESSAGE];
    }
}

// -------------------------------------------------------------------------------
//	实现WebDataParserDelegate委托方法
//  解析json字符串发生错误
// -------------------------------------------------------------------------------

- (void)parseWithError:(NSString *)errorString
{
    
    [self showAlertMessage:errorString];
}

@end
