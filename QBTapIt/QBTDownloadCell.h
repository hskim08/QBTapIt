//
//  QBTDownloadCell.h
//  QBTapIt
//
//  Created by Hyung-Suk Kim on 2/8/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QBTAudioDownloader.h"

@interface QBTDownloadCell : UITableViewCell

@property IBOutlet UIProgressView* progress;
@property IBOutlet UILabel* titleLabel;

@property (nonatomic) QBTAudioDownloader* downloader;

@end
