//
//  HeaderCellView.m
//  OutlineViewDemo
//
//  Created by Vadim Shpakovski on 2/24/17.
//  Copyright © 2017 DTS. All rights reserved.
//

#import "HeaderCellView.h"

@implementation HeaderCellView

- (instancetype)initWithFrame:(NSRect)frame {
	if ((self = [super initWithFrame:frame])) {

		NSTextField *label = [NSTextField labelWithString:@""];
		label.selectable = NO;
		label.font = [NSFont systemFontOfSize:16.0 weight:NSFontWeightRegular];
		label.translatesAutoresizingMaskIntoConstraints = NO;
		[self addSubview:label];
		NSLayoutConstraint *labelCenterX = [label.centerXAnchor constraintEqualToAnchor:self.centerXAnchor];
		NSLayoutConstraint *labelCenterY = [label.centerYAnchor constraintEqualToAnchor:self.centerYAnchor];

		[self addConstraints:@[labelCenterX, labelCenterY]];

		self.textField = label;
	}
	return self;
}

#pragma mark

- (void)setObjectValue:(id)objectValue {
	[super setObjectValue:objectValue];

	if (self.objectValue) {
		NSParameterAssert([objectValue isKindOfClass:NSNumber.class]);
		[self updateControlsForStarred:[self.objectValue boolValue]];
	}
}

#pragma mark - Private API

- (void)updateControlsForStarred:(BOOL)isStarred {
	self.textField.stringValue = (isStarred ? @"★★★★★" : @"☆☆☆☆☆");
	self.textField.textColor = (self.backgroundStyle == NSBackgroundStyleLight ? NSColor.textColor : NSColor.selectedTextColor);
}

@end
