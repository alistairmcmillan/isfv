//
//  ASSFVData.h
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

typedef enum _ASSFVStatus {
	ASSFVNotChecked = 1,
	ASSFVMatchCRC = 2,
	ASSFVNotMatchCRC = 4,
	ASSFVMissing = 8,
	ASSFVNoAccess = 64,
	ASSFVUnknownError = 128
} ASSFVStatus;

@interface ASSFVData : NSObject {
	NSMutableArray *_files;
	NSMutableArray *_checkSums;
	NSMutableArray *_statuses;
}

- (int) count;
- (void) setFiles:(NSArray*)files withCheckSums:(NSArray*)checkSums;
- (id) fileAtIndex:(int)index;
- (id) checkSumAtIndex:(int)index;
- (id) statusAtIndex:(int)index;
- (void) replaceStatusAtIndex:(int)i with:(ASSFVStatus)status;
- (void) addFile:(NSString*)fileName atIndex:(int)index;
- (BOOL) isAllOkay;
- (NSEnumerator*) filesEnumerator;
- (NSEnumerator*) checkSumsEnumerator;
- (NSEnumerator*) statusesEnumerator;

@end
