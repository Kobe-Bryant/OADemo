//
//  DangerChemicalsCategoryViewController.h
//  BoandaProject
//
//  Created by PowerData on 13-10-16.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "BaseViewController.h"

@interface DangerChemicalsCategoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *listTableView;
@property (nonatomic, strong) NSArray *data;

@end
