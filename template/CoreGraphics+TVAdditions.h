/*
 *  CoreGraphics+TVAdditions.h
 *  tvclient
 *
 *  Created by Cory Kilger on 1/4/11.
 *  Copyright 2011 i.TV LLC. All rights reserved.
 *
 */

// You are responsible for releasing this object.
static inline CGPathRef TVPathCreateWithRoundedRect(CGRect rect, CGFloat radius) {
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL, CGRectGetMinX(rect)+radius, CGRectGetMinY(rect));
	CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect)-radius, CGRectGetMinY(rect));
	CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMinY(rect)+radius, radius);
	CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect)-radius);
	CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMaxX(rect)-radius, CGRectGetMaxY(rect), radius);
	CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect)+radius, CGRectGetMaxY(rect));
	CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMaxY(rect)-radius, radius);
	CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect)+radius);
	CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMinX(rect)+radius, CGRectGetMinY(rect), radius);
	return path;
}

// You are responsible for releasing this object.
static inline CGPathRef TVPathCreateWithRoundedRectWithOptions(CGRect rect, CGFloat radius, BOOL top, BOOL bottom) {
	CGMutablePathRef path = CGPathCreateMutable();
	
	// Top edge
	CGPathMoveToPoint(path, NULL, CGRectGetMinX(rect)+radius, CGRectGetMinY(rect));
	CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect)-radius, CGRectGetMinY(rect));
	
	// Top right corner
	if (top)
		CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMinY(rect)+radius, radius);
	else {
		CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect));
		CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect)+radius);
	}
	
	// Right edge
	CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect)-radius);
	
	// Bottom right corner
	if (bottom)
		CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMaxX(rect)-radius, CGRectGetMaxY(rect), radius);
	else {
		CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
		CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect)-radius, CGRectGetMaxY(rect));
	}
	
	// Bottom edge
	CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect)+radius, CGRectGetMaxY(rect));
	
	// Bottom left corner
	if (bottom)
		CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMaxY(rect)-radius, radius);
	else {
		CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect));
		CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect)-radius);
	}
	
	// Left edge
	CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect)+radius);
	
	// Top left corner
	if (top)
		CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMinX(rect)+radius, CGRectGetMinY(rect), radius);
	else {
		CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect));
		CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect)+radius, CGRectGetMinY(rect));
	}
	
	return path;
}