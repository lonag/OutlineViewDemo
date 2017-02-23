//
//  OutlineViewController.m
//  OutlineViewDemo
//
//  Created by Vadim Shpakovski on 2/23/17.
//  Copyright © 2017 DTS. All rights reserved.
//

#import "OutlineViewController.h"

#import "OutlineItem.h"
#import "OutlineRowView.h"
#import "DataObject.h"

@interface OutlineViewController () <NSOutlineViewDataSource, NSOutlineViewDelegate>

@property (nonatomic, strong, readonly) NSMutableArray <OutlineItem *> *items;
@property (nonatomic, strong) NSOutlineView *outlineView;

@end

@implementation OutlineViewController

- (instancetype)initWithDataObjects:(NSArray<DataObject *> *)objects {
	NSParameterAssert(objects.count > 1);
	if ((self = [super init])) {
		_items = [[NSMutableArray alloc] init];
		for (DataObject *object in objects) {
			[_items addObject:[[OutlineItem alloc] initWithDataObject:object]];
		}
	}
	return self;
}

- (void)dealloc {
	self.outlineView.dataSource = nil;
	self.outlineView.delegate = nil;
}

#pragma mark

- (void)loadView {
	NSTableColumn *tableColumn = [[NSTableColumn alloc] init];
	tableColumn.resizingMask = NSTableColumnAutoresizingMask;
	NSOutlineView *outlineView = [[NSOutlineView alloc] init];
	outlineView.allowsColumnResizing = YES;
	outlineView.headerView = nil;
	outlineView.columnAutoresizingStyle = NSTableViewFirstColumnOnlyAutoresizingStyle;
	[outlineView addTableColumn:tableColumn];
	NSScrollView *scrollView = [[NSScrollView alloc] init];
	scrollView.documentView = outlineView;
	scrollView.hasVerticalScroller = YES;
	scrollView.autohidesScrollers = YES;
	self.view = scrollView;
	self.outlineView = outlineView;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	self.outlineView.doubleAction = @selector(toggleStar:);
	self.outlineView.rowHeight = 44.0;
	self.outlineView.dataSource = self;
	self.outlineView.delegate = self;
}

#pragma mark - NSOutlineViewDataSource

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(OutlineItem *)item {
	return (item ? 0 : self.items.count);
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)position ofItem:(OutlineItem *)item {
	return (item ? nil : self.items[position]);
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
	return NO;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(OutlineItem *)item {
	return item.dataObject;
}

#pragma mark - NSOutlineViewDelegate

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(OutlineItem *)item {
	Class cellViewClass = item.cellViewClass;
	NSString *cellViewIdentifier = NSStringFromClass(cellViewClass);
	NSTableCellView *cellView = [outlineView makeViewWithIdentifier:cellViewIdentifier owner:nil];
	if (cellView == nil) {
		cellView = (id)[[cellViewClass alloc] init];
		NSAssert([cellView isKindOfClass:NSTableCellView.class], @"%@ must be represented by subclass of NSTableCellView", item);
		cellView.identifier = cellViewIdentifier;
	}
	return cellView;
}

- (NSTableRowView *)outlineView:(NSOutlineView *)outlineView rowViewForItem:(OutlineItem *)item {
	NSString *const Identifier = @"OutlineRowView";
	OutlineRowView *rowView = [outlineView makeViewWithIdentifier:Identifier owner:nil];
	if (rowView == nil) {
		rowView = [[OutlineRowView alloc] init];
		rowView.identifier = Identifier;
	}
	rowView.emphasizedBackgroundColor = item.emphasizedBackgroundColor;
	return rowView;
}

#pragma mark - User Actions

- (IBAction)toggleStar:(id)sender {
	NSInteger selectedRow = [self.outlineView rowForView:sender];
	if (selectedRow < 0) {
		selectedRow = self.outlineView.selectedRow;
	}
	if (selectedRow < 0) {
		return;
	}

	[NSAnimationContext beginGrouping];
	[self.outlineView beginUpdates];

	[self toggleStarForItemAtIndex:selectedRow];

	[self.outlineView endUpdates];
	[NSAnimationContext endGrouping];
}

#pragma mark - Private API

- (void)toggleStarForItemAtIndex:(NSInteger)oldIndex {

	//
	// 1. Remove item from the old position
	//
	DataObject *oldObject = self.items[oldIndex].dataObject;
	[self.items removeObjectAtIndex:oldIndex];

	//
	// 2. Create a new model with inverted Star
	//
	DataObject *newObject = [[DataObject alloc] initWithTitle:oldObject.title starred:!oldObject.starred];

	//
	// 3. Move Starred item to the top, Unstarred to the bottom
	//
	OutlineItem *newItem = [[OutlineItem alloc] initWithDataObject:newObject];
	NSInteger newIndex = (newObject.starred ? 0 : self.items.count);
	[self.items insertObject:newItem atIndex:newIndex];

	//
	// 4. Notify outline view of model changes
	//
	if ([NSUserDefaults.standardUserDefaults boolForKey:@"UseMoveAPI"]) {
		[self.outlineView moveItemAtIndex:oldIndex inParent:nil toIndex:newIndex inParent:nil];
	} else {
		[self.outlineView removeItemsAtIndexes:[NSIndexSet indexSetWithIndex:oldIndex] inParent:nil withAnimation:NSTableViewAnimationSlideUp];
		[self.outlineView insertItemsAtIndexes:[NSIndexSet indexSetWithIndex:newIndex] inParent:nil withAnimation:NSTableViewAnimationSlideDown];
	}
}

@end
