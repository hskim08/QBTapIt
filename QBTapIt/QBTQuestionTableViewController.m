//
//  QBTQuestionTableViewController.m
//  QBTapIt
//
//  Created by Ethan Kim on 3/25/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import "QBTQuestionTableViewController.h"

#import "QBTSelectViewController.h"

#import "QBTUserData.h"

@interface QBTQuestionTableViewController ()

@property (nonatomic) NSArray* handArray;
@property (nonatomic) NSArray* ynArray;

- (void) updateFromUserData;

- (BOOL) isDataValid;

@end

@implementation QBTQuestionTableViewController

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

    self.continueButton.enabled = NO;
    
    // Initialize user data
    QBTUserData* userData = [QBTUserData sharedInstance];
    [userData initData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:NO
                                       animated:YES];
    
    [self updateFromUserData];
    
    self.continueButton.enabled = [self isDataValid];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [segue.identifier isEqualToString:@"QuestionTableToSelect"] ) {
        UITableViewCell* cell = sender;
        
        QBTSelectViewController* vc = [segue destinationViewController];
        vc.titleString = cell.textLabel.text;
        vc.detailString = cell.detailTextLabel.text;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"QuestionTableToSelect"
                              sender:[tableView cellForRowAtIndexPath:indexPath]];
}

#pragma mark - IBAction Selectors

- (IBAction) continuePushed:(UIButton*)sender
{
    QBTUserData* userData = [QBTUserData sharedInstance];
    
    userData.instrumentTraining = self.instrumentSlider.value*5;
    userData.theoryTraining = self.theorySlider.value*5;
    userData.listeningHabits = self.habitSlider.value*5;
    
    // open next page
    userData.instrumentTraining == 0 ?
    [self performSegueWithIdentifier:@"QuestionTableToStart"
                              sender:self] :
    [self performSegueWithIdentifier:@"QuestionTableToTraining"
                              sender:self];
}

#pragma mark - Private Implementation

@synthesize handArray = _handArray;
- (NSArray*) handArray
{
    if (!_handArray) {
        _handArray = @[@"Left", @"Right", @"Both"];
    }
    return _handArray;
}

@synthesize ynArray = _ynArray;
- (NSArray*) ynArray
{
    if (!_ynArray) {
        _ynArray = @[@"No", @"Yes", @"Don't know"];
    }
    return _ynArray;
}

- (void) updateFromUserData
{
    QBTUserData* userData = [QBTUserData sharedInstance];
    
    self.ageLabel.text = userData.age > 0 ? [NSString stringWithFormat:@"%d", userData.age] : @"--";
    self.genderLabel.text = userData.gender ? userData.gender : @"--";
    self.languageLabel.text = userData.nativeLanguage ? userData.nativeLanguage : @"--";
    
    SInt8 val = 0;
    val = userData.handedness;
    self.handedLabel.text = [self.handArray objectAtIndex:(val < 0 ? 2 : val)];
    val = userData.toneDeaf;
    self.toneLabel.text = [self.ynArray objectAtIndex:(val < 0 ? 2 : val)];
    val = userData.arrhythmic;
    self.arrhythmicLabel.text = [self.ynArray objectAtIndex:(val < 0 ? 2 : val)];
}

- (BOOL) isDataValid
{
    QBTUserData* userData = [QBTUserData sharedInstance];
    
    if (userData.age < 1) return NO;
    if (userData.gender == nil) return NO;
    if (userData.nativeLanguage == nil) return NO;
    
    return YES;
}

@end
