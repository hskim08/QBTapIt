//
//  QBTTaskDoneViewController.m
//  QBTapIt
//
//  Created by Hyung-Suk Kim on 11/2/12.
//  Copyright (c) 2012 CCRMA, Stanford University. All rights reserved.
//

#import "QBTTaskDoneViewController.h"

@interface QBTTaskDoneViewController ()

@end

@implementation QBTTaskDoneViewController

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

#pragma mark - IBAction Selectors
- (IBAction) okPushed:(UIButton*)sender
{
    [self performSegueWithIdentifier:@"DoneToConsent" sender:self];
}

@end
