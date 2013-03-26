//
//  QBTTaskViewController.m
//  QBTapIt
//
//  Created by Ethan Kim on 11/2/12.
//  Copyright (c) 2012 CCRMA, Stanford University. All rights reserved.
//

#import "QBTTaskViewController.h"

#import "QBTLyricsData.h"

#import "QBTUserData.h"
#import "QBTSessionData.h"
#import "QBTTaskData.h"

#import "QBTTaskFamiliarityViewController.h"
#import "QBTTaskQuestionViewController.h"

@interface QBTTaskViewController () <QBTTaskFamiliarityViewControllerDelegate, QBTTaskQuestionViewControllerDelegate>

@property NSInteger taskNumber;
@property NSTimeInterval startTime;
@property NSArray* taskOrder;
@property BOOL withMusic;

// Data Arrays
@property NSMutableString* tapOnData;
@property NSMutableString* tapOffData;
@property NSMutableString* tapXPosData;
@property NSMutableString* tapYPosData;
@property NSMutableString* tapOffXPosData;
@property NSMutableString* tapOffYPosData;

@property QBTTaskData* currentTask;

- (void) createRandomOrder;

- (void) updateTaskUI;
- (void) startTask;
- (void) saveTaskData;

@end

@implementation QBTTaskViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = YES;
    
    [self.navigationController setToolbarHidden:YES
                                       animated:YES];
    
    if ( [QBTUserData sharedInstance].handedness == 0 ) { // left handed - hide left button
        self.navigationItem.leftBarButtonItem = nil;
    }
    else { // right handed - hide right button
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    self.taskNumber = 0;
    self.withMusic = NO;
    QBTSessionData* sessionData = [QBTSessionData sharedInstance];
    [sessionData initData];
    sessionData.userId = [QBTUserData sharedInstance].userId;
    
    // send user data to server
    if (![QBTLyricsData sharedInstance].isTrialRun)
        [[QBTUserData sharedInstance] sendToServer];
    
    // create random order
    [self createRandomOrder];
    
    [self updateTaskUI];
    [self startTask];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIView override

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    // light tap label
    self.tapLabel.textColor = [UIColor greenColor];
    
    // get tap on time
    NSTimeInterval tapOnTime = [[NSDate date] timeIntervalSince1970] - self.startTime;
    
    for (UITouch* touch in touches) { // for each touch
        
        // save tap on time
        [self.tapOnData appendFormat:@"%f, ", tapOnTime];
//        NSLog(@"On: %f", tapOnTime);
        
        // save position
        CGPoint point = [touch locationInView:self.view];
        [self.tapXPosData appendFormat:@"%f, ", point.x];
        [self.tapYPosData appendFormat:@"%f, ", self.view.frame.size.height - point.y];
        
        NSLog(@"On: %f (%.1f/%.1f)", tapOnTime, point.x, self.view.frame.size.height - point.y);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    // unlight tap label
    self.tapLabel.textColor = [UIColor blackColor];
    
    // get tap off time
    NSTimeInterval tapOffTime = [[NSDate date] timeIntervalSince1970] - self.startTime;;
    
    for (UITouch* touch in touches) {
        
        // save tap off time
        [self.tapOffData appendFormat:@"%f, ", tapOffTime];
        
        // save position
        CGPoint point = [touch locationInView:self.view];
        [self.tapOffXPosData appendFormat:@"%f, ", point.x];
        [self.tapOffYPosData appendFormat:@"%f, ", self.view.frame.size.height - point.y];
        
        NSLog(@"Off: %f (%.1f/%.1f)", tapOffTime, point.x, self.view.frame.size.height - point.y);
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [segue.identifier isEqualToString:@"TaskToFamiliarity"] ) { // prepare familiarity
        
        QBTTaskFamiliarityViewController* familiarityVC = [segue destinationViewController];
        familiarityVC.delegate = self;
        
        familiarityVC.noTaps = (self.tapOnData.length < 1);
        
        NSNumber* n = [self.taskOrder objectAtIndex:self.taskNumber];
        familiarityVC.taskIdx = n.intValue;
    }
    else if ( [segue.identifier isEqualToString:@"TaskToTaskQuestion"] ) { // prepare questionnaire
        
        QBTTaskQuestionViewController* questionVC = [segue destinationViewController];
        questionVC.delegate = self;
    }
}

#pragma mark - IBAction Selectors

- (IBAction) nextPushed:(UIButton*)sender
{    
    // open task question view
    self.withMusic ? [self performSegueWithIdentifier:@"TaskToTaskQuestion" sender:self] : [self performSegueWithIdentifier:@"TaskToFamiliarity" sender:self];
}

#pragma mark - Private Implementation

- (void) createRandomOrder
{
    UInt16 count = [[QBTLyricsData sharedInstance] taskCount];
    NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:count];

    for (UInt16 i = 0; i < count; i++ ) {
        
        [array setObject:[NSNumber numberWithInt:i]
      atIndexedSubscript:i];
    }
    
    if ([QBTLyricsData sharedInstance].isTrialRun) { // don't randomize for trial
        
        self.taskOrder = array;
    }
    else {
        
        NSMutableArray* result = [[NSMutableArray alloc] initWithCapacity:0];
        srand(time(NULL)); // set random seed
        
        while (array.count > 0) {
            int removeIdx = rand() % array.count;
            
            [result addObject:[array objectAtIndex:removeIdx]];
            [array removeObjectAtIndex:removeIdx];
        }
        
        self.taskOrder = result;
    }
}

- (void) updateTaskUI
{
    // update navigation title
    self.navigationItem.title = [NSString stringWithFormat:@"%@ %d", @"Task", (self.taskNumber+1)];
    
    // get actual task index after randomization
    NSNumber* n = [self.taskOrder objectAtIndex:self.taskNumber];
    int taskIdx = n.intValue;
    
    // update title text
    self.titleLabel.text = [NSString stringWithFormat:@"%@", [[QBTLyricsData sharedInstance] titleForTask:taskIdx]];
    self.artistLabel.text = [NSString stringWithFormat:@"%@ (%@)",
                             [[QBTLyricsData sharedInstance] artistForTask:taskIdx],
                             [[QBTLyricsData sharedInstance] yearForTask:taskIdx]];
    
    // load new lyrics
    self.lyricsTextView.text = [[QBTLyricsData sharedInstance] lyricsForTask:taskIdx];
}

- (void) startTask
{
    NSNumber* n = [self.taskOrder objectAtIndex:self.taskNumber];
    int taskIdx = n.intValue;
    
    // initialize task data object
    self.currentTask = [[QBTTaskData alloc] init];
    self.currentTask.trackOrder = self.taskNumber+1;
    self.currentTask.songTitle = [[QBTLyricsData sharedInstance] titleForTask:taskIdx];
    self.currentTask.withMusic = self.withMusic;
    
    // initialize data buffers
    self.tapOnData = [NSMutableString stringWithCapacity:3];
    self.tapOffData = [NSMutableString stringWithCapacity:3];
    self.tapXPosData = [NSMutableString stringWithCapacity:3];
    self.tapYPosData = [NSMutableString stringWithCapacity:3];
    self.tapOffXPosData = [NSMutableString stringWithCapacity:3];
    self.tapOffYPosData = [NSMutableString stringWithCapacity:3];

    // reset start time
    self.startTime = [[NSDate date] timeIntervalSince1970];
}

- (void) saveTaskData
{
    // remove last comma
    if (self.tapOnData.length > 2)
        [self.tapOnData deleteCharactersInRange:NSMakeRange(self.tapOnData.length-2, 2)];
    if (self.tapOffData.length > 2)
        [self.tapOffData deleteCharactersInRange:NSMakeRange(self.tapOffData.length-2, 2)];
    if (self.tapXPosData.length > 2)
        [self.tapXPosData deleteCharactersInRange:NSMakeRange(self.tapXPosData.length-2, 2)];
    if (self.tapYPosData.length > 2)
        [self.tapYPosData deleteCharactersInRange:NSMakeRange(self.tapYPosData.length-2, 2)];
    if (self.tapOffXPosData.length > 2)
        [self.tapOffXPosData deleteCharactersInRange:NSMakeRange(self.tapOffXPosData.length-2, 2)];
    if (self.tapOffYPosData.length > 2)
        [self.tapOffYPosData deleteCharactersInRange:NSMakeRange(self.tapOffYPosData.length-2, 2)];
    
    // save task data
    self.currentTask.tapOnTimeData = self.tapOnData;
    self.currentTask.tapOffTimeData = self.tapOffData;
    self.currentTask.tapXPositionData = self.tapXPosData;
    self.currentTask.tapYPositionData = self.tapYPosData;
    self.currentTask.tapOffXPositionData = self.tapOffXPosData;
    self.currentTask.tapOffYPositionData = self.tapOffYPosData;
        
    QBTSessionData* sessionData = [QBTSessionData sharedInstance];
//    [sessionData.taskDataArray addObject:self.currentTask];
    
    // send task data to server
    [sessionData sendTaskToServer:self.currentTask];
}

#pragma mark - QBTTaskQuestionViewControllerDelegate Selectors

- (void) handleFamiliarity:(Float32)answer
{
    self.currentTask.songFamiliarity = answer;
}

- (void) handleHelpful:(UInt16)answer
{
    self.currentTask.withMusicHelpful = answer;
}

- (void) willCloseQuestionnaire
{
    // prepare new lyrics before questionnaire closes
        
    self.taskNumber++; // increment task number
        
    if (self.taskNumber < [[QBTLyricsData sharedInstance] taskCount])
        [self updateTaskUI];
}

- (void) didCloseFamiliarity
{
    // save data
    if (![QBTLyricsData sharedInstance].isTrialRun)
        [self saveTaskData];
    
    self.withMusic = YES;
    
    // prepare next task
    if (![QBTLyricsData sharedInstance].isTrialRun)
        [self startTask];
}

- (void) didCloseQuestionnaire
{
    // save data
    if (![QBTLyricsData sharedInstance].isTrialRun)
        [self saveTaskData];
    
    // prepare for without music task
    if (self.taskNumber >= [[QBTLyricsData sharedInstance] taskCount]) { // end session

        if ([QBTLyricsData sharedInstance].isTrialRun) {
            
            [self performSegueWithIdentifier:@"TaskToReady" sender:self];
        }
        else {
            
            [self performSegueWithIdentifier:@"TaskToDone" sender:self];
        }
    }
    else { // prepare next task
        
        self.withMusic = NO;

        if (![QBTLyricsData sharedInstance].isTrialRun)
            [self startTask];
    }
}

@end
