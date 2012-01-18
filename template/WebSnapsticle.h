//
//  WebSnapsticle.h
//  SecondScreen
//
//  Created by TheD on 4/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WebSnapsticle : NSObject <UIWebViewDelegate> { 
    BOOL hasCleanedUp;
}
+ (id) snapsticleFor:(NSURL*)url delegateView:(UIView*)dView withSize:(CGSize)size callback:(void(^)(UIImage*))callback;
@end
