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
@property BOOL withMusic;

// Data Arrays
@property NSMutableString* tapOnData;
@property NSMutableString* tapOffData;
@property NSMutableString* tapXPosData;
@property NSMutableString* tapYPosData;

@property QBTTaskData* currentTask;

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
    
    self.taskNumber = 0;
    self.withMusic = NO;
    QBTSessionData* sessionData = [QBTSessionData sharedInstance];
    [sessionData initData];
    sessionData.userId = [QBTUserData sharedInstance].userId;
    
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
        [self.tapYPosData appendFormat:@"%f, ", point.y];
//        NSLog(@"x/y: %f/%f", point.x, point.y);
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
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"TaskToTaskQuestion"]){
        QBTTaskQuestionViewController* questionVC = [segue destinationViewController];
        questionVC.delegate = self;
        questionVC.withMusic = self.withMusic;
    }
    else if([segue.identifier isEqualToString:@"TaskToAudio"]){
        QBTTaskAudioViewController* audioVC = [segue destinationViewController];
        audioVC.delegate = self;
    }
}

#pragma mark - IBAction Selectors

- (IBAction) nextPushed:(UIButton*)sender
{    
    // open task question view
    [self performSegueWithIdentifier:@"TaskToTaskQuestion" sender:self];
}

#pragma mark - Private Implementation

- (void) updateTaskUI
{
    // update navigation title
    self.navigationItem.title = [NSString stringWithFormat:@"%@ %d", @"Task", (self.taskNumber+1)];
    
    // update title text
    self.titleLabel.text = [NSString stringWithFormat:@"%@ - %@", [[QBTLyricsData sharedInstance] titleForTask:self.taskNumber], [[QBTLyricsData sharedInstance] artistForTask:self.taskNumber]];
    
    // load new lyrics
    self.lyricsTextView.text = [[QBTLyricsData sharedInstance] lyricsForTask:self.taskNumber];
}

- (void) startTask
{
    // initialize data buffers
    self.currentTask = [[QBTTaskData alloc] init];
    self.tapOnData = [NSMutableString stringWithCapacity:3];
    self.tapOffData = [NSMutableString stringWithCapacity:3];
    self.tapXPosData = [NSMutableString stringWithCapacity:3];
    self.tapYPosData = [NSMutableString stringWithCapacity:3];

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
    
    // save task data
    self.currentTask.songId = [NSString stringWithFormat:@"%d", self.taskNumber]; // TODO: set song format properly
    
    self.currentTask.tapOnTimeData = self.tapOnData;
    self.currentTask.tapOffTimeData = self.tapOffData;
    self.currentTask.tapXPositionData = self.tapXPosData;
    self.currentTask.tapYPositionData = self.tapYPosData;
    
    self.currentTask.withMusic = self.withMusic;
        
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
    [self saveTaskData];
    
    if(self.withMusic) { // prepare for without music task
        
        if (self.taskNumber >= [[QBTLyricsData sharedInstance] taskCount]) { // end session
            
            // send data to server
            [[QBTUserData sharedInstance] sendToServer];
            [[QBTSessionData sharedInstance] sendToServer];
            
            [self performSegueWithIdentifier:@"TaskToDone" sender:self];
        }
        else { // prepare next task
            self.withMusic = NO;
            
            [self startTask];
        }
    }
    else { // prepare for with music task
    
        // load music
        NSString* filename = [[QBTLyricsData sharedInstance] filenameForTask:self.taskNumber];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *basePath = [paths objectAtIndex:0];
        
        NSURL* fileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", basePath, filename]];
        
        [[QBTAudioPlayer sharedInstance] initWithUrl:fileUrl];
        
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
    [self startTask];
}

@end
