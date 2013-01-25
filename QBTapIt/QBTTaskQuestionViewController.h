//
//  QBTTaskQuestionViewController.h
//  QBTapIt
//
//  Created by Ethan Kim on 1/14/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QBTTaskQuestionViewControllerDelegate <NSObject>

- (void) handleFamiliarity:(UInt16)answer;

- (void) didFinishQuestionnaire;

@end


@interface QBTTaskQuestionViewController : UIViewController

@property id<QBTTaskQuestionViewControllerDelegate> delegate;

@property IBOutlet UISlider* familiaritySlider;

@property IBOutlet UILabel* answer1;
@property IBOutlet UILabel* answer2;
@property IBOutlet UILabel* answer3;
@property IBOutlet UILabel* answer4;
@property IBOutlet UILabel* answer5;

- (IBAction) doneClicked:(UIButton*)sender;
- (IBAction) labelTapped:(UITapGestureRecognizer*)sender;

@end
