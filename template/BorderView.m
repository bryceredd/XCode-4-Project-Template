//
//  BorderView.m
//  TVPulse
//
//  Created by TheD on 8/8/11.
//  Copyright 2011 i.TV. All rights reserved.
//

#import "BorderView.h"
#import "CoreGraphics+DDAdditions.h"

@interface BorderView()
- (void) drawBordersInContext:(CGContextRef)ctx;
@end

@implementation BorderView

@synthesize topColor;
@synthesize bottomColor;
@synthesize leftColor;
@synthesize rightColor;

@synthesize topBorderWidth;
@synthesize bottomBorderWidth;
@synthesize leftBorderWidth;
@synthesize rightBorderWidth;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) { 
        [self initColors];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) { 
        [self initColors];
    }
    return self;
}

- (void) initColors {
    self.topColor = [UIColor clearColor];
    self.bottomColor = [UIColor clearColor];
    self.leftColor = [UIColor clearColor];
    self.rightColor = [UIColor clearColor];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawBordersInContext:context];
}

- (void) drawBordersInContext:(CGContextRef)ctx {
    
    CGFloat minX = CGRectGetMinX(CGContextGetClipBoundingBox(ctx));
    CGFloat maxX = CGRectGetMaxX(CGContextGetClipBoundingBox(ctx));
    CGFloat minY = CGRectGetMinY(CGContextGetClipBoundingBox(ctx));
    CGFloat maxY = CGRectGetMaxY(CGContextGetClipBoundingBox(ctx));

    
    if(self.topBorderWidth) {
        DDDrawLine(ctx, minX, minY, maxX, minY, self.topBorderWidth, self.topColor);
    }
    
    if(self.bottomBorderWidth) {
        DDDrawLine(ctx, minX, maxY, maxX, maxY, self.bottomBorderWidth, self.bottomColor);
    }
    
    if(self.leftBorderWidth) {
        DDDrawLine(ctx, minX, minY, minX, maxY, self.leftBorderWidth, self.leftColor);
    }
    
    if(self.rightBorderWidth) {
        DDDrawLine(ctx, maxX, minY, maxX, maxY, self.rightBorderWidth, self.rightColor);
    }
    
}

@end
