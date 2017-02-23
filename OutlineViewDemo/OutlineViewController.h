//
//  OutlineViewController.h
//  OutlineViewDemo
//
//  Created by Vadim Shpakovski on 2/23/17.
//  Copyright © 2017 DTS. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DataObject;

NS_ASSUME_NONNULL_BEGIN

@interface OutlineViewController : NSViewController

- (instancetype)initWithDataObjects:(NSArray <DataObject *> *)objects;

@end

NS_ASSUME_NONNULL_END
