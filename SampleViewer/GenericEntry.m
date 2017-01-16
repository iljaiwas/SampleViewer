//
//  GenericEntry.m
//  SampleViewer
//
//  Created by ilja on 12.01.17.
//  Copyright © 2017 iwascoding GmbH. All rights reserved.
//

#import "GenericEntry.h"

#import "Entry.h"

@implementation GenericEntry

- (void) addEntry:(Entry*) inEntry
{
	if (nil == self.subEntries)
	{
		self.subEntries = @[inEntry];
	}
	else
	{
		self.subEntries = [self.subEntries arrayByAddingObject:inEntry];
	}

}

+ (NSSet *)keyPathsForValuesAffectingIsLeaf
{
	return [NSSet setWithObject:@"subEntries"];
}

- (BOOL) isLeaf
{
	return self.subEntries.count == 0;
}

+(NSSet *)keyPathsForValuesAffectingSubEntryCount
{
	return [NSSet setWithObject:@"subEntries"];
}

- (NSInteger) subEntryCount
{
	return self.subEntries.count;
}

- (NSString*) percentageInCallstack
{
	return nil;
}

- (NSInteger) totalSamplesForSymbol:(NSString*)inName
{
	NSInteger total = 0;
	
	if ([self.name isEqualToString:inName])
	{
		total += self.sampleCount;
	}
	
	for (Entry *entry in self.subEntries)
	{
		total += [entry totalSamplesForSymbol:inName];
	}
	return total;
}

- (NSSet*) callersForSymbol:(NSString*) inSymbol
{
	NSMutableSet *callers = [NSMutableSet set];
	
	for (Entry *entry in self.subEntries)
	{
		if ([entry.name isEqualToString:inSymbol])
		{
			[callers addObject:self];
		}
		[callers unionSet:[entry callersForSymbol:inSymbol]];
	}
	return [NSSet setWithSet:callers];
}

@end
