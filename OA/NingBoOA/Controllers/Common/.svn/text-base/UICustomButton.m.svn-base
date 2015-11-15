//
//  UICustomButton.m
//  GuangXiOA
//
//  Created by zhang on 12-10-30.
//
//

#import "UICustomButton.h"
#import "ZrsUtils.h"

@implementation UICustomImage

+(UIImage*)image:(UIImage*)image withCap:(CapLocation)location capWidth:(NSUInteger)capWidth buttonWidth:(NSUInteger)buttonWidth
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(buttonWidth, image.size.height), NO, 0.0);
    
    if (location == CapLeft)
        // To draw the left cap and not the right, we start at 0, and increase the width of the image by the cap width to push the right cap out of view
        [image drawInRect:CGRectMake(0, 0, buttonWidth + capWidth, image.size.height)];
    else if (location == CapRight)
        // To draw the right cap and not the left, we start at negative the cap width and increase the width of the image by the cap width to push the left cap out of view
        [image drawInRect:CGRectMake(0.0-capWidth, 0, buttonWidth + capWidth, image.size.height)];
    else if (location == CapMiddle)
        // To draw neither cap, we start at negative the cap width and increase the width of the image by both cap widths to push out both caps out of view
        [image drawInRect:CGRectMake(0.0-capWidth, 0, buttonWidth + (capWidth * 2), image.size.height)];
    
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

@end

@implementation UICustomButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



+(UICustomButton*)woodButtonWithText:(NSString*)buttonText stretch:(CapLocation)location
{
    UIImage* buttonImage = nil;
    UIImage* buttonPressedImage = nil;
    NSUInteger buttonWidth = 0;
    
    if (location == CapLeftAndRight)
    {
        buttonWidth = [ZrsUtils calculateTextWidth:buttonText byFont:[UIFont systemFontOfSize:17.0] andHeight:45];
        buttonImage = [[UIImage imageNamed:@"nav-button.png"] stretchableImageWithLeftCapWidth:CAP_WIDTH topCapHeight:0.0];
        buttonPressedImage = [[UIImage imageNamed:@"nav-button-press.png"] stretchableImageWithLeftCapWidth:CAP_WIDTH topCapHeight:0.0];
    }
    else
    {
        buttonWidth = BUTTON_SEGMENT_WIDTH;
        
        UIImage *originalImg = [[UIImage imageNamed:@"nav-button.png"] stretchableImageWithLeftCapWidth:CAP_WIDTH topCapHeight:0.0];
        buttonImage = [UICustomImage image:originalImg withCap:location capWidth:CAP_WIDTH buttonWidth:buttonWidth];
        
        buttonPressedImage = [UICustomImage image:[[UIImage imageNamed:@"nav-button-press.png"] stretchableImageWithLeftCapWidth:CAP_WIDTH topCapHeight:0.0] withCap:location capWidth:CAP_WIDTH buttonWidth:buttonWidth];
    }
    
    
    UICustomButton* button = [UICustomButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0, 0.0, buttonWidth, buttonImage.size.height);
    button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.shadowOffset = CGSizeMake(0,-1);
    button.titleLabel.shadowColor = [UIColor darkGrayColor];
    
    [button setTitle:buttonText forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:buttonPressedImage forState:UIControlStateSelected];
    button.adjustsImageWhenHighlighted = NO;
    
    return button;
}


@end


@implementation UICustomBarButtonItem
+(UIBarButtonItem*)woodBarButtonItemWithText:(NSString*)buttonText
{
    return [[UIBarButtonItem alloc] initWithCustomView:[UICustomButton woodButtonWithText:buttonText stretch:CapLeftAndRight]] ;
}
@end
