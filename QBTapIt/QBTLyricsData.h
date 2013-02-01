//
//  QBTLyricsData.h
//  QBTapIt
//
//  Created by Ethan Kim on 1/30/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QBTLyricsData : NSObject

+ (QBTLyricsData *) sharedInstance; // singleton

- (void) reloadFromUrl:(NSURL*)url;

- (UInt16) taskCount;

- (NSString*) titleForTask:(UInt16)task;
- (NSString*) artistForTask:(UInt16)task;
- (NSString*) lyricsForTask:(UInt16)task;
- (NSString*) filenameForTask:(UInt16)task;

@end
