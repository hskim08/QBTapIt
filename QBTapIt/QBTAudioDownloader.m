//
//  QBTAudioDownloader.m
//  QBTapIt
//
//  Created by Ethan Kim on 2/1/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import "QBTAudioDownloader.h"

#import "QBTServerSettings.h"

@interface QBTAudioDownloader()<NSURLConnectionDataDelegate>

@property NSURLConnection* connection;

@property (readwrite) NSString* filename;
@property (readwrite) Float32 progress;

@property UInt64 expectedLength;
@property NSMutableData* downloadData;

@end

@implementation QBTAudioDownloader

- (id)init
{
    self = [super init];
    
    if (self) {
        self.downloadData = [[NSMutableData alloc] init];
    }
    return self;
}

- (void) downloadAudioWithUrl:(NSURL*)url
{
//    NSLog(@"Downloading from : %@", [url absoluteString]);
    
    self.filename = [[url absoluteString] lastPathComponent];
    self.progress = 0;
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    self.connection = [NSURLConnection connectionWithRequest:request
                                                    delegate:self];
}

- (void) cancelDownload
{
    [self.connection cancel];
}

#pragma mark - NSURLConnectionDataDelegate Selectors

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@", error.description);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.filename = response.suggestedFilename;
    self.expectedLength = response.expectedContentLength;
    
    [self.delegate downloader:self
        updatedFilename:self.filename];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.downloadData appendData:data];
    
    self.progress = self.downloadData.length/(Float32)self.expectedLength;
    
    [self.delegate downloader:self
                 madeProgress:self.progress];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // save to file in temp directory
    NSString* filePath = [NSString stringWithFormat:@"%@/%@", [QBTServerSettings tempDirectory], self.filename];
    [self.downloadData writeToFile:filePath
                        atomically:YES];
    
//    NSLog(@"File saved to: %@", filePath);
    
    [self.delegate downloader:self
        finishedDownloadingTo:filePath];
    
    [self.manager downloader:self
        finishedDownloadingTo:filePath];
}


@end
