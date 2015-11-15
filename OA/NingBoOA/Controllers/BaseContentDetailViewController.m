//
//  BaseContentDetailViewController.m
//  NingBoOA
//
//  Created by PowerData on 13-11-4.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "BaseContentDetailViewController.h"
#import "NSStringUtil.h"

@interface BaseContentDetailViewController ()

@end

@implementation BaseContentDetailViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCanEditWithCell:(UITableViewCell *)aCell andWithTag:(int)aTag andWithIndexPath:(NSIndexPath *)indexPath
{
    //设置Label的字体的颜色
    UILabel *label = (UILabel *)[aCell viewWithTag:aTag];
    [label setTextColor:[UIColor blueColor]];
    
    //添加修改按钮
    UIView *view = [aCell viewWithTag:aTag+1];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"editing.png"] forState:UIControlStateNormal];
    if(aTag == 1)
    {
        btn.tag = (indexPath.row+1)*100 + 1;
    }
    else if (aTag == 3)
    {
        btn.tag = (indexPath.row+1)*100 + 2;
    }
    [btn setFrame:CGRectMake((view.frame.origin.x+view.frame.size.width), view.frame.origin.y+(view.frame.size.height-30)/2, 60, 30)];
    [view.superview addSubview:btn];
    [btn addTarget:self action:@selector(modifyData:) forControlEvents:UIControlEventTouchUpInside];
}

- (NSArray *)getRowDetail:(int)rowIndex
{
    NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:3];
    for(int i = 0; i < self.toDisplayRowAry.count; i++)
    {
        NSString *titleIndex = [self.toDisplayRowAry objectAtIndex:i];
        if(rowIndex == [titleIndex intValue])
        {
            [ret addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    return ret;
}

- (void)modifyData:(UIButton *)sender
{
    //子类必须继承
}

- (void)passWithNewValue:(NSString *)newValue andWithRow:(int)aRow andWithIndex:(int)aIndex andWithKey:(NSString *)aKey
{
    //子类必须继承
}

//获得指定行的高度
- (CGFloat)getRowHeightWithRowIndex:(NSInteger)rowIndex
{
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:18.0];
    
    NSArray *rowDetailAry = [self getRowDetail:rowIndex];
    CGFloat cellHeight = 60.0f;
    NSString *text = @"";
    
    if(rowDetailAry.count == 1)
    {
        NSString *key = [self.toDisplayKeyAry objectAtIndex:[[rowDetailAry objectAtIndex:0] intValue]];
        text = [self.docInfo objectForKey:key];
        cellHeight = [NSStringUtil calculateTextHeight:text byFont:font andWidth:560] + 20;
    }
    else if(rowDetailAry.count == 2)
    {
        NSString *key1 = [self.toDisplayKeyAry objectAtIndex:[[rowDetailAry objectAtIndex:0] intValue]];
        NSString *value1 = [self.docInfo objectForKey:key1];
        NSString *key2 = [self.toDisplayKeyAry objectAtIndex:[[rowDetailAry objectAtIndex:1] intValue]];
        NSString *value2 = [self.docInfo objectForKey:key2];
        if(value1 == nil || value1.length == 0)
        {
            value1 = @"";
        }
        if(value2 == nil || value2.length == 0)
        {
            value2 = @"";
        }
        if(value1.length > value2.length)
        {
            text = value1;
        }
        else
        {
            text = value2;
        }
        cellHeight = [NSStringUtil calculateTextHeight:text byFont:font andWidth:210] + 20;
    }
    if(cellHeight < 60)
    {
        cellHeight = 60.0f;
    }
    return cellHeight;
}

- (void)getEditorData
{
    NSMutableArray *tmpary = [[NSMutableArray alloc] initWithCapacity:0];
    for(int i = 0; i < self.toDisplayKeyAry.count; i++)
    {
        [tmpary addObject:@"0"];
    }
    NSArray *editAry = [[self.docInfo objectForKey:@"edit"] componentsSeparatedByString:@","];
    for(int i = 0; i < self.toDisplayKeyAry.count; i++)
    {
        NSString *key = [self.toDisplayKeyAry objectAtIndex:i];
        
        if([editAry containsObject:key])
        {
            [tmpary replaceObjectAtIndex:i withObject:@"1"];
            
        }
        NSRange range = [key rangeOfString:@"_Histroy"];
        if(range.location != NSNotFound)
        {
            key = [key substringToIndex:range.location];
            if([editAry containsObject:key])
            {
                [tmpary replaceObjectAtIndex:i withObject:@"1"];
            }
        }
    }
    self.toDisplayEditAry = tmpary;
}

@end
