//
//  QBTSetupViewController.m
//  QBTapIt
//
//  Created by Ethan Kim on 11/2/12.
//  Copyright (c) 2012 CCRMA, Stanford University. All rights reserved.
//

#import "QBTSetupViewController.h"

@interface QBTSetupViewController ()

@end

@implementation QBTSetupViewController

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

- (IBAction)startPushed:(UIButton*)sender
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end
