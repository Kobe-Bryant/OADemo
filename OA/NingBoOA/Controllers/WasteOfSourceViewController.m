//
//  WasterOfSourceViewController.m
//  GMEPS_HZ
//
//  Created by 熊 熙 on 13-6-20.
//
//

#import "WasteOfSourceViewController.h"
#import "WasteItemViewController.h"
#import "FMDatabase.h"
@interface WasteOfSourceViewController ()

@end

@implementation WasteOfSourceViewController


- (void)dealloc {

}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [_wasteSourceAry count];
    NSLog(@"number of %d",[_wasteSourceAry count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *backgroundImagePath = [[NSBundle mainBundle] pathForResource:(indexPath.row%2 == 0) ? @"lightblue" : @"white" ofType:@"png"];
	UIImage *backgroundImage = [[UIImage imageWithContentsOfFile:backgroundImagePath] stretchableImageWithLeftCapWidth:0.0 topCapHeight:1.0];
	cell.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage] ;
	cell.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	cell.backgroundView.frame = cell.bounds;
	cell.textLabel.backgroundColor = [UIColor clearColor];
	
    cell.textLabel.font  = [UIFont systemFontOfSize:24];
    
    cell.textLabel.text =[self.wasteSourceAry objectAtIndex:indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sourceStr = [self.wasteSourceAry objectAtIndex:indexPath.row];
    
    //获取数据库文件
    NSString *dbFilePath = [[NSBundle mainBundle] pathForResource:@"hbsc_data" ofType:@"db"];
    FMDatabase *database = [FMDatabase databaseWithPath:dbFilePath];
    if (![database open]) {
        NSLog(@"Open database failed");
        return;
    }
    
    NSString *queryStr =[NSString stringWithFormat:@"select  DMNR,DMBH,FWTX,HYLY,SJDMBH from dangerwaste  where HYLY = \'%@\' ",sourceStr];
    
    FMResultSet *resultSet =[database executeQuery:queryStr];
    
    NSMutableArray *describeAry = [NSMutableArray array];
    NSMutableArray *bhAry       = [NSMutableArray array];
    NSMutableArray *featureAry  = [NSMutableArray array];
    NSMutableArray *sourAry     = [NSMutableArray array];
    NSMutableArray *cgAry = [NSMutableArray array];
    NSMutableArray *categoryAry = [NSMutableArray array];
    
    while([resultSet next]) {
        NSString *wasteDescribe = [resultSet stringForColumn:@"DMNR"];
        NSString *wasteBH       = [resultSet stringForColumn:@"DMBH"];
        NSString *wasteFeature  = [resultSet stringForColumn:@"FWTX"];
        NSString *wasteSource   = [resultSet stringForColumn:@"HYLY"];
        NSString *categoryBH   = [resultSet stringForColumn:@"SJDMBH"];
        
        [describeAry addObject:wasteDescribe];
        [bhAry       addObject:wasteBH];
        [featureAry  addObject:wasteFeature];
        [sourAry     addObject:wasteSource];
        [cgAry addObject:categoryBH];
    }
    
    for (NSString *bh in cgAry) {
        queryStr =[NSString stringWithFormat:@"select  DMBH,DMNR from dangerwaste  where DMBH = \'%@\' ",bh];
        resultSet =[database executeQuery:queryStr];
        NSString *cg = nil;
         while([resultSet next]) {
             cg =  [resultSet stringForColumn:@"DMNR"];
         }
        
        NSString *wasteCategory = [NSString stringWithFormat:@"%@<br/>%@",bh, cg];
        
        [categoryAry addObject:wasteCategory];
        
    }
    

    
        
    [database close];
    
    WasteItemViewController *wasteItemViewController = [[WasteItemViewController alloc] initWithStyle:UITableViewStylePlain];
    wasteItemViewController.title = sourceStr;
    wasteItemViewController.wasteDeAry = describeAry;
    wasteItemViewController.wasteBHAry = bhAry;
    wasteItemViewController.wasteFeAry = featureAry;
    wasteItemViewController.wasteHlAry = sourAry;
    wasteItemViewController.wasteCgAry = categoryAry;
    
    [self.navigationController pushViewController:wasteItemViewController animated:YES];
    

}

@end
