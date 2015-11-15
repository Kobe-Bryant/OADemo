//
//  UICustomButton.h
//  GuangXiOA
//
//  Created by zhang on 12-10-30.
//
//

#import <UIKit/UIKit.h>

#define BUTTON_WIDTH 54.0
#define BUTTON_SEGMENT_WIDTH 80.0
#define CAP_WIDTH 5.0

typedef enum {
    CapLeft          = 0,
    CapMiddle        = 1,
    CapRight         = 2,
    CapLeftAndRight  = 3
} CapLocation;


@interface UICustomImage : UIImage
+(UIImage*)image:(UIImage*)image withCap:(CapLocation)location capWidth:(NSUInteger)capWidth buttonWidth:(NSUInteger)buttonWidth;

@end


@interface UICustomButton : UIButton

+(UIButton*)woodButtonWithText:(NSString*)buttonText stretch:(CapLocation)location;
@end

@interface UICustomBarButtonItem : UIBarButtonItem
+(UIBarButtonItem*)woodBarButtonItemWithText:(NSString*)buttonText;
@end
