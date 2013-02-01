//
//  QBTSetupViewController.m
//  QBTapIt
//
//  Created by Ethan Kim on 11/2/12.
//  Copyright (c) 2012 CCRMA, Stanford University. All rights reserved.
//

#import "QBTSetupViewController.h"

#import "QBTLyricsData.h"

@interface QBTSetupViewController () <UITextFieldDelegate>

@property (nonatomic) NSString* experimenterId;

@end

@implementation QBTSetupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (!self.experimenterId)
        self.experimenterId = @"Experimenter";
    
    self.experimenterIdText.text = self.experimenterId;
    self.experimenterIdText.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction Selectors

- (IBAction)startPushed:(UIButton*)sender
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (IBAction)reloadPushed:(UIButton*)sender
{
    // TODO: read from NSUserDefaults
    NSURL* downloadUrl = [NSURL URLWithString:@"http://ccrma.stanford.edu/~hskim08/qbt/lyrics.csv"];
    
    [[QBTLyricsData sharedInstance] reloadFromUrl:downloadUrl];
}

#pragma mark - UITextFieldDelegate Selectors

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    // save to defaults
    NSLog(@"Experimenter ID: %@", textField.text);

    self.experimenterId = textField.text;
    
    return NO;
}

#pragma mark - Private Implementation

@synthesize experimenterId = _experimenterId;
- (void) setExperimenterId:(NSString *)experimenterId
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:experimenterId forKey:@"ExperimenterId"];
    [defaults synchronize];
}

- (NSString*) experimenterId
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    return [defaults objectForKey:@"ExperimenterId"];
}

@end
