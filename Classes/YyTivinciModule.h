/**
 * Titanium Paint Module
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "TiModule.h"

typedef enum {
	DrawModeErase = 0,
	DrawModeStraightLine = 1,
	DrawModeCurve = 2,
	DrawModeCircle = 3,
	DrawModeRectangle = 4,
} DrawModeSelection;

@interface YyTivinciModule : TiModule
{
}

// constants
@property(nonatomic,readonly) NSInteger ERASE;
@property(nonatomic,readonly) NSInteger STRAIGHT_LINE;
@property(nonatomic,readonly) NSInteger CURVE_LINE;
@property(nonatomic,readonly) NSInteger CIRCLE;
@property(nonatomic,readonly) NSInteger RECTANGLE;

@end
