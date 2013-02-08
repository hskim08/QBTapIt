//
//  QBTSettingsViewController.h
//  QBTapIt
//
//  Created by Ethan Kim on 2/7/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QBTSettingsViewController : UITableViewController

@property IBOutlet UITextField* experimenterIdText;

@property IBOutlet UIStepper* trialStepper;
@property IBOutlet UILabel* trialLabel;

- (IBAction)donePushed:(UIButton*)sender;

- (IBAction)trialStepperPushed:(UIStepper*)sender;

@end
