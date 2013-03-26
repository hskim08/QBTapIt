//
//  QBTTrainingViewController.h
//  QBTapIt
//
//  Created by Hyung-Suk Kim on 3/26/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QBTTrainingViewController : UIViewController

@property IBOutlet UITextField* durationText;
@property IBOutlet UIButton* durationButton;
@property IBOutlet UITextField* instrumentText;

@property IBOutlet UITableView* tableView;

@property IBOutlet UIView* pickerHolder;
@property IBOutlet UIPickerView* pickerView;

@property IBOutlet UIBarButtonItem* continueButton;

- (IBAction)continuePushed:(UIBarButtonItem*)sender;

- (IBAction)addPushed:(UIButton*)sender;
- (IBAction)durationPushed:(UIButton*)sender;

- (IBAction) pickerDonePushed:(UIButton*)sender;

@end
