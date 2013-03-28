//
//  QBTTaskData.h
//  QBTapIt
//
//  Created by Hyung-Suk Kim on 1/14/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QBTTaskData : NSObject

@property (nonatomic, strong) NSString* songTitle;
@property (nonatomic, readwrite) NSUInteger trackOrder;

@property (nonatomic, strong) NSString* tapOnTimeData;
@property (nonatomic, strong) NSString* tapOffTimeData;
@property (nonatomic, strong) NSString* tapYPositionData;
@property (nonatomic, strong) NSString* tapXPositionData;
@property (nonatomic, strong) NSString* tapOffYPositionData;
@property (nonatomic, strong) NSString* tapOffXPositionData;

@property (nonatomic, readwrite) SInt8 withMusic;

@property (nonatomic, readwrite) Float32 songFamiliarity;
@property (nonatomic, readwrite) SInt8 withMusicHelpful; // only for withMusic

- (void) sendToServer;
- (void) saveToDisk;

@end
