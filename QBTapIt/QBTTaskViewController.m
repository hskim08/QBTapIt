//
//  QBTTaskViewController.m
//  QBTapIt
//
//  Created by Ethan Kim on 11/2/12.
//  Copyright (c) 2012 CCRMA, Stanford University. All rights reserved.
//

#import "QBTTaskViewController.h"

#import "CSVParser.h"

@interface QBTTaskViewController ()

@property NSInteger taskNumber;

@property (nonatomic) NSURL* csvUrl;
@property (nonatomic) NSArray* keyArray;
@property (nonatomic) CSVParser* csvParser;

- (void) updateLyrics;

@end

@implementation QBTTaskViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.taskNumber = 0;
    [self updateLyrics];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction Selectors

- (IBAction) nextPushed:(UIButton*)sender
{
    self.taskNumber++;
    
    if (self.taskNumber >= [self.csvParser arrayOfParsedRows].count) {
        
        [self performSegueWithIdentifier:@"TaskToDone" sender:self];
    }
    else {
        
        [self updateLyrics];
    }
}

#pragma mark - Private Implementation

@synthesize csvUrl = _csvUrl;
- (NSURL*) csvUrl
{
    if (_csvUrl == nil) {
        
        _csvUrl = [[NSBundle mainBundle] URLForResource: @"lyrics_short"
                                          withExtension: @"csv"];
    }
    return  _csvUrl;
}

@synthesize keyArray = _keyArray;
- (NSArray*) keyArray
{
    if (_keyArray == nil) {
        _keyArray = [NSArray arrayWithObjects:
                     @"Song Title",
                     @"Artist",
                     @"Year",
                     @"Lyrics",
                     nil];
    }
    return _keyArray;
}

@synthesize csvParser = _csvParser;
- (CSVParser*) csvParser
{
    if (_csvParser == nil) {
        NSError* error;
        NSString* csvString = [NSString stringWithContentsOfURL:self.csvUrl
                                                       encoding:NSASCIIStringEncoding
                                                          error:&error];
        
        if (csvString == nil) return _csvParser; // handle error
        
        _csvParser = [[CSVParser alloc] initWithString:csvString
                                             separator:@","
                                             hasHeader:YES
                                            fieldNames:self.keyArray
                      ];
    }
    return _csvParser;
}



- (void) updateLyrics
{
    NSDictionary* taskData = [[self.csvParser arrayOfParsedRows] objectAtIndex:self.taskNumber];
    self.lyricsTextView.text = [taskData objectForKey:@"Lyrics"];
}

@end
