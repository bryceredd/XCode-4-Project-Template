//
//  UIColor+Additions.h
//  tvclient
//
//  Created by Cory Kilger on 12/3/10.
//  Copyright 2010 i.TV LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIColor (Additions)

+ (UIColor*) averageColorBetweenColor:(UIColor*)color1 andColor:(UIColor*)color2;
+ (UIColor*) randomColor;

@end
