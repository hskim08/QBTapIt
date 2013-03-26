//
//  QBTQuestionViewController.h
//  QBTapIt
//
//  Created by Ethan Kim on 11/2/12.
//  Copyright (c) 2012 CCRMA, Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QBTQuestionViewController : UIViewController

@property IBOutlet UIScrollView* scrollView;

//@property IBOutlet UITextField* ageText;
@property IBOutlet UIButton* ageButton;
@property IBOutlet UIButton* genderButton;
@property IBOutlet UIButton* languageButton;

@property IBOutlet UIButton* handedButton;
@property IBOutlet UIButton* toneButton;
@property IBOutlet UIButton* arrhythmicButton;

@property IBOutlet UISlider* instrumentSlider;
@property IBOutlet UISlider* theorySlider;
@property IBOutlet UISlider* habitSlider;

@property IBOutlet UIView* pickerHolder;
@property IBOutlet UIPickerView* pickerView;

@property IBOutlet UIBarButtonItem* continueButton;

- (IBAction) continuePushed:(UIButton*)sender;

- (IBAction) agePushed:(UIButton*)sender;
- (IBAction) genderPushed:(UIButton*)sender;
- (IBAction) languagePushed:(UIButton*)sender;
- (IBAction) handPushed:(UIButton*)sender;
- (IBAction) tonePushed:(UIButton*)sender;
- (IBAction) arrhythmicPushed:(UIButton*)sender;

- (IBAction) pickerDonePushed:(UIButton*)sender;


@end
