//
//  DataObject.m
//  OutlineViewDemo
//
//  Created by Vadim Shpakovski on 2/23/17.
//  Copyright © 2017 DTS. All rights reserved.
//

#import "DataObject.h"

@implementation DataObject

- (instancetype)initWithTitle:(NSString *)title starred:(BOOL)starred {
	NSParameterAssert(title.length > 0);
	if ((self = [super init])) {
		_title = [title copy];
		_starred = starred;
	}
	return self;
}

@end
