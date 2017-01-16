//
//  SampleWindowUIController.m
//  SampleViewer
//
//  Created by ilja on 12.01.17.
//  Copyright © 2017 iwascoding GmbH. All rights reserved.
//

#import "SampleWindowUIController.h"

#import "Entry.h"
#import "Thread.h"

@interface SampleWindowUIController ()

@property (weak) IBOutlet NSTreeController	*treeController;
@property (weak) IBOutlet NSOutlineView		*outlineView;

@property NSArray *callersForSelectedEntry;


@property Entry *selectedEntry;

@end

@implementation SampleWindowUIController

- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
	id selectedObject = self.treeController.selectedObjects.firstObject;
	
	if ([selectedObject isKindOfClass:[Entry class]])
	{
		self.selectedEntry = selectedObject;
		self.callersForSelectedEntry = [[self.selectedEntry.thread callersForSymbol:self.selectedEntry.name] allObjects];
	}
	else
	{
		self.selectedEntry = nil;
		self.callersForSelectedEntry = nil;
	}
}

- (IBAction) expandHeaviestStackTraceInSelectedThread:(id)sender
{
	GenericEntry *itemToExpand = self.selectedThread;
	
	while (itemToExpand)
	{
		[self.outlineView expandItem:[self treeNodeForEntry:itemToExpand]];
		itemToExpand = itemToExpand.subEntries.firstObject;
	}
}

- (Thread*) selectedThread
{
	id		selectedObject = self.treeController.selectedObjects.firstObject;
	Thread *selectedThread;
	
	if ([selectedObject isKindOfClass:Thread.class])
	{
		selectedThread = selectedObject;
	}
	else
	{
		selectedThread = [selectedObject thread];
	}
	return selectedThread;
}

- (NSTreeNode*) treeNodeForEntry:(GenericEntry*) inEntry
{
	for (NSInteger row = 0; row < self.outlineView.numberOfRows; row++)
	{
		NSTreeNode *node = [self.outlineView itemAtRow:row];
		
		if (node.representedObject == inEntry)
		{
			return node;
		}
	}
	return nil;
}

@end
