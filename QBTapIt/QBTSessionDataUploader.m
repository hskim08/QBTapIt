//
//  QBTSessionUploader.m
//  QBTapIt
//
//  Created by Ethan Kim on 3/29/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import "QBTSessionDataUploader.h"

#import "QBTServerSettings.h"

#import "QBTUserData.h"
#import "QBTSessionData.h"
#import "QBTTaskData.h"

@interface QBTSessionDataUploader()

@property QBTSessionData* sessionData;

- (void) sendSession:(NSString*)sessionDir;
- (void) sendUserData:(NSString*)fileName;
- (void) loadSessionData:(NSString*)fileName;
- (void) sendTaskData:(NSString*)fileName;

@end

@implementation QBTSessionDataUploader

#pragma mark - Singleton

static QBTSessionDataUploader* sharedInstance = nil;
+ (QBTSessionDataUploader *) sharedInstance {
    if (sharedInstance == nil)
        sharedInstance = [[QBTSessionDataUploader alloc] init];
    
    return sharedInstance;
}

- (void) sendSavedSessions
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError* error;
    
    NSArray* files = [fileManager contentsOfDirectoryAtPath:[QBTServerSettings savedDirectory]
                                                      error:&error];
    for (NSString* file in files) {
        
        [self sendSession:[NSString stringWithFormat:@"%@/%@", [QBTServerSettings savedDirectory], file]];
    }
}

// TODO: move this code to session uploader class
- (void) sendSession:(NSString*)sessionDir
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError* error;

    NSArray* files = [fileManager contentsOfDirectoryAtPath:sessionDir
                                                      error:&error];
    
    // send user data
    [self sendUserData:[NSString stringWithFormat:@"%@/user", sessionDir]];
    
    // load session
    [self loadSessionData:[NSString stringWithFormat:@"%@/session", sessionDir]];

    // send task data
    for (NSString* file in files) {
        
        if ([file hasPrefix:@"task"]) {
            
            [self sendTaskData:[NSString stringWithFormat:@"%@/%@", sessionDir, file]];
        }
    }
    
    
}

- (void) sendUserData:(NSString*)fileName
{
    // load data
    QBTUserData* userData = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
    
    NSLog(@"Loaded user with ID: %@", userData.userId);

    // send data
    [userData sendToServer];
}

- (void) loadSessionData:(NSString*)fileName
{
    // load data
    self.sessionData = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
    
    NSLog(@"Loaded session with ID: %@", self.sessionData.sessionId);
}

- (void) sendTaskData:(NSString*)fileName
{
    // load data
    QBTTaskData* taskData = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
    taskData.sessionData = self.sessionData;
    
    NSLog(@"Loaded task of song: %@ (with Music: %d)", taskData.songTitle, taskData.withMusic);
    
    // send data
    [taskData sendToServer];
}


@end
