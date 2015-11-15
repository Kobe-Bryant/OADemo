//
//  DangerChemicalsViewController.h
//  BoandaProject
//
//  Created by PowerData on 13-10-16.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "BaseViewController.h"
#import "HBSCHelper.h"

@interface DangerChemicalsViewController : BaseViewController
{
    sqlite3 *data_db;
    NSArray *tableColumn;
}

@property (nonatomic, strong) IBOutlet UIButton *categoryBtn;
@property (nonatomic, strong) IBOutlet UIButton *cnBihuaBtn;
@property (nonatomic, strong) IBOutlet UIButton *enAlphaBtn;
@property (nonatomic, strong) IBOutlet UIButton *searchBtn;
@property (nonatomic, strong) IBOutlet UITextField *cnameText;
@property (nonatomic, strong) IBOutlet UITextField *enameText;
@property (nonatomic, strong) IBOutlet UITextField *estatecodeText;
@property (nonatomic, strong) IBOutlet UITextField *cascodeText;
@property (nonatomic, strong) IBOutlet UIImageView *imgView;

-(IBAction)categoryClicked:(id)sender;
-(IBAction)cnBihuaBtnClicked:(id)sender;
-(IBAction)enAlphaBtnClicked:(id)sender;
-(IBAction)searchBtnClicked:(id)sender;
- (IBAction)keyboardWillHide:(NSNotification *)note;

@end
