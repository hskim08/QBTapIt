//
//  QBTVolumeAdjustViewController.m
//  QBTapIt
//
//  Created by Ethan Kim on 2/27/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import "QBTVolumeAdjustViewController.h"

#import "QBTAudioPlayer.h"

#import <MediaPlayer/MediaPlayer.h>

@interface QBTVolumeAdjustViewController ()

@end

@implementation QBTVolumeAdjustViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction Selectors

- (IBAction)continueClicked:(UIButton*)sender
{
    [[QBTAudioPlayer sharedInstance] stop];
    
    [self performSegueWithIdentifier:@"VolumeToStart"
                              sender:self];
}

- (IBAction)playClicked:(UIButton*)sender
{
    NSURL* testTrackUrl = [[NSBundle mainBundle] URLForResource:@"earthAngel"
                                                  withExtension:@"mp3"];
    
    [[QBTAudioPlayer sharedInstance] initWithUrl:testTrackUrl];
    [[QBTAudioPlayer sharedInstance] play];
}

@end
