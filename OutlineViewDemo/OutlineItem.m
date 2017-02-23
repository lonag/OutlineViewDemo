//
//  OutlineItem.m
//  OutlineViewDemo
//
//  Created by Vadim Shpakovski on 2/23/17.
//  Copyright © 2017 DTS. All rights reserved.
//

#import "OutlineItem.h"

#import "DataObject.h"
#import "StarredOutlineItemCellView.h"
#import "OutlineItemCellView.h"

@implementation OutlineItem

- (instancetype)initWithDataObject:(DataObject *)dataObject {
	NSParameterAssert(dataObject);
	if ((self = [super init])) {
		_dataObject = dataObject;
	}
	return self;
}

#pragma mark - Public API

- (Class)cellViewClass {
	return (self.dataObject.starred ? StarredOutlineItemCellView.class : OutlineItemCellView.class);
}

- (NSColor *)emphasizedBackgroundColor {
	return (self.dataObject.starred ? NSColor.orangeColor : NSColor.keyboardFocusIndicatorColor);
}

@end
