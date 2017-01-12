//
//  Entry.h
//  SampleViewer
//
//  Created by ilja on 12.01.17.
//  Copyright © 2017 iwascoding GmbH. All rights reserved.
//

#import "GenericEntry.h"

@class Thread;

@interface Entry : GenericEntry

@property NSString* prefix;

@property NSString	*library;
@property NSInteger offset;
@property NSString	*address;

@property (readonly) NSInteger level;

@property (weak) Thread *thread;

@end
