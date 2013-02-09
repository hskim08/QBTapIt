//
//  QBTAudioDownloader.h
//  QBTapIt
//
//  Created by Ethan Kim on 2/1/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QBTAudioDownloader;

@protocol QBTAudioDownloaderManagerDelegate <NSObject>

- (void) downloader:(QBTAudioDownloader*)downloader finishedDownloadingTo:(NSString*)destinationString;

@end

@protocol QBTAudioDownloaderDelegate <NSObject>

- (void) downloader:(QBTAudioDownloader*)downloader updatedFilename:(NSString*)filename;
- (void) downloader:(QBTAudioDownloader*)downloader madeProgress:(Float32)progress;
- (void) downloader:(QBTAudioDownloader*)downloader finishedDownloadingTo:(NSString*)destinationString;

@end

@interface QBTAudioDownloader : NSObject

@property id<QBTAudioDownloaderDelegate> delegate;
@property id<QBTAudioDownloaderManagerDelegate> manager;

@property (readonly) NSString* filename;
@property (readonly) Float32 progress;

- (void) downloadAudioWithUrl:(NSURL*)url;

@end
