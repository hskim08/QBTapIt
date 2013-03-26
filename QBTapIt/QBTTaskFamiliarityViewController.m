//
//  QBTFamiliarityViewController.m
//  QBTapIt
//
//  Created by Hyung-Suk Kim on 3/7/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import "QBTTaskFamiliarityViewController.h"

#import "QBTTaskAudioViewController.h"

@interface QBTTaskFamiliarityViewController () <QBTTaskAudioViewControllerDelegate>

@end

@implementation QBTTaskFamiliarityViewController

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.noTaps) {
        self.familiaritySlider.value = 0;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [segue.identifier isEqualToString:@"FamiliarityToAudio"] ) { // prepare audio view

        QBTTaskAudioViewController* audioVC = [segue destinationViewController];
        audioVC.delegate = self;
        
        audioVC.taskIdx = self.taskIdx;
    }
}

#pragma mark - IBAction Selectors

- (IBAction) doneClicked:(UIButton*)sender
{
    // save data
    [self.delegate handleFamiliarity:self.familiaritySlider.value*5];
    
    // show audio view
    [self performSegueWithIdentifier:@"FamiliarityToAudio"
                              sender:self];
}

#pragma mark - QBTTaskAudioViewControllerDelegate Selectors

- (void) didCloseAudioViewController
{
    [self dismissViewControllerAnimated:YES
                             completion:^(void){

                                 [self.delegate didCloseFamiliarity];
                             }];
}

@end
