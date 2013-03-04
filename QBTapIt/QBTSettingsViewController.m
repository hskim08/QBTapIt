//
//  QBTSettingsViewController.m
//  QBTapIt
//
//  Created by Ethan Kim on 2/7/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import "QBTSettingsViewController.h"

#import "QBTServerSettings.h"

@interface QBTSettingsViewController () <UITextFieldDelegate>

@property (nonatomic) NSString* experimenterId;
@property (nonatomic) NSInteger trialCount;

@end

@implementation QBTSettingsViewController

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
    
    if (!self.experimenterId)
        self.experimenterId = @"Experimenter";
    self.experimenterIdText.text = self.experimenterId;
    
    if (self.trialCount < 1 || self.trialCount > 4) {
        self.trialCount = 2;
    }
    self.trialStepper.value = self.trialCount;
    self.trialLabel.text = [NSString stringWithFormat:@"%d", (int)self.trialStepper.value];
    
    self.experimenterIdText.delegate = self;
    
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

#pragma mark - IBAction Selectors

- (IBAction)donePushed:(UIButton*)sender
{
    // save id in case view is closed without returning
    self.experimenterId = self.experimenterIdText.text;
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (IBAction)trialStepperPushed:(UIStepper*)sender
{
    self.trialLabel.text = [NSString stringWithFormat:@"%d", (int)sender.value];
    
    // write value to default setting
    self.trialCount = sender.value;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - UITextFieldDelegate Selectors

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    // save to defaults
    if (textField == self.uploadText) {
        
        [QBTServerSettings sharedInstance].uploadServer = textField.text;
    }
    else if (textField == self.downloadText) {
        
        [QBTServerSettings sharedInstance].songListServer = textField.text;
    }
    else if (textField == self.experimenterIdText) {
        
        self.experimenterId = textField.text;
    }
    
    return NO;
}

#pragma mark - Private Implementation

@synthesize experimenterId = _experimenterId;
- (void) setExperimenterId:(NSString *)experimenterId
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:experimenterId forKey:@"ExperimenterId"];
    [defaults synchronize];
}

- (NSString*) experimenterId
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults objectForKey:@"ExperimenterId"];
}

@synthesize trialCount = _trialCount;
- (void) setTrialCount:(NSInteger)trialCount
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:trialCount forKey:@"TrialCount"];
    [defaults synchronize];
}

- (NSInteger) trialCount
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults integerForKey:@"TrialCount"];
}

@end
