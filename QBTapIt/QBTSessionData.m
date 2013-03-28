//
//  QBTSessionData.m
//  QBTapIt
//
//  Created by Hyung-Suk Kim on 1/10/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import "QBTSessionData.h"

#include <sys/types.h>
#include <sys/sysctl.h>

#import "QBTServerSettings.h"


@interface QBTSessionData()

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

// X.X.0 -> debugging
// X.X.1 -> release version
//
// 1.0.X -> first test
// 1.1.X -> added specific training
@synthesize version = _version;
-(NSString*) version
{
    if (!_version) {
#ifdef DEBUG
        _version = @"1.1.0"; // update version when necessary
#else
        _version = @"1.1.1";
#endif

    }
    return _version;
}

@synthesize deviceType = _deviceType;
- (NSString*) deviceType
{
    if(!_deviceType) {
        
        _deviceType = [self platform];
    }
    return _deviceType;
}

- (void) initData
{
    self.sessionId = [self createSessionId];
    NSLog(@"Session ID: %@", self.sessionId);

    self.experimenterId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ExperimenterId"];
}

- (void) saveToDisk
{
    NSString *fileName = [NSString stringWithFormat:@"%@/session", self.sessionDir];
    [NSKeyedArchiver archiveRootObject:self
                                toFile:fileName];
}

- (NSString*) sessionDir
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];

    NSString* ssDir = [NSString stringWithFormat:@"%@/saved/%@", docDir, self.sessionId];
    
    // check if directory exists
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if ( ![fileManager fileExistsAtPath:ssDir] ) { // create if directory doesn't exist
        
        NSError* error;
        [fileManager createDirectoryAtPath:ssDir
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:&error];
        if (error)
            NSLog(@"Failed to create temp directory:: %@", error.description);
    }

    return ssDir;
}

#pragma mark - NSCoding Selectors

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        
        self.userId = [decoder decodeObjectForKey:@"userId"];
        self.version = [decoder decodeObjectForKey:@"version"];
        self.sessionId = [decoder decodeObjectForKey:@"sessionId"];
        self.experimenterId = [decoder decodeObjectForKey:@"experimenterId"];
        self.deviceType = [decoder decodeObjectForKey:@"deviceType"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.userId forKey:@"userId"];
    [encoder encodeObject:self.version forKey:@"version"];
    [encoder encodeObject:self.sessionId forKey:@"sessionId"];
    [encoder encodeObject:self.experimenterId forKey:@"experimenterId"];
    [encoder encodeObject:self.deviceType forKey:@"deviceType"];
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

