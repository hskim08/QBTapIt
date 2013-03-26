//
//  QBTFamiliarityViewController.h
//  QBTapIt
//
//  Created by Hyung-Suk Kim on 3/7/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QBTTaskFamiliarityViewControllerDelegate <NSObject>

- (void) handleFamiliarity:(Float32)answer;

- (void) didCloseFamiliarity;

@end

@interface QBTTaskFamiliarityViewController : UIViewController

@property id<QBTTaskFamiliarityViewControllerDelegate> delegate;

@property BOOL noTaps;
@property NSUInteger taskIdx;

@property IBOutlet UISlider* familiaritySlider;

@end
