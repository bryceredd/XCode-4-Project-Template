//
//  BorderView.h
//  TVPulse
//
//  Created by TheD on 8/8/11.
//  Copyright 2011 i.TV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface BorderView : UIView

@property(nonatomic) int topBorderWidth;
@property(nonatomic) int bottomBorderWidth;
@property(nonatomic) int leftBorderWidth;
@property(nonatomic) int rightBorderWidth;
@property(nonatomic, strong) UIColor* topColor;
@property(nonatomic, strong) UIColor* bottomColor;
@property(nonatomic, strong) UIColor* leftColor;
@property(nonatomic, strong) UIColor* rightColor;

- (void) initColors;

@end
