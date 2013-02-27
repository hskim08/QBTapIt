//
//  QBTAudioPlayer.h
//  QBTapIt
//
//  Created by Ethan Kim on 1/24/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QBTAudioPlayerDelegate <NSObject>

- (void)audioPlayerDidFinishPlaying;

@end

@interface QBTAudioPlayer : NSObject

+ (QBTAudioPlayer *) sharedInstance;

@property id<QBTAudioPlayerDelegate> delegate;

- (void) initWithUrl:(NSURL*)url;

- (void) play;
- (void) pause;
- (void) stop;

- (BOOL) isPlaying;

@end
