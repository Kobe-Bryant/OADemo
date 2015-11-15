//
//  GeneratePDF.h
//  ImagesToPdf
//
//  Created by chen on 11-7-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GeneratePDF : NSObject {

}
+ (CGContextRef) openPdfWithFileName:(NSString *)saveFileName;
+ (void)closePdf:(CGContextRef)pdfContext ;
+ (void)newPage:(CGContextRef)pdfContext;
+ (void)endPage:(CGContextRef)pdfContext;
+ (void)printToPdfWithString:(NSString *)contextString fontSize:(CGFloat)size atPoint:(CGPoint)point;
+ (void)printToPdf:(CGContextRef)pdfContext withStringRightAligment:(NSString *)contextString fontSize:(CGFloat)size atPoint:(CGPoint)point;
+(void) addImage:(UIImage*)img atPoint:(CGPoint)point ;
@end
