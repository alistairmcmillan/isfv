//
//  ASWindowController.h
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

#import <Cocoa/Cocoa.h>

@interface ASWindowController : NSWindowController {
	IBOutlet NSTextField *_status;
	IBOutlet NSTextField *_percentage;
	IBOutlet NSLevelIndicator *_level;
	IBOutlet NSButton *_arrow;
	IBOutlet NSTextField *_details;
	IBOutlet NSScrollView *_scroller;
	IBOutlet NSTableView *_table;
	IBOutlet NSTextField *_info;
	IBOutlet NSButton *_cancelButton;
	ASSFVData *_data;
	int _extendedHeight;
	BOOL _fadeIn;
	NSAnimation *_animation;
	NSTimer *_timer;
}

- (IBAction)showDetails:(id)sender;
- (IBAction)cancelCheck:(id)sender;
- (void) populateData: (ASSFVData*)data;
- (void) updateData: (int)index percentCompleted:(float)percent;
- (void) percentCompleted:(float)percent;
- (void) filePercentCompleted:(float)percent;
- (void) failedFile:(BOOL)failed;
- (void) warningFile:(BOOL)warning;
- (void) setInfoSpeed: (int)speed withTime: (int)time isDone: (BOOL)done;
- (void) closeWindow;

@end
