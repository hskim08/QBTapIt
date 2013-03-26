//
//  QBTVolumeAdjustViewController.h
//  QBTapIt
//
//  Created by Hyung-Suk Kim on 2/27/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MediaPlayer/MediaPlayer.h>

@interface QBTVolumeAdjustViewController : UIViewController

@property IBOutlet MPVolumeView* volumeView;

- (IBAction)playClicked:(UIButton*)sender;
- (IBAction)continueClicked:(UIButton*)sender;

@end
