//
//  NSString+MD5Addition.m
//  UIDeviceAddition
//
//  Created by Georg Kitz on 20.08.11.
//  Copyright 2011 Aurora Apps. All rights reserved.
//

#import "UITableViewCell+OADetail.h"
#import <CommonCrypto/CommonDigest.h>

@implementation UITableViewCell(OADetail)

+(UITableViewCell*)makeAutoSubCell:(UITableView *)tableView
					 withTitle:(NSString *)aTitle
						 value:(NSString *)aValue
                     andHeight:(CGFloat)theHeight
{
	UILabel* lblTitle = nil;
	UILabel* lblValue = nil;
    NSString *cellIdentifier = [NSString stringWithFormat:@"cellcustom_%.1f_%@",theHeight, aTitle];
	UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (aCell == nil) {
        aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

	
	if (aCell.contentView != nil)
	{
		lblTitle = (UILabel *)[aCell.contentView viewWithTag:1];
		lblValue = (UILabel *)[aCell.contentView viewWithTag:2];
	}
	
	if (lblTitle == nil) {
		CGRect tRect2 = CGRectMake(0, 0, 150, theHeight);
		lblTitle = [[UILabel alloc] initWithFrame:tRect2]; //此处使用id定义任何控件对象
		[lblTitle setBackgroundColor:[UIColor clearColor]];
		//[lblTitle setTextColor:[UIColor grayColor]];
        [lblTitle setTextColor:[UIColor blackColor]];
		lblTitle.font = [UIFont fontWithName:@"Helvetica" size:19.0];
		//lblTitle.textAlignment = UITextAlignmentRight;
        lblTitle.textAlignment = UITextAlignmentCenter;
        UIColor *bg = [UIColor colorWithRed:214.f/255.f green:234.f/255.f blue:254.f/255.f alpha:1];
        [lblTitle setBackgroundColor:bg];
		lblTitle.tag = 1;
        lblTitle.numberOfLines = 0;
		[aCell.contentView addSubview:lblTitle];

		
		CGRect tRect3 = CGRectMake(160, 0, 610-60, theHeight);
		lblValue = [[UILabel alloc] initWithFrame:tRect3]; //此处使用id定义任何控件对象
		[lblValue setBackgroundColor:[UIColor clearColor]];
		[lblValue setTextColor:[UIColor blackColor]];
		lblValue.font = [UIFont fontWithName:@"Helvetica" size:19.0];
		lblValue.textAlignment = UITextAlignmentLeft;
		lblValue.tag = 2;	
        lblValue.numberOfLines = 0;
		[aCell.contentView addSubview:lblValue];

	}
	if (aTitle == nil) aTitle = @"";
    if (aValue == nil) aValue = @"";
	if (lblTitle != nil)	[lblTitle setText:aTitle];
	if (lblValue != nil)	[lblValue setText:aValue];
	
    aCell.accessoryType = UITableViewCellAccessoryNone;
	return aCell;
}


+ (UITableViewCell*)makeAutoHeightSubCell:(UITableView *)tableView
                     withValue1:(NSString *)aTitle
                         value2:(NSString *)aTitle2
                         value3:(NSString *)aValue
                         value4:(NSString *)aValue2
                         height:(CGFloat)aHeight
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"makeSubCell %.1f_%@",aHeight, aTitle];
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (aCell == nil) {
        aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
	UILabel* label1 = nil;
    UILabel* label2 = nil;
    UILabel* label3 = nil;
    UILabel* label4 = nil;
    
	if (aCell.contentView != nil)
	{
        label1 = (UILabel *)[aCell.contentView viewWithTag:1];
        label2 = (UILabel *)[aCell.contentView viewWithTag:2];
        label3 = (UILabel *)[aCell.contentView viewWithTag:3];
        label4 = (UILabel *)[aCell.contentView viewWithTag:4];
    }
	
	if (label1 == nil) {
		CGRect tRect = CGRectMake(0, 0, 150, aHeight);
        NSMutableArray *ary = [NSMutableArray arrayWithCapacity:4];
        for(int i=0;i<4;i++){
            UILabel *tLabel = [[UILabel alloc] initWithFrame:tRect]; //此处使用id定义任何控件对象
            [tLabel setBackgroundColor:[UIColor clearColor]];
            tLabel.numberOfLines = 0;
            tLabel.lineBreakMode = UILineBreakModeWordWrap;
            tLabel.font = [UIFont fontWithName:@"Helvetica" size:19.0];
            if(i%2 == 0){
                tRect.origin.x += 150;
                tRect.size.width = 234-60;
                tLabel.textAlignment = UITextAlignmentCenter;
                UIColor *bg = [UIColor colorWithRed:214.f/255.f green:234.f/255.f blue:254.f/255.f alpha:1];
                [tLabel setBackgroundColor:bg];
                [tLabel setTextColor:[UIColor blackColor]];
            }
            else{
                tRect.size.width = 150;
                tRect.origin.x += 234;
                tLabel.textAlignment = UITextAlignmentLeft;
                [tLabel setTextColor:[UIColor blackColor]];
            }
            
            
            tLabel.tag = i+1;
            [aCell.contentView addSubview:tLabel];
            
            [ary addObject:tLabel];
        }
        label1 = [ary objectAtIndex:0];
        label2 = [ary objectAtIndex:1];
        label3 = [ary objectAtIndex:2];
        label4 = [ary objectAtIndex:3];
        
    }
    
    if (label1 != nil)  [label1 setText:aTitle];
    if (label2 != nil)  [label2 setText:aValue];
    if (label3 != nil) [label3 setText:aTitle2];
    if (label4 != nil) [label4 setText:aValue2];
    
    aCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
	return aCell;
}

@end
