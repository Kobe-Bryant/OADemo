//
//  UISelectSubjectVC.m
//  NingBoOA
//
//  Created by PowerData on 14-4-1.
//  Copyright (c) 2014年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "UISelectSubjectVC.h"
#import "WebServiceHelper.h"
#import "WebDataParserHelper.h"
#import "ServiceUrlString.h"
#import "JSONKit.h"

@interface UISelectSubjectVC ()<WebDataParserDelegate,NSURLConnHelperDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) WebServiceHelper *webServiceHelper;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *valueArray;
@property (nonatomic,copy) NSString *selectWord;
@end

@implementation UISelectSubjectVC
@synthesize delegate;

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
    
    UIBarButtonItem *backBar = [[UIBarButtonItem alloc]init];
    backBar.title = @"返回";
    self.navigationItem.backBarButtonItem = backBar;
    
    self.contentSizeForViewInPopover = CGSizeMake(250, 300);
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 250, 300) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    if (self.isType == YES || self.isSubject == YES ) {
        self.typeArray = [[NSMutableArray alloc]init];

        NSString *URL = [ServiceUrlString generateOAWebServiceUrl];
        self.webServiceHelper = [[WebServiceHelper alloc] initWithUrl:URL method:self.method nameSpace:WEBSERVICE_NAMESPACE delegate:self];
        [self.webServiceHelper runAndShowWaitingView:self.view];
    }
    else{
        NSMutableArray *array = [[NSMutableArray alloc]init];
        for (NSDictionary *dataDic in self.valueArray) {
            NSString *type = [dataDic objectForKey:@"type"];
            if ([type isEqualToString:self.type]) {
                [array addObject:dataDic];
            }
        }
        self.valueArray = array;
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)processWebData:(NSData *)webData{
    if ([webData length] <= 0) {
        return;
    }
    WebDataParserHelper *dataParserHelper = [[WebDataParserHelper alloc]initWithFieldName:[NSString stringWithFormat:@"%@Return",self.method] andWithJSONDelegate:self];
    [dataParserHelper parseXMLData:webData];
}

-(void)parseJSONString:(NSString *)jsonStr{
    NSDictionary *dataDic = [jsonStr objectFromJSONString];
    if (dataDic != nil) {
        self.valueArray = [dataDic objectForKey:@"listinfo"];
        if (self.isType == YES) {
            for (NSDictionary *dataDic in self.valueArray) {
                NSString *type = [dataDic objectForKey:@"type"];
                if (![self.typeArray containsObject:type]) {
                    [self.typeArray addObject:type];
                }
            }
        }
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (self.isType == YES) {
        return self.typeArray.count;
    }
    else{
        return self.valueArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (self.isType == YES) {
        cell.textLabel.text = [self.typeArray objectAtIndex:indexPath.row];
    }
    else{
        NSDictionary *dataDic = [self.valueArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [dataDic objectForKey:@"name"];
    }
   
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    NSDictionary *dataDic = [self.valueArray objectAtIndex:indexPath.row];
    NSString *name = [dataDic objectForKey:@"name"];
    
    if (self.isType == YES) {
        NSString *type = [self.typeArray objectAtIndex:indexPath.row];
        UISelectSubjectVC *subjectV = [[UISelectSubjectVC alloc]init];
        subjectV.type = type;
        subjectV.delegate = delegate;
        subjectV.valueArray = self.valueArray;
        [self.navigationController pushViewController:subjectV animated:YES];
    }
    else if (self.isSubject){
        [delegate returnSelectSubjectWord:name];
    }
    else{
        [delegate returnSelectSubjectWord:[NSString stringWithFormat:@"%@ %@",self.type,name]];
    }
}

@end
