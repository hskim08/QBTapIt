//
//  QBTUserData.m
//  QBTapIt
//
//  Created by Ethan Kim on 1/8/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import "QBTUserData.h"

#import "QBTServerSettings.h"

@interface QBTUserData()<NSURLConnectionDelegate>

@property(nonatomic,strong) NSURLConnection* connection;

@end

@implementation QBTUserData

#pragma mark - Singleton

static QBTUserData* sharedInstance = nil;
+ (QBTUserData *) sharedInstance {
    if (sharedInstance == nil)
        sharedInstance = [[QBTUserData alloc] init];
    
    return sharedInstance;
}

# pragma mark - Public Implementation

+ (NSString *)createUUID
{
    // Create universally unique identifier (object)
    CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);
    
    // Get the string representation of CFUUID object.
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    NSString *uuidStr = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    
    CFRelease(uuidObject);
    
    return uuidStr;
}

- (void) initData
{
    self.userId = [QBTUserData createUUID];
    NSLog(@"User ID: %@", self.userId);
    
    self.age = 0;
    self.gender = nil;
    self.nativeLanguage = nil;
    self.handedness = -1;
    self.toneDeaf = -1;
    self.arrythmic = -1;
}

- (void) sendToServer
{
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/record/userInfo",
                                                                         [QBTServerSettings sharedInstance].serverIp]]
                                    cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                    timeoutInterval:1000];
    
    [request setTimeoutInterval:1000];
    [request setHTTPMethod:@"POST"];
    
    NSMutableString* params = [NSMutableString string];
    [params appendFormat:@"user_id=%@", self.userId];
    [params appendFormat:@"&age=%d", self.age];
    [params appendFormat:@"&gender=%@", self.gender];
    [params appendFormat:@"&native_language=%@", self.nativeLanguage];
    [params appendFormat:@"&handedness=%d", self.handedness];
    [params appendFormat:@"&tone_deaf=%d", self.toneDeaf];
    [params appendFormat:@"&arrythmic=%d", self.arrythmic];
    [params appendFormat:@"&listening_habits=%f", self.listeningHabits];
    [params appendFormat:@"&instrument_training=%f", self.instrumentTraining];
    [params appendFormat:@"&theory_training=%f", self.theoryTraining];
    
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
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

