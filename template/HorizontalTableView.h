//
//  HorizontalTableView.h
//  tvtag
//
//  Created by Bryce Redd on 1/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HorizontalTableViewDelegate <NSObject>
- (UIView*) viewForIndex:(int)index;
@end

/* ok, this class works a lot like uitableview - but there are a few key
differences, mostly because i am too lazy to make a full clone:

1. you dont need to specify widths of your cells (which are just views) it just 
reads them on the fly.  consequently your scroll bar "grows" as you scroll

2. you dont need to specify the count of the cells (because our scroll bar just grows,
so theres no use for getting a count)  it just draws as many cells as the delegate returns.
when the delegate returns nil, it stops "growing"

3. the queue doesn't use an identifier, so queuedView just returns a random queued view*/

@interface HorizontalTableView : UIScrollView <UIScrollViewDelegate>
@property(nonatomic, weak) NSObject<HorizontalTableViewDelegate>* tableDelegate;
- (UIView*) queuedView;
- (void) reloadData;
@end
