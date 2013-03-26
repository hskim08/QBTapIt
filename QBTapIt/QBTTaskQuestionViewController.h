//
//  QBTTaskQuestionViewController.h
//  QBTapIt
//
//  Created by Hyung-Suk Kim on 1/14/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QBTTaskQuestionViewControllerDelegate <NSObject>

//- (void) handleFamiliarity:(Float32)answer;
- (void) handleHelpful:(UInt16)answer;

- (void) willCloseQuestionnaire;
- (void) didCloseQuestionnaire;

@end


@interface QBTTaskQuestionViewController : UIViewController

@property id<QBTTaskQuestionViewControllerDelegate> delegate;
//@property BOOL withMusic;
//@property BOOL noTaps;

@property IBOutlet UIBarButtonItem* doneButton;

//@property IBOutlet UIView* familiarityView;
//@property IBOutlet UISlider* familiaritySlider;

@property IBOutlet UIView* helpfulView;
@property IBOutlet UILabel* answer1;
@property IBOutlet UILabel* answer2;
@property IBOutlet UILabel* answer3;
@property IBOutlet UILabel* answer4;
@property IBOutlet UILabel* answer5;
@property IBOutlet UILabel* answer6;
@property IBOutlet UILabel* checkBox1;
@property IBOutlet UILabel* checkBox2;
@property IBOutlet UILabel* checkBox3;
@property IBOutlet UILabel* checkBox4;
@property IBOutlet UILabel* checkBox5;
@property IBOutlet UILabel* checkBox6;

- (IBAction) doneClicked:(UIButton*)sender;
- (IBAction) labelTapped:(UITapGestureRecognizer*)sender;
- (IBAction) checkBoxTapped:(UITapGestureRecognizer*)sender;

@end
