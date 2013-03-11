//
//  QBTFamiliarityViewController.m
//  QBTapIt
//
//  Created by Ethan Kim on 3/7/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import "QBTTaskFamiliarityViewController.h"

@interface QBTTaskFamiliarityViewController ()

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

#pragma mark - IBAction Selectors

- (IBAction) doneClicked:(UIButton*)sender
{
    [self.delegate handleFamiliarity:self.familiaritySlider.value*5];
    
    [self dismissViewControllerAnimated:YES
                             completion:^(void){
                                 
                                 [self.delegate didCloseFamiliarity];
                             }];
}

@end
