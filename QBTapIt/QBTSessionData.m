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

// X.X.Xa -> debugging
// X.X.X -> release version
//
// 1.0.X -> first test
// 1.1.X -> added specific training
@synthesize version = _version;
-(NSString*) version
{
    // this uses the app version the the plist for the version number
    if (!_version) {
        
#ifdef DEBUG
        _version = [NSString stringWithFormat:@"%@a", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];;
#else
        _version = [NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];;
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
    
    self.connected = [QBTServerSettings checkWifiConnection];
}

- (void) saveToDisk
{
    NSString *fileName = [NSString stringWithFormat:@"%@/session", self.sessionDir];
    
    if (![NSKeyedArchiver archiveRootObject:self
                                     toFile:fileName])
        NSLog(@"Failed to save session data to disk");
}

- (NSString*) sessionDir
{
    NSString* pathString = [NSString stringWithFormat:@"%@/%@", [QBTServerSettings savedDirectory], self.sessionId];
    
    [QBTServerSettings checkDirectoryPath:pathString];
    
    return pathString;
}

#pragma mark - NSCoding Selectors

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        
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
    [dateFormat setDateFormat:@"yyyyMMdd-HHmmss"];
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

