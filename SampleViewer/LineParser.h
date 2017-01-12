//
//  EntryParser.h
//  SampleViewer
//
//  Created by ilja on 12.01.17.
//  Copyright © 2017 iwascoding GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Entry;

@interface LineParser : NSObject

+ (id) objectFromLine:(NSString*) inLine;

@end
