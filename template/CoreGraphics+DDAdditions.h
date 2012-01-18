//
//  CoreGraphics+DDAdditions.h
//  SecondScreen
//
//  Created by Dave Durazzani on 4/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


// This addition is meant to be thread safe, as such, it is not going to
// use any UIKit calls!!! All implemented in Core Graphics.

static inline void DDDrawLine(CGContextRef context, float x1, float y1, float x2, float y2, float width, UIColor * color) {
    CGContextSetLineWidth(context, width);
    CGContextSetStrokeColorWithColor(context, color.CGColor);		
    CGContextMoveToPoint(context, x1, y1);
    CGContextAddLineToPoint(context, x2, y2);
    CGContextStrokePath(context);
}

static inline CGImageRef DDCreateImageWithAlphaFromImage(CGImageRef image) {
    
    size_t width = CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);
    
    // The bitsPerComponent and bitmapInfo values are hard-coded to prevent an "unsupported parameter combination" error
    CGContextRef offscreenContext = CGBitmapContextCreate(NULL,
                                                          width,
                                                          height,
                                                          8,
                                                          0,
                                                          CGImageGetColorSpace(image),
                                                          kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    
    // Draw the image into the context and retrieve the new image, which will now have an alpha layer
    CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), image);
    CGImageRef imageRefWithAlpha = CGBitmapContextCreateImage(offscreenContext);
    
    // Clean up
    CGContextRelease(offscreenContext);
    
    return imageRefWithAlpha;
}

static inline CGImageRef DDCreateNormalizedImageFromImage(CGImageRef image) {
    // We want to normalize the image since it could be not as native as it
    // needs to be to perform operations on it. This will allow to always
    // create a context in following manipulations!
    
    size_t width = CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, 
                                                         width, 
                                                         height, 
                                                         8, (4 * width), 
                                                         colorspace, 
                                                         kCGImageAlphaPremultipliedFirst);
    
     CGColorSpaceRelease(colorspace);
    
    if(context == NULL) {
		printf("Context for normalizing image not created!\n");
		return nil;
	}
    
    CGContextSetInterpolationQuality(context, kCGInterpolationDefault);
    CGRect destRect = CGRectMake(0, 0, width, height);
    CGContextDrawImage(context, destRect, image);
    CGImageRef normalizedImage = CGBitmapContextCreateImage(context);
    
    //Cleanup
    CGContextRelease(context);
    
    return normalizedImage;    

}

static inline CGImageRef DDCreateFlippedImageOnYOfImage(CGImageRef image) {
    CGContextRef currentContext = CGBitmapContextCreate(NULL,
                                                        CGImageGetWidth(image) ,
                                                        CGImageGetHeight(image),
                                                        CGImageGetBitsPerComponent(image),
                                                        0,
                                                        CGImageGetColorSpace(image),
                                   //                     CGImageGetBitmapInfo(image));
                                                        kCGImageAlphaPremultipliedFirst);
    
    if(currentContext == NULL) {
		printf("Context for flipping image not created!\n");
		return nil;
	}
    
    CGAffineTransform flippedVertical = CGAffineTransformMake(
                                                              1,
                                                              0,
                                                              0,
                                                              -1,
                                                              0,
                                                              CGImageGetHeight(image)
                                                              );
    
    CGContextConcatCTM(currentContext, flippedVertical);
    CGContextDrawImage(currentContext, CGContextGetClipBoundingBox(currentContext), image);
    
    CGImageRef flippedImageRef = CGBitmapContextCreateImage(currentContext);
    
    // Cleanup
    CGContextRelease(currentContext);
    
    return flippedImageRef;
}

static inline CGImageRef DDCreateResizedImageFromImage(CGImageRef image, CGSize toSize) {
    
	CGContextRef context = CGBitmapContextCreate(NULL,toSize.width,toSize.height,
												 CGImageGetBitsPerComponent(image),
												 0,
												 CGImageGetColorSpace(image),
												 CGImageGetAlphaInfo(image));
    
	
	if(context == NULL) {
        NSLog(@"********COULD NOT CREATE CONTEXT FOR RESIZING IMAGE**********");
		return nil;
    }
    
    CGRect contextRect = CGContextGetClipBoundingBox(context);
    CGRect resizedRect = CGRectMake(contextRect.origin.x,
                                    contextRect.origin.y,
                                    toSize.width,
                                    toSize.height);
    
    // draw image to context
	CGContextDrawImage(context, resizedRect, image);
    
    CGImageRef imgRef = CGBitmapContextCreateImage(context);
    
    //Cleanup
    CGContextRelease(context);

    return imgRef;
}

static inline CGImageRef DDCreateImageWithRoundCornesFromImage(CGImageRef image, CGFloat radius) {
    CGImageRef imageWithAlpha = DDCreateImageWithAlphaFromImage(image);
    CGFloat width = CGImageGetWidth(imageWithAlpha);
    CGFloat height = CGImageGetHeight(imageWithAlpha);
    
    // Build a context that's the same dimensions as the new size
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 width,
                                                 height,
                                                 CGImageGetBitsPerComponent(imageWithAlpha),
                                                 0,
                                                 CGImageGetColorSpace(imageWithAlpha),
                                                 CGImageGetBitmapInfo(imageWithAlpha));
    
    if(context == NULL) {
        NSLog(@"********COULD NOT CREATE CONTEXT FOR ROUND CORNERS IMAGE**********");
        CGImageRelease(imageWithAlpha);
		return nil;
    }
    
    // Create a clipping path with rounded corners
    CGContextBeginPath(context);
    
    CGRect contextRect = CGContextGetClipBoundingBox(context);

    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(contextRect), CGRectGetMinY(contextRect));
    CGContextScaleCTM(context, radius, radius);
    CGFloat fw = CGRectGetWidth(contextRect) / radius;
    CGFloat fh = CGRectGetHeight(contextRect) / radius;
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
    
    CGContextClosePath(context);
    CGContextClip(context);
    
    // Draw the image to the context; the clipping path will make anything outside the rounded rect transparent
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image);
    
    // Create a CGImage from the context
    CGImageRef clippedImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGImageRelease(imageWithAlpha);

    
    return clippedImage;
}

static inline CGImageRef DDCreateShadowOnImage(CGImageRef image, CGFloat radius, CGFloat borderWidth)  {
    
    CGFloat width = CGImageGetWidth(image);
    CGFloat height = CGImageGetHeight(image);
    
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB(); //c
    CGContextRef shadowContext = CGBitmapContextCreate(NULL, //c
                                                       width + radius,
                                                       height + radius,
                                                       CGImageGetBitsPerComponent(image),
                                                       0,
                                                       colourSpace, kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colourSpace);
    
    if(shadowContext == NULL) {
        printf("Shadow Context not created!\n");
        return nil;
    }
    
    
    CGContextSetShadowWithColor(shadowContext,
                                CGSizeMake(0, 0),
                                radius,
                                [UIColor blackColor].CGColor);
    
    CGContextDrawImage(shadowContext,
                       CGRectMake(radius+borderWidth,
                                  radius+borderWidth,
                                  width-(radius+2*borderWidth),
                                  height-(radius+2*borderWidth)),
                       image);
    
    CGImageRef shadowedCGImage = CGBitmapContextCreateImage(shadowContext); //c
    
    CGContextRelease(shadowContext);
    
    return shadowedCGImage;
    
    
    return nil;
}

static inline CGImageRef DDCreateBorderOnImage(CGImageRef image, CGFloat radius, CGFloat lineWidth, CGFloat r, CGFloat g, CGFloat b, CGFloat a) {
    CGFloat width = CGImageGetWidth(image);
    CGFloat height = CGImageGetHeight(image);
    
    // Build a context that's the same dimensions as the new size
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 width,
                                                 height,
                                                 CGImageGetBitsPerComponent(image),
                                                 0,
                                                 CGImageGetColorSpace(image),
                                                 CGImageGetBitmapInfo(image));
    
    if(context == NULL) {
        NSLog(@"********COULD NOT CREATE CONTEXT FOR ROUND CORNERS IMAGE**********");
		return nil;
    }
    
    // Draw the image to the context; the clipping path will make anything outside the rounded rect transparent
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image);
    
    // set stroking color and draw circle
	CGContextSetRGBStrokeColor(context, r, g, b, a);
    CGContextSetLineWidth(context, lineWidth);
    
    CGRect smallerRect = CGContextGetClipBoundingBox(context);

    // Create border
    CGFloat minx = CGRectGetMinX(smallerRect), 
    midx = CGRectGetMidX(smallerRect),
    maxx = CGRectGetMaxX(smallerRect); 
    CGFloat miny = CGRectGetMinY(smallerRect),
    midy = CGRectGetMidY(smallerRect),
    maxy = CGRectGetMaxY(smallerRect); 
    
    CGContextMoveToPoint(context, minx, midy); 
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius); 
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius); 
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius); 
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius); 
    CGContextClosePath(context); 
    
    CGContextDrawPath(context, kCGPathStroke);
    
    // Create a CGImage from the context
    CGImageRef imageWithBorder = CGBitmapContextCreateImage(context);
    
    // Cleanup
    CGContextRelease(context);
    
    return imageWithBorder;
}

static inline CGImageRef DDCreateImageFromWebview(UIWebView* webView) {
    
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	if(colorSpace == NULL) {
		printf("Error allocating color space.\n");
		return nil;
	}
    
	CGContextRef context = CGBitmapContextCreate(NULL,
												 webView.bounds.size.width,
												 webView.bounds.size.height,
												 8,
												 webView.bounds.size.width * 4,
												 colorSpace,
												 kCGImageAlphaPremultipliedLast);
	CGColorSpaceRelease(colorSpace);
    
    if(context == NULL) {
		printf("Context not created!\n");
		return nil;
	}
    
    [webView.layer renderInContext:context];
    
    CGImageRef snapshotRef = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    
    return snapshotRef;
}

static inline void DDDrawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef  endColor) {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = [NSArray arrayWithObjects:(__bridge id)startColor, (__bridge id)endColor, nil];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, 
                                                        (__bridge CFArrayRef) colors, locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

