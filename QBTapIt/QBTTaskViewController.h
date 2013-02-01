//
//  QBTTaskViewController.h
//  QBTapIt
//
//  Created by Ethan Kim on 11/2/12.
//  Copyright (c) 2012 CCRMA, Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QBTTaskViewController : UIViewController

@property IBOutlet UILabel* titleLabel;
@property IBOutlet UITextView* lyricsTextView;
@property IBOutlet UILabel* tapLabel;

- (IBAction) nextPushed:(UIButton*)sender;

@end
