//
//  QBTAudioPlayer.m
//  QBTapIt
//
//  Created by Ethan Kim on 1/24/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import "QBTAudioPlayer.h"

#import <AVFoundation/AVFoundation.h>

@interface QBTAudioPlayer()<AVAudioPlayerDelegate>

@property AVAudioPlayer* audioPlayer;

@end

@implementation QBTAudioPlayer

#pragma mark - Singleton

static QBTAudioPlayer* sharedInstance = nil;
+ (QBTAudioPlayer *) sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[QBTAudioPlayer alloc] init];
     
        // setup audio session
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient
                                               error: nil];
        
        NSError *activationError = nil;
        [[AVAudioSession sharedInstance] setActive:YES
                                             error:&activationError];
        
        // Registers this class as the delegate of the audio session.
        [[AVAudioSession sharedInstance] setDelegate:self];
        
//        NSLog(@"Audio Session Setup!");
    }
    
    return sharedInstance;
}

#pragma mark - Public Selectors

- (void) initWithUrl:(NSURL*)url
{
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url
                                                              error:nil];
    
    self.audioPlayer.delegate = self;
}

- (void) play
{
    [self.audioPlayer play];
}

- (void) pause
{
    [self.audioPlayer pause];
}

- (void) stop
{
    [self.audioPlayer stop];
}

#pragma mark - AVAudioPlayerDelegate Selectors

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.delegate audioPlayerDidFinishPlaying];
}

@end
