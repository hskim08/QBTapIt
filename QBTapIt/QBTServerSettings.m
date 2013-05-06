//
//  QBTServerSettings.m
//  QBTapIt
//
//  Created by Hyung-Suk Kim on 1/8/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import "QBTServerSettings.h"

#import "Reachability.h"

@implementation QBTServerSettings

- (id) init
{
    self = [super init];
    
    if (self) {
        
        if (!self.uploadServer) {
            
            self.uploadServer = @"your.server.edu/upload";
            self.songListServer = @"your.server.edu/download";
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
    
    [QBTServerSettings checkDirectoryPath:pathString];
    
    return pathString;
}

+ (NSString*) savedDirectory
{
    NSString* pathString = [NSString stringWithFormat:@"%@/saved", [QBTServerSettings documentsDirectory]];
    
    [QBTServerSettings checkDirectoryPath:pathString];
    
    return pathString;
}

+ (NSString*) backupDirectory
{
    NSString* pathString = [NSString stringWithFormat:@"%@/backup", [QBTServerSettings documentsDirectory]];
    
    [QBTServerSettings checkDirectoryPath:pathString];
    
    return pathString;
}

+ (void) checkDirectoryPath:(NSString*)pathString
{
    // check if saved dir exists
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if ( ![fileManager fileExistsAtPath:pathString] ) {
        NSError* error;
        [fileManager createDirectoryAtPath:pathString
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:&error];
        if (error)
            NSLog(@"Failed to create saved directory:: %@", error.description);
    }
}

+ (BOOL) checkWifiConnection
{
    Reachability* reachability = [Reachability reachabilityForLocalWiFi];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    
    return (networkStatus != NotReachable);
}

@end
