//
//  QBTTaskTextViewController.m
//  QBTapIt
//
//  Created by Ethan Kim on 11/2/12.
//  Copyright (c) 2012 CCRMA, Stanford University. All rights reserved.
//

#import "QBTTaskTextViewController.h"

@interface QBTTaskTextViewController ()

@end

@implementation QBTTaskTextViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    // TODO: Load task explanation from file
}

#pragma mark - IBAction Selectors

- (IBAction) startClicked:(UIButton*)sender
{
    [self performSegueWithIdentifier:@"StartToTask" sender:self];
}

@end
