//
//  QBTTaskData.m
//  QBTapIt
//
//  Created by Hyung-Suk Kim on 1/14/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import "QBTTaskData.h"

#import "QBTSessionData.h"

#import "QBTServerSettings.h"

@interface QBTTaskData()<NSURLConnectionDataDelegate>

@property(nonatomic,strong) NSURLConnection* connection;

@end

@implementation QBTTaskData

#pragma mark - Public Implementation

- (void) sendToServer
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/record/taskInfo",
                                                                                             [QBTServerSettings sharedInstance].uploadServer]]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:1000];
    
    [request setTimeoutInterval:1000];
    [request setHTTPMethod:@"POST"];
    
    NSMutableString* params = [NSMutableString string];
    
    QBTSessionData* sessionData = [QBTSessionData sharedInstance];
    [params appendFormat:@"user_id=%@", sessionData.userId];
    [params appendFormat:@"&version_number=%@", sessionData.version];
    [params appendFormat:@"&session_id=%@", sessionData.sessionId];
    [params appendFormat:@"&experimenter_id=%@", sessionData.experimenterId];
    [params appendFormat:@"&device_type=%@", sessionData.deviceType];
    
    [params appendFormat:@"&song_title=%@", self.songTitle];
    [params appendFormat:@"&task_order=%d", self.trackOrder];
    
    [params appendFormat:@"&tap_data=%@", self.tapOnTimeData];
    [params appendFormat:@"&tap_off_data=%@", self.tapOffTimeData];
    [params appendFormat:@"&tap_y_data=%@", self.tapYPositionData];
    [params appendFormat:@"&tap_x_data=%@", self.tapXPositionData];
    [params appendFormat:@"&tap_off_y_data=%@", self.tapOffYPositionData];
    [params appendFormat:@"&tap_off_x_data=%@", self.tapOffXPositionData];
    
    [params appendFormat:@"&with_music=%d", self.withMusic];
    [params appendFormat:@"&song_familiarity=%f", self.songFamiliarity];
    [params appendFormat:@"&audio_helpful=%d", self.withMusicHelpful];
    
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    // TODO: save to disk only when there is no internet connection
    [self saveToDisk];
}

- (void) saveToDisk
{
    NSString *fileName = [NSString stringWithFormat:@"%@/task_%3d_%d", [QBTSessionData sharedInstance].sessionDir, self.trackOrder, self.withMusic];
    [NSKeyedArchiver archiveRootObject:self
                                toFile:fileName];
}

#pragma mark - NSCoding Selectors

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        
        self.songTitle = [decoder decodeObjectForKey:@"songTitle"];
        self.trackOrder = [decoder decodeIntegerForKey:@"trackOrder"];
        
        self.tapOnTimeData = [decoder decodeObjectForKey:@"tapOnTimeData"];
        self.tapOffTimeData = [decoder decodeObjectForKey:@"tapOffTimeData"];
        self.tapYPositionData = [decoder decodeObjectForKey:@"tapYPositionData"];
        self.tapXPositionData = [decoder decodeObjectForKey:@"tapXPositionData"];
        self.tapOffYPositionData = [decoder decodeObjectForKey:@"tapOffYPositionData"];
        self.tapOffXPositionData = [decoder decodeObjectForKey:@"tapOffXPositionData"];
        
        self.withMusic = [decoder decodeIntegerForKey:@"withMusic"];
        self.songFamiliarity = [decoder decodeFloatForKey:@"songFamiliarity"];
        self.withMusicHelpful = [decoder decodeIntegerForKey:@"withMusicHelpful"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.songTitle forKey:@"songTitle"];
    [encoder encodeInteger:self.trackOrder forKey:@"trackOrder"];
    
    [encoder encodeObject:self.tapOnTimeData forKey:@"tapOnTimeData"];
    [encoder encodeObject:self.tapOffTimeData forKey:@"tapOffTimeData"];
    [encoder encodeObject:self.tapYPositionData forKey:@"tapYPositionData"];
    [encoder encodeObject:self.tapXPositionData forKey:@"tapXPositionData"];
    [encoder encodeObject:self.tapOffYPositionData forKey:@"tapOffYPositionData"];
    [encoder encodeObject:self.tapOffXPositionData forKey:@"tapOffXPositionData"];
    
    [encoder encodeInteger:self.withMusic forKey:@"withMusic"];
    [encoder encodeFloat:self.songFamiliarity forKey:@"songFamiliarity"];
    [encoder encodeInteger:self.withMusicHelpful forKey:@"withMusicHelpful"];
}

#pragma mark - NSURLConnectionDataDelegate selectors

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError:%@", error.description);
}

@end
