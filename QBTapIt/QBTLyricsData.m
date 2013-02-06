//
//  QBTLyricsData.m
//  QBTapIt
//
//  Created by Ethan Kim on 1/30/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import "QBTLyricsData.h"

#import "CSVParser.h"

#import "QBTAudioDownloader.h"

@interface QBTLyricsData()

@property CSVParser* csvParser;

- (NSString*) checkForLocalFile;

- (CSVParser*) parserWithUrl:(NSURL*)url;
- (CSVParser*) parserWithString:(NSString*)csvString;

- (NSString*) downloadCsvStringFromUrl:(NSURL*)url;
- (void) saveStringToDocuments:(NSString*)string;
- (void) downloadAudioFiles;

@end

@implementation QBTLyricsData

# pragma  mark - Singleton
static QBTLyricsData* sharedInstance = nil;
+ (QBTLyricsData*) sharedInstance
{
    if (sharedInstance == nil)
        sharedInstance = [[QBTLyricsData alloc] init];
    
    return sharedInstance;
}

@synthesize isTrialRun = _isTrialRun;
- (void) setIsTrialRun:(BOOL)isTrialRun
{
    _isTrialRun = isTrialRun;
    
    if (_isTrialRun) {
        NSURL* defaultUrl = [[NSBundle mainBundle] URLForResource: @"lyrics_trial"
                                                    withExtension: @"csv"];
        
        self.csvParser = [self parserWithUrl:defaultUrl];
    }
    else {
        NSString* localString = [self checkForLocalFile];
        
        self.csvParser = [self parserWithString:localString];
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        
        NSString* localString = [self checkForLocalFile];
        
        if (localString) { // check for local copy
            
            self.csvParser = [self parserWithString:localString];
        }
        else { // load default lyrics
            
            NSURL* defaultUrl = [[NSBundle mainBundle] URLForResource: @"lyrics_trial"
                                                       withExtension: @"csv"];
            
            self.csvParser = [self parserWithUrl:defaultUrl];
        }
        
    }
    return self;
}

#pragma mark - Public Implementation

- (void) reloadFromUrl:(NSURL*)url
{
    // download csv string
    NSString* csvString = [self downloadCsvStringFromUrl:url];
    
    // download lyrics file
    self.csvParser = [self parserWithString:csvString];
    
    [self downloadAudioFiles];
}

- (UInt16) taskCount
{
    return [self.csvParser arrayOfParsedRows].count;
}

- (NSString*) titleForTask:(UInt16)task
{
    NSDictionary* taskData = [[self.csvParser arrayOfParsedRows] objectAtIndex:task];
    return [taskData objectForKey:@"Song Title"];
}

- (NSString*) artistForTask:(UInt16)task
{
    NSDictionary* taskData = [[self.csvParser arrayOfParsedRows] objectAtIndex:task];
    return [taskData objectForKey:@"Artist"];
}

- (NSString*) lyricsForTask:(UInt16)task
{
    NSDictionary* taskData = [[self.csvParser arrayOfParsedRows] objectAtIndex:task];
    return [taskData objectForKey:@"Lyrics"];
}

- (NSURL*) fileUrlForTask:(UInt16)task
{
    NSDictionary* taskData = [[self.csvParser arrayOfParsedRows] objectAtIndex:task];
    NSString* filename = [taskData objectForKey:@"Filename"];
    
    if (self.isTrialRun) {
        
        return [[NSBundle mainBundle] URLForResource:[filename stringByDeletingPathExtension]
                                       withExtension:[filename pathExtension]];
    }
    else {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *basePath = [paths objectAtIndex:0];
        
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", basePath, filename]];
    }
}

#pragma mark - Private Implementation

- (NSString*) checkForLocalFile
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* filename = @"lyrics.csv";
    NSString* fileString = [NSString stringWithFormat:@"%@/%@", documentsDir, filename];
    
    return [NSString stringWithContentsOfFile:fileString
                                     encoding:NSASCIIStringEncoding
                                        error:nil];
}

- (CSVParser*) parserWithUrl:(NSURL*)url
{
    NSError* error;
    NSString* csvString = [NSString stringWithContentsOfURL:url
                                                   encoding:NSASCIIStringEncoding
                                                      error:&error];
    
    if (error) {
        NSLog(@"%@", [error description]);
        return nil;
    }
    
    return [self parserWithString:csvString];
}

- (CSVParser*) parserWithString:(NSString*)csvString
{
    NSArray* keyArray = @[@"Song Title", @"Artist", @"Year", @"Filename", @"Lyrics"];
    
    return [[CSVParser alloc] initWithString:csvString
                                   separator:@","
                                   hasHeader:YES
                                  fieldNames:keyArray
            ];
}

// TODO: move to downloader class
- (NSString*) downloadCsvStringFromUrl:(NSURL*)url
{
    NSError* error;
    NSString* csvString = [NSString stringWithContentsOfURL:url
                                                   encoding:NSASCIIStringEncoding
                                                      error:&error];
    
    if (error) { // failed to load file
        NSLog(@"Failed to load file from: %@", url.absoluteString);
        NSLog(@"%@", [error description]);
    }
    
    [self saveStringToDocuments:csvString];
    
    return csvString;
}

// TODO: move to downloader class
- (void) saveStringToDocuments:(NSString*)string
{
    // write csv file to documents directory
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* filename = @"lyrics.csv";
    NSString* fileString = [NSString stringWithFormat:@"%@/%@", documentsDir, filename];
    
    NSError* error;
    [string writeToFile:fileString
                atomically:YES
                  encoding:NSASCIIStringEncoding
                     error:&error];
    
    if (error) { // failed to write file
        NSLog(@"Failed to write string to: %@", fileString);
        NSLog(@"%@", [error description]);
    }
}

- (void) downloadAudioFiles
{
    for (NSDictionary* taskData in [self.csvParser arrayOfParsedRows]) {
        NSString* filename = [taskData objectForKey:@"Filename"];
        
        // TODO: change to modifiable url
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://ccrma.stanford.edu/~hskim08/qbt/files/%@", filename]];
        QBTAudioDownloader* downloader = [[QBTAudioDownloader alloc] init];
        [downloader downloadAudioWithUrl:url];
    }
}

@end
