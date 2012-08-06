/**
 * Titanium Paint Module
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "YyTivinciView.h"
#import "TiUtils.h"


@implementation YyTivinciView

- (id)init
{
	if ((self = [super init]))
	{
		drawMode = DrawModeCurve;
		strokeWidth = 5;
        strokeAlpha = 1;
        strokeDynamic = false;
        blurredEdges = false;
		strokeColor = CGColorRetain([[TiUtils colorValue:@"#000"] _color].CGColor);
        htmlColor=@"#000";
        imageHistory = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor clearColor];
	}
	return self;
}

- (BOOL) initContext:(CGSize)size withImage:(CGImageRef) image {
	
    if (cacheContext != nil) {
        [cacheContext release];
        free(cacheBitmap);
    }
	int bitmapByteCount;
	int	bitmapBytesPerRow;
    float scaleFactor = [[UIScreen mainScreen] scale];
	
	// Declare the number of bytes per row. Each pixel in the bitmap in this
	// example is represented by 4 bytes; 8 bits each of red, green, blue, and
	// alpha.
	bitmapBytesPerRow = (size.width * 4)* scaleFactor;
	bitmapByteCount = (bitmapBytesPerRow * size.height)* scaleFactor;
	
	// Allocate memory for image data. This is the destination in memory
	// where any drawing to the bitmap context will be rendered.
    
    cacheBitmap = malloc( bitmapByteCount );
    if (cacheBitmap == NULL){
        return NO;
    }
    
    
	cacheContext = CGBitmapContextCreate (cacheBitmap, size.width * scaleFactor, size.height * scaleFactor, 8, bitmapBytesPerRow, CGColorSpaceCreateDeviceRGB(), kCGImageAlphaPremultipliedLast);
    if(scaleFactor > 1) {
        CGContextScaleCTM(cacheContext, 2, 2);
    }
    //kCGImageAlphaNoneSkipFirst);
    
    CGContextClearRect(cacheContext, self.bounds);
    if (image != nil) {
        CGContextDrawImage(cacheContext, self.bounds, image);
    }
	return YES;
}

- (void)dealloc
{
    [imageHistory release];
	CGColorRelease(strokeColor);
	[super dealloc];
}


- (void)drawSolidLine
{
    CGContextBeginPath(cacheContext);
	CGContextMoveToPoint(cacheContext, point2.x == -1 ? point3.x : point2.x, point2.y == -1 ? point3.y : point2.y);
	CGContextAddLineToPoint(cacheContext, point3.x, point3.y);
}

- (void)drawCircle
{
    CGRect rectangle = CGRectMake( point2.x, point2.y, point3.x - point2.x , point3.y - point2.y);
    CGContextAddEllipseInRect(cacheContext, rectangle);
}

- (void)drawRectangle
{
    CGRect rectangle = CGRectMake( point2.x, point2.y, point3.x - point2.x , point3.y - point2.y);
    
    CGContextAddRect(cacheContext, rectangle);
}

- (NSDictionary *)drawEraserLine
{
    // This is an implementation of Bresenham's line algorithm
    int x0 = point2.x, y0 = point2.y;
    int x1 = point3.x, y1 = point3.y;
    int dx = abs(x0-x1), dy = abs(y0-y1);
    int sx = x0 < x1 ? 1 : -1, sy = y0 < y1 ? 1 : -1;
    int err = dx - dy, e2;
    
    while(true)
    {
        CGContextClearRect(cacheContext, CGRectMake(x0, y0, strokeWidth, strokeWidth));
        if (x0 == x1 && y0 == y1)
        {
            break;
        }
        e2 = 2 * err;
        if (e2 > -dy)
        {
            err -= dy;
            x0 += sx;
        }
        if (e2 < dx)
        {
            err += dx;
            y0 += sy;
        }
    }
    NSDictionary *props = nil;
    if ([self.proxy _hasListeners:@"draw"]){
        props = [NSDictionary dictionaryWithObjectsAndKeys:
                 @"draw",@"type",
                 [NSNumber numberWithInt: drawMode], @"drawMode",
                 [NSNumber numberWithFloat:strokeWidth], @"width",
                 [TiUtils pointToDictionary:point2],@"start",
                 [TiUtils pointToDictionary:point3], @"end",
                 nil];
        //[self.proxy fireEvent:@"draw" withObject:props]; 
    }
    return props;
}
- (NSDictionary *)drawBezierCurve {
    CGContextBeginPath(cacheContext);
    CGFloat x0,y0,x1,y1,x2,y2,x3,y3;
    
    NSDictionary * props = nil;
    if(point0.x > -1){
        x3 = point3.x;
        y3 = point3.y;	
        
        x2 = point2.x;
        y2 = point2.y;						
        
        x1 = point1.x;
        y1 = point1.y;						
        
        x0 = point0.x;
        y0 = point0.y;						
        
        
        double smooth_value = 0.7;
        
        double xc1 = (x0 + x1) / 2.0;
        double yc1 = (y0 + y1) / 2.0;
        double xc2 = (x1 + x2) / 2.0;
        double yc2 = (y1 + y2) / 2.0;
        double xc3 = (x2 + x3) / 2.0;
        double yc3 = (y2 + y3) / 2.0;
        
        double len1 = sqrt((x1-x0) * (x1-x0) + (y1-y0) * (y1-y0));
        double len2 = sqrt((x2-x1) * (x2-x1) + (y2-y1) * (y2-y1));
        double len3 = sqrt((x3-x2) * (x3-x2) + (y3-y2) * (y3-y2));
        
        double k1 = len1 / (len1 + len2);
        double k2 = len2 / (len2 + len3);
        
        double xm1 = xc1 + (xc2 - xc1) * k1;
        double ym1 = yc1 + (yc2 - yc1) * k1;
        
        double xm2 = xc2 + (xc3 - xc2) * k2;
        double ym2 = yc2 + (yc3 - yc2) * k2;
        
        // Resulting control points. Here smooth_value is mentioned
        // above coefficient K whose value should be in range [0...1].
        double ctrl1_x = xm1 + (xc2 - xm1) * smooth_value + x1 - xm1;
        double ctrl1_y = ym1 + (yc2 - ym1) * smooth_value + y1 - ym1;
        
        double ctrl2_x = xm2 + (xc2 - xm2) * smooth_value + x2 - xm2;
        double ctrl2_y = ym2 + (yc2 - ym2) * smooth_value + y2 - ym2;	
        
        CGContextMoveToPoint(cacheContext,x1,y1);
        if (len2 < 2) {
            CGContextAddLineToPoint(cacheContext,x2,y2);
        } else {
            CGContextAddCurveToPoint(cacheContext,ctrl1_x,ctrl1_y,ctrl2_x,ctrl2_y, x2,y2);
        }
        
        
        double step_limit = 0.05; // smallest percentage change in width
        double width_limit = 0.25; // limit for dynamic width step
        
        double width = strokeWidth * (1 - ((len1 -10)/40 * (1-width_limit)));
        if (lastWidth > -1) {
            if (abs(width - lastWidth) > step_limit) {
                if (width > lastWidth) {
                    width = lastWidth + step_limit;
                } else {
                    width = lastWidth -step_limit;
                }
            }
        }
        
        if (width > strokeWidth || !strokeDynamic) {
            width = strokeWidth;
        } else if (width < strokeWidth * width_limit) {
            width = strokeWidth * width_limit;
        }
        
        CGContextSetLineWidth(cacheContext, width);
        lastWidth = width;
        if (blurredEdges) {
            CGContextSetShadowWithColor(cacheContext, CGSizeMake(0.0, 0.0), 2.0, strokeColor);
        }
        lastWidth = width;
        if ([self.proxy _hasListeners:@"draw"]){
            if (len2 < 2) {
                props = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"draw",@"type",
                           [NSNumber numberWithInt: DrawModeStraightLine], @"drawMode",
                           [NSNumber numberWithFloat:strokeAlpha], @"alpha",
                           [NSNumber numberWithFloat:strokeWidth], @"width",
                           htmlColor, @"color",
                           [TiUtils pointToDictionary:point2 ],@"start",
                           [TiUtils pointToDictionary:point3 ], @"end",
                           nil];
            }else {
                props = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"draw",@"type",
                         [NSNumber numberWithInt: drawMode], @"drawMode",
                         [NSNumber numberWithFloat:strokeAlpha], @"alpha",
                         [NSNumber numberWithDouble:width], @"width",
                         htmlColor, @"color",
                         [TiUtils pointToDictionary:point1 ],@"start",
                         [TiUtils pointToDictionary:point2 ], @"end",
                         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:ctrl1_x], @"x",
                          [NSNumber numberWithDouble:ctrl1_y], @"y",nil], @"control1",
                         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:ctrl2_x], @"x",
                          [NSNumber numberWithDouble:ctrl2_y], @"y",nil], @"control2",
                         nil];
            }
            //[self.proxy fireEvent:@"draw" withObject:props]; 
        }
    }
	CGContextSetShouldAntialias(cacheContext,YES); 
    return props;
}	

- (void)drawAt:(CGPoint)currentPoint touchEnd:(bool)isEnd
{
    if ((drawMode == DrawModeStraightLine || drawMode == DrawModeCircle || drawMode == DrawModeRectangle)){
        if ([imageHistory count] == 0) {
            [self clearImage];
        } else {
            [self drawImage: [imageHistory objectAtIndex:[imageHistory count] -1]];
        }
    }
    NSDictionary *props;
    if (drawMode == DrawModeErase) {
        props = [self drawEraserLine];
    } else {
        CGContextSetLineCap(cacheContext, kCGLineCapRound);
        CGContextSetLineWidth(cacheContext, strokeWidth);
        CGContextSetAlpha(cacheContext, strokeAlpha);
        CGContextSetStrokeColorWithColor(cacheContext, strokeColor);
        
        if (drawMode == DrawModeCurve && (point0.x > -1 || !isEnd)) {
            props = [self drawBezierCurve];
        } else if (drawMode == DrawModeCircle) {
            [self drawCircle];
        } else if (drawMode == DrawModeRectangle) {
            [self drawRectangle];
        } else {
            [self drawSolidLine];
        }
    }
    CGContextStrokePath(cacheContext);
    
    if ((drawMode == DrawModeErase || (drawMode == DrawModeCurve && point1.x > -1)) && [self.proxy _hasListeners:@"draw"]){
        [self.proxy fireEvent:@"draw" withObject:props]; 
    }
    CGRect dirtyPoint1, dirtyPoint2;
    double delta = strokeWidth * 2;
    if (drawMode == DrawModeCurve && point1.x > -1) {
        dirtyPoint1 = CGRectMake(point1.x-strokeWidth, point1.y-strokeWidth, delta, delta);
        dirtyPoint2 = CGRectMake(point2.x-strokeWidth, point2.y-strokeWidth, delta, delta);
    } else {
        dirtyPoint1 = CGRectMake(point2.x-strokeWidth, point2.y-strokeWidth, delta, delta);
        dirtyPoint2 = CGRectMake(point3.x-strokeWidth, point3.y-strokeWidth, delta, delta);
    } 
    [self setNeedsDisplayInRect:CGRectUnion(dirtyPoint1, dirtyPoint2)];
    
}

/* 
 
 UIView Functions 
 
 */

- (CGImageRef) extractImage 
{
    return CGBitmapContextCreateImage(cacheContext);
}

- (void) drawImage: (CGImageRef) inImage
{
    [self initContext:[self bounds].size withImage: inImage];
    [self setNeedsDisplay];
}

- (void) clearImage {
    [self initContext:[self bounds].size withImage: nil];
    [self setNeedsDisplay];
}

/*
 
 TOUCH EVENTS
 
 */

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    if (cacheContext == nil) {
        [self initContext:[self bounds].size withImage: nil];
    }
    lastWidth = -1;
	[super touchesBegan:touches withEvent:event];
    [imageHistory addObject:[self extractImage]];
	UITouch *touch = [touches anyObject];
    if (drawMode == DrawModeCurve || drawMode == DrawModeErase) {
        point0 = CGPointMake(-1, -1);
        point1 = CGPointMake(-1, -1); // previous previous point
        point2 = CGPointMake(-1, -1); // previous touch point
        point3 = [touch locationInView:self]; // current touch point 
    } else {
        point0 = CGPointMake(-1, -1);
        point1 = CGPointMake(-1, -1); // previous previous point
        point2 = [touch locationInView:self]; // previous touch point
        point3 = CGPointMake(-1, -1); // current touch point 
    }
    
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{
	[super touchesMoved:touches withEvent:event];
	UITouch *touch = [touches anyObject];
    if (drawMode == DrawModeCurve || drawMode == DrawModeErase) {
        point0 = point1;
        point1 = point2;
        point2 = point3;
        point3 = [touch locationInView:self]; }
    else {
        point3 = [touch locationInView:self];
    }
    [self drawAt:point3 touchEnd: false];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
	[super touchesEnded:touches withEvent:event];
	UITouch *touch = [touches anyObject];
    if (drawMode == DrawModeCurve || drawMode == DrawModeErase) {
        point0 = point1;
        point1 = point2;
        point2 = point3;
        point3 = [touch locationInView:self]; }
    else {
        point3 = [touch locationInView:self];
    }
	[self drawAt:point3 touchEnd: true];
    int mode = drawMode;
    if (drawMode == DrawModeCurve && point0.x == -1) {
        mode = DrawModeStraightLine;
    }
    if ([self.proxy _hasListeners:@"draw"]){
        if (!(mode == DrawModeCurve || mode == DrawModeErase)) {
            NSDictionary *props = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"draw",@"type",
                                   [NSNumber numberWithInt: mode], @"drawMode",
                                   [NSNumber numberWithFloat:strokeAlpha], @"alpha",
                                   [NSNumber numberWithFloat:strokeWidth], @"width",
                                   htmlColor, @"color",
                                   [TiUtils pointToDictionary:point2 ],@"start",
                                   [TiUtils pointToDictionary:point3 ], @"end",
                                   nil];
            [self.proxy fireEvent:@"draw" withObject:props]; 
        }
    }
}

- (void) drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGImageRef cacheImage = CGBitmapContextCreateImage(cacheContext);
    if (drawMode==DrawModeErase) {
        CGContextClearRect(context, self.bounds);
    }
    CGContextDrawImage(context, self.bounds, cacheImage);
    CGImageRelease(cacheImage);
}





#pragma mark Public APIs



-(void) setDrawMode_:(id)mode
{
    drawMode = [TiUtils intValue:mode];
}

- (void)setStrokeWidth_:(id)width
{
	strokeWidth = [TiUtils floatValue:width];
}

- (void)setStrokeDynamic_:(id)value
{
    strokeDynamic = [TiUtils boolValue:value];
}

- (void) setBlurredEdges_: (id)value
{
    blurredEdges = [TiUtils boolValue:value];
}

- (void)setStrokeColor_:(id)value
{
	CGColorRelease(strokeColor);
    htmlColor = [TiUtils stringValue:value];
	TiColor *color = [TiUtils colorValue:value];
	strokeColor = [color _color].CGColor;
	CGColorRetain(strokeColor);
}

- (void)setStrokeAlpha_:(id)alpha
{
    strokeAlpha = [TiUtils floatValue:alpha] / 255.0;
}

- (void)setImage_:(id)value
{
	UIImage *image = value==nil ? nil : [TiUtils image:value proxy:(TiProxy*)self.proxy];
	if (image!=nil)
	{
        if (cacheContext == nil) {
            [self initContext:[self bounds].size withImage: nil];
        }
        UIGraphicsPushContext(cacheContext);
        [image drawInRect:[self bounds]];
        UIGraphicsPopContext();
        [self setNeedsDisplay];
	}
	else
	{
		[self clearImage];
	}
}

- (void)undo:(id)args
{
    if ([imageHistory count] > 0)
	{
        if ([imageHistory objectAtIndex:[imageHistory count] -1] == [NSNull null]) {
            [self clearImage];
        } else {
            [self drawImage:[imageHistory objectAtIndex:[imageHistory count] -1]];
            CGImageRelease([imageHistory objectAtIndex:[imageHistory count] -1]);
            
        }
        [imageHistory removeObjectAtIndex:[imageHistory count] -1];
	} else 	{
		[self clearImage];
	}
}



- (void)clear:(id)args
{
    [self clearImage];
}

@end
