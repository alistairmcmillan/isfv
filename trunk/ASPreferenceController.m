//
//  ASPreferenceController.m
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

#import "ASPreferenceController.h"

static NSDictionary *defaultValues() {
    static NSDictionary *dict = nil;
    if (!dict) {
        dict = [[NSDictionary alloc] initWithObjectsAndKeys:
			[NSNumber numberWithBool:NO], CloseWindow,
			[NSNumber numberWithInt:30], CloseTime, 
			[NSNumber numberWithBool:NO], DetailMode,
			[NSNumber numberWithBool:NO], OverwriteReadOnlyFiles,
			[NSNumber numberWithBool:NO], WinSFVFormat,
			[NSNumber numberWithBool:NO], DatesTimes,
			nil];
    }
    return dict;
}

@implementation ASPreferenceController

static ASPreferenceController *sharedInstance = nil;

+ (ASPreferenceController *)sharedInstance {
    return sharedInstance ? sharedInstance : [[self alloc] init];
}

- (id)init {
    if (sharedInstance) {		// We just have one instance, return that one instead
        [self release];
    } else if ((self = [super init])) {
        curValues = [[[self class] preferencesFromDefaults] copyWithZone:[self zone]];
        origValues = [curValues retain];
        [self discardDisplayedValues];
        sharedInstance = self;
    }
    return sharedInstance;
}

- (void)dealloc {
    if (self != sharedInstance) [super dealloc];	// Don't free the shared instance
}

/* The next few factory methods are conveniences, working on the shared instance
*/
+ (id)objectForKey:(id)key {
    return [[[self sharedInstance] preferences] objectForKey:key];
}

+ (void)saveDefaults {
    [[self sharedInstance] saveDefaults];
}

- (void)saveDefaults {
    NSDictionary *prefs = [self preferences];
    if (![origValues isEqual:prefs]) [ASPreferenceController savePreferencesToDefaults:prefs];
}

- (NSDictionary *)preferences {
    return curValues;
}

- (void)showPanel:(id)sender {
    if (!panel) {
        if (![NSBundle loadNibNamed:@"ASPreferences" owner:self])  {
            NSLog(@"Failed to load ASPreferences.nib");
            NSBeep();
            return;
        }
		[panel setHidesOnDeactivate:NO];
		[panel setExcludedFromWindowsMenu:YES];
		[panel setMenu:nil];
        [self updateUI];
        [panel center];
    }
    [panel makeKeyAndOrderFront:nil];
}

- (void)updateUI {
	[closeWindow selectCellWithTag:[[displayedValues objectForKey:CloseWindow] boolValue] ? 1 : 0];
    [timeToClose setIntValue:[[displayedValues objectForKey:CloseTime] intValue]];
    [detailMode setState:[[displayedValues objectForKey:DetailMode] boolValue]];
    [sfvFormat selectCellWithTag:[[displayedValues objectForKey:DatesTimes] boolValue] ? 1 : 0];
	[datesTimes setState:[[displayedValues objectForKey:DatesTimes] boolValue]];
	[timeToClose setEnabled:[[closeWindow selectedCell] tag]];
}

- (void)miscChanged:(id)sender {
	static NSNumber *yes = nil;
    static NSNumber *no = nil;
    int anInt;
    
    if (!yes) {
        yes = [[NSNumber alloc] initWithBool:YES];
        no = [[NSNumber alloc] initWithBool:NO];
    }
	
    [displayedValues setObject:[[closeWindow selectedCell] tag] ? yes : no forKey:CloseWindow];
    [displayedValues setObject:[detailMode state] ? yes : no forKey:DetailMode];
    [displayedValues setObject:[[sfvFormat selectedCell] tag] ? yes : no forKey:WinSFVFormat];
    [displayedValues setObject:[datesTimes state] ? yes : no forKey:DatesTimes];
    
	if ((anInt = [timeToClose intValue]) < 1 || anInt > 10000) {
        if ((anInt = [[displayedValues objectForKey:WindowWidth] intValue]) < 1 
			|| anInt > 10000) anInt = [[defaultValues() objectForKey:CloseTime] intValue];
		[timeToClose setIntValue:anInt];
    } else {
		[displayedValues setObject:[NSNumber numberWithInt:anInt] forKey:CloseTime];
    }
	
	[timeToClose setEnabled:[[closeWindow selectedCell] tag]];
	
    [self commitDisplayedValues];	
}

#define getStringDefault(name) \
{id obj = [defaults stringForKey:name]; \
	[dict setObject:obj ? obj : [defaultValues() objectForKey:name] forKey:name];}

#define getBoolDefault(name) \
{id obj = [defaults objectForKey:name]; \
	[dict setObject:obj ? [NSNumber numberWithBool:[defaults boolForKey:name]] : \
 [defaultValues() objectForKey:name] forKey:name];}

#define getIntDefault(name) \
{id obj = [defaults objectForKey:name]; \
	[dict setObject:obj ? [NSNumber numberWithInt:[defaults integerForKey:name]] : \
 [defaultValues() objectForKey:name] forKey:name];}

+ (NSDictionary *)preferencesFromDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
	
    getBoolDefault(CloseWindow);
    getIntDefault(CloseTime);
    getBoolDefault(DetailMode);
    getBoolDefault(WinSFVFormat);
    getBoolDefault(DatesTimes);
    return dict;
}

#define setStringDefault(name) \
{if ([[defaultValues() objectForKey:name] isEqual:[dict objectForKey:name]]) \
	[defaults removeObjectForKey:name]; else [defaults setObject:[dict \
 objectForKey:name] forKey:name];}

#define setBoolDefault(name) \
{if ([[defaultValues() objectForKey:name] isEqual:[dict objectForKey:name]]) \
	[defaults removeObjectForKey:name]; else [defaults setBool:[[dict \
 objectForKey:name] boolValue] forKey:name];}

#define setIntDefault(name) \
{if ([[defaultValues() objectForKey:name] isEqual:[dict objectForKey:name]]) \
	[defaults removeObjectForKey:name]; else [defaults setInteger:[[dict \
 objectForKey:name] intValue] forKey:name];}

+ (void)savePreferencesToDefaults:(NSDictionary *)dict {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    setBoolDefault(CloseWindow);
    setIntDefault(CloseTime);
    setBoolDefault(DetailMode);
    setBoolDefault(WinSFVFormat);
    setBoolDefault(DatesTimes);
}

- (void)windowWillClose:(NSNotification *)notification {
    NSWindow *window = [notification object];
    (void)[window makeFirstResponder:window];
}

- (void)commitDisplayedValues {
    if (curValues != displayedValues) {
        [curValues release];
        curValues = [displayedValues copyWithZone:[self zone]];
    }
}

- (void)discardDisplayedValues {
    if (curValues != displayedValues) {
        [displayedValues release];
        displayedValues = [curValues mutableCopyWithZone:[self zone]];
        [self updateUI];
    }
}

@end
