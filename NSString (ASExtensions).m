//
//  NSString (ASExtensions).m
//  iSFV
//
//  Created by Albert Sodyl on 06/08/07.
//  Copyright 2007, 2008 Eoros. All rights reserved.
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

#import "NSString (ASExtensions).h"


@implementation NSString (ASExtensions)

- (int) indexOfLastCharacter:(char)character {
	int i;
	for (i = (int)[self length] - 1; i > 0; i--) {
		if ([self characterAtIndex:i] == character)
			return i;
	}
	return -1;
}

- (BOOL) isChildOfDirectory:(NSString*)directory {
	BOOL result = -1;
	NSArray *directoryComponents = [directory pathComponents];
	NSArray *selfComponents = [self pathComponents];
	NSEnumerator *de = [directoryComponents objectEnumerator];
	NSEnumerator *se = [selfComponents objectEnumerator];
	NSString *dc = [de nextObject];
	NSString *sc;
	if(dc) {
		result = YES;
		do {
			if(!(sc = [se nextObject]) || ![dc isEqual:sc]) {
				result = NO;
				break;
			}
		} while ((dc = [de nextObject]));
	}
	return result;
}

@end
