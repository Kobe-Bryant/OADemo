//
//  QQSectionHeaderView.m
//  TQQTableView
//
//  Created by Futao on 11-6-22.
//  Copyright 2011 ftkey.com. All rights reserved.
//

#import "QQSectionHeaderView.h"


@implementation QQSectionHeaderView

@synthesize  delegate, section , opened,disclosureButton;

-(UIView *)initWithFrame:(CGRect)frame title:(NSString*)title section:(NSInteger)sectionNumber opened:(BOOL)isOpened delegate:(id)aDelegate
{
    
    if ((self = [super initWithFrame:frame]))
    {
		UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleAction:)];
		[self addGestureRecognizer:tapGesture];
		self.userInteractionEnabled = YES;
		section = sectionNumber;
		delegate = aDelegate;
		opened = isOpened;

//        UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellBG_type1.png"]];
//        [self addSubview:background];
//        
//        CGRect titleLabelFrame = self.bounds;
//        titleLabelFrame.origin.x += 35.0;
//        titleLabelFrame.size.width -= 35.0;
//        CGRectInset(titleLabelFrame, 0.0, 5.0);
//        UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleLabelFrame];
//        titleLabel.text = title;
//        titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
//        titleLabel.textColor = [UIColor blackColor];
//        titleLabel.backgroundColor = [UIColor clearColor];
//        [self addSubview:titleLabel];
        UIImageView *background = [[UIImageView alloc] initWithFrame:frame];
        background.image = [UIImage imageNamed:@"cellBG_type1.png"];
        [self addSubview:background];
        
        self.disclosureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        disclosureButton.frame = CGRectMake(0.0, 3.0, 30.0, 30.0);
        [disclosureButton setImage:[UIImage imageNamed:@"carat.png"] forState:UIControlStateNormal];
        [disclosureButton setImage:[UIImage imageNamed:@"carat-open.png"] forState:UIControlStateSelected];
//		
		disclosureButton.userInteractionEnabled = NO;
		disclosureButton.selected = isOpened;
        [self addSubview:disclosureButton];
        
        CGRect titleLabelFrame = self.bounds;
        titleLabelFrame.origin.y = 7.0;
        titleLabelFrame.origin.x += 36.0;
        titleLabelFrame.size.width -= 30.0;
        titleLabelFrame.size.height = 21.0;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleLabelFrame];
        titleLabel.font = [UIFont systemFontOfSize:19.0];
        //titleLabel.backgroundColor = [UIColor colorWithRed:159.0/255 green:215.0/255 blue:230.0/255 alpha:1.0];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = title;
        
        [self addSubview:titleLabel];
		

		
		//self.backgroundColor = [UIColor colorWithRed:0xe9/255.0 green:0xe9/255.0 blue:0xe9/255.0 alpha:1.0f];
	}
	return self;
}

-(id)initWithFrame:(CGRect)frame title:(NSString*)title subTitle:(NSString*)aSubTitle section:(NSInteger)sectionNumber opened:(BOOL)isOpened delegate:(id)aDelegate
{
    if ((self = [super initWithFrame:frame]))
    {
		UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleAction:)];
		[self addGestureRecognizer:tapGesture];
		self.userInteractionEnabled = YES;
		section = sectionNumber;
		delegate = aDelegate;
		opened = isOpened;
        
        UIImageView *background = [[UIImageView alloc] initWithFrame:frame];
        background.image = [UIImage imageNamed:@"cellBG_type1.png"];
        [self addSubview:background];
        
        CGRect titleLabelFrame = CGRectMake(35.0, 2.0, frame.size.width-35, 26);
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleLabelFrame];
        titleLabel.text = title;
        titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:titleLabel];
		
		CGRect subtitleLabelFrame = CGRectMake(35.0, 30.0, frame.size.width-35, frame.size.height - 35);
        UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:subtitleLabelFrame];
        subtitleLabel.text = aSubTitle;
        subtitleLabel.numberOfLines = 0;
        subtitleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        subtitleLabel.textColor = [UIColor darkGrayColor];
        subtitleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:subtitleLabel];
        
        NSLog(@"isOpen:%d",isOpened);
		self.disclosureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        disclosureButton.frame = CGRectMake(0.0, 2.0, 35.0, 35.0);
        [disclosureButton setImage:[UIImage imageNamed:@"carat.png"] forState:UIControlStateNormal];
        [disclosureButton setImage:[UIImage imageNamed:@"carat-open.png"] forState:UIControlStateSelected];
		
		disclosureButton.userInteractionEnabled = NO;
		disclosureButton.selected = isOpened;
        [self addSubview:disclosureButton];
		
		//self.backgroundColor = [UIColor colorWithRed:0xe9/255.0 green:0xe9/255.0 blue:0xe9/255.0 alpha:1.0f];
	}
	return self;
}

-(IBAction)toggleAction:(id)sender
{
	disclosureButton.selected = !disclosureButton.selected;
	if (disclosureButton.selected)
    {
		if ([delegate respondsToSelector:@selector(sectionHeaderView:sectionOpened:)])
        {
			[delegate sectionHeaderView:self sectionOpened:section];
		}
	}
	else
    {
		if ([delegate respondsToSelector:@selector(sectionHeaderView:sectionClosed:)])
        {
			[delegate sectionHeaderView:self sectionClosed:section];
		}
	}
}

@end
