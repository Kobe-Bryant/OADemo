//
//  IMTWebView.m
//  webkittest
//
//  Created by Petr Dvorak on 11/23/11.
//  Copyright (c) 2011 Inmite. All rights reserved.
//

#import "TaoBaoWebView.h"

@interface UIWebView ()
-(id)webView:(id)view identifierForInitialRequest:(id)initialRequest fromDataSource:(id)dataSource;
-(void)webView:(id)view resource:(id)resource didFinishLoadingFromDataSource:(id)dataSource;
-(void)webView:(id)view resource:(id)resource didFailLoadingWithError:(id)error fromDataSource:(id)dataSource;
@end

@implementation TaoBaoWebView

@synthesize isFinished = _isFinished;
@synthesize progressDelegate;
@synthesize resourceCount;
@synthesize resourceCompletedCount;

-(id)webView:(id)view identifierForInitialRequest:(id)initialRequest fromDataSource:(id)dataSource
{
    [super webView:view identifierForInitialRequest:initialRequest fromDataSource:dataSource];
    return [NSNumber numberWithInt:resourceCount++];
}

- (void)webView:(id)view resource:(id)resource didFailLoadingWithError:(id)error fromDataSource:(id)dataSource {
    [super webView:view resource:resource didFailLoadingWithError:error fromDataSource:dataSource];
    //_isFinished = NO;
    resourceCompletedCount++;
    if ([self.progressDelegate respondsToSelector:@selector(webView:didReceiveResourceNumber:totalResources:)]) {
        [self.progressDelegate webView:self didReceiveResourceNumber:resourceCompletedCount totalResources:resourceCount];
    }
}

-(void)webView:(id)view resource:(id)resource didFinishLoadingFromDataSource:(id)dataSource
{
    [super webView:view resource:resource didFinishLoadingFromDataSource:dataSource];
    //_isFinished = YES;
    resourceCompletedCount++;
    if ([self.progressDelegate respondsToSelector:@selector(webView:didReceiveResourceNumber:totalResources:)]) {
        [self.progressDelegate webView:self didReceiveResourceNumber:resourceCompletedCount totalResources:resourceCount];
    }
}


@end
