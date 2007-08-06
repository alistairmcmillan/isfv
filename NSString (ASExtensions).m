//
//  NSString (ASExtensions).m
//  iSFV
//
//  Created by Albert Sodyl on 06/08/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "NSString (ASExtensions).h"


@implementation NSString (ASExtensions)

- (int) indexOfLastCharacter:(char)character {
	int i;
	for (i = [self length] - 1; i > 0; i--) {
		if ([self characterAtIndex:i] == character)
			return i;
	}
	return -1;
}

@end
