//
//  TVService.h
//  tvclient
//
//  Created by Bryce Redd on 7/15/10.
//  Copyright 2010 i.TV LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SLURLRequest;

@interface SLService : NSObject {}

@property (assign) BOOL cancelled;

+ (id) service;

- (SLService*) getRequest;
- (SLService*) postRequest;
- (SLService*) putRequest;
- (SLService*) deleteRequest;
- (SLService*) cancel;
- (SLService*) setUrl:(NSURL*)url;

- (void) execute:(void(^)(SLURLRequest*))callback;

@end
