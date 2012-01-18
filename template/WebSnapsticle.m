//
//  WebSnapsticle.m
//  SecondScreen
//
//  Created by TheD on 4/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WebSnapsticle.h"
#import <QuartzCore/QuartzCore.h>
#import "CoreGraphics+DDAdditions.h"


// TRIGGERTIMER_COUNT is used to put a delay the creation of
// the snapshot of the webview once the webview is "apparently"
// done loading. The variable count is reset to zero every time
// the webview is done loading a request, from there on count is
// incremented every TIMER_INTERVAL seconds and once count reaches
// TRIGGERTIMER_COUNT's value then the snapshot happens.

#define TRIGGERTIMER_COUNT      4
#define TIMER_INTERVAL          1
#define TIMER_FAILSAFE_STOP     20



@interface WebSnapsticle()
@property(nonatomic, retain) NSURL *webURL;
@property(nonatomic, retain) UIView *delegateView;
@property(nonatomic, copy) void(^imageCallback)(UIImage*);
@property(nonatomic, retain) UIWebView* snapperWebview;
@property(nonatomic, assign) int outstandingRequests;
@property(nonatomic, assign) int count;
@property(nonatomic, retain) NSTimer* snapTimer;
@property(nonatomic, retain) NSTimer* failsafeTimer;

- (id) initWithURL:(NSURL*)url delegateView:(UIView*)dView withSize:(CGSize)size callback:(void(^)(UIImage*))callback;
- (void)increaseTimerCount;
- (void)createImageFromWebView:(UIWebView*)wv;
- (void)cleanup;
@end



@implementation WebSnapsticle
@synthesize webURL;
@synthesize delegateView;
@synthesize imageCallback;
@synthesize snapperWebview;
@synthesize outstandingRequests;
@synthesize snapTimer;
@synthesize count;
@synthesize failsafeTimer;


+ (id) snapsticleFor:(NSURL*)url delegateView:(UIView*)dView withSize:(CGSize)size callback:(void(^)(UIImage*))callback  {
    return [[self alloc] initWithURL:url delegateView:dView withSize:size callback:callback];
}

- (id) initWithURL:(NSURL*)url delegateView:(UIView*)dView withSize:(CGSize)size callback:(void(^)(UIImage*))callback {
    if ((self = [super init])) {
                
        self.webURL = url;
        self.delegateView = dView;
        self.imageCallback = callback;

        
        // We are going to pass in a frame that is out of the visible area!!! We do not want to see this webview.
        // It is just going to be used to load the page and render its content into an image for caching!

        self.snapperWebview = [[UIWebView alloc] initWithFrame:CGRectMake(self.delegateView.frame.origin.x - (size.width + 100),
                                                                           self.delegateView.frame.origin.y - (size.height +100),
                                                                           size.width,
                                                                           size.height)];
        
        // This should not be visible becase of the frame we initialized the webview with!
        [self.delegateView addSubview:self.snapperWebview];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:self.webURL];
        self.snapperWebview.delegate = self;
        self.snapperWebview.scalesPageToFit = YES;
        [self.snapperWebview loadRequest:requestObj];

        
        self.failsafeTimer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:TIMER_FAILSAFE_STOP] interval:0 target:self selector:@selector(cleanup) userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:self.failsafeTimer forMode:NSRunLoopCommonModes];
        
    } return self;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    //NSLog(@"Websticle started loading");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.outstandingRequests--;
        if(!self.outstandingRequests) {
            self.count = 0;
        }
        if(!self.snapTimer)
            self.snapTimer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL
                                                         target:self
                                                       selector:@selector(increaseTimerCount)
                                                       userInfo:nil
                                                        repeats:YES];
    });

}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    self.outstandingRequests++;
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    self.outstandingRequests--;
}

- (void)increaseTimerCount {
    ////NSLog(@"SNAP TIMER COUNT is: %i, outstandingRequests: %i", self.count, self.outstandingRequests);
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        if(self.count == TRIGGERTIMER_COUNT && !self.outstandingRequests) {
            [self createImageFromWebView:self.snapperWebview];
            [self.snapTimer invalidate];
            self.snapTimer = nil;
        }
        
        if(self.count > (TRIGGERTIMER_COUNT*2) && self.outstandingRequests) {
            
            // if there is a request that is just going to take too long (TRIGGERTIMER_COUNT*2)
            // then snap what we have so that we can move on!
            
            [self createImageFromWebView:self.snapperWebview];
            [self.snapTimer invalidate];
            self.snapTimer = nil;
        } 
        
        self.count++; 
            
    });
    
}

- (void)createImageFromWebView:(UIWebView*)wv {
    //////NSLog(@"*************SANPSTICLE LOADING IS COMPLETE!!!*****************");
    
    //CGImageRef snapshot = DDCreateImageFromWebview(wv);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        @synchronized(self) {
            
            if(hasCleanedUp) { return; }
            
            UIGraphicsBeginImageContext(wv.layer.bounds.size);
            [wv.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            self.imageCallback(image);
            
            [self cleanup];
        }
    });
}

- (void)cleanup {
    dispatch_async(dispatch_get_main_queue(), ^{
        @synchronized(self) {
            
            if(hasCleanedUp) { return; }
            
            [self.snapTimer invalidate];
            self.snapTimer = nil;
            
            [self.failsafeTimer invalidate];
            self.failsafeTimer = nil;
            
            [self.snapperWebview removeFromSuperview];
            
            self.snapperWebview.delegate = nil;
                        
            hasCleanedUp = YES;
        
        }
    });
}

@end
