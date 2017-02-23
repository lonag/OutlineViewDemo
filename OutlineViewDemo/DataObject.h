//
//  DataObject.h
//  OutlineViewDemo
//
//  Created by Vadim Shpakovski on 2/23/17.
//  Copyright © 2017 DTS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataObject : NSObject

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, assign, getter = isStarred) BOOL starred;

- (instancetype)initWithTitle:(NSString *)title starred:(BOOL)starred;

@end

#pragma mark

@interface NSObject (ToggleStar)

- (IBAction)toggleStar:(id)sender;

@end

NS_ASSUME_NONNULL_END
