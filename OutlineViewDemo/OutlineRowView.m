//
//  OutlineRowView.m
//  OutlineViewDemo
//
//  Created by Vadim Shpakovski on 2/23/17.
//  Copyright © 2017 DTS. All rights reserved.
//

#import "OutlineRowView.h"

#import <QuartzCore/QuartzCore.h>

@implementation OutlineRowView

- (void)drawSelectionInRect:(NSRect)dirtyRect {
	NSColor *backgroundColor = (self.emphasized ? (self.emphasizedBackgroundColor ?: NSColor.alternateSelectedControlColor) : NSColor.secondarySelectedControlColor);
	if (self.groupRowStyle) {
		backgroundColor = [backgroundColor colorWithAlphaComponent:0.25];
	}
	[backgroundColor setFill];
	NSRectFillUsingOperation(dirtyRect, NSCompositingOperationSourceOver);
}

#pragma mark - NSAnimatablePropertyContainer

+ (id)defaultAnimationForKey:(NSString *)key {
	if ([key isEqualToString:NSStringFromSelector(@selector(emphasizedBackgroundColor))]) {
		return CABasicAnimation.animation;
	} else {
		return [super defaultAnimationForKey:key];
	}
}

#pragma mark - Public API

- (void)setEmphasizedBackgroundColor:(NSColor *)emphasizedBackgroundColor {
	if (_emphasizedBackgroundColor != emphasizedBackgroundColor) {
		_emphasizedBackgroundColor = emphasizedBackgroundColor;
		[self setNeedsDisplay:YES];
	}
}

@end
