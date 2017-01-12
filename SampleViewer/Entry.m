//
//  Entry.m
//  SampleViewer
//
//  Created by ilja on 12.01.17.
//  Copyright © 2017 iwascoding GmbH. All rights reserved.
//

#import "Entry.h"
#import "Thread.h"

@implementation Entry

- (NSInteger) level
{
	return self.prefix.length;
}

- (NSString*) percentageInCallstack
{
	return [NSString stringWithFormat:@"%.2f%@", ((float)self.sampleCount / (float) self.thread.sampleCount) * 100, @"%"];
}

- (NSString*) percentageInThread
{
	NSInteger samplesInThread = [self.thread totalSamplesForSymbol:self.name];
	
	return [NSString stringWithFormat:@"%.2f%@", ((float)samplesInThread / (float) self.thread.sampleCount) * 100, @"%"];

}

@end
