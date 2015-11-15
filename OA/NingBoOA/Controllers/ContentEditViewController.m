//
//  ContentEditViewController.m
//  NingBoOA
//
//  Created by 曾静 on 13-9-30.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "ContentEditViewController.h"
#import "NSStringUtil.h"
#import "BECheckBox.h"
#import "PDJsonkit.h"
#import "SystemConfigContext.h"
#import "ServiceUrlString.h"

@interface ContentEditViewController ()
@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UITextField *contentTextField;
@property (nonatomic, strong) UILabel *displayLabel;
@property (nonatomic, strong) UITextView *displayView;
@property (nonatomic, strong) UIView  *opinionView;
@property (nonatomic, strong) UITableView *displayTableView;
@property (nonatomic, strong) NSArray *displayDataArray;
@property (nonatomic, strong) NSMutableArray *selectedAry;//选中的数据
@property (nonatomic, strong) UIDatePicker *displayDatePicker;
@end

@implementation ContentEditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelClick:)];
    UIBarButtonItem *saveBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(saveClick:)];
    self.navigationItem.leftBarButtonItem = cancelBarButtonItem;
    self.navigationItem.rightBarButtonItem = saveBarButtonItem;
	
    if(self.editorTitle == nil)
    {
        self.title = @"";
    }
    else
    {
        self.title = self.editorTitle;
    }
    
    if(self.oldValue == nil)
    {
        self.oldValue = @"";
    }
    
    if(self.editorType == kEditor_Type_UITextView)
    {
        //UITextView只有一个输入框（适用于份数,）
        self.contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(70, 20, 400, 200)];
        [self.view addSubview:self.contentTextView];
        self.contentTextView.font = [UIFont systemFontOfSize:17];
        self.contentTextView.text = self.oldValue;
    }
    else if (self.editorType == kEditor_Type_UITextField)
    {
        //UITextField
        self.contentTextField = [[UITextField alloc] initWithFrame:CGRectMake(70, 20, 400, 30)];
        self.contentTextField.borderStyle = UITextBorderStyleRoundedRect;
        [self.view addSubview:self.contentTextField];
        self.contentTextField.text = self.oldValue;
    }
    
    else if(self.editorType == KEditor_Type_GWGZ) {
 
        //发文稿纸
        self.displayLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 20, 400, 44)];
        [self.view addSubview:self.displayLabel];
        self.displayLabel.numberOfLines = 0;
        self.displayLabel.textAlignment = UITextAlignmentCenter;
        self.displayLabel.text = self.oldValue;
        
        self.selectedAry = [[NSMutableArray alloc] init];
        [self.selectedAry addObject:self.oldValue];
        
        NSString *strUrl = [ServiceUrlString generateOAWebServiceUrl];
        NSString *params = nil;
        self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:self.serviceName nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
       
        
//        self.displayDataArray = @[@"宁波市环境保护局发文稿纸",@"宁波生态市建设工作领导小组办公室发文稿纸",@"宁波生态市建设工作领导小组发文稿纸",@"中共宁波市环境保护局党组",@"中共宁波市环境保护局直属机关委员会",@"宁波市环境污染整治工作领导小组文件",@"宁波市环境污染整治工作领导小组办公\345\256\244文件",@"宁波市环保模范单位创建活动指导委员会",@"宁波市环保模范单位创建活动指导委员会办公室",@"宁波市国家环境保护模范城市复查迎检工作领导小组文件",@"宁波市国家环境保护模范城市复查迎检工作领导小组办公室文件",@"宁波市环保专项行动领导小组办公室文件",@"宁波市规划环境影响评价工\344\275\234领导小组文件",@"宁波市规划环境影响评价工作领导小组办公室文件",@"宁波市第一次污染源普查工作领导小组办公室文件",@"宁波市节能减排工作领导\345\260\217组污染减排办公室文件",@"宁波市机动车排气污染防治工作领导小组",@"宁波市机动车排气污染防治工作领导小组办公室",@"宁波市加快建设生态文明协调推进小组办公室文件",@"宁波市机动车排气污染防治工作领导小组文件",@"宁波市机动车排气污染防治工作领导小组办公室文件",@"宁波市生态环境综合整\346\262\273工作领导小组办公室文件"];

        self.displayTableView = [[UITableView alloc] initWithFrame:CGRectMake(70, self.displayLabel.frame.origin.y+self.displayLabel.frame.size.height+4, 400, 500)];
        
        [self.view addSubview:self.displayTableView];
        self.displayTableView.dataSource = self;
        self.displayTableView.delegate = self;
        [self.webServiceHelper runAndShowWaitingView:self.view];
    }
    else if (self.editorType == kEditor_Type_Dept)
    {
        //主送单位 抄送单位
        self.displayLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 20, 400, 44)];
        [self.view addSubview:self.displayLabel];
        self.displayLabel.numberOfLines = 0;
        self.displayLabel.textAlignment = UITextAlignmentCenter;
        self.displayLabel.text = self.oldValue;
        
        self.selectedAry = [[NSMutableArray alloc] init];
        NSArray *units = [self.oldValue componentsSeparatedByString:@","];
        for (NSString *unit in units) {
            if ([unit isEqualToString:@""] && unit) {
                break;
            }
            [self.selectedAry addObject:unit];
        }
        
        //        self.displayDataArray = [[NSArray alloc] initWithObjects:@"国家环境保护部", @"浙江省环境保护厅", @"宁波市人民政府", @"各县（市）区环保局（分局）,各县（市）、区环保局（分局）,大榭开发区,东钱湖旅游度假区,宁波国家高新区、保税区、杭州湾新区环保局（分局）", @"余姚市环境保护局", @"慈溪市环境保护局", @"奉化市环境保护局", @"象山县环境保护局", @"宁海县环境保护局", @"大榭开发区环境保护局", @"鄞州区环境保护局,镇海区环境保护局", @"北仑区环境保护局", @"科技园区环境保护局", @"东钱湖旅游度假区环境保护局", @"宁波市环科院", @"宁波市监测中心站", @"宁波市环境监察支队", @"海曙环境保护分局", @"江东区环境保护分局", @"江北环境保护分局",nil];
        
        NSString *strUrl = [ServiceUrlString generateOAWebServiceUrl];
        NSString *params = nil;
        self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:self.serviceName nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
        
        self.displayTableView = [[UITableView alloc] initWithFrame:CGRectMake(70, self.displayLabel.frame.origin.y+self.displayLabel.frame.size.height+4, 400, 500)];
        [self.view addSubview:self.displayTableView];
        self.displayTableView.dataSource = self;
        self.displayTableView.delegate = self;
        [self.webServiceHelper runAndShowWaitingView:self.view];
    }
    else if (self.editorType == kEditor_Type_ZTC)
    {
        //主题词 （多选）
        self.displayLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 20, 400, 44)];
        [self.view addSubview:self.displayLabel];
        self.displayLabel.numberOfLines = 0;
        self.displayLabel.textAlignment = UITextAlignmentCenter;
        self.displayLabel.text = self.oldValue;
        
        self.selectedAry = [[NSMutableArray alloc] init];
        NSArray *topics = [self.oldValue componentsSeparatedByString:@","];
        for (NSString *topic in topics) {
            if ([topic isEqualToString:@""] && topic) {
                break;
            }
            [self.selectedAry addObject:topic];
        }
        
        NSString *strUrl = [ServiceUrlString generateOAWebServiceUrl];
        NSString *params = nil;
        self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:self.serviceName nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
        
//        self.displayDataArray = [[NSArray alloc] initWithObjects:@"环保", @"报告", @"通知", @"函", @"请示", @"污染", @"信访", @"批复", @"意见", @"复函", @"通报", @"生态", @"企业", nil];
        
        self.displayTableView = [[UITableView alloc] initWithFrame:CGRectMake(70, self.displayLabel.frame.origin.y+self.displayLabel.frame.size.height+4, 400, 500)];
        [self.view addSubview:self.displayTableView];
        self.displayTableView.dataSource = self;
        self.displayTableView.delegate = self;
        [self.webServiceHelper runAndShowWaitingView:self.view];
        
    }
    
    else if(self.editorType == kEditor_Type_FBWZ) {
        //发布网站
        self.displayLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 20, 400, 44)];
        [self.view addSubview:self.displayLabel];
        self.displayLabel.numberOfLines = 0;
        self.displayLabel.textAlignment = UITextAlignmentCenter;
        self.displayLabel.text = self.oldValue;
        
        self.selectedAry = [[NSMutableArray alloc] init];
        [self.selectedAry addObject:self.oldValue];
        
        NSString *strUrl = [ServiceUrlString generateOAWebServiceUrl];
        NSString *params = nil;
        self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:self.serviceName nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
        
        self.displayTableView = [[UITableView alloc] initWithFrame:CGRectMake(70, self.displayLabel.frame.origin.y+self.displayLabel.frame.size.height+4, 400, 500)];
        
        [self.view addSubview:self.displayTableView];
        self.displayTableView.dataSource = self;
        self.displayTableView.delegate = self;
        [self.webServiceHelper runAndShowWaitingView:self.view];

    }
    
    else if(self.editorType == kEditor_Type_SSQY) {
        //所属区域
        self.displayLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 20, 400, 44)];
        [self.view addSubview:self.displayLabel];
        self.displayLabel.numberOfLines = 0;
        self.displayLabel.textAlignment = UITextAlignmentCenter;
        self.displayLabel.text = self.oldValue;
        
        self.selectedAry = [[NSMutableArray alloc] init];
        [self.selectedAry addObject:self.oldValue];
        
        NSString *strUrl = [ServiceUrlString generateOAWebServiceUrl];
        NSString *params = nil;
        self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:self.serviceName nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
        
        self.displayTableView = [[UITableView alloc] initWithFrame:CGRectMake(70, self.displayLabel.frame.origin.y+self.displayLabel.frame.size.height+4, 400, 500)];
        
        [self.view addSubview:self.displayTableView];
        self.displayTableView.dataSource = self;
        self.displayTableView.delegate = self;
        [self.webServiceHelper runAndShowWaitingView:self.view];
        
    }

    else if(self.editorType == KEditor_Type_SRYJ) {
        //输入意见
        self.displayLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 20, 400, 44)];
        [self.view addSubview:self.displayLabel];
        self.displayLabel.numberOfLines = 0;
        self.displayLabel.textAlignment = UITextAlignmentCenter;
        self.displayLabel.text = self.oldValue;
        
        self.selectedAry = [[NSMutableArray alloc] init];
        if (![self.oldValue isEqualToString:@""] && self.oldValue) {
            [self.selectedAry addObject:self.oldValue];
        }
        
        self.opinionView = [[UIView alloc] initWithFrame:CGRectMake(70, self.displayLabel.frame.origin.y+self.displayLabel.frame.size.height+4, 400, 40)];
        
        CGRect rect1 = CGRectMake(70, 0, 130, 40);
        
        CGRect rect2 = CGRectMake(130+70, 0, 130, 40);
        
        BECheckBox *radioBox1=[[BECheckBox alloc]initWithFrame:rect1];
        radioBox1.tag = 1;
        radioBox1.isChecked = YES;
        [radioBox1 setTitle:@"通用常用意见" forState:UIControlStateNormal];
        radioBox1.titleLabel.font=[UIFont systemFontOfSize:17];
        [radioBox1 setImage:[UIImage imageNamed:@"radiobutton_checked.png"] forState:UIControlStateNormal];
        [radioBox1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [radioBox1 setTarget:self fun:@selector(checkBoxClicked:)];
        
        
        BECheckBox *radioBox2=[[BECheckBox alloc]initWithFrame:rect2];
        radioBox2.tag = 2;
        radioBox2.isChecked = YES;
        [radioBox2 setTitle:@"我的常用意见" forState:UIControlStateNormal];
        radioBox2.titleLabel.font=[UIFont systemFontOfSize:17];
        [radioBox2 setImage:[UIImage imageNamed:@"radiobutton_checked.png"] forState:UIControlStateNormal];
        [radioBox2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [radioBox2 setTarget:self fun:@selector(checkBoxClicked:)];
        
        NSDictionary *userInfo = [[SystemConfigContext sharedInstance] getUserInfo];
        NSString *userid = [userInfo objectForKey:@"userId"];
        
        
        NSString *strUrl = [ServiceUrlString generateOAWebServiceUrl];
        NSString *params = [WebServiceHelper createParametersWithKey:@"Hy_userid" value:userid,nil];
//        self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:@"returnCustomOpinionList" nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
        
        self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:self.serviceName nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
        
        
        //        self.commonAry = @[@"已阅。",@"同意。",@"拟同意，请徐局长审定。",@"不同意。",@"请局领导阅。",@"请局领导阅示。",@"办公室已核。",@"处室已核。",@"会议我参加"];
        //
        //        self.customAry = @[@"请局领导阅，请各处(室)、三分局、支队、固管中心、宣教中心、机排中心、监测中心、环科院阅。",@"请励局阅示，请组人处阅处。",@"请励局阅示，请生态处阅处。",@"请汪局阅示，请办公室阅处。",@"请汪局阅示，请支队阅处。",@"请吴书记阅示，请宣教中心阅处。",@"请方局阅示，请污防处阅处。",@"请方局阅示，请计财处阅处。",@"请胡局阅示，请审批（建管）处阅处。",@"请胡局阅示，请总量（科监）处阅处。",@"请虞总阅示，请固管中心阅处。",@"请虞总阅示，请机排中心阅处。",@"请林助理阅示，请辐射处阅处。",@"请林助理阅示，请法规处阅处。",@"请张书记阅示，请监察室阅处。"];
        
        
        [self.opinionView addSubview:radioBox1];
        [self.opinionView addSubview:radioBox2];
        [self.view addSubview:self.opinionView];
        
        
        
        self.displayTableView = [[UITableView alloc] initWithFrame:CGRectMake(70, self.displayLabel.frame.origin.y+self.displayLabel.frame.size.height+4+40, 400, 500)];
        [self.view addSubview:self.displayTableView];
        self.displayTableView.dataSource = self;
        self.displayTableView.delegate = self;
        [self.webServiceHelper run];
    }
}



- (void)cancelClick:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)saveClick:(id)sender
{
    
    if([self.delegate respondsToSelector:@selector(passWithNewValue:andWithRow:andWithIndex:andWithKey:)])
    {
        NSString *newValue;
        if(self.editorType == kEditor_Type_UITextView)
        {
            newValue = self.contentTextView.text;
        }
        else if(self.editorType == kEditor_Type_UITextField)
        {
            newValue = self.contentTextField.text;
        }
        
        [self.delegate passWithNewValue:newValue andWithRow:self.row andWithIndex:self.index andWithKey:self.key];
    }
    else {
        NSString *newValue = nil;
        NSString *type = nil;
        if (self.editorType == kEditor_Type_Dept || self.editorType == KEditor_Type_GWGZ || self.editorType == kEditor_Type_ZTC || self.editorType == kEditor_Type_FBWZ || self.editorType == kEditor_Type_SSQY) {
            newValue = self.displayLabel.text;
            type = @"UITextField";
        }
        
        if (self.editorType == KEditor_Type_SRYJ) {
            newValue = self.displayLabel.text;
            type = @"UITextView";
        }
        
        if ([self.delegate respondsToSelector:@selector(passWithNewValue:Type:)]) {
            [self.delegate passWithNewValue:newValue Type:type];
        }
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

- (CGFloat)getTextHeight:(NSString *)text
{
    UIFont *font = [UIFont systemFontOfSize:17.0];
    NSString *itemTitle =[NSString stringWithFormat:@"%@", text];
    CGFloat cellHeight = [NSStringUtil calculateTextHeight:itemTitle byFont:font andWidth:400];
    if(cellHeight <= 44)
        cellHeight = 44;
    return cellHeight;
}

- (void)checkBoxClicked:(BECheckBox *)sender {
    NSMutableArray *valueAry = [NSMutableArray arrayWithArray:self.displayDataArray];
    
    if (sender.tag == 1) {
        if (sender.isChecked) {
            [valueAry addObjectsFromArray:self.commonAry];
        }
        else {
            [valueAry removeObjectsInArray:self.commonAry];
        }
    }
    else {
        if (sender.isChecked) {
            [valueAry addObjectsFromArray:self.customAry];
        }
        else {
            [valueAry removeObjectsInArray:self.customAry];
        }
    }
    
    self.displayDataArray = valueAry;
    
    [self.displayTableView reloadData];
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
        if(self.editorType == KEditor_Type_GWGZ) {
            NSArray *listinfo = [tmpParsedJsonDict objectForKey:@"listinfo"];
            NSMutableArray *tempList = [NSMutableArray arrayWithCapacity:1];
            for(NSDictionary *paperType in listinfo) {
                NSString *name = [paperType objectForKey:@"paper"];
                [tempList addObject:name];
            }
            self.displayDataArray = tempList;
            [self.displayTableView reloadData];
        }
        else if(self.editorType == kEditor_Type_Dept) {
            NSArray *listinfo = [tmpParsedJsonDict objectForKey:@"listinfo"];
            NSMutableArray *tempList = [NSMutableArray arrayWithCapacity:1];
            for(NSDictionary *paperType in listinfo) {
                NSString *name = [paperType objectForKey:@"unit"];
                [tempList addObject:name];
            }
            self.displayDataArray = tempList;
            [self.displayTableView reloadData];
        }
        else if(self.editorType == kEditor_Type_ZTC) {
            NSArray *listinfo = [tmpParsedJsonDict objectForKey:@"listinfo"];
            NSMutableArray *tempList = [NSMutableArray arrayWithCapacity:1];
            for(NSDictionary *paperType in listinfo) {
                NSString *name = [paperType objectForKey:@"topic"];
                [tempList addObject:name];
            }
            self.displayDataArray = tempList;
            [self.displayTableView reloadData];
        }
        else if(self.editorType == kEditor_Type_FBWZ){
            NSArray *listinfo = [tmpParsedJsonDict objectForKey:@"listinfo"];
            NSMutableArray *tempList = [NSMutableArray arrayWithCapacity:1];
            for(NSDictionary *paperType in listinfo) {
                NSString *name = [paperType objectForKey:@"wz"];
                [tempList addObject:name];
            }
            self.displayDataArray = tempList;
            [self.displayTableView reloadData];
        }
        else if(self.editorType == kEditor_Type_SSQY){
            NSArray *listinfo = [tmpParsedJsonDict objectForKey:@"listinfo"];
            NSMutableArray *tempList = [NSMutableArray arrayWithCapacity:1];
            for(NSDictionary *paperType in listinfo) {
                NSString *name = [paperType objectForKey:@"qy"];
                [tempList addObject:name];
            }
            self.displayDataArray = tempList;
            [self.displayTableView reloadData];
        }

        else if(self.editorType == KEditor_Type_SRYJ) {
            NSArray *listinfo = [tmpParsedJsonDict objectForKey:@"listinfo"];
            NSMutableArray *tempList = [NSMutableArray arrayWithCapacity:1];
            for(NSDictionary *paperType in listinfo) {
                NSString *name = [paperType objectForKey:@"opinion"];
                [tempList addObject:name];
            }
            
            if ([self.serviceName isEqualToString:@"returnPersonOpinionList"]) {
                self.customAry = tempList;
                self.serviceName = @"returnCustomOpinionList";
                NSString *strUrl = [ServiceUrlString generateOAWebServiceUrl];
                NSString *params = nil;
                self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:strUrl method:@"returnCustomOpinionList" nameSpace:WEBSERVICE_NAMESPACE  parameters:params delegate:self];
                [self.webServiceHelper runAndShowWaitingView:self.view];
            }
            
            else if([self.serviceName isEqualToString:@"returnCustomOpinionList"]) {
                self.commonAry = tempList;
                self.displayDataArray = [self.commonAry arrayByAddingObjectsFromArray:self.customAry];
                [self.displayTableView reloadData];
                
            }

            
            
        }
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


#pragma mark -
#pragma mark UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.displayDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.0;
    NSString *value = [self.displayDataArray objectAtIndex:indexPath.row];
    
  
    height = [self getTextHeight:value];
    
        
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell_Item";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSString *value = [self.displayDataArray objectAtIndex:indexPath.row];
    
    if([self.selectedAry containsObject:value])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = value;
    return cell;
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *value = [self.displayDataArray objectAtIndex:indexPath.row];
    if(self.editorType == kEditor_Type_Dept || self.editorType == kEditor_Type_ZTC || self.editorType == KEditor_Type_SRYJ)
    {
        if([self.selectedAry containsObject:value])
        {
            [self.selectedAry removeObject:value];
        }
        else
        {
            [self.selectedAry addObject:value];
        }
    }
    
    
    else if(self.editorType == kEditor_Type_FBWZ || self.editorType == kEditor_Type_SSQY  || self.editorType == KEditor_Type_GWGZ )
    {
        if(![self.selectedAry containsObject:value])
        {
            [self.selectedAry removeAllObjects];
            [self.selectedAry addObject:value];
        }
    }
    
    
    NSMutableString *str = [[NSMutableString alloc] init];
    for(int i = 0; i < self.selectedAry.count; i++)
    {
        NSString *tt =  [self.selectedAry objectAtIndex:i];
        if (self.editorType == KEditor_Type_SRYJ  ) {
                [str appendString:tt];
        }
        else {
            if(i==0)
            {
                [str appendFormat:@"%@", tt];
            }
            else
            {
                [str appendFormat:@",%@", tt];
            }
        }
    }
    
    CGFloat height = 0.0;


    height = [self getTextHeight:str];
    if (self.editorType == KEditor_Type_SRYJ) {
        [UIView animateWithDuration:0.2 animations:^{
            
        self.displayLabel.frame = CGRectMake(self.displayLabel.frame.origin.x, self.displayLabel.frame.origin.y, 400, height);
            
        self.opinionView.frame = CGRectMake(70, self.displayLabel.frame.origin.y+4+height, 400, 40);
        self.displayTableView.frame = CGRectMake(70, self.displayLabel.frame.origin.y+4+40+height, 400, 500-(height - 44 -40));
        }];
    }
    
    else {
        [UIView animateWithDuration:0.2 animations:^{
        self.displayLabel.frame = CGRectMake(self.displayLabel.frame.origin.x, self.displayLabel.frame.origin.y, 400, height);
        
        self.displayTableView.frame = CGRectMake(self.displayTableView.frame.origin.x, self.displayLabel.frame.origin.y+4+height , 400, 500-(height-44));
        //self.displayLabel.frame.size.height+4+40
    }];
    }
    
    self.displayLabel.text = str;
    [self.displayTableView reloadData];
}

@end
