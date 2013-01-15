//
//  QBTSessionData.m
//  QBTapIt
//
//  Created by Ethan Kim on 1/10/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import "QBTSessionData.h"

#import "QBTServerSettings.h"
#import "QBTTaskData.h"

@interface QBTSessionData()<NSURLConnectionDelegate>

@property(nonatomic,strong) NSURLConnection* connection;

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

@synthesize taskDataArray = _taskDataArray;
- (NSMutableArray*)taskDataArray {
    if (_taskDataArray == nil) {
        _taskDataArray = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _taskDataArray;
}

- (void) initData
{
    [self.taskDataArray removeAllObjects];
}

- (void) sendToServer
{
    // For each task
    for (QBTTaskData* taskData in self.taskDataArray) {
        // Create a request with related data
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/record/taskInfo",
                                                                                                 [QBTServerSettings sharedInstance].serverIp]]
                                                               cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                           timeoutInterval:1000];

        [request setTimeoutInterval:1000];
        [request setHTTPMethod:@"POST"];

        NSMutableString* params = [NSMutableString string];
        [params appendFormat:@"user_id=%@", self.userId];
        [params appendFormat:@"&experimenter_id=%@", self.experimenterId];

//        [params appendFormat:@"&session_date=%@", self.userId];
//        [params appendFormat:@"&task_order=%ld", self.taskOrder];
        [params appendFormat:@"&with_music=%d", taskData.withMusic];
        
        [params appendFormat:@"&tap_data=%@", taskData.tapOnTimeData];
        [params appendFormat:@"&position_data=%@", taskData.tapYPositionData];
        
        [params appendFormat:@"&music_was_as_expected=%d", taskData.musicAsExpected];
        [params appendFormat:@"&song_familiarity=%d", taskData.songFamiliarity];

        [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
        self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
}

- (void) saveToDisk
{
    
}

#pragma mark - NSURLConnectionDelegate selectors

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError:%@", error.description);
}

#pragma mark - Private implementation

@end

