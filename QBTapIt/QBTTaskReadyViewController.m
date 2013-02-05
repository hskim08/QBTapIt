//
//  QBTTaskReadyViewController.m
//  QBTapIt
//
//  Created by Ethan Kim on 2/4/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import "QBTTaskReadyViewController.h"

#import "QBTLyricsData.h"

@interface QBTTaskReadyViewController ()

@end

@implementation QBTTaskReadyViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController setToolbarHidden:NO
                                       animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)continueClicked:(UIButton*)sender
{
    [QBTLyricsData sharedInstance].isTrialRun = NO;
    
    [self performSegueWithIdentifier:@"ReadyToTask" sender:self];
}

@end
