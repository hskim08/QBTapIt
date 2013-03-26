//
//  QBTSelectViewController.h
//  QBTapIt
//
//  Created by Ethan Kim on 3/25/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QBTSelectViewController : UIViewController

@property NSString* titleString;
@property NSString* detailString;

@property IBOutlet UITableView* tableView;

@property IBOutlet UIPickerView* pickerView;

- (IBAction)donePushed:(UIBarButtonItem*)sender;

@end
