//
//  YoutubeView.m
//  TVPulse
//
//  Created by Bryce Redd on 8/1/11.
//  Copyright 2011 i.TV. All rights reserved.
//

#import "YoutubeView.h"

@implementation YoutubeView

@synthesize playOnLoad;

- (void) loadYoutubeVideo:(NSURL*)url {
    self.delegate = self;
    
    // HTML to embed YouTube video
    NSString *youTubeVideoHTML = @"<html><head>\
    <body style=\"margin:0\">\
    <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
    width=\"%0.0f\" height=\"%0.0f\"></embed>\
    </body></html>";

    // Populate HTML with the URL and requested frame size
    NSString *html = [NSString stringWithFormat:youTubeVideoHTML, url, self.frame.size.width, self.frame.size.height];

    // Load the html into the webview
    [self loadHTMLString:html baseURL:nil];

    for(UIView* sv in self.subviews) {
       if([sv isKindOfClass:[UIScrollView class]]) {
           UIScrollView *scv = (UIScrollView*)sv;
           scv.scrollEnabled = NO;
       }
    }
}

- (UIButton *)findButtonInView:(UIView *)view {
    UIButton *button = nil;

    if ([view isMemberOfClass:[UIButton class]]) {
        return (UIButton *)view;
    }

    if (view.subviews && [view.subviews count] > 0) {
        for (UIView *subview in view.subviews) {
            button = [self findButtonInView:subview];
            if (button) return button;
        }
    }

    return button;
}

- (void)webViewDidFinishLoad:(UIWebView *)_webView {
    if(!playOnLoad) return;
    
    UIButton *b = [self findButtonInView:_webView];
    [b sendActionsForControlEvents:UIControlEventTouchUpInside];
}
@end
