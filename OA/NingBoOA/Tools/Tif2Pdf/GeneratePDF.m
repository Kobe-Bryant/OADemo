//
//  GeneratePDF.m
//  ImagesToPdf
//
//  Created by chen on 11-7-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GeneratePDF.h"


@implementation GeneratePDF
+ (CGContextRef) openPdfWithFileName:(NSString *)saveFileName {
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
//    NSString *saveDirectory = [paths objectAtIndex:0];
    NSString *saveDirectory = NSTemporaryDirectory();
//    [NSString stringWithFormat:@"%@tmp.pdf",NSTemporaryDirectory()]
    NSString *newFilePath = [saveDirectory stringByAppendingPathComponent:saveFileName];
    const char *filename = [newFilePath UTF8String]; 
    // This code block sets up our PDF Context so that we can draw to it 
    CGRect pageRect=CGRectMake(0, 0, 768,960);
    CGContextRef pdfContext; 
    CFStringRef path; 
    CFURLRef url; 
    CFMutableDictionaryRef myDictionary = NULL; 
    // Create a CFString from the filename we provide to this method when we call it 
    path = CFStringCreateWithCString (NULL, filename, kCFStringEncodingUTF8); 
    // Create a CFURL using the CFString we just defined 
    url = CFURLCreateWithFileSystemPath (NULL, path, kCFURLPOSIXPathStyle, 0); 
    CFRelease (path); 
    // This dictionary contains extra options mostly for ’signing’ the PDF 
    myDictionary = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks); 
    CFDictionarySetValue(myDictionary, kCGPDFContextTitle, CFSTR("My PDF File")); 
    CFDictionarySetValue(myDictionary, kCGPDFContextCreator, CFSTR("My Name")); 
    // Create our PDF Context with the CFURL, the CGRect we provide, and the above defined dictionary 
    pdfContext = CGPDFContextCreateWithURL (url, &pageRect, myDictionary); 
    // Cleanup our mess 
    CFRelease(myDictionary); 
    CFRelease(url); 
    // Done creating our PDF Context, now it’s time to draw to it 
    // Starts our first page 
    return pdfContext;
}

+ (void)closePdf:(CGContextRef)pdfContext {
    // End text 
    // We are done drawing to this page, let’s end it 
    // We could add as many pages as we wanted using CGContextBeginPage/CGContextEndPage 
    // We are done with our context now, so we release it 
    CGContextRelease (pdfContext); 
}

+ (void)newPage:(CGContextRef)pdfContext {
    CGRect pageRect=CGRectMake(0, 0,768,960);
    CGContextBeginPage (pdfContext, &pageRect); 
    CGContextSetTextDrawingMode (pdfContext, kCGTextFill); 
    CGContextSetRGBFillColor (pdfContext, 0.0, 0.0, 0.0, 1.0); 
    CGContextConcatCTM(pdfContext, CGAffineTransformMake(1,0,0,-1,0,960));//反转变换
    UIGraphicsPushContext(pdfContext);
  //  CGContextStrokeRect(pdfContext, CGRectMake(50, 100, pageRect.size.width-100, pageRect.size.height-150)); 
}

+ (void)endPage:(CGContextRef)pdfContext {
    UIGraphicsPopContext();
    CGContextEndPage (pdfContext); 
}    

+ (void)printToPdfWithString:(NSString *)contextString fontSize:(CGFloat)size atPoint:(CGPoint)point {
    [contextString drawAtPoint:point withFont:[UIFont systemFontOfSize:size]];
}

+ (void)printToPdf:(CGContextRef)pdfContext withStringRightAligment:(NSString *)contextString fontSize:(CGFloat)size atPoint:(CGPoint)point {
    
	CGPoint p0 = CGContextGetTextPosition(pdfContext);
    CGContextSetTextDrawingMode (pdfContext, kCGTextInvisible); 
    [contextString drawAtPoint:p0 withFont:[UIFont systemFontOfSize:size]];
    CGPoint p1 = CGContextGetTextPosition(pdfContext);
    CGContextSetTextDrawingMode (pdfContext, kCGTextFill); 
    [contextString drawAtPoint:CGPointMake(point.x - p1.x + p0.x, point.y)  withFont:[UIFont systemFontOfSize:size]];
    
	
	
}

+(void) addImage:(UIImage*)img atPoint:(CGPoint)point 
{
	[img drawAtPoint:point];
}

@end
