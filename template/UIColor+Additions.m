//
//  UIColor+Additions.m
//  tvclient
//
//  Created by Cory Kilger on 12/3/10.
//  Copyright 2010 i.TV LLC. All rights reserved.
//

#import "UIColor+Additions.h"

#ifndef AVERAGE
#define AVERAGE(a,b)  (((a)+(b)) / 2.f)
#endif

@implementation UIColor (Additions)

+ (UIColor*) averageColorBetweenColor:(UIColor*)color1 andColor:(UIColor*)color2 {
    const CGFloat* component1 = CGColorGetComponents(color1.CGColor);
    const CGFloat* component2 = CGColorGetComponents(color2.CGColor);
    
    
    return [UIColor colorWithRed:AVERAGE(component1[0], component2[0]) 
                           green:AVERAGE(component1[1], component2[1]) 
                            blue:AVERAGE(component1[2], component2[2]) 
                           alpha:AVERAGE(component1[3], component2[3])];
}

+ (UIColor*) randomColor {
    float red = ((float)(arc4random() % 255))/255.f;
    float green = ((float)(arc4random() % 255))/255.f;
    float blue = ((float)(arc4random() % 255))/255.f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.f];
}

@end
