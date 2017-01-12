//
//  GenericEntry.h
//  SampleViewer
//
//  Created by ilja on 12.01.17.
//  Copyright © 2017 iwascoding GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Entry;

@interface GenericEntry : NSObject

@property NSInteger sampleCount;
@property NSString  *name;

@property NSArray *subEntries;

- (void) addEntry:(Entry*) inEntry;

- (BOOL) isLeaf;


- (NSInteger) totalSamplesForSymbol:(NSString*)inName;

@end
