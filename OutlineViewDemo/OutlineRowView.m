//
//  OutlineRowView.m
//  OutlineViewDemo
//
//  Created by Vadim Shpakovski on 2/23/17.
//  Copyright © 2017 DTS. All rights reserved.
//

#import "OutlineRowView.h"

@implementation OutlineRowView

- (void)drawSelectionInRect:(NSRect)dirtyRect {
	NSColor *backgroundColor = (self.emphasized ? (self.emphasizedBackgroundColor ?: NSColor.selectedControlColor) : NSColor.secondarySelectedControlColor);
	[backgroundColor setFill];
	NSRectFillUsingOperation(dirtyRect, NSCompositingOperationSourceOver);
}

#pragma mark - Public API

- (void)setEmphasizedBackgroundColor:(NSColor *)emphasizedBackgroundColor {
	if (_emphasizedBackgroundColor != emphasizedBackgroundColor) {
		_emphasizedBackgroundColor = emphasizedBackgroundColor;
		[self setNeedsDisplay:YES];
	}
}

@end
