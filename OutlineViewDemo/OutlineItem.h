//
//  OutlineItem.h
//  OutlineViewDemo
//
//  Created by Vadim Shpakovski on 2/23/17.
//  Copyright © 2017 DTS. All rights reserved.
//

#import <AppKit/AppKit.h>

@class DataObject;

NS_ASSUME_NONNULL_BEGIN

@interface OutlineItem : NSObject

@property (nonatomic, strong, readonly) DataObject *dataObject;
@property (nonatomic, strong, readonly) Class cellViewClass;
@property (nonatomic, strong, readonly, nullable) NSColor *emphasizedBackgroundColor;

- (instancetype)initWithDataObject:(DataObject *)dataObject;

@end

NS_ASSUME_NONNULL_END
