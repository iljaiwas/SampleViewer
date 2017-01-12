//
//  Document.m
//  SampleViewer
//
//  Created by ilja on 12.01.17.
//  Copyright © 2017 iwascoding GmbH. All rights reserved.
//

#import "Document.h"

#import "LineParser.h"
#import "Thread.h"
#import "Entry.h"
#import "SampleWindowUIController.h"

@interface Document ()

@property NSArray *threads;

@property NSMutableArray *callStack; // used during parsing only

@property (weak) IBOutlet SampleWindowUIController *windowUIController;

@end

@implementation Document

- (instancetype)init {
    self = [super init];
    if (self) {
		// Add your subclass-specific initialization here.
    }
    return self;
}

+ (BOOL)autosavesInPlace {
	return YES;
}

- (NSString *)windowNibName {
	// Override returning the nib file name of the document
	// If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
	return @"Document";
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
	// Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
	// You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
	[NSException raise:@"UnimplementedMethod" format:@"%@ is unimplemented", NSStringFromSelector(_cmd)];
	return nil;
}

-(BOOL)readFromURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError * _Nullable __autoreleasing *)outError
{
	NSError				*error;
	NSStringEncoding	encoding;
	NSString			*fileContents = [NSString stringWithContentsOfURL:url usedEncoding:&encoding error:&error];
	
	if (fileContents == nil)
	{
		*outError = error;
		return NO;
	}
	
	NSArray *lines = [fileContents componentsSeparatedByString:@"\n"];
	
	self.callStack = [NSMutableArray array];
	
	for (NSString *line in lines)
	{
		id object = [LineParser objectFromLine:line];
		
		if ([object isKindOfClass:[Thread class]])
		{
			[self addThread:object];
		}
		else if ([object isKindOfClass:[Entry class]])
		{
			[self addEntry:object];
		}
	}
	
	self.callStack = nil;
	
	return YES;
}

- (void) addThread:(Thread*) inThread
{
	if (nil == self.threads)
	{
		self.threads = @[inThread];
	}
	else
	{
		self.threads = [self.threads arrayByAddingObject:inThread];
	}
	[self.callStack removeAllObjects];
}

- (void) addEntry:(Entry*) inEntry
{
	if (self.callStack.count == 0)
	{
		// first entry for this thread
		[(Thread*)self.threads.lastObject addEntry:inEntry];
	}
	else
	{
		Entry *lastEntry = self.callStack.lastObject;
		
		while (inEntry.level <= lastEntry.level)
		{
			[self.callStack removeLastObject];
			lastEntry = self.callStack.lastObject;
		}
		[lastEntry addEntry:inEntry];
	}
	[self.callStack addObject:inEntry];
	inEntry.thread = self.threads.lastObject;
}

- (IBAction) expandHeaviestStackTraceInSelectedThread:(id)sender
{
	[self.windowUIController expandHeaviestStackTraceInSelectedThread:sender];
}

@end
