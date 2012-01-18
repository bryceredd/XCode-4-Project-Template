//
// URLRequest.m
// Caching
//
// Created by Sean Hess on 2/4/10.
// Copyright 2010 Apple Inc. All rights reserved.
//

#import "SLURLRequest.h"
#import "JSONKit.h"

#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"


@interface SLURLRequest ()
@property BOOL cancelled;
- (void) handleResults;
- (void) sendASI;

+ (NSOperationQueue*)sharedQueue;


@property (nonatomic, unsafe_unretained) NSInteger statusCode;
@property (nonatomic, strong) NSError * error;
@property (nonatomic, strong) NSData * responseData;
@property (nonatomic, strong) NSDictionary * headers;
@property (nonatomic, strong) NSOperation * operation;
@property (nonatomic, strong) ASIHTTPRequest * request;

@end


@implementation SLURLRequest

@synthesize url, cancelled, httpMethod, callback, body, contentType;
@synthesize error, responseData, statusCode, headers, operation, request;

+ (NSOperationQueue *) sharedQueue {
    static NSOperationQueue* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [NSOperationQueue new];
        [instance setMaxConcurrentOperationCount:8];
        [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]]; 
    });
    
    return instance;
}

- (id) init {
    self = [super init];
    if (!self)
		return nil;
    
    self.httpMethod = @"GET";
    
    return self;
}


#pragma mark execution

- (void) cancel {
    self.cancelled = YES;  
    [self.operation cancel]; 
    [self.request cancel];
    [self cleanup];
}

- (void) sendWithCallback:(void(^) (SLURLRequest *))block {

    // Process the request, check for errors, check the cache, then set up the call
    // NOTE! Because of our design of the services (where you don't retain them), the service
    // will be dealloced very early. The Service is the only thing that has a retain on the
    // request, so the request will get dealloced, causing it to cancel or not exist for the delegate
    
    // SO: we retain the request, and release it after we call back

    NSAssert(block, @"block should not be NULL");
    NSAssert([[url absoluteString] length], @"url should not be NULL or EMPTY");
	
	self.callback = block;
    
    self.operation = [NSBlockOperation blockOperationWithBlock:^{

        // Connections are made in the current thread
        // If the request has been cancelled, return without calling back
        // This will never be called if the operation is cancelled early. 
        
        if (self.cancelled) {
            NSLog(@"%@ %@ (%i) CANCELLED EARLY", self.httpMethod, self.url, self.httpStatusCode);
            [self cleanup];
            return;
        }        
        
        NSLog(@"%@ %@", self.httpMethod, self.url);
        
        
        [self sendASI];
    }];

    [[SLURLRequest sharedQueue] addOperation:self.operation];
}


- (void) sendASI {

    // ASI doesn't retain itself like our other cheater methods do, so we have to do it by hand here
    
    self.request = [ASIHTTPRequest requestWithURL:self.url];
    [self.request setRequestMethod:self.httpMethod];    
    
    if (self.contentType) {
        [self.request addRequestHeader:@"Content-Type" value:self.contentType];    
    }

    if (self.body) {
        [self.request appendPostData:self.body];
    }
    
    void(^complete)(void) = ^{
        self.responseData = [self.request responseData];
        self.statusCode = [self.request responseStatusCode];
        self.headers = [self.request responseHeaders];
        self.error = self.request.error;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self handleResults];
        });
    };

    [self.request setCompletionBlock:complete];
    [self.request setFailedBlock:complete];
    
    [self.request startAsynchronous];
}




#pragma mark Other

- (void) handleResults {
    
    // store to cache. Note that this REALLY doesn't like to be in a background thread. It makes it crash
    // a lot. (At least, in a gcd queue). 
    
    if (self.cancelled) {
        NSLog(@"%@ %@ (%i) CANCELLED ", self.httpMethod, self.url, self.httpStatusCode);
        [self cleanup];
        return;
    }
	
    else if (self.httpStatusCode < HTTPStatusOK || self.httpStatusCode >= HTTPStatusBadRequest) {
        NSLog(@"%@ %@ (%i) ERROR %@ ", self.httpMethod, self.url, self.httpStatusCode, [self errorDescription]);
    }
	
    
    callback(self);
    
    [self cleanup];
}


// cleanup must be called at the end of every request
// this method will remove blocks that have retained
// self.  if cleanup is not called for some reason the 
// request will never dealloc

- (void) cleanup {
    self.request = nil;
    self.operation = nil;
    self.callback = nil;
}






#pragma mark -

- (void)setBodyFromObject:(id)object {    
    self.contentType = @"application/json";
    self.body = [object JSONData];
}

- (void)setBodyFromDictionary:(NSDictionary*)dict {
    [self setBodyFromObject:dict];
}

- (void)setBodyFromArray:(NSArray*)arr {
    [self setBodyFromObject:arr];
}

- (NSInteger)httpStatusCode {
    return self.statusCode;
}

- (NSString *)errorDescription {
    return [[[self.error userInfo] objectForKey:NSUnderlyingErrorKey] localizedDescription];
}






#pragma mark Accessors

- (id) jsonValue {
	if (!self.responseData || ![self.responseData length]) { return nil; }
	
    NSError * err = nil;
    id results = [[JSONDecoder decoder] parseJSONData:self.responseData error:&err];
    if (error) { NSLog(@"JSON PARSING ERROR: %@, %@", [err localizedDescription], [self stringValue]); }
	
    return results;
}

- (UIImage *) imageValue {
    return [UIImage imageWithData:self.responseData];
}

- (NSString *) stringValue {
    return [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
}


@end
