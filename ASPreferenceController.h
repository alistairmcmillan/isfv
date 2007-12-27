//
//  ASPreferenceController.h
//  iSFV
//
//  Created by Albert Sodyl on 26/12/07.
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

#define CloseWindow @"CloseWindow"
#define CloseTime @"CloseTime"
#define DetailMode @"DetailMode"
#define OverwriteReadOnlyFiles @"OverwriteReadOnlyFiles"
#define WinSFVFormat @"WinSFVFormat"
#define DatesTimes @"DatesTimes"
#define WindowWidth @"WindowWidth"
#define WindowHeight @"WindowHeight"


@interface ASPreferenceController : NSObject {
	IBOutlet id closeWindow;
	IBOutlet id timeToClose;
	IBOutlet id detailMode;
	IBOutlet id sfvFormat;
	IBOutlet id datesTimes;
	IBOutlet id panel;
	
	NSDictionary *curValues;	// Current, confirmed values for the preferences
    NSDictionary *origValues;	// Values read from preferences at startup
    NSMutableDictionary *displayedValues;	// Values displayed in the UI	
}

+ (id)objectForKey:(id)key;	/* Convenience for getting global preferences */
+ (void)saveDefaults;		/* Convenience for saving global preferences */
- (void)saveDefaults;		/* Save the current preferences */

+ (ASPreferenceController *)sharedInstance;

- (NSDictionary *)preferences;	/* The current preferences; contains values for
	the documented keys */

- (void)showPanel:(id)sender;	/* Shows the panel */

- (void)miscChanged:(id)sender;

- (void)updateUI;		/* Updates the displayed values in the UI */
- (void)commitDisplayedValues;	/* The displayed values are made current */
- (void)discardDisplayedValues;	/* The displayed values are replaced with current
	prefs and updateUI is called */

- (void)miscChanged:(id)sender;		/* Action message for most of the misc items
	in the UI to get displayedValues */

+ (NSDictionary *)preferencesFromDefaults;
+ (void)savePreferencesToDefaults:(NSDictionary *)dict;

@end
