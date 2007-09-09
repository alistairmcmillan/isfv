//
//  ASCancelButton.m
//  iSFV
//
//  Imported from The Unarchiver 1.6 on 08/09/07.
//  Copyright The Unarchiver Team, Albert Sodyl 2007 . All rights reserved.
//

//	iSFV is free software; you can redistribute it and/or modify
//	it under the terms of the GNU General Public License as published by
//	the Free Software Foundation; either version 3 of the License, or
//	(at your option) any later version.
//
//	iSFV is distributed in the hope that it will be useful,
//	but WITHOUT ANY WARRANTY; without even the implied warranty of
//	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//	GNU General Public License for more details.
//
//	You should have received a copy of the GNU General Public License
//	along with this program.  If not, see <http://www.gnu.org/licenses/>.

#import "ASCancelButton.h"

@implementation ASCancelButton

-(id)initWithCoder:(NSCoder *)coder
{
	if((self = [super initWithCoder:coder]))
	{
		normal=[[NSImage imageNamed:@"close_normal"] retain];
		hover=[[NSImage imageNamed:@"close_hover"] retain];
		press=[[NSImage imageNamed:@"close_press"] retain];
		[self setImage:normal];
		[self setAlternateImage:press];
		[self setShowsBorderOnlyWhileMouseInside:YES];
	}
	return self;
}

-(void)dealloc
{
	[normal release];
	[hover release];
	[press release];

	[super dealloc];
}


-(void)mouseEntered:(NSEvent *)event
{
	if([self isEnabled]) [self setImage:hover];
	[super mouseEntered:event];
}

-(void)mouseExited:(NSEvent *)event
{
	[self setImage:normal];
	[super mouseExited:event];
}



-(BOOL)acceptsFirstResponder { return YES; }

-(BOOL)becomeFirstResponder { return YES; }

-(void)setTrackingRect
{
	NSPoint loc=[self convertPoint:[[self window] mouseLocationOutsideOfEventStream] fromView:nil];
	BOOL inside=([self hitTest:loc]==self);
	if(inside) [[self window] makeFirstResponder:self];
	trackingtag=[self addTrackingRect:[self visibleRect] owner:self userData:nil assumeInside:inside];
}

-(void)clearTrackingRect
{
	[self removeTrackingRect:trackingtag];
}

-(void)resetCursorRects
{
	[super resetCursorRects];
	[self clearTrackingRect];
	[self setTrackingRect];
}

-(void)viewWillMoveToWindow:(NSWindow *)win
{
	if(!win&&[self window]) [self clearTrackingRect];
}

-(void)viewDidMoveToWindow
{
	if([self window]) [self setTrackingRect];
}

@end
