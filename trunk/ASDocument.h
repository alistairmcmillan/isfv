//
//  MyDocument.h
//  iSFV
//
//  Created by Albert Sodyl on 01/08/07.
//  Copyright __MyCompanyName__ 2007 . All rights reserved.
//


#import <Cocoa/Cocoa.h>

@interface ASDocument : NSDocument
{
	ASWindowController *windowController;
	NSMutableArray *_files;
	NSMutableArray *_checkSums;
}
@end
