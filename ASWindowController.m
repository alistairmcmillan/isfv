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
#import "ASDocument.h"
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
	NSString* s = [NSString stringWithFormat:@"%.0f%%", p];
	[_percentage setStringValue:s];
}

- (void) setInfoSpeed: (int)speed withTime: (int)time {
	NSString *s, *su, *t, *tu;
	if(speed < 0) {
		s = [NSString stringWithString:@"-"];
		su = [NSString stringWithString:@""];
	} else {
		if (speed >= 1024*1024) {
			s = [NSString stringWithFormat:@"%.2f", (float) speed / (1024*1024)];
			su = [NSString stringWithString:@"MiB/s"];
		} else if (speed >= 10*1024) {
			s = [NSString stringWithFormat:@"%.1f", (float) speed / (1024)];
			su = [NSString stringWithString:@"KiB/s"];
		} else {
			s = [NSString stringWithFormat:@"%d", speed];
			su = [NSString stringWithString:@"B/s"];
		}
	}
	if (time < 0) {
		t = [NSString stringWithString:@"-"];
		tu = [NSString stringWithString:@""];
	} else {
		if (time >= 3600) {
			t = [NSString stringWithFormat:@"%d:%02d", time/3600, time/60];
			tu = [NSString stringWithString:@"h"];
		} else if (time >= 60) {
			t = [NSString stringWithFormat:@"%d:%02d", time/60, time % 60];
			tu = [NSString stringWithString:@"m"];
		} else {
			t = [NSString stringWithFormat:@"%d", time];
			tu = [NSString stringWithString:@"s"];
		}
	}
	[_info setStringValue:[NSString
stringWithFormat:@"Speed: %@ %@  Time Remaining: %@ %@", s, su, t, tu]];
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
	[self setInfoSpeed: -1 withTime: -1];
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
	if(warning) {
		[_level setCriticalValue:101];
		[_level setWarningValue:0.00001];
	}
	else {
		[_level setWarningValue:0];
	}
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
		[_info setFrame:NSMakeRect(20,4,currentRect.size.width-40,14)];
		[_info setHidden:NO];
	}
	else { // Collapse window
		_extendedHeight = [[self window] contentRectForFrameRect:currentRect]
			.size.height - WMAX_HEIGHT;
		currentRect.origin.y += _extendedHeight;
		currentRect.size.height -= _extendedHeight;
		[[self window] setContentMaxSize:NSMakeSize(currentMaxSize.width,WMAX_HEIGHT)];
		[[self window] setContentMinSize:NSMakeSize(currentMinSize.width,WMAX_HEIGHT)];
		[_info setHidden:YES];
		[_scroller setHidden:YES];
		[[self window] setFrame:currentRect display:YES animate:YES];
	}
}

- (IBAction)cancelCheck:(id)sender {
	[[self document] cancelCheck];
}

@end