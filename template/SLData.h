//
//  TVData.h
//  tvtag
//
//  Created by Bryce Redd on 11/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLData : NSObject
@property(nonatomic, strong) NSDictionary* definition;

+ (id) dataWithDefinition:(NSDictionary*)definition;
- (id) initWithDefinition:(NSDictionary*)definition;

@end
