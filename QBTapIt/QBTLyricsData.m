//
//  QBTLyricsData.m
//  QBTapIt
//
//  Created by Ethan Kim on 1/30/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import "QBTLyricsData.h"

#import "CSVParser.h"

#import "QBTServerSettings.h"
#import "QBTAudioDownloader.h"

@interface QBTLyricsData()

@property CSVParser* csvParser;

- (NSString*) getLocalSonglist;

- (CSVParser*) parserWithUrl:(NSURL*)url;
- (CSVParser*) parserWithString:(NSString*)csvString;

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

+ (NSString*) songListFilename
{
    return @"lyrics.csv";
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
        NSString* localString = [self getLocalSonglist];
        
        self.csvParser = [self parserWithString:localString];
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        
        NSString* localString = [self getLocalSonglist];
        
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

- (void) reloadSongList
{
    NSString* localString = [self getLocalSonglist];
    
    self.csvParser = [self parserWithString:localString];
}

- (UInt16) taskCount
{
    if (self.isTrialRun) {
        return [[NSUserDefaults standardUserDefaults] integerForKey:@"TrialCount"];
    }
    
    return [self.csvParser arrayOfParsedRows].count;
}

- (NSString*) titleForTask:(NSUInteger)task
{
    NSDictionary* taskData = [[self.csvParser arrayOfParsedRows] objectAtIndex:task];
    return [taskData objectForKey:@"Song Title"];
}

- (NSString*) artistForTask:(NSUInteger)task
{
    NSDictionary* taskData = [[self.csvParser arrayOfParsedRows] objectAtIndex:task];
    return [taskData objectForKey:@"Artist"];
}

- (NSString*) yearForTask:(NSUInteger)task
{
    NSDictionary* taskData = [[self.csvParser arrayOfParsedRows] objectAtIndex:task];
    return [taskData objectForKey:@"Year"];
}

- (NSString*) lyricsForTask:(NSUInteger)task
{
    NSDictionary* taskData = [[self.csvParser arrayOfParsedRows] objectAtIndex:task];
    return [taskData objectForKey:@"Lyrics"];
}

- (NSURL*) fileUrlForTask:(NSUInteger)task
{
    NSDictionary* taskData = [[self.csvParser arrayOfParsedRows] objectAtIndex:task];
    NSString* filename = [taskData objectForKey:@"Filename"];
    
    if (self.isTrialRun) {
        
        return [[NSBundle mainBundle] URLForResource:[filename stringByDeletingPathExtension]
                                       withExtension:[filename pathExtension]];
    }
    else {
        
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [QBTServerSettings documentsDirectory], filename]];
    }
}

#pragma mark - Private Implementation

- (NSString*) getLocalSonglist
{
    NSString* fileString = [NSString stringWithFormat:@"%@/%@", [QBTServerSettings documentsDirectory], [QBTLyricsData songListFilename]];
    
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
    NSArray* keyArray = @[@"Song Title", @"Artist", @"Year", @"Lyrics", @"Filename"];
    
    return [[CSVParser alloc] initWithString:csvString
                                   separator:@","
                                   hasHeader:YES
                                  fieldNames:keyArray
            ];
}

@end
