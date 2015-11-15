//
//  BECheckBox.m
//  
//
//  Created by jordenwu-Mac on 10-11-11.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "DeSelectBtn.h"
@implementation DeSelectBtn

@synthesize isDeSelect;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.contentHorizontalAlignment  = UIControlContentHorizontalAlignmentLeft;		
		[self setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
		[self addTarget:self action:@selector(didDeSelectClicked:) forControlEvents:UIControlEventTouchUpInside];
	}
    return self;
}

-(void)setTarget:(id)tar fun:(SEL)ff
{
	target=tar;
	fun=ff;
}
-(void)setIsChecked:(BOOL)deSelect
{   
	isDeSelect=deSelect;
//	if (deSelect) {
//		[self setImage:[UIImage imageNamed:@"radiobutton_checked.png"] forState:UIControlStateNormal];
//		
//	}
//	else {
//		[self setImage:[UIImage imageNamed:@"radiobutton.png"] forState:UIControlStateNormal];
//	}
}

-(void) didDeSelectClicked:(id)sender
{
//	if(self.isDeSelect ==NO){
//		self.isDeSelect =YES;
//		[self setImage:[UIImage imageNamed:@"radiobutton_checked.png"] forState:UIControlStateNormal];
//		
//	}else{
//		self.isDeSelect =NO;
//		[self setImage:[UIImage imageNamed:@"radiobutton.png"] forState:UIControlStateNormal];
		
	//}
    [target performSelector:fun withObject:sender];
}


@end

