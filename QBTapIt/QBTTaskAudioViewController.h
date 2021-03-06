//
//  QBTTaskAudioViewController.h
//  QBTapIt
//
//  Created by Hyung-Suk Kim on 11/2/12.
//  Copyright (c) 2012 CCRMA, Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QBTTaskAudioViewControllerDelegate <NSObject>

- (void) didCloseAudioViewController;

@end

@interface QBTTaskAudioViewController : UIViewController

@property id<QBTTaskAudioViewControllerDelegate> delegate;

@property NSUInteger taskIdx;

@property IBOutlet UIBarButtonItem* continueButton;
@property IBOutlet UIButton* playButton;

@property IBOutlet UILabel* titleLabel;
@property IBOutlet UILabel* artistLabel;
@property IBOutlet UITextView* lyricsView;

- (IBAction) doneClicked:(UIButton*)sender;
- (IBAction) playClicked:(UIButton*)sender;

@end
