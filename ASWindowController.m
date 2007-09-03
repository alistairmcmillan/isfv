//
//  ASWindowController.m
//  iSFV
//
//  Created by Albert Sodyl on 06/08/07.
//  Copyright 2007 Eoros. All rights reserved.
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

#import "ASSFVData.h"
#import "ASWindowController.h"

#define WMAX_HEIGHT 100

@implementation ASWindowController

- (void) populateData: (ASSFVData*)data {
	_data = data;
}

- (void) updateData:(int)index percentCompleted:(float)f {
	NSParameterAssert(index >= 0 && index < [_data count]);
	NSString *status = @"Checking ";
	[_status setStringValue:[status stringByAppendingString:[_data fileAtIndex:index]]];
	[status release];
	[_percentage setStringValue:@"0%"];
	[_level setFloatValue:f];
	[_table reloadData];
}

- (void) percentCompleted:(float)p {
	[_level setFloatValue:p];
}

- (void) filePercentCompleted:(float)p {
	NSString* s = [NSString stringWithFormat:@"%1.1f%%", p];
	[_percentage setStringValue:s];
}

- (void)windowDidLoad {
	[super windowDidLoad];
	if ([_data count] > 0) {
		NSString *status = @"Checking ";
		[_status setStringValue:[status stringByAppendingString:[_data fileAtIndex:0]]];
		[status release];
		[_percentage setStringValue:@"0%"];
	}
	else {
		[_status setStringValue:@""];
		[_percentage setStringValue:@""];
	}
	[_level setWarningValue:0];
	[_level setCriticalValue:0];
	[_level setFloatValue:0.00];
	[_level setEnabled:NO];
	_extendedHeight = 150;
	[_table setDataSource:_data];
}

- (void)showWindow:(id)sender {
	[super showWindow:sender];
	[[self document] windowControllerDidLoadNib:self];
}

- (void) failedFile:(BOOL)failed {
	if(failed)
		[_level setCriticalValue:0.00001];
	else
		[_level setCriticalValue:0];
}

- (void) warningFile:(BOOL)warning {
	if(warning)
		[_level setWarningValue:0.00001];
	else
		[_level setWarningValue:0];
}

- (IBAction)showDetails:(id)sender {
	if (sender == _details)
		[_arrow setState:NSOnState];
	NSSize currentMaxSize = [[self window] contentMaxSize];
	NSSize currentMinSize = [[self window] contentMinSize];
	NSRect currentRect = [[self window] frame];
	if ([sender state] == NSOnState) { // Extend window
		currentRect.origin.y -= _extendedHeight;
		currentRect.size.height += _extendedHeight;
		[[self window] setContentMaxSize:NSMakeSize(currentMaxSize.width,1600)];
		[[self window] setContentMinSize:NSMakeSize(currentMinSize.width,150)];
		[[self window] setFrame:currentRect display:YES animate:YES];
		[_scroller setFrame:NSMakeRect(20,20,currentRect.size.width-40,_extendedHeight-10)];
		[_scroller setHidden:NO];
	}
	else { // Collapse window
		_extendedHeight = [[self window] contentRectForFrameRect:currentRect]
			.size.height - WMAX_HEIGHT;
		currentRect.origin.y += _extendedHeight;
		currentRect.size.height -= _extendedHeight;
		[[self window] setContentMaxSize:NSMakeSize(currentMaxSize.width,WMAX_HEIGHT)];
		[[self window] setContentMinSize:NSMakeSize(currentMinSize.width,WMAX_HEIGHT)];
		[_scroller setHidden:YES];
		[[self window] setFrame:currentRect display:YES animate:YES];
	}
}

@end
