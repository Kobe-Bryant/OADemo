//
//  TakePhotoViewController.h
//  BoandaProject
//
//  Created by Alex Jean on 13-8-1.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@protocol TakePhotoDelegate;

@interface TakePhotoViewController : BaseViewController <UIScrollViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPopoverControllerDelegate,UITextFieldDelegate>

@end

@protocol TakePhotoDelegate <NSObject>

- (void)returnWithPhotoValue:(NSString *)value;

@end
