//
//  QBTTaskData.h
//  QBTapIt
//
//  Created by Hyung-Suk Kim on 1/14/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QBTSessionData.h"

@interface QBTTaskData : NSObject

@property QBTSessionData* sessionData;

@property NSString* songTitle;
@property NSUInteger trackOrder;

@property NSString* tapOnTimeData;
@property NSString* tapOffTimeData;
@property NSString* tapYPositionData;
@property NSString* tapXPositionData;
@property NSString* tapOffYPositionData;
@property NSString* tapOffXPositionData;

@property NSInteger withMusic;

@property Float32 songFamiliarity;
@property NSInteger withMusicHelpful; // only for withMusic

- (void) saveData;
- (void) sendToServer;
- (void) saveToDisk;

@end
