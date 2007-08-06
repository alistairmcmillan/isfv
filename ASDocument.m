//
//  MyDocument.m
//  iSFV
//
//  Created by Albert Sodyl on 01/08/07.
//  Copyright __MyCompanyName__ 2007 . All rights reserved.
//

#import "ASDocument.h"

@implementation ASDocument

- (id)init
{
    self = [super init];
    if (self) {
    
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

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    BOOL readSuccess = NO;
    NSAttributedString *fileContents = [[NSAttributedString alloc]
            initWithData:data options:NULL documentAttributes:NULL
				   error:outError];
    if (fileContents) {
        readSuccess = YES;
		NSLog([fileContents string]);
        //[self setText:fileContents];
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
