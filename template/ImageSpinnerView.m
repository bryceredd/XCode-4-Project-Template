//
//  ImageSpinnerView.m
//  tvtag
//
//  Created by Bryce Redd on 11/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageSpinnerView.h"

@interface ImageSpinnerView() 
@property(nonatomic, strong) UIActivityIndicatorView* spinner;
- (void) createSpinner;
@end

@implementation ImageSpinnerView

@synthesize spinner;

- (id) initWithCoder:(NSCoder *)aDecoder {
    if((self = [super initWithCoder:aDecoder])) {
        [self createSpinner];
    } return self;
}

- (id) initWithFrame:(CGRect)frame {
    if((self = [super initWithFrame:frame])) {
        [self createSpinner];
    } return self;
}

- (id) initWithImage:(UIImage *)img {
    if((self = [super initWithImage:img])) {
        [self createSpinner];
        self.image = img;
    } return self;
}

- (id) initWithImage:(UIImage *)img highlightedImage:(UIImage *)highlightedImage {
   if((self = [super initWithImage:img highlightedImage:highlightedImage])) {
        [self createSpinner];
        self.image = img;
    } return self;
}

- (void) setImage:(UIImage *)image {
    [super setImage:image];
    
    if(image) { 
        [spinner stopAnimating];
        self.alpha = 0.f;
        [UIView animateWithDuration:.25 animations:^{
            self.alpha = 1.f;
        }];
    }
    else [spinner startAnimating];
        
}

- (void) createSpinner {
    if(spinner) return;
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    spinner.hidesWhenStopped = YES;
    spinner.center = self.center;
    [spinner startAnimating];
    
    [self addSubview:spinner];
}


@end
