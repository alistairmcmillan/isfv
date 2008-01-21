//
//  ASSFVData.m
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
#import "ASSFVData.h"
#import "ASDocument.h"


@implementation ASSFVData

- (id)init
{
    self = [super init];
    if (self) {
		_files = [[NSMutableArray alloc] init];
		_checkSums = [[NSMutableArray alloc] init];
		_statuses = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) setFiles:(NSArray*)files withCheckSums:(NSArray*)checkSums {
	[_files removeAllObjects];
	[_files setArray:files];
	[_checkSums removeAllObjects];
	[_checkSums setArray:checkSums];
	[_statuses removeAllObjects];
	int i = [self count];
	NSNumber* statuses[i];
	NSNumber* value = [NSNumber numberWithInt:ASSFVNotChecked];
	while(--i >= 0) {
		statuses[i] = value;
	}
	[_statuses setArray:[NSArray arrayWithObjects:statuses count:[self count]]];
}

- (int) count {
	return [_files count];
}

- (id) tableView:(NSTableView *) aTableView
objectValueForTableColumn:(NSTableColumn *) aTableColumn
			 row:(int) rowIndex {
	if ([[aTableColumn identifier] isEqual:@"file"]) {
		return [self fileAtIndex:rowIndex];
	} else if ([[aTableColumn identifier] isEqual:@"checksum"]) {
		return [self checkSumAtIndex:rowIndex];
	} else if ([[aTableColumn identifier] isEqual:@"status"]) {
		switch([[self statusAtIndex:rowIndex] intValue]) {
			case ASSFVNotChecked:
				return @"";
				break;
			case ASSFVMatchCRC:
				return @"OK";
				break;
			case ASSFVNotMatchCRC:
				return @"Corrupt";
				break;
			case ASSFVMissing:
				return @"Missing";
				break;
			case ASSFVNoAccess:
				return @"No Access";
				break;
			case ASSFVUnknownError:
				return @"Unknown Error";
				break;
			default:
				NSLog(@"CRITICAL ERROR: Should not get here.");
				return @"Critical Error";
		}
	} else
		return @"Undefined";
}

- (void)tableView:(NSTableView *) aTableView
   setObjectValue:anObject
   forTableColumn:(NSTableColumn * )aTableColumn
			  row:(int)rowIndex {
    NSParameterAssert(rowIndex >= 0 && rowIndex < [self count]);
	if ([[aTableColumn identifier] isEqual:@"file"]) {
		[_files removeObjectAtIndex:rowIndex];
		[_files insertObject:anObject atIndex:rowIndex];
	} else if ([[aTableColumn identifier] isEqual:@"checksum"]) {
		[_checkSums removeObjectAtIndex:rowIndex];
		[_checkSums insertObject:anObject atIndex:rowIndex];
	} else
		NSLog(@"Incorrect column identifier %@ for object %@",
			  [aTableColumn identifier], anObject);
}

//- (BOOL) tableView:(NSTableView *) tv writeRowsWithIndexes:(NSIndexSet *)rowIndexes
//	  toPasteboard:(NSPasteboard*)pboard {
//    // Copy the row numbers to the pasteboard.
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
//    [pboard declareTypes:[NSArray arrayWithObject:NSFilenamesPboardType] owner:self];
//    [pboard setData:data forType:NSFilenamesPboardType];
//    return YES;
//}

- (NSDragOperation)tableView:(NSTableView*)tv
				validateDrop:(id <NSDraggingInfo>)info
				 proposedRow:(int)row
	   proposedDropOperation:(NSTableViewDropOperation)op {
    //[tv setDropRow: -1 dropOperation: NSTableViewDropOn];
    return NSDragOperationEvery;
}

- (BOOL)tableView:(NSTableView *)aTableView acceptDrop:(id <NSDraggingInfo>)info
			  row:(int)row dropOperation:(NSTableViewDropOperation)operation {
	BOOL result = NO;
	if(row < 0)
		row = 0;
    NSPasteboard* pboard = [info draggingPasteboard];
	NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
    //NSLog(@"file: %@", files);
	NSEnumerator *e = [files objectEnumerator];
	NSString *file;
	NSString *path = [self path];
	if (path) {
		while((file = [e nextObject])) {
			NSFileManager *fileMan = [NSFileManager defaultManager];
			BOOL isDir;
			if ([fileMan fileExistsAtPath:file isDirectory:&isDir] && isDir) {
				NSDirectoryEnumerator *dirEnum = [fileMan enumeratorAtPath:file];
				NSString *f;
				while ((f = [dirEnum nextObject])) {
					if ([fileMan fileExistsAtPath:[file stringByAppendingPathComponent:f]
									  isDirectory:&isDir] && !isDir)
						[self addFile:[file stringByAppendingPathComponent:f]
							  atIndex:row atPath:path];
				}
			} else {
				[self addFile:file atIndex:row atPath:path];
			}
		}
		[aTableView reloadData];
		result = YES;
	}
	return result;
}

- (void) addFile:(NSString *)fileName atIndex:(int)index atPath:(NSString*)path {
	if([fileName isChildOfDirectory:path]) {
		fileName = [fileName substringFromIndex:[path length]+1];
		[_files insertObject:fileName atIndex:index];
		[_checkSums insertObject:@"" atIndex:index];
		[_statuses insertObject:[NSNumber numberWithInt:ASSFVNotChecked] atIndex:index];
	}
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

- (id) statusAtIndex:(int)index {
	if ([self count] <= 0)
		return nil;
	NSParameterAssert(index >= 0 && index < [self count]);
	return [_statuses objectAtIndex:index];
}

- (void) replaceStatusAtIndex:(int)i with:(ASSFVStatus)status {
	[_statuses replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:status]];
}

- (void) replaceCheckSumAtIndex:(int)i with:(id)checkSum {
	[_checkSums replaceObjectAtIndex:i withObject:checkSum];
}

- (BOOL) isAllOkay {
	NSEnumerator *enumerator = [self statusesEnumerator];
	id status;
	while((status = [enumerator nextObject]))
		if ([status intValue] != ASSFVMatchCRC)
			return NO;
	return YES;
}

- (NSIndexSet*)notOkIndexes {
	int i;
	ASSFVStatus status;
	NSMutableIndexSet *set = [[NSMutableIndexSet alloc] init];
	for(i = 0; i < [self count]; i++) {
		status = [[_statuses objectAtIndex:i] intValue];
		if(status != ASSFVMatchCRC)
			[set addIndex:i];
	}
	return set;
}

- (NSEnumerator*) filesEnumerator {
	return [_files objectEnumerator];
}

- (NSEnumerator*) checkSumsEnumerator {
	return [_checkSums objectEnumerator];
}

- (NSEnumerator*) statusesEnumerator {
	return [_statuses objectEnumerator];
}

- (id)delegate {
    return _delegate;
}

- (void)setDelegate:(id)newDelegate {
    _delegate = newDelegate;
}

- (NSString*)path {
	NSString* result = nil;
	if ( [_delegate respondsToSelector:@selector(documentPath)] )
		(result = [_delegate documentPath]);
	return result;
}

@end
