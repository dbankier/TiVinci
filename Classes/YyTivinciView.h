/**
 * Titanium Paint Module
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "TiUIView.h"
#import "YyTivinciModule.h"



@interface YyTivinciView : TiUIView {
@private
	UIImageView *drawImage;
	//CGPoint lastPoint;
	CGFloat strokeWidth;
	CGFloat strokeAlpha;
	CGColorRef strokeColor;
    NSString* htmlColor;
    bool strokeDynamic;
    bool blurredEdges;
    
    double lastWidth;
    
	DrawModeSelection drawMode;
	//NSMutableArray *pointsArray;
    NSMutableArray *imageHistory;
    
    
    void *cacheBitmap;
    CGContextRef cacheContext;
    
    CGPoint point0;
    CGPoint point1;
    CGPoint point2;
    CGPoint point3;
    
}
@end
