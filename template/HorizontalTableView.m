//
//  HorizontalTableView.m
//  tvtag
//
//  Created by Bryce Redd on 1/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HorizontalTableView.h"

@interface HorizontalTableView() {
    int leftIndex, rightIndex; // these indicate the next _blank_ space
}
@property(nonatomic, strong) NSMutableSet* queue;
@property(nonatomic, strong) NSMutableArray* displayedViews;
- (void) load;
- (void) addAdditionalViews;
- (void) removeOffscreenViews;
- (UIView*) queuedView;
- (void) queueView:(UIView*)view;
@end

@implementation HorizontalTableView
@synthesize queue, displayedViews, tableDelegate;

- (id) init {
    if ((self = [super init])) {
        [self load];
    } return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    if((self = [super initWithCoder:aDecoder])) {
        [self load];
    } return self;
}

- (id) initWithFrame:(CGRect)frame {
    if((self = [super initWithFrame:frame])) {
        [self load];
    } return self;
}

- (void) load {
    self.delegate = self;
    self.queue = [NSMutableSet set];
    self.displayedViews = [NSMutableArray array];
    leftIndex = -1;
    rightIndex = 0;
}

- (void) setTabledelegate:(id<HorizontalTableViewDelegate>)d {
    tableDelegate = d;
    
    [self reloadData];
}

- (void) reloadData {
    [self removeOffscreenViews];
    [self addAdditionalViews];
}

- (void) removeOffscreenViews {    
    if(![displayedViews count]) { return; }

    float padding = 10.f;


    // chop left
    BOOL shouldCut = NO;
    do {
        UIView* view = [displayedViews objectAtIndex:0];
        float leftTrimThreshold = view.frame.origin.x + view.frame.size.width + padding;
        shouldCut = displayedViews.count && leftTrimThreshold < self.contentOffset.x;
        
        if(shouldCut) {
            
            [view removeFromSuperview];
            [self queueView:view];
            [displayedViews removeObject:view];
            leftIndex++;
            
        }
        
    } while (shouldCut);
    
    
    
    if(![displayedViews count]) { return; }
    
    
    
    // chop right
    shouldCut = NO;
    do {
        UIView* view = [displayedViews lastObject];
        float rightTrimThreshold = view.frame.origin.x - padding;
        shouldCut = displayedViews.count && (self.contentOffset.x + self.frame.size.width < rightTrimThreshold);
        
        if(shouldCut) {
            
            [view removeFromSuperview];
            [self queueView:view];
            [displayedViews removeObject:view];
            rightIndex--;
            
        }
        
    } while (shouldCut);
}

- (void) addAdditionalViews {

    // add left
    BOOL shouldAdd = NO;
    do {
        if(!displayedViews.count) continue;
        
        UIView* first = [displayedViews objectAtIndex:0];
        shouldAdd = self.contentOffset.x < first.frame.origin.x;
        
        if(shouldAdd) {
            UIView* view = [tableDelegate viewForIndex:leftIndex];
            if(!view) break;
            
            --leftIndex;
            [displayedViews insertObject:view atIndex:0];
            setFrameX(view, first.frame.origin.x - view.frame.size.width);
            setFrameY(view, 0);
            setFrameHeight(view, CGRectGetHeight(self.frame));
            [self addSubview:view];
            
        }
        
    } while (shouldAdd);
    
    
    // add right
    shouldAdd = NO;
    do {
        
        UIView* last = [displayedViews lastObject];

        shouldAdd = !last || self.contentOffset.x + self.frame.size.width > last.frame.origin.x + last.frame.size.width;

        
        if(shouldAdd) {
            
            
            UIView* view = [tableDelegate viewForIndex:rightIndex];
            if(!view) break;
            
            ++rightIndex;
            [displayedViews addObject:view];
            setFrameX(view, last.frame.origin.x + last.frame.size.width);
            setFrameY(view, 0);
            setFrameHeight(view, CGRectGetHeight(self.frame));
            [self addSubview:view];
            
            
            if(view.frame.origin.x + view.frame.size.width > self.contentSize.width)
                [self setContentSize:CGSizeMake(view.frame.origin.x + view.frame.size.width, 0)];
        }
        
    } while (shouldAdd);
}


- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    [self reloadData];
}


- (UIView*) queuedView {
    if(![queue count]) return nil;
    
    UIView* view;
    @synchronized(queue) {
        view = [queue anyObject];
        [queue removeObject:view];
    }
    
    return view;
}

- (void) queueView:(UIView*)view {
    @synchronized(queue) {
        [queue addObject:view];
    }
}

@end
