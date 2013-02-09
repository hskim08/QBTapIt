//
//  QBTSongListDownloader.h
//  QBTapIt
//
//  Created by Ethan Kim on 2/8/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QBTSongListDownloaderDelegate <NSObject>

- (void) downloadListChanged;

@end

@interface QBTSongListDownloader : NSObject

+ (QBTSongListDownloader *) sharedInstance;

@property id<QBTSongListDownloaderDelegate> delegate;

@property (nonatomic) NSMutableArray* audioDownloaderArray;
// TODO: make more secure by showing as NSArray, not NSMutableArray

@property (readonly, getter = isDownloading) BOOL downloading;

- (void) downloadSongListFromServer;

@end
