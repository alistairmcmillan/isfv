//
//  ASCancelButton.h
//  iSFV
//
//  Imported from The Unarchiver 1.6 on 08/09/07.
//  Copyright The Unarchiver Team, Albert Sodyl 2007 . All rights reserved.
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

@interface ASCancelButton:NSButton
{
	NSImage *normal,*hover,*press;
	NSTrackingRectTag trackingtag;
}

-(id)initWithCoder:(NSCoder *)coder;
-(void)dealloc;
-(void)mouseEntered:(NSEvent *)event;
-(void)mouseExited:(NSEvent *)event;

@end
