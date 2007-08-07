//
//  ASSFVData.h
//  iSFV
//
//  Created by Albert Sodyl on 06/08/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ASSFVData : NSObject {
	NSMutableArray *_files;
	NSMutableArray *_checkSums;
}

- (int) count;
- (void) setFiles:(NSArray*)files withCheckSums:(NSArray*)checkSums;
- (id) fileAtIndex:(int)index;
- (id) checkSumAtIndex:(int)index;
- (NSArray*) files;
- (NSArray*) checkSums;

@end
