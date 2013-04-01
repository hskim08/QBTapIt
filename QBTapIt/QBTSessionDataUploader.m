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
- (void) moveSessionToBackup:(NSString*)session;
- (void) deleteSession:(NSString*)sessionDir;

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
        
        NSString* sessionDir = [NSString stringWithFormat:@"%@/%@", [QBTServerSettings savedDirectory], file];
        
        // send the session
        // TODO: check if the session data was successfully sent
        [self sendSession:sessionDir];
        
        // move session to backup
        [self moveSessionToBackup:file];
        
        // delete the session (Don't delete unless absolutely sure the data has been sent. We will copy a backup in the meantime)
//        [self deleteSession:sessionDir];
        
        // signal delegate
        [self.delegate didSendSession:YES];
    }
}

- (void) moveSessionToBackup:(NSString*)session
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError* error;
    
    NSString* sessionDir = [NSString stringWithFormat:@"%@/%@", [QBTServerSettings savedDirectory], session];
    NSString* backupDir = [NSString stringWithFormat:@"%@/%@", [QBTServerSettings backupDirectory], session];
    
    [fileManager moveItemAtPath:sessionDir
                         toPath:backupDir
                          error:&error];
    
    if (error)
        NSLog(@"Failed to move session (%@)", error.description);
    
}

- (void) deleteSession:(NSString*)sessionDir
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError* error;

    [fileManager removeItemAtPath:sessionDir
                            error:&error];
    
    if (error)
        NSLog(@"Failed to delete session directory at %@ (%@)", sessionDir, error.description);
}

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
