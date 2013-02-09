//
//  QBTSongListDownloader.m
//  QBTapIt
//
//  Created by Ethan Kim on 2/8/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import "QBTSongListDownloader.h"

#import "CSVParser.h"

#import "QBTServerSettings.h"
#import "QBTLyricsData.h"
#import "QBTAudioDownloader.h"

@interface QBTSongListDownloader()<QBTAudioDownloaderManagerDelegate>

- (NSString*) downloadCsvStringFromUrl:(NSURL*)url;

- (CSVParser*) getLocalSonglist;

@end

@implementation QBTSongListDownloader

#pragma mark - Singleton

static QBTSongListDownloader* sharedInstance = nil;
+ (QBTSongListDownloader *) sharedInstance {
    if (sharedInstance == nil)
        sharedInstance = [[QBTSongListDownloader alloc] init];
    
    return sharedInstance;
}

@synthesize audioDownloaderArray = _audioDownloaderArray;
- (NSMutableArray*) audioDownloaderArray
{
    if (!_audioDownloaderArray) {
        _audioDownloaderArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _audioDownloaderArray;
}

- (BOOL) isDownloading
{
    return self.audioDownloaderArray.count > 0;
}

- (void) downloadSongListFromServer
{
    // get songlist from server
    NSURL* downloadUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/%@",
                                               [QBTServerSettings sharedInstance].songListServer, @"lyrics.csv"]
                          ];
    NSString* csvString = [self downloadCsvStringFromUrl:downloadUrl];
    
    // save to file
    [self saveStringToDocuments:csvString];

    // reload lyrics data
    [[QBTLyricsData sharedInstance] reloadSongList];

    // start downloading audio files
    [self downloadAudioFiles];
}

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
    
    return csvString;
}

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
    CSVParser* csvParser = [self getLocalSonglist];
    
    for (NSDictionary* taskData in [csvParser arrayOfParsedRows]) {

        NSString* filename = [taskData objectForKey:@"Filename"];

        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/files/%@",
                                           [QBTServerSettings sharedInstance].songListServer, filename]
                      ];
        QBTAudioDownloader* downloader = [[QBTAudioDownloader alloc] init];
        [downloader downloadAudioWithUrl:url];
        downloader.manager = self;
        
        [self.audioDownloaderArray addObject:downloader];
    }
}

- (CSVParser*) getLocalSonglist
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* filename = @"lyrics.csv";
    NSString* fileString = [NSString stringWithFormat:@"%@/%@", documentsDir, filename];
    
    NSString* csvString = [NSString stringWithContentsOfFile:fileString
                                     encoding:NSASCIIStringEncoding
                                        error:nil];
    
    NSArray* keyArray = @[@"Song Title", @"Artist", @"Year", @"Filename", @"Lyrics"];
    return [[CSVParser alloc] initWithString:csvString
                                   separator:@","
                                   hasHeader:YES
                                  fieldNames:keyArray
            ];
}

#pragma mark - QBTAudioDownloaderManagerDelegate Selector

- (void) downloader:(QBTAudioDownloader*)downloader finishedDownloadingTo:(NSString*)destinationString
{
    [self.audioDownloaderArray removeObject:downloader];
    
    // signal for update
    [self.delegate downloadListChanged];
}

@end
