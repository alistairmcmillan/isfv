//
//  ASTableView.m
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

#import "ASTableView.h"

@implementation ASTableView

- (void)keyDown:(NSEvent*)event_ {
    NSString *eventCharacters = [event_ characters];
    if ([eventCharacters length]) {
        switch ([eventCharacters characterAtIndex:0]) {
            case NSDeleteFunctionKey:
            case NSDeleteCharFunctionKey:
            case NSDeleteCharacter: {
                if ([self dataSource] && [[self dataSource] respondsToSelector:
                                          @selector(tableView:deleteRows:)]
                    && [self numberOfSelectedRows] > 0
                    && [[self dataSource] tableView:self
                                         deleteRows:[self selectedRowIndexes]])
                    [self reloadData];
                else
                    [super keyDown:event_];
            } break;
            default:
                [super keyDown:event_];
                break;
        }
    }
}

@end
