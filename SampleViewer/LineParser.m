//
//  EntryParser.m
//  SampleViewer
//
//  Created by ilja on 12.01.17.
//  Copyright © 2017 iwascoding GmbH. All rights reserved.
//

#import "LineParser.h"

#import "Entry.h"
#import "Thread.h"

@implementation LineParser

+ (id) objectFromLine:(NSString*) inLine
{
	Entry *entry = [self parseEntryFromLine:inLine];
	
	if (entry)
	{
		return entry;
	}
	Thread *thread = [self parseThreadFromLine:inLine];

	return thread;
}

+ (Entry*) parseEntryFromLine:(NSString*) inLine
{
	NSDictionary *regexForKeyDict = @{@"prefix": @"^([\\s+!:|]+)",
									  @"sampleCount" : @"^[\\s+!:|]+(\\d+)",
									  @"name" : @"^.+\\d+\\s+(.+?)\\s+\\(in\\s.+",
									  @"library" : @"^.+\\s\\(in(\\s.+)\\).*",
									  @"offset" : @"^.+\\).*\\+\\s(\\w+)",
									  @"address" :  @"^.+(\\[0x[\\w,0\\.]+\\])"};
	Entry	*newEntry = [[Entry alloc] init];
	
	for (NSString *key in regexForKeyDict )
	{
		NSString *regex = regexForKeyDict[key];
		
		NSString *value = [self firstGroupFromRegex:regex inString:inLine];
		if (value)
		{
			[newEntry setValue:value forKey:key];
		}
		else
		{
			return nil;
		}
	}
	
	return newEntry;
}

+ (Thread*) parseThreadFromLine:(NSString*) inLine
{
	NSDictionary *regexForKeyDict = @{@"sampleCount": @"^\\s+(\\d+).+",
									  @"name" : @"^\\s+[\\d]+\\s+(.+)",};
	Thread	*newThread = [[Thread alloc] init];
	
	for (NSString *key in regexForKeyDict )
	{
		NSString *regex = regexForKeyDict[key];
		
		NSString *value = [self firstGroupFromRegex:regex inString:inLine];
		if (value)
		{
			[newThread setValue:value forKey:key];
		}
		else
		{
			return nil;
		}
	}
	
	return newThread;
}

+ (NSString*) firstGroupFromRegex:(NSString*) inRegEx inString:(NSString*) inLine
{
	NSError *regexError;
	NSRegularExpression *aRegx=[NSRegularExpression regularExpressionWithPattern:inRegEx options:NSRegularExpressionCaseInsensitive error:&regexError];
	
	NSArray *results=[aRegx matchesInString:inLine options:0 range:NSMakeRange(0, inLine.length)];
	NSTextCheckingResult *result = results.firstObject;

	if (result)
	{
		NSRange range = [result rangeAtIndex:1];
		
		if (range.length)
		{
			return [inLine substringWithRange:range];
		}
	}
	
	return nil;
	
}

@end
