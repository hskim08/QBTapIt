//
//  QBTDownloadCell.m
//  QBTapIt
//
//  Created by Hyung-Suk Kim on 2/8/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import "QBTDownloadCell.h"

@interface QBTDownloadCell()<QBTAudioDownloaderDelegate>

@end

@implementation QBTDownloadCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@synthesize downloader = _downloader;
- (void) setDownloader:(QBTAudioDownloader *)downloader
{
    _downloader = downloader;
    
    // set downloader delegate and initialize cell
    downloader.delegate = self;
    self.titleLabel.text = downloader.filename;
    self.progress.progress = downloader.progress;
}

#pragma mark - QBTAudioDownloaderDelegate Selectors

- (void) downloader:(QBTAudioDownloader*)downloader updatedFilename:(NSString*)filename
{
    self.titleLabel.text = filename;
}

- (void) downloader:(QBTAudioDownloader*)downloader madeProgress:(Float32)progress
{
    self.progress.progress = progress;
}

- (void) downloader:(QBTAudioDownloader*)downloader finishedDownloadingTo:(NSString*)destinationString
{
    
}

@end
