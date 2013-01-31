//
//  QBTLyricsData.m
//  QBTapIt
//
//  Created by Ethan Kim on 1/30/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import "QBTLyricsData.h"

#import "CSVParser.h"

@interface QBTLyricsData()

@property CSVParser* csvParser;

- (CSVParser*) parserWithUrl:(NSURL*)url;

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

- (id)init
{
    self = [super init];
    if (self) {
        
        NSURL* defaultUrl = [[NSBundle mainBundle] URLForResource: @"lyrics_short"
                                                withExtension: @"csv"];
        self.csvParser = [self parserWithUrl:defaultUrl];
    }
    return self;
}

#pragma mark - Public Implementation

- (void) reloadFromUrl:(NSURL*)url
{
    // download lyrics file
    self.csvParser = [self parserWithUrl:url];
    
    // TODO: download song files
}

- (UInt16) taskCount
{
    return [self.csvParser arrayOfParsedRows].count;
}

- (NSString*) lyricsForTask:(UInt16)task
{
    NSDictionary* taskData = [[self.csvParser arrayOfParsedRows] objectAtIndex:task];
    return [taskData objectForKey:@"Lyrics"];
}

- (NSString*) filenameForTask:(UInt16)task
{
    NSDictionary* taskData = [[self.csvParser arrayOfParsedRows] objectAtIndex:task];
    return [taskData objectForKey:@"Filename"];
}

#pragma mark - Private Implementation

- (CSVParser*) parserWithUrl:(NSURL*)url
{
    NSError* error;
    NSString* csvString = [NSString stringWithContentsOfURL:url
                                                   encoding:NSASCIIStringEncoding
                                                      error:&error];
    
    if (!csvString)
        return nil; // handle error
    
    NSArray* keyArray = @[@"Song Title", @"Artist", @"Year", @"Filename", @"Lyrics"];
    
    return [[CSVParser alloc] initWithString:csvString
                                   separator:@","
                                   hasHeader:YES
                                  fieldNames:keyArray
            ];

}

@end
