//
//  YoutubeView.h
//  TVPulse
//
//  Created by Bryce Redd on 8/1/11.
//  Copyright 2011 i.TV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YoutubeView : UIWebView <UIWebViewDelegate>
@property(nonatomic, unsafe_unretained) BOOL playOnLoad;
- (void) loadYoutubeVideo:(NSURL*)url;
@end
