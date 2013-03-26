//
//  QBTQuestionTableViewController.h
//  QBTapIt
//
//  Created by Ethan Kim on 3/25/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QBTQuestionTableViewController : UITableViewController

@property IBOutlet UILabel* ageLabel;
@property IBOutlet UILabel* genderLabel;
@property IBOutlet UILabel* languageLabel;

@property IBOutlet UILabel* handedLabel;
@property IBOutlet UILabel* toneLabel;
@property IBOutlet UILabel* arrhythmicLabel;

@property IBOutlet UISlider* instrumentSlider;
@property IBOutlet UISlider* theorySlider;
@property IBOutlet UISlider* habitSlider;

@property IBOutlet UIBarButtonItem* continueButton;


- (IBAction) continuePushed:(UIButton*)sender;

@end
