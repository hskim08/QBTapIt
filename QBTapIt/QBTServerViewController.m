//
//  QBTServerViewController.m
//  QBTapIt
//
//  Created by Ethan Kim on 2/7/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import "QBTServerViewController.h"

#import "QBTServerSettings.h"

@interface QBTServerViewController () <UITextFieldDelegate>

@end

@implementation QBTServerViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.uploadText.text = [QBTServerSettings sharedInstance].uploadServer;
    self.downloadText.text = [QBTServerSettings sharedInstance].songListServer;
    
    self.uploadText.delegate = self;
    self.downloadText.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate Selectors

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (textField == self.uploadText) {
        
        [QBTServerSettings sharedInstance].uploadServer = textField.text;
    }
    else if (textField == self.downloadText) {
        
        [QBTServerSettings sharedInstance].songListServer = textField.text;
    }
    
    return NO;
}

@end
