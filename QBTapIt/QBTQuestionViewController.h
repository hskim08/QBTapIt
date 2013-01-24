//
//  QBTQuestionViewController.h
//  QBTapIt
//
//  Created by Ethan Kim on 11/2/12.
//  Copyright (c) 2012 CCRMA, Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QBTQuestionViewController : UIViewController

@property UITextField* IBOutlet ageText;
@property UIButton* IBOutlet genderButton;

@property UIButton* IBOutlet languageButton;

@property UIButton* IBOutlet handedButton;
@property UIButton* IBOutlet toneButton;
@property UIButton* IBOutlet arrhythmicButton;

@property UISlider* IBOutlet instrumentSlider;
@property UISlider* IBOutlet theorySlider;

@property UIView* IBOutlet pickerHolder;
@property UIPickerView* IBOutlet pickerView;

- (IBAction) continuePushed:(UIButton*)sender;

- (IBAction) genderPushed:(UIButton*)sender;
- (IBAction) languagePushed:(UIButton*)sender;
- (IBAction) handPushed:(UIButton*)sender;
- (IBAction) tonePushed:(UIButton*)sender;
- (IBAction) arrhythmicPushed:(UIButton*)sender;

- (IBAction) pickerDonePushed:(UIButton*)sender;


@end
