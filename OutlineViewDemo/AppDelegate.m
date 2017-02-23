//
//  AppDelegate.m
//  OutlineViewDemo
//
//  Created by Vadim Shpakovski on 2/23/17.
//  Copyright © 2017 DTS. All rights reserved.
//

#import "AppDelegate.h"

#import "OutlineViewController.h"
#import "DataObject.h"

@interface AppDelegate () <NSApplicationDelegate>

@property (nonatomic, weak) IBOutlet NSWindow *window;
@property (nonatomic, strong) NSWindowController *windowController;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	NSViewController *outlineViewController = [[OutlineViewController alloc] initWithDataObjects:@[
		 [[DataObject alloc] initWithTitle:@"Apple" starred:YES],
		 [[DataObject alloc] initWithTitle:@"Tesla" starred:YES],
		 [[DataObject alloc] initWithTitle:@"Twitter" starred:YES],
		 [[DataObject alloc] initWithTitle:@"Google" starred:NO],
		 [[DataObject alloc] initWithTitle:@"Facebook" starred:NO],
		 [[DataObject alloc] initWithTitle:@"Amazon" starred:NO],
		 [[DataObject alloc] initWithTitle:@"Samsung" starred:NO]
	]];
	self.windowController = [[NSWindowController alloc] initWithWindow:self.window];
	outlineViewController.view.frame = self.window.contentView.frame;
	self.windowController.contentViewController = outlineViewController;
	[self.window center];
	[self.windowController showWindow:nil];
}

@end
