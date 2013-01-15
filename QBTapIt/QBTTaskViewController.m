//
//  QBTTaskViewController.m
//  QBTapIt
//
//  Created by Ethan Kim on 11/2/12.
//  Copyright (c) 2012 CCRMA, Stanford University. All rights reserved.
//

#import "QBTTaskViewController.h"

#import "CSVParser.h"

#import "QBTSessionData.h"
#import "QBTTaskData.h"

#import "QBTTaskQuestionViewController.h"

@interface QBTTaskViewController () <QBTTaskQuestionViewControllerDelegate>

@property NSInteger taskNumber;
@property NSTimeInterval startTime;

@property NSMutableString* tapOnData;

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
    QBTSessionData* sessionData = [QBTSessionData sharedInstance];
    [sessionData initData];
    
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
    
    NSTimeInterval tapOnTime = [[NSDate date] timeIntervalSince1970] - self.startTime;
    NSLog(@"On: %f", tapOnTime);
    
    // save taps
    [self.tapOnData appendFormat:@"%f, ", tapOnTime];
    
    // TODO: save positions
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    NSTimeInterval tapOffTime = [[NSDate date] timeIntervalSince1970] - self.startTime;
    NSLog(@"Off: %f", tapOffTime);
    
    // TODO: save taps
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
        
        NSArray* keyArray = @[@"Song Title", @"Artist", @"Year", @"Lyrics"];
        
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

    // reset start time
    self.startTime = [[NSDate date] timeIntervalSince1970];
}

- (void) saveTaskData
{
    // remove last comma
    [self.tapOnData deleteCharactersInRange:NSMakeRange(self.tapOnData.length-2, 2)];
    
    // save task data
    self.currentTask.songId = [NSString stringWithFormat:@"%d", self.taskNumber]; // TODO: set song format properly
    self.currentTask.tapOnTimeData = self.tapOnData;
    self.currentTask.withMusic = NO; // TODO: set properly from questionnaire
    
    QBTSessionData* sessionData = [QBTSessionData sharedInstance];
    [sessionData.taskDataArray addObject:self.currentTask];
}

- (void) prepareNextTask
{
    self.taskNumber++;
    if (self.taskNumber >= [self.csvParser arrayOfParsedRows].count) { // end session
        
        // send session data to server
        [[QBTSessionData sharedInstance] sendToServer];
        
        [self performSegueWithIdentifier:@"TaskToDone" sender:self];
    }
    else { // prepare next task
        
        [self startTask];
    }
}

#pragma mark - QBTTaskQuestionViewControllerDelegate Selectors

- (void) handleAnswer:(UInt16)answer
{
    self.currentTask.songFamiliarity = answer;
    self.currentTask.musicAsExpected = NO; // TODO: handle this
    
    [self saveTaskData];

    // prepare next task
    [self prepareNextTask];
}

@end
