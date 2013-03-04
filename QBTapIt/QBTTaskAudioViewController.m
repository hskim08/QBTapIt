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
    
    [self.playButton setTitle:@"Play"
                     forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.continueButton.enabled = NO; // NOTE: this should be NO for release version
    self.titleLabel.text = self.songTitle;
    self.lyricsView.text = self.lyrics;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [QBTAudioPlayer sharedInstance].delegate = self;
//    [[QBTAudioPlayer sharedInstance] play]; // uncomment code to start playing immediately
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

    // uncomment the following code to close view controller
    // immediately after audio stops
//    [self dismissViewControllerAnimated:YES
//                             completion:^{
//                                 [self.delegate didCloseAudioViewController];
//                             }];
}

@end
