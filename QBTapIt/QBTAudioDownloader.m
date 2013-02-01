//
//  QBTAudioDownloader.m
//  QBTapIt
//
//  Created by Ethan Kim on 2/1/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import "QBTAudioDownloader.h"

@interface QBTAudioDownloader()<NSURLConnectionDataDelegate>

@property NSURLConnection* connection;

@property (readwrite) NSString* filename;
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
    NSLog(@"Downloading from : %@", [url absoluteString]);
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    self.connection = [NSURLConnection connectionWithRequest:request
                                                    delegate:self];
}

#pragma mark - NSURLConnectionDataDelegate Selectors

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@", error.description);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Suggested Filename: %@", response.suggestedFilename);
    NSLog(@"Expected content: %lld", response.expectedContentLength);
    
    self.filename = response.suggestedFilename;
    self.expectedLength = response.expectedContentLength;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.downloadData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // save to file
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    
    NSString* filePath = [NSString stringWithFormat:@"%@/%@", documentsDir, self.filename];
    [self.downloadData writeToFile:filePath
                        atomically:YES];
    
    NSLog(@"File saved to: %@", filePath);
}


@end
