# Outline view API

## Working

1. Clone the repo and open `OutlineViewDemo.xcodeproj`
1. Build and Run the app
1. Double-click any Starred item
1. It becomes Unstarred and “teleports” to the bottom
1. Double-click any Unstarred item
1. It becomes Starred and “teleports” to the top

## Not Working

1. Open `OutlineViewDemo.xcodeproj`
1. Go to `Product ˒ Scheme ˒ Edit Scheme… ˒ Run ˒ Arguments`
1. Expand `Arguments Passed On Launch`
1. Enable `-UseMoveAPI` and `YES`
1. Build and Run the app
1. Double-click any Starred item
1. It jumps to the bottom, but *appearance* remains as it is Starred
1. Double-click any Unstarred item
1. It jumps to the top, but *appearance* remains as it is Unstarred

## Problem

The working version uses `removeItemsAtIndexes:inParent:withAnimation:` + `insertItemsAtIndexes:indexSetWithIndex:inParent:withAnimation:`, but this is a workaround. What we really want is `moveItemAtIndex:inParent:toIndex:inParent:`… However, it does not work:

```objc
if ([NSUserDefaults.standardUserDefaults boolForKey:@"UseMoveAPI"]) {
	[self.outlineView moveItemAtIndex:oldIndex inParent:nil toIndex:newIndex inParent:nil];
} else {
	[self.outlineView removeItemsAtIndexes:[NSIndexSet indexSetWithIndex:oldIndex] inParent:nil withAnimation:NSTableViewAnimationSlideUp];
	[self.outlineView insertItemsAtIndexes:[NSIndexSet indexSetWithIndex:newIndex] inParent:nil withAnimation:NSTableViewAnimationSlideDown];
}
```

This is a sequence of events for `remove`-`insert` API:

1. `outlineView:child:ofItem:`
1. `outlineView:rowViewForItem:`
1. `outlineView:viewForTableColumn:item:`
1. `outlineView:objectValueForTableColumn:byItem:`
1. `outlineView:isItemExpandable:`

And this is what is called after `move` API:

1. *Nothing*

## Solution

It is assumed that you _move exactly the same cell_, but I want it to be reloaded during animation 😇

### How?