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

#import "QBTTaskQuestionViewController.h"
#import "QBTTaskAudioViewController.h"

#import "QBTAudioPlayer.h"

@interface QBTTaskViewController () <QBTTaskQuestionViewControllerDelegate, QBTTaskAudioViewControllerDelegate>

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
    
    self.tapLabel.textColor = [UIColor greenColor];
    
    // save tap on
    NSTimeInterval tapOnTime = [[NSDate date] timeIntervalSince1970] - self.startTime;
    
    [self.tapOnData appendFormat:@"%f, ", tapOnTime];
//    NSLog(@"On: %f", tapOnTime);
    
    // save positions
    assert(touches.count == 1);
    
    for (UITouch* touch in touches) {
        CGPoint point = [touch locationInView:self.view];
        
        [self.tapXPosData appendFormat:@"%f, ", point.x];
        [self.tapYPosData appendFormat:@"%f, ", self.view.frame.size.height - point.y];
//        NSLog(@"x/y: %f/%f", point.x, self.view.frame.size.height - point.y);
        break;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    self.tapLabel.textColor = [UIColor blackColor];
    
    // save tap off
    NSTimeInterval tapOffTime = [[NSDate date] timeIntervalSince1970] - self.startTime;
    [self.tapOffData appendFormat:@"%f, ", tapOffTime];
//    NSLog(@"Off: %f", tapOffTime);
    
    // save positions
    assert(touches.count == 1);
    
    for (UITouch* touch in touches) {
        CGPoint point = [touch locationInView:self.view];
        
        [self.tapOffXPosData appendFormat:@"%f, ", point.x];
        [self.tapOffYPosData appendFormat:@"%f, ", self.view.frame.size.height - point.y];
//        NSLog(@"x/y: %f/%f", point.x, self.view.frame.size.height - point.y);
        break;
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [segue.identifier isEqualToString:@"TaskToTaskQuestion"] ) { // prepare questionnaire
        
        QBTTaskQuestionViewController* questionVC = [segue destinationViewController];
        questionVC.delegate = self;
        questionVC.withMusic = self.withMusic;
        
        questionVC.noTaps = (self.tapOnData.length < 1);
    }
    else if ( [segue.identifier isEqualToString:@"TaskToAudio"] ) { // prepare audio view
        
        QBTTaskAudioViewController* audioVC = [segue destinationViewController];
        audioVC.delegate = self;
    
        // prepare for audio playback
        NSNumber* n = [self.taskOrder objectAtIndex:self.taskNumber];
        int taskIdx = n.intValue;
        
        // load music
        NSURL* fileUrl = [[QBTLyricsData sharedInstance] fileUrlForTask:taskIdx];
        [[QBTAudioPlayer sharedInstance] initWithUrl:fileUrl];
        
        // set song title and lyrics
        audioVC.songTitle = [[QBTLyricsData sharedInstance] titleForTask:taskIdx];
        audioVC.lyrics = [[QBTLyricsData sharedInstance] lyricsForTask:taskIdx];
    }
}

#pragma mark - IBAction Selectors

- (IBAction) nextPushed:(UIButton*)sender
{    
    // open task question view
    [self performSegueWithIdentifier:@"TaskToTaskQuestion" sender:self];
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
        
//        int i = 0;
//        NSLog(@"Printing randomized result");
//        for (NSNumber* n in result) {
//            i++;
//            NSLog(@"%d: %d", i, n.intValue);
//        }
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
    [sessionData.taskDataArray addObject:self.currentTask];
    
    NSLog(@"Saved task: %d", sessionData.taskDataArray.count);
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
    if(self.withMusic) { // prepare lyrics before questionnaire closes
        
        self.taskNumber++; // increment task number
        
        if (self.taskNumber < [[QBTLyricsData sharedInstance] taskCount])
            [self updateTaskUI];
    }
}

- (void) didCloseQuestionnaire
{
    // save data
    if (![QBTLyricsData sharedInstance].isTrialRun)
        [self saveTaskData];
    
    if(self.withMusic) { // prepare for without music task
        
        if (self.taskNumber >= [[QBTLyricsData sharedInstance] taskCount]) { // end session
    
            if ([QBTLyricsData sharedInstance].isTrialRun) {
                
                [self performSegueWithIdentifier:@"TaskToReady" sender:self];
            }
            else {
                // send data to server
                [[QBTUserData sharedInstance] sendToServer];
                [[QBTSessionData sharedInstance] sendToServer];
                
                [self performSegueWithIdentifier:@"TaskToDone" sender:self];
            }
        }
        else { // prepare next task
            self.withMusic = NO;

            if (![QBTLyricsData sharedInstance].isTrialRun)
                [self startTask];
        }
    }
    else { // prepare for with music task

        // open audio view controller
        [self performSegueWithIdentifier:@"TaskToAudio" sender:self];
        // start task when audio view controller closes
    }
}

#pragma mark - QBTTaskAudioViewControllerDelegate Selectors

- (void) didCloseAudioViewController
{
    self.withMusic = YES;
    
    // prepare next task
    if (![QBTLyricsData sharedInstance].isTrialRun)
        [self startTask];
}

@end
