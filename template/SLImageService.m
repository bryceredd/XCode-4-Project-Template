//
//  TVImageService.m
//  tvtag
//
//  Created by Bryce Redd on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SLImageService.h"
#import "SLURLRequest.h"

@implementation SLImageService

- (void) fetchImage:(NSURL *)url withWidth:(float)width callback:(void (^)(UIImage *))callback {
    if(!callback) 
        NSLog(@"something very bad has happened!");
        
    NSString* smallerUrl = [NSString stringWithFormat:@"%@/%d/%@", API_SENCHA, (int)width, url.absoluteString];
    
    [self setUrl:[NSURL URLWithString:smallerUrl]];

    [self execute:^(SLURLRequest* request) {
        callback(request.imageValue);
    }];
}

- (void) fetchImage:(NSURL*) url callback:(void(^)(UIImage*))callback {

    [self setUrl:url];

    [self execute:^(SLURLRequest* request) {
        callback(request.imageValue);
    }];
}

@end
