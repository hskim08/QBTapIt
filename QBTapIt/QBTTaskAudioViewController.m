//
//  QBTTaskAudioViewController.m
//  QBTapIt
//
//  Created by Ethan Kim on 11/2/12.
//  Copyright (c) 2012 CCRMA, Stanford University. All rights reserved.
//

#import "QBTTaskAudioViewController.h"

#import "QBTAudioPlayer.h"

@interface QBTTaskAudioViewController () <QBTAudioPlayerDelegate>

@end

@implementation QBTTaskAudioViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.playButton.enabled = YES;
    [self.playButton setTitle:@"Play"
                     forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

#ifdef DEBUG
    self.continueButton.enabled = YES; // Note: enable button for debugging
#else
    self.continueButton.enabled = NO;
#endif
    
    self.titleLabel.text = self.songTitle;
    self.artistLabel.text = self.artist;
    self.lyricsView.text = self.lyrics;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [QBTAudioPlayer sharedInstance].delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction Selectors

- (IBAction) doneClicked:(UIButton*)sender
{
    [[QBTAudioPlayer sharedInstance] stop];
    
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 [self.delegate didCloseAudioViewController];
                             }];
}

- (IBAction) playClicked:(UIButton*)sender
{
    if ( [QBTAudioPlayer sharedInstance].isPlaying ) {
        
        [[QBTAudioPlayer sharedInstance] stop];
        
        [self.playButton setTitle:@"Play"
                         forState:UIControlStateNormal];
    }
    else {
        
        [[QBTAudioPlayer sharedInstance] play];
        
        [self.playButton setTitle:@"Pause"
                         forState:UIControlStateNormal];
    }
}

#pragma mark QBTAudioPlayerDelegate Selectors
- (void)audioPlayerDidFinishPlaying
{
    self.continueButton.enabled = YES;

    [[QBTAudioPlayer sharedInstance] stop];
    
    [self.playButton setTitle:@"Play"
                     forState:UIControlStateNormal];
    
    self.playButton.enabled = NO; // disable play button. subject can only hear the music once.
    [self.playButton setAlpha:0.5];
}

@end
