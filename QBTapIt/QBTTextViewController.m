//
//  QBTTextViewController.m
//  QBTapIt
//
//  Created by Hyung-Suk Kim on 11/2/12.
//  Copyright (c) 2012 CCRMA, Stanford University. All rights reserved.
//

#import "QBTTextViewController.h"

@interface QBTTextViewController ()<UITextViewDelegate>

@end

@implementation QBTTextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationItem.hidesBackButton = YES;
    
    // TODO: Load consent form from file
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction Selectors

- (IBAction)settingsPushed:(UIButton*)sender
{
    [self performSegueWithIdentifier:@"ConsentToSettings"
                              sender:self];
}

- (IBAction)agreePushed:(UIButton*)sender
{
    [self performSegueWithIdentifier:@"TextToQuestion"
                              sender:self];
}

- (IBAction)disagreePushed:(UIButton*)sender
{
    [self performSegueWithIdentifier:@"TextToDone"
                              sender:self];
}

@end
