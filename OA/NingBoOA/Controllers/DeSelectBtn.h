//
//  BECheckBox.h
//
//  Created by jordenwu-Mac on 10-11-11.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>


@interface DeSelectBtn : UIButton {
	BOOL isDeSelect;
	id target;
	SEL fun;
}
@property (nonatomic,assign) BOOL isDeSelect;

-(void)didDeSelectClicked:(id)sender;
-(void)setTarget:(id)tar fun:(SEL )ff;
@end