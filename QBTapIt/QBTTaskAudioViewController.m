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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.continueButton.enabled = YES; // TODO: this should be NO for release version
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [QBTAudioPlayer sharedInstance].delegate = self;
    [[QBTAudioPlayer sharedInstance] play];
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

#pragma mark QBTAudioPlayerDelegate Selectors
- (void)audioPlayerDidFinishPlaying
{
    self.continueButton.enabled = YES;

    [[QBTAudioPlayer sharedInstance] stop];

    // uncomment the following coe to close view controller
    // immediately after audio stops
//    [self dismissViewControllerAnimated:YES
//                             completion:^{
//                                 [self.delegate didCloseAudioViewController];
//                             }];
}

@end
