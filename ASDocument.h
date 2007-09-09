//
//  ASDocument.h
//  iSFV
//
//  Created by Albert Sodyl on 01/08/07.
//  Copyright Eoros 2007 . All rights reserved.
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

@interface ASDocument : NSDocument
{
	ASWindowController *windowController;
	ASSFVData *_data;
	NSDate *_date;
	long _dataRead;
	float _percentCompleted;
	float _filePercentCompleted;
	BOOL _threadShouldExit;
}
@end
