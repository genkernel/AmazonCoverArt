//
//  GTMLogger+ASL.h
//
//  Copyright 2007-2008 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not
//  use this file except in compliance with the License.  You may obtain a copy
//  of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
//  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
//  License for the specific language governing permissions and limitations under
//  the License.
//

#import <Foundation/Foundation.h>
#import <asl.h>
#import "GTMLogger.h"


// GTMLogger (GTMLoggerASLAdditions)
//
// Adds a convenience creation method that allows you to get a standard
// GTMLogger object that is configured to write to ASL (Apple System Log) using
// the GTMLogASLWriter (declared below).
//
@interface GTMLogger (GTMLoggerASLAdditions)

// Returns a new autoreleased GTMLogger instance that will log to ASL, using
// the GTMLogStandardFormatter, and the GTMLogLevelFilter filter.
+ (id)standardLoggerWithASL;

@end


@class GTMLoggerASLClient;

// GTMLogASLWriter
//
// A GTMLogWriter implementation that will send log messages to ASL (Apple
// System Log facility). To use with GTMLogger simply set the "writer" for a
// GTMLogger to be an instance of this class. The following example sets the
// shared system logger to lot to ASL.
//
//   [[GTMLogger sharedLogger] setWriter:[GTMLogASLWriter aslWriter]];
//   GTMLoggerInfo(@"Hi");  // This is sent to ASL
//
// See GTMLogger.h for more details and a higher-level view.
//
@interface GTMLogASLWriter : NSObject <GTMLogWriter> {
@private
	Class aslClientClass_;
}

// Returns an autoreleased GTMLogASLWriter instance that uses an instance of
// GTMLoggerASLClient.
+ (id)aslWriter;

// Designated initializer. Uses instances of the specified |clientClass| to talk
// to the ASL system. This method is typically only useful for testing. Users
// should generally NOT use this method to get an instance. Instead, simply use
// the +aslWriter method to obtain an instance.
- (id)initWithClientClass:(Class)clientClass;

@end  // GTMLogASLWriter


// Helper class used by GTMLogASLWriter to create an ASL client and write to the
// ASL log. This class is need to make management/cleanup of the aslclient work
// in a multithreaded environment. You'll need one of these GTMLoggerASLClient
// per thread (this is automatically handled by GTMLogASLWriter).
//
// This class should rarely (if EVER) be used directly. It's designed to be used
// internally by GTMLogASLWriter, and by some unit tests. It should not be
// used externally.
@interface GTMLoggerASLClient : NSObject {
@private
	aslclient client_;
}

// Sends the given string to ASL at the specified ASL log |level|.
- (void)log:(NSString *)msg level:(int)level;

@end

