//
//  UISelectSubjectVC.h
//  NingBoOA
//
//  Created by PowerData on 14-4-1.
//  Copyright (c) 2014年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UISelectSubjectDelegate <NSObject>

-(void)returnSelectSubjectWord:(NSString *)word;

@end

@interface UISelectSubjectVC : UIViewController
@property (nonatomic,assign) id<UISelectSubjectDelegate> delegate;
@property (nonatomic,strong) NSMutableArray *typeArray;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *method;
@property (nonatomic,assign) BOOL isType;
@property (nonatomic,assign) BOOL isSubject;
@end
