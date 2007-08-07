//
//  ASSFVData.m
//  iSFV
//
//  Created by Albert Sodyl on 06/08/07.
//  Copyright 2007 Eoros. All rights reserved.
//

//	This file is part of iSFV.
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


@implementation ASSFVData

- (id)init
{
    self = [super init];
    if (self) {
		_files = [[NSMutableArray alloc] init];
		_checkSums = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) setFiles:(NSArray*)files withCheckSums:(NSArray*)checkSums {
	[_files removeAllObjects];
	[_files setArray:files];
	[_checkSums removeAllObjects];
	[_checkSums setArray:checkSums];
}

- (int) count {
	return [_files count];
}

- (id) tableView:(NSTableView *) aTableView
objectValueForTableColumn:(NSTableColumn *) aTableColumn
			 row:(int) rowIndex {
	if ([aTableColumn identifier] == @"file") {
		return [self fileAtIndex:rowIndex];
	} else if ([aTableColumn identifier] == @"checksum") {
		return [self checkSumAtIndex:rowIndex];
	} else
		return @"Undefined";
}

- (void)tableView:(NSTableView *) aTableView
   setObjectValue:anObject
   forTableColumn:(NSTableColumn * )aTableColumn
			  row:(int)rowIndex {
    NSParameterAssert(rowIndex >= 0 && rowIndex < [self count]);
	if ([aTableColumn identifier] == @"file") {
		[_files removeObjectAtIndex:rowIndex];
		[_files insertObject:anObject atIndex:rowIndex];
	} else if ([aTableColumn identifier] == @"checksum") {
		[_checkSums removeObjectAtIndex:rowIndex];
		[_checkSums insertObject:anObject atIndex:rowIndex];
	} else
		NSLog(@"Incorrect column identifier %@ for object %@",
			  [aTableColumn identifier], anObject);
}

- (int) numberOfRowsInTableView:(NSTableView *)aTableView {
	return [self count];  
}

- (id) fileAtIndex:(int)index {
	NSParameterAssert(index >= 0 && index < [self count]);
	return [_files objectAtIndex:index];
}

- (id) checkSumAtIndex:(int)index {
	NSParameterAssert(index >= 0 && index < [self count]);
	return [_checkSums objectAtIndex:index];
}

- (NSArray*) files {
	return _files;
}
- (NSArray*) checkSums {
	return _checkSums;
}

@end
