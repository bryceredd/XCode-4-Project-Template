//
//  GradientView.m
//  tvclient
//
//  Created by Bryce Redd on 12/19/11.
//  Copyright (c) 2011 i.TV LLC. All rights reserved.
//

#import "GradientView.h"
#import <QuartzCore/QuartzCore.h>

@interface GradientView() 
@property(nonatomic, retain) CAGradientLayer* gradientLayer;
@end

@implementation GradientView

@synthesize colors, gradientLayer, isHorizontal;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    
    }
    return self;
}

- (void) setColors:(NSArray *)array {
    colors = array;
    
    [gradientLayer removeFromSuperlayer];
    
    self.gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = array;
    
    self.isHorizontal = self.isHorizontal;
    
    [self.layer insertSublayer:gradientLayer atIndex:0];
}

- (void) setIsHorizontal:(BOOL)flag {
    isHorizontal = flag;
    
    if(isHorizontal) {
        gradientLayer.startPoint = CGPointMake(0, 0.5);
        gradientLayer.endPoint = CGPointMake(1.0, 0.5);
    } else {
        gradientLayer.startPoint = CGPointMake(0.5, 0);
        gradientLayer.endPoint = CGPointMake(0.5, 1.0);
    }   
}

-(void)layoutSubviews {
    gradientLayer.frame = self.bounds;
}

@end
