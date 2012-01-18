//
// URLRequest.h
// Caching
//
// Created by Sean Hess on 2/4/10.
// Copyright 2010 Apple Inc. All rights reserved.
//

// Simplification of NSURLConnection and NSURLRequest for our application
// Uses URLCache to aggresively cache stuff

#import <Foundation/Foundation.h>
#import "ASIHTTPRequestDelegate.h"

#define HTTPStatusNone                0
#define HTTPStatusOK                  200
#define HTTPStatusNotModified         304
#define HTTPStatusMovedPermanently    301
#define HTTPStatusBadRequest          400
#define HTTPStatusUnauthorized        401
#define HTTPStatusForbidden           403
#define HTTPStatusNotFound            404
#define HTTPStatusInternalServerError 500
#define HTTPStatusNotImplemented      501
#define HTTPStatusBadGateway          502
#define HTTPStatusAlert               522


@interface SLURLRequest : NSObject <ASIHTTPRequestDelegate> {
    BOOL cancelled;
}


// REQUEST

@property (nonatomic, copy) NSString * httpMethod;
@property (nonatomic, copy) void(^callback)(SLURLRequest* request);
@property (nonatomic, copy) NSString * contentType; 
@property (nonatomic, strong) NSURL * url;
@property (nonatomic, strong) NSData * body; 

- (void) setBodyFromObject:(id)object; // must have JSONData as a method
- (void) setBodyFromDictionary:(NSDictionary*)dict;
- (void) setBodyFromArray:(NSArray*)arr;


- (void) sendWithCallback:(void(^)(SLURLRequest *))block;
- (void) cancel;
- (void) cleanup;

- (NSString *) errorDescription;


// RESPONSE
- (NSInteger) httpStatusCode;
- (NSDictionary *) headers; // response headers
- (NSError *) error;


// Body values
- (id) jsonValue;
- (UIImage *) imageValue;
- (NSString *) stringValue;
- (NSData *) responseData;

@end

