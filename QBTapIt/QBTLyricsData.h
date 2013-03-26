//
//  QBTLyricsData.h
//  QBTapIt
//
//  Created by Hyung-Suk Kim on 1/30/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QBTLyricsData : NSObject

+ (QBTLyricsData *) sharedInstance; // singleton

+ (NSString*) songListFilename;

@property (nonatomic) BOOL isTrialRun;

- (void) reloadSongList;

- (UInt16) taskCount;

- (NSString*) titleForTask:(NSUInteger)task;
- (NSString*) artistForTask:(NSUInteger)task;
- (NSString*) yearForTask:(NSUInteger)task;
- (NSString*) lyricsForTask:(NSUInteger)task;
- (NSURL*) fileUrlForTask:(NSUInteger)task;

@end
