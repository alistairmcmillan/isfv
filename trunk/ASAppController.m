#import "ASAppController.h"

@implementation ASAppController

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)theApplication
{
    return NO;
}

//- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename
//{
//    NSDocumentController *dc;
//    id doc;
//	
//    dc = [NSDocumentController sharedDocumentController];
//    doc = [dc openDocumentWithContentsOfFile:filename display:YES];
//	
//    return ( doc != nil);
//}

@end
