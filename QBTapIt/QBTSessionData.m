//
//  QBTSessionData.m
//  QBTapIt
//
//  Created by Ethan Kim on 1/10/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import "QBTSessionData.h"

#include <sys/types.h>
#include <sys/sysctl.h>

#import "QBTServerSettings.h"
#import "QBTTaskData.h"

@interface QBTSessionData()<NSURLConnectionDataDelegate>

@property(nonatomic,strong) NSURLConnection* connection;

- (NSString*) createSessionId;

- (NSString*) platform;

@end

@implementation QBTSessionData

# pragma  mark - Singleton
static QBTSessionData* sharedInstance = nil;
+ (QBTSessionData*) sharedInstance
{
    if (sharedInstance == nil)
        sharedInstance = [[QBTSessionData alloc] init];
    
    return sharedInstance;
}

#pragma mark - Public implementation

@synthesize version = _version;
-(NSString*) version
{
    return @"1.0.0"; // update version when necessary
}

@synthesize deviceType = _deviceType;
- (NSString*) deviceType
{
    return [self platform];
}

@synthesize taskDataArray = _taskDataArray;
- (NSMutableArray*)taskDataArray {
    if (_taskDataArray == nil) {
        _taskDataArray = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _taskDataArray;
}

- (void) initData
{
    self.sessionId = [self createSessionId];
    NSLog(@"Session ID: %@", self.sessionId);

    self.experimenterId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ExperimenterId"];
    
    [self.taskDataArray removeAllObjects];
}

- (void) sendToServer
{
    // For each task
    for (QBTTaskData* taskData in self.taskDataArray) {
        // Create a request with related data
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/record/taskInfo",
                                                                                                 [QBTServerSettings sharedInstance].uploadServer]]
                                                               cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                           timeoutInterval:1000];

        [request setTimeoutInterval:1000];
        [request setHTTPMethod:@"POST"];

        NSMutableString* params = [NSMutableString string];
        [params appendFormat:@"user_id=%@", self.userId];
        [params appendFormat:@"&version_number=%@", self.version];
        [params appendFormat:@"&session_id=%@", self.sessionId];
        [params appendFormat:@"&experimenter_id=%@", self.experimenterId];
        [params appendFormat:@"&device_type=%@", self.deviceType];

        [params appendFormat:@"&song_title=%@", taskData.songTitle];
        [params appendFormat:@"&task_order=%d", taskData.trackOrder];
        
        [params appendFormat:@"&tap_data=%@", taskData.tapOnTimeData];
        [params appendFormat:@"&tap_off_data=%@", taskData.tapOffTimeData];
        [params appendFormat:@"&tap_y_data=%@", taskData.tapYPositionData];
        [params appendFormat:@"&tap_x_data=%@", taskData.tapXPositionData];
        
        [params appendFormat:@"&with_music=%d", taskData.withMusic];
        [params appendFormat:@"&song_familiarity=%f", taskData.songFamiliarity];
        [params appendFormat:@"&audio_helpful=%d", taskData.withMusicHelpful];

        [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
        self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
}

- (void) saveToDisk
{
}

#pragma mark - NSURLConnectionDataDelegate selectors

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError:%@", error.description);
}



- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
//    NSString* ss = [[NSString alloc] initWithBytes:data.bytes
//                                            length:data.length
//                                          encoding:NSUTF8StringEncoding];
//    
//    NSLog(@"TaskInfo: %@", ss);
}

#pragma mark - Private implementation

- (NSString*) createSessionId
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyyMMdd-HH:mm:ss"];
    NSString *dateString = [dateFormat stringFromDate:date];
    
    return dateString;
}

// Code from https://github.com/ars/uidevice-extension
- (NSString *) platform
{
	size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
	sysctlbyname("hw.machine", machine, &size, NULL, 0);
	NSString *platform = [NSString stringWithCString:machine encoding: NSUTF8StringEncoding];
	free(machine);
	return platform;
}

@end

