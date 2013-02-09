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

- (CSVParser*) getTempSonglist;

// TODO: move to file manager class
- (void) cleanDirectory:(NSString*)dirPath;
- (void) cleanDirectory:(NSString*)dirPath except:(NSString*)file;
- (void) moveContentsOfDirectory:(NSString*)fromDir toDirectory:(NSString*)toDir;

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
    // clear temp directory
    [self cleanDirectory:[QBTServerSettings tempDirectory]];
    
    // get songlist from server
    NSString* urlString = [NSString stringWithFormat:@"http://%@/%@",
                           [QBTServerSettings sharedInstance].songListServer,
                           [QBTLyricsData songListFilename]];
    NSURL* downloadUrl = [NSURL URLWithString:urlString];
    
    NSString* csvString = [self downloadCsvStringFromUrl:downloadUrl];
    
    // save to file
    [self saveStringToDocuments:csvString];

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
    // write csv file to temp directory
    NSString* fileString = [NSString stringWithFormat:@"%@/%@",
                            [QBTServerSettings tempDirectory],
                            [QBTLyricsData songListFilename]];
    
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
    CSVParser* csvParser = [self getTempSonglist];
    
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

- (void) cancelDownload
{
    for (QBTAudioDownloader* downloader in self.audioDownloaderArray) {
        
        [downloader cancelDownload];
    }
    
    // clear downloader array
    [self.audioDownloaderArray removeAllObjects];
    
    // clear temp directory
    [self cleanDirectory:[QBTServerSettings tempDirectory]];
    
    // signal for update
    [self.delegate downloadListChanged];
}

- (CSVParser*) getTempSonglist
{
    NSString* fileString = [NSString stringWithFormat:@"%@/%@", [QBTServerSettings tempDirectory], [QBTLyricsData songListFilename]];
    
    NSString* csvString = [NSString stringWithContentsOfFile:fileString
                                     encoding:NSASCIIStringEncoding
                                        error:nil];
    
    NSArray* keyArray = @[@"Song Title", @"Artist", @"Year", @"Filename", @"Lyrics"];
    return [[CSVParser alloc] initWithString:csvString
                                   separator:@","
                                   hasHeader:YES
                                  fieldNames:keyArray];
}

#pragma mark - QBTAudioDownloaderManagerDelegate Selector

- (void) downloader:(QBTAudioDownloader*)downloader finishedDownloadingTo:(NSString*)destinationString
{
    [self.audioDownloaderArray removeObject:downloader];
    
    if (self.audioDownloaderArray.count == 0) { // finished downloading
        
        // Clear old files in document directory
        [self cleanDirectory:[QBTServerSettings documentsDirectory]
                      except:[QBTServerSettings tempDirectory].lastPathComponent];
        
        // Move new files to docoment directory
        [self moveContentsOfDirectory:[QBTServerSettings tempDirectory]
                          toDirectory:[QBTServerSettings documentsDirectory]];
        
        // Update QBTLyricsData
        [[QBTLyricsData sharedInstance] reloadSongList];
    }
    
    // signal for update
    [self.delegate downloadListChanged];
}

// TODO: move to file manager class
- (void) cleanDirectory:(NSString*)dirPath
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    NSError* error;
    NSArray* files = [fileManager contentsOfDirectoryAtPath:dirPath
                                                      error:&error];
    
    for (NSString* file in files) {
        
        [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@", [QBTServerSettings tempDirectory], file]
                                error:&error];
        
        if (error) {
            
            NSLog(@"Failed to remove file in documents directory: %@", file);
            NSLog(@"%@", error.description);
        }
    }
}

// TODO: move to file manager class
- (void) cleanDirectory:(NSString*)dirPath except:(NSString*)exFile
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError* error;
    
    NSArray* files = [fileManager contentsOfDirectoryAtPath:dirPath
                                                      error:&error];
    
    for (NSString* file in files) {
        
        if (![file isEqualToString:exFile]) {
            
            [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@", [QBTServerSettings documentsDirectory], file]
                                    error:&error];
            
            if (error) {
                
                NSLog(@"Failed to remove file in documents directory: %@", file);
                NSLog(@"%@", error.description);
            }
        }
    }

}

// TODO: move to file manager class
- (void) moveContentsOfDirectory:(NSString*)fromDir toDirectory:(NSString*)toDir
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError* error;
    
    NSArray* files = [fileManager contentsOfDirectoryAtPath:fromDir
                                                          error:&error];
    
    for (NSString* file in files) {
        
        [fileManager moveItemAtPath:[NSString stringWithFormat:@"%@/%@", fromDir, file]
                             toPath:[NSString stringWithFormat:@"%@/%@", toDir, file]
                              error:&error];
        
        if (error) {
            
            NSLog(@"Failed to move file to documents directory: %@", file);
            NSLog(@"%@", error.description);
        }
    }
}

@end
