//
//  MyDocument.m
//  iSFV
//
//  Created by Albert Sodyl on 01/08/07.
//  Copyright __MyCompanyName__ 2007 . All rights reserved.
//

#import "NSString (ASExtensions).h"
#import "ASDocument.h"

@implementation ASDocument

- (id)init
{
    self = [super init];
    if (self) {
		_files = [[NSMutableArray alloc] init];
		_checkSums = [[NSMutableArray alloc] init];
        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
    
    }
    return self;
}

//- (void)awakeFromNib
//{
//	[controller openDocument:self];
//}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document 
	// supports multiple NSWindowControllers, you should remove this method and
	// override -makeWindowControllers instead.
    return @"ASDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has
	// loaded the document's window.
}

- (void)parseSFV:(NSString *)fileContents {
	// Go through each file and verify
	NSArray *lines = [fileContents componentsSeparatedByString:@"\n"];
	NSMutableArray *files = [[NSMutableArray alloc] init];
	NSMutableArray *checkSums = [[NSMutableArray alloc] init];
	NSString *line, *gLine;
	int i = 0;
	NSEnumerator *e = [lines objectEnumerator];
	while (line = [e nextObject]) {
		gLine = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		if ([gLine length] > 8 && [gLine characterAtIndex:0] != ';'
			&& [gLine characterAtIndex:0] != '#') {
			i = [gLine indexOfLastCharacter:' '];
			if (i >= 0)	{
				[files addObject:[gLine substringToIndex:i]];
				[checkSums addObject:[gLine substringFromIndex:(i+1)]];
			}
		}
		//[gLine release];
	}
	[_files setArray:files];
	[_checkSums setArray:checkSums];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    BOOL readSuccess = NO;
    NSString *fileContents = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (fileContents) {
        readSuccess = YES;
		[self parseSFV:fileContents];
        [fileContents release];
    }
    return readSuccess;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    //NSData *data = [textView RTFFromRange:NSMakeRange(0,
	//												  [[textView textStorage] length])];
    if (/*!data &&*/ outError) {
        *outError = [NSError errorWithDomain:NSCocoaErrorDomain
										code:NSFileWriteUnknownError userInfo:nil];
    }
    return [[NSData alloc] init]; //data;
}

- (NSData *)dataRepresentationOfType:(NSString *)aType
{
    // Insert code here to write your document from the given data.  You can
	// also choose to override -fileWrapperRepresentationOfType: or 
	// -writeToFile:ofType: instead.
    
    // For applications targeted for Tiger or later systems, you should use the
	// new Tiger API -dataOfType:error:.  In this case you can also choose to
	// override -writeToURL:ofType:error:, -fileWrapperOfType:error:, or 
	// -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.

    return nil;
}

- (BOOL)loadDataRepresentation:(NSData *)data ofType:(NSString *)aType
{
    // Insert code here to read your document from the given data.  You can also
	// choose to override -loadFileWrapperRepresentation:ofType: or
	// -readFromFile:ofType: instead.
    
    // For applications targeted for Tiger or later systems, you should use the
	// new Tiger API readFromData:ofType:error:.  In this case you can also
	// choose to override -readFromURL:ofType:error: or
	// -readFromFileWrapper:ofType:error: instead.
    
    return YES;
}

@end
