//
//  OutlineItemCellView.m
//  OutlineViewDemo
//
//  Created by Vadim Shpakovski on 2/23/17.
//  Copyright © 2017 DTS. All rights reserved.
//

#import "OutlineItemCellView.h"

#import "DataObject.h"

@implementation OutlineItemCellView

- (instancetype)initWithFrame:(NSRect)frame {
	if ((self = [super initWithFrame:frame])) {

		NSTextField *label = [NSTextField labelWithString:@""];
		label.selectable = NO;
		label.font = [NSFont systemFontOfSize:20.0 weight:NSFontWeightLight];
		label.translatesAutoresizingMaskIntoConstraints = NO;
		[self addSubview:label];
		NSLayoutConstraint *labelLeading = [label.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:20.0];
		NSLayoutConstraint *labelCenterY = [label.centerYAnchor constraintEqualToAnchor:self.centerYAnchor];

		NSButton *starButton = [[NSButton alloc] init];
		starButton.title = @"☆";
		starButton.bordered = NO;
		starButton.font = [NSFont systemFontOfSize:40.0 weight:NSFontWeightLight];
		starButton.bezelStyle = NSBezelStyleRounded;
		starButton.translatesAutoresizingMaskIntoConstraints = NO;
		starButton.action = @selector(toggleStar:);
		[self addSubview:starButton];
		NSLayoutConstraint *buttonLeading = [starButton.leadingAnchor constraintGreaterThanOrEqualToAnchor:label.trailingAnchor constant:8.0];
		NSLayoutConstraint *buttonCenterY = [starButton.centerYAnchor constraintEqualToAnchor:self.centerYAnchor];
		NSLayoutConstraint *buttonTrailing = [starButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-12.0];

		[self addConstraints:@[labelLeading, labelCenterY, buttonLeading, buttonCenterY, buttonTrailing]];

		self.textField = label;
	}
	return self;
}

#pragma mark

- (void)setObjectValue:(id)objectValue {
	[super setObjectValue:objectValue];

	if (self.objectValue) {
		NSParameterAssert([objectValue isKindOfClass:DataObject.class]);
		[self updateControlsForDataObject:self.objectValue];
	}
}

#pragma mark - Private API

- (void)updateControlsForDataObject:(DataObject *)dataObject {
	self.textField.stringValue = dataObject.title;
	self.textField.textColor = (self.backgroundStyle == NSBackgroundStyleLight ? NSColor.textColor : NSColor.selectedTextColor);
}

@end
