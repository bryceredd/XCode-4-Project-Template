//
//  TVData.m
//  tvtag
//
//  Created by Bryce Redd on 11/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SLData.h"

@implementation SLData

@synthesize definition;

+ (id) dataWithDefinition:(NSDictionary*)definition {
    return [[self alloc] initWithDefinition:definition];
}

- (id) initWithDefinition:(NSDictionary*)dictionary {
    if((self = [super init])) {
        self.definition = dictionary;
    }
    return self;
}


@end
