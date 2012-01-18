//
//  UIView+Additions.m
//  SecondScreen
//
//  Created by Dave Durazzani on 2/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIView+Additions.h"

@implementation UIView(Additions)

-(id)initWithNibName:(NSString*)name {
	Class class = [self class];
	if (!name)
		name = NSStringFromClass(class);
	
	NSArray * nibObjects = [[NSBundle mainBundle] loadNibNamed:name owner:nil options:nil];
	for (id obj in nibObjects) {
		if ([obj isKindOfClass:class]) 
			return obj;
	}
	
	return nil;
}

+(id)viewFromNibName:(NSString*)name {
    Class class = [self class];
	if (!name)
		name = NSStringFromClass(class);
	
	NSArray * nibObjects = [[NSBundle mainBundle] loadNibNamed:name owner:nil options:nil];
	for (id obj in nibObjects) {
		if ([obj isKindOfClass:class])             
			return obj;
	}
	
	return nil;
}


@end