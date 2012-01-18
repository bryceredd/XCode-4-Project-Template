//
//  NSArray+Reverse.h
//  tvtag
//
//  Created by Bryce Redd on 12/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSArray(Reverse)
- (NSArray *)reversedArray;
@end

@interface NSMutableArray (Reverse)
- (void)reverse;
@end