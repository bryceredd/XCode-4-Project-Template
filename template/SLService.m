//
// TVService.m
// tvclient
//
// Created by Bryce Redd on 7/15/10.
// Copyright 2010 i.TV LLC. All rights reserved.
//

#import "SLService.h"
#import "SLURLRequest.h"


@interface SLService()
@property (nonatomic, strong) SLURLRequest * request;
@end

@implementation SLService

@synthesize cancelled, request;

+ (id) service {
    return [self new];
}  

- (id) init {
    if ((self = [super init]))
        self.request = [SLURLRequest new];
        [self getRequest];
    return self;
}

- (void) execute:(void(^)(SLURLRequest*))callback {
    NSAssert(self.request.url, @"No URL specified in request!");
    
    [self.request sendWithCallback:callback];
}

- (SLService*) setUrl:(NSURL*)url {
    self.request.url = url;
    return self;
}

- (SLService*) getRequest {
    self.request.httpMethod = @"GET";
    return self;
}

- (SLService*) postRequest {
    self.request.httpMethod = @"POST";
    return self;
}

- (SLService*) putRequest {
    self.request.httpMethod = @"PUT";
    return self;
}

- (SLService*) deleteRequest {
    self.request.httpMethod = @"DELETE";
    return self;
}

- (SLService*) cancel {
    self.cancelled = YES;
    [self.request cancel];
    return self;
}

@end
