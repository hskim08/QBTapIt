//
//  QBTTaskQuestionViewController.h
//  QBTapIt
//
//  Created by Ethan Kim on 1/14/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QBTTaskQuestionViewControllerDelegate <NSObject>

- (void) handleAnswer:(UInt16)answer;

@end

@interface QBTTaskQuestionViewController : UIViewController

@property id<QBTTaskQuestionViewControllerDelegate> delegate;

- (IBAction) doneClicked:(UIButton*)sender;

@end
