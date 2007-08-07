//
//  ASWindowController.m
//  iSFV
//
//  Created by Albert Sodyl on 06/08/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "ASSFVData.h"
#import "ASWindowController.h"

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
	[_level setFloatValue:(f*100)];
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
	[_level setFloatValue:0.00];
}

- (void)showWindow:(id)sender {
	[super showWindow:sender];
	[[self document] windowControllerDidLoadNib:self];
}

@end
