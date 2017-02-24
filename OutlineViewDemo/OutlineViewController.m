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
#import "HeaderCellView.h"

@interface OutlineViewController () <NSOutlineViewDataSource, NSOutlineViewDelegate>

@property (nonatomic, strong, readonly) NSMutableArray <NSMutableArray <OutlineItem *> *> *items;
@property (nonatomic, strong) NSOutlineView *outlineView;

@end

@implementation OutlineViewController

- (instancetype)initWithDataObjects:(NSArray<DataObject *> *)objects {
	NSParameterAssert(objects.count > 1);
	if ((self = [super init])) {
		_items = [[NSMutableArray alloc] initWithObjects:[[NSMutableArray alloc] init], [[NSMutableArray alloc] init], nil];
		for (DataObject *object in objects.reverseObjectEnumerator) {
			[self insertDataObject:object atIndex:0];
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
	self.outlineView.rowSizeStyle = NSTableViewRowSizeStyleCustom;
	self.outlineView.intercellSpacing = CGSizeZero;
	self.outlineView.dataSource = self;
	self.outlineView.delegate = self;
	[self.outlineView expandItem:nil expandChildren:YES];
}

#pragma mark - NSOutlineViewDataSource

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
	if (item == nil) {
		return self.items.count;
	} else if ([item isKindOfClass:NSNumber.class]) {
		BOOL isStarred = [item boolValue];
		return [self collectionForStarred:isStarred].count;
	} else {
		return 0;
	}
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)position ofItem:(id)item {
	if (item == nil) {
		BOOL isStarred = (position == 0);
		return @(isStarred);
	} else {
		BOOL isStarred = [item boolValue];
		return [self collectionForStarred:isStarred][position];
	}
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
	return [item isKindOfClass:NSNumber.class];
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(OutlineItem *)item {
	return ([item isKindOfClass:OutlineItem.class] ? [item dataObject] : item);
}

#pragma mark - NSOutlineViewDelegate

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
	Class cellViewClass = ([item isKindOfClass:OutlineItem.class] ? [item cellViewClass] : HeaderCellView.class);
	NSString *cellViewIdentifier = NSStringFromClass(cellViewClass);
	NSTableCellView *cellView = [outlineView makeViewWithIdentifier:cellViewIdentifier owner:nil];
	if (cellView == nil) {
		cellView = (id)[[cellViewClass alloc] init];
		NSAssert([cellView isKindOfClass:NSTableCellView.class], @"%@ must be represented by subclass of NSTableCellView", item);
		cellView.identifier = cellViewIdentifier;
	}
	return cellView;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item {
	return [item isKindOfClass:NSNumber.class];
}

- (NSTableRowView *)outlineView:(NSOutlineView *)outlineView rowViewForItem:(id)item {
	NSString *const Identifier = @"OutlineRowView";
	OutlineRowView *rowView = [outlineView makeViewWithIdentifier:Identifier owner:nil];
	if (rowView == nil) {
		rowView = [[OutlineRowView alloc] init];
		rowView.identifier = Identifier;
	}
	rowView.emphasizedBackgroundColor = ([item isKindOfClass:OutlineItem.class] ? [item emphasizedBackgroundColor] : nil);
	return rowView;
}

- (CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item {
	return ([item isKindOfClass:OutlineItem.class] ? ([item dataObject].starred ? 64.0 : 44.0) : 32.0);
}

#pragma mark - User Actions

- (IBAction)toggleStar:(id)sender {
	NSInteger clickedRow = [self.outlineView rowForView:sender];
	if (clickedRow < 0) {
		clickedRow = self.outlineView.selectedRow;
	}
	if (clickedRow < 0) {
		return;
	}

	// Expand or Collapse header on Double-Click
	id item = [self.outlineView itemAtRow:clickedRow];
	if ([item isKindOfClass:NSNumber.class]) {
		if ([self.outlineView isItemExpanded:item]) {
			[self.outlineView.animator collapseItem:item];
		} else {
			[self.outlineView.animator expandItem:item];
		}
		return;
	}

	[NSAnimationContext beginGrouping];
	if ((NSApp.currentEvent.modifierFlags & NSEventModifierFlagShift) > 0) {
		// Press Shift to make animation slower
		NSAnimationContext.currentContext.duration *= 10.0;
	} else if ((NSApp.currentEvent.modifierFlags & NSEventModifierFlagOption) > 0) {
		// Press Option to avoid animation
		NSAnimationContext.currentContext.duration = 0.0;
	}

	[self.outlineView beginUpdates];

	OutlineItem *newItem = [self toggleStarForItemAtIndex:clickedRow];

	[self.outlineView endUpdates];

	// Warning: AppKit does not handle new height when you reload item after move
	//          This results in mis-aligned cell view frame leading to bad layout
	//          To fix resize animation, we must adjust cell view frame manually!
	//          Note that timing is important, change frame only after endUpdates
	NSUInteger newIndex = [self.outlineView rowForItem:newItem];
	NSTableRowView *rowView = [self.outlineView rowViewAtRow:newIndex makeIfNecessary:NO];
	CGRect rowViewFrame = rowView.frame;
	NSTableCellView *cellView = [self.outlineView viewAtColumn:0 row:newIndex makeIfNecessary:NO];
	CGRect cellViewFrame = cellView.frame;
	cellViewFrame.size.height = CGRectGetHeight(rowViewFrame);
	cellView.frame = cellViewFrame;

	[NSAnimationContext endGrouping];
}

#pragma mark - Private API

- (NSMutableArray <OutlineItem *> *)collectionForStarred:(BOOL)isStarred {
	return (isStarred ? self.items.firstObject : self.items.lastObject);
}

- (OutlineItem *)insertDataObject:(DataObject *)object atIndex:(NSUInteger)position {
	NSMutableArray <OutlineItem *> *collection = [self collectionForStarred:object.starred];
	OutlineItem *item = [[OutlineItem alloc] initWithDataObject:object];
	[collection insertObject:item atIndex:position];
	return item;
}

- (OutlineItem *)toggleStarForItemAtIndex:(NSInteger)sourceRow {

	//
	// 1. Remove item from the old position
	//
	OutlineItem *oldItem = [self.outlineView itemAtRow:sourceRow];
	DataObject *oldObject = oldItem.dataObject;
	NSMutableArray <OutlineItem *> *oldCollection = [self collectionForStarred:oldObject.starred];
	NSUInteger oldPosition = [oldCollection indexOfObject:oldItem];
	[oldCollection removeObject:oldItem];

	//
	// 2. Create inverted model
	//
	DataObject *newObject = [[DataObject alloc] initWithTitle:oldObject.title starred:!oldObject.starred];

	//
	// 3. Move item to the top of its section
	//
	NSUInteger newPosition = 0;
	OutlineItem *newItem = [self insertDataObject:newObject atIndex:newPosition];

	//
	// 4. Notify outline view of model changes
	//
	id oldParent = @(oldObject.starred);
	id newParent = @(newObject.starred);
	[self.outlineView moveItemAtIndex:oldPosition inParent:oldParent toIndex:newPosition inParent:newParent];

	//
	// 5. Reload new item to update contents and height
	//
	[self.outlineView.animator expandItem:newParent];
	[self.outlineView reloadItem:oldItem];
	NSUInteger targetRow = [self.outlineView rowForItem:newItem];
	[self.outlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:targetRow] byExtendingSelection:NO];
	[self.outlineView scrollRowToVisible:targetRow];

	//
	// 6. Change row view attributes manually
	//
	OutlineRowView *rowView = [self.outlineView rowViewAtRow:targetRow makeIfNecessary:NO];
	rowView.emphasizedBackgroundColor = newItem.emphasizedBackgroundColor;

	return newItem;
}

@end
