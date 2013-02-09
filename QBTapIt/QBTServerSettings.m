//
//  QBTServerSettings.m
//  QBTapIt
//
//  Created by Ethan Kim on 1/8/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import "QBTServerSettings.h"

@implementation QBTServerSettings

- (id) init
{
    self = [super init];
    
    if (self) {
        
        if (!self.uploadServer) {
            
            self.uploadServer = @"ding.stanford.edu";
            self.songListServer = @"ding.stanford.edu";
        }
    }
    
    return self;
}

@synthesize uploadServer = _serverIp;
- (void) setUploadServer:(NSString *)serverIp
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:serverIp forKey:@"UploadServer"];
    [defaults synchronize];
}

- (NSString*) uploadServer
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults objectForKey:@"UploadServer"];
}

@synthesize songListServer = _songListServer;
- (void) setSongListServer:(NSString *)songListServer
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:songListServer forKey:@"SongListServer"];
    [defaults synchronize];
}

- (NSString*) songListServer
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults objectForKey:@"SongListServer"];
}

# pragma  mark - Singleton
static QBTServerSettings* sharedInstance = nil;
+ (QBTServerSettings*) sharedInstance
{
    if (sharedInstance == nil)
        sharedInstance = [[QBTServerSettings alloc] init];

    return sharedInstance;
}

+ (NSString*) documentsDirectory
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString*) tempDirectory
{
    NSString* pathString = [NSString stringWithFormat:@"%@/temp", [QBTServerSettings documentsDirectory]];
    
    // check if temp dir exists
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if ( ![fileManager fileExistsAtPath:pathString] ) {
        NSError* error;
        [fileManager createDirectoryAtPath:pathString
               withIntermediateDirectories:NO
                                attributes:nil
                                     error:&error];
        if (error)
            NSLog(@"Failed to create temp directory:: %@", error.description);
    }
    
    return pathString;
}

@end
