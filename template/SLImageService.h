//
//  TVImageService.h
//  tvtag
//
//  Created by Bryce Redd on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLService.h"

@interface SLImageService : SLService

- (void) fetchImage:(NSURL*) url callback:(void(^)(UIImage*))callback;
- (void) fetchImage:(NSURL*)url withWidth:(float)width callback:(void (^)(UIImage *))callback;

@end
