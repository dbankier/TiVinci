/**
 * Titanium Paint Module
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */

#import "YyTivinciViewProxy.h"
#import "TiUtils.h"

@implementation YyTivinciViewProxy


-(void)clear:(id)args
{
	[[self view] performSelectorOnMainThread:@selector(clear:) withObject:args waitUntilDone:NO];
}

-(void)undo:(id)args
{
	[[self view] performSelectorOnMainThread:@selector(undo:) withObject:args waitUntilDone:NO];
}

@end
