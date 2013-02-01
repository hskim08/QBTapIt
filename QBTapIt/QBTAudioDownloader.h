//
//  QBTAudioDownloader.h
//  QBTapIt
//
//  Created by Ethan Kim on 2/1/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QBTAudioDownloader;

@protocol QBTAudioDownloaderDelegate <NSObject>

- (void) downloader:(QBTAudioDownloader*)downloader madeProgress:(Float32)progress;

- (void) downloader:(QBTAudioDownloader*)downloader finishedDownloadingTo:(NSString*)destinationString;

@end

@interface QBTAudioDownloader : NSObject

@property id<QBTAudioDownloaderDelegate> delegate;

@property (readonly) NSString* filename;

- (void) downloadAudioWithUrl:(NSURL*)url;

@end
