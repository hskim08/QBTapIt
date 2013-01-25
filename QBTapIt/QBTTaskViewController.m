//
//  QBTTaskViewController.m
//  QBTapIt
//
//  Created by Ethan Kim on 11/2/12.
//  Copyright (c) 2012 CCRMA, Stanford University. All rights reserved.
//

#import "QBTTaskViewController.h"

#import "CSVParser.h"

#import "QBTUserData.h"
#import "QBTSessionData.h"
#import "QBTTaskData.h"

#import "QBTTaskQuestionViewController.h"

#import "QBTAudioPlayer.h"

@interface QBTTaskViewController () <QBTTaskQuestionViewControllerDelegate>

@property NSInteger taskNumber;
@property NSTimeInterval startTime;
@property BOOL withMusic;

// Data Arrays
@property NSMutableString* tapOnData;
@property NSMutableString* tapOffData;
@property NSMutableString* tapXPosData;
@property NSMutableString* tapYPosData;

@property QBTTaskData* currentTask;

@property (nonatomic) CSVParser* csvParser;

- (void) startTask;
- (void) saveTaskData;
- (void) prepareNextTask;

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
    
    NSTimeInterval tapOnTime = [[NSDate date] timeIntervalSince1970] - self.startTime;
    NSLog(@"On: %f", tapOnTime);
    
    // save tap on
    [self.tapOnData appendFormat:@"%f, ", tapOnTime];
    
    // save positions
    assert(touches.count == 1);
    
    for (UITouch* touch in touches) {
        CGPoint point = [touch locationInView:self.view];
        NSLog(@"x/y: %f/%f", point.x, point.y);
        
        [self.tapXPosData appendFormat:@"%f, ", point.x];
        [self.tapYPosData appendFormat:@"%f, ", point.y];
        break;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    self.tapLabel.textColor = [UIColor blackColor];
    
    NSTimeInterval tapOffTime = [[NSDate date] timeIntervalSince1970] - self.startTime;
    NSLog(@"Off: %f", tapOffTime);
    
    // save tap off
    [self.tapOffData appendFormat:@"%f, ", tapOffTime];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"TaskToTaskQuestion"]){
        QBTTaskQuestionViewController* questionVC = [segue destinationViewController];
        questionVC.delegate = self;
    }
}

#pragma mark - IBAction Selectors

- (IBAction) nextPushed:(UIButton*)sender
{    
    // open task question view
    [self performSegueWithIdentifier:@"TaskToTaskQuestion" sender:self];
}

//- (IBAction) testButton:(UIButton*)sender
//{
//    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"04"
//                                                              ofType:@"wav"];
//    
//	// Converts the sound's file path to an NSURL object
//	NSURL *soundFileUrl = [[NSURL alloc] initFileURLWithPath:soundFilePath];
//    
//    [[QBTAudioPlayer sharedInstance] playAudioWithUrl:soundFileUrl];
//}

#pragma mark - Private Implementation

@synthesize csvParser = _csvParser;
- (CSVParser*) csvParser
{
    if (_csvParser == nil) {
        NSURL* csvUrl = [[NSBundle mainBundle] URLForResource: @"lyrics_short"
                                withExtension: @"csv"];
        
        NSError* error;
        NSString* csvString = [NSString stringWithContentsOfURL:csvUrl
                                                       encoding:NSASCIIStringEncoding
                                                          error:&error];
        
        if (csvString == nil) return _csvParser; // handle error
        
        NSArray* keyArray = @[@"Song Title", @"Artist", @"Year", @"Filename", @"Lyrics"];
        
        _csvParser = [[CSVParser alloc] initWithString:csvString
                                             separator:@","
                                             hasHeader:YES
                                            fieldNames:keyArray
                      ];
    }
    return _csvParser;
}

- (void) startTask
{
    // update title text
    self.navigationItem.title = [NSString stringWithFormat:@"%@ %d", @"Task", (self.taskNumber+1)];
    
    // load new lyrics
    NSDictionary* taskData = [[self.csvParser arrayOfParsedRows] objectAtIndex:self.taskNumber];
    self.lyricsTextView.text = [taskData objectForKey:@"Lyrics"];
    
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
        
    QBTSessionData* sessionData = [QBTSessionData sharedInstance];
    [sessionData.taskDataArray addObject:self.currentTask];
}

- (void) prepareNextTask
{
//    if (self.withMusic) { // after music
        self.taskNumber++; // increment task number
    
        if (self.taskNumber >= [self.csvParser arrayOfParsedRows].count) { // end session
            
            // send data to server
            [[QBTUserData sharedInstance] sendToServer];
            [[QBTSessionData sharedInstance] sendToServer];
            
            [self performSegueWithIdentifier:@"TaskToDone" sender:self];
        }
        else { // prepare next task
            
            [self startTask];
        }
        
//    }
//    else { // before music
//        // play music
//        
//        // start task
//    }

    // toggle
//    self.withMusic = !self.withMusic;
}

#pragma mark - QBTTaskQuestionViewControllerDelegate Selectors

- (void) handleFamiliarity:(UInt16)answer
{
    self.currentTask.songFamiliarity = answer;
    
    self.currentTask.musicAsExpected = NO; // TODO: get answer from questionnaire
    
    [self saveTaskData];
}

- (void) didFinishQuestionnaire
{
    // prepare next task
    [self prepareNextTask];
}

@end
