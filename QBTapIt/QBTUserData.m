//
//  QBTUserData.m
//  QBTapIt
//
//  Created by Hyung-Suk Kim on 1/8/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import "QBTUserData.h"

#import "QBTSessionData.h"

#import "QBTServerSettings.h"

@interface QBTUserData()<NSURLConnectionDataDelegate>

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
    
    self.age = 0;
    self.gender = nil;
    self.nativeLanguage = nil;
    self.handedness = 1;
    self.toneDeaf = 0;
    self.arrhythmic = 0;
    self.specificTraining = nil;
}

- (void) saveData
{
    if ([QBTSessionData sharedInstance].isConnected)
        [self sendToServer];
    else
        [self saveToDisk];
}

- (void) sendToServer
{
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/record/userInfo",
                                                                         [QBTServerSettings sharedInstance].uploadServer]]
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
    [params appendFormat:@"&arrhythmic=%d", self.arrhythmic];
    [params appendFormat:@"&listening_habits=%f", self.listeningHabits];
    [params appendFormat:@"&instrument_training=%f", self.instrumentTraining];
    [params appendFormat:@"&theory_training=%f", self.theoryTraining];
    if (self.specificTraining)
        [params appendFormat:@"&specific_training=%@", self.specificTraining];
    
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void) saveToDisk
{
    NSString *fileName = [NSString stringWithFormat:@"%@/user", [QBTSessionData sharedInstance].sessionDir];
    
    if (![NSKeyedArchiver archiveRootObject:self
                                     toFile:fileName])
        NSLog(@"Failed to save user data to disk");
}

#pragma mark - NSCoding Selectors

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        
        NSLog(@"Decoding user data");
        
        self.userId = [decoder decodeObjectForKey:@"userId"];
    
        self.age = [decoder decodeIntegerForKey:@"age"];
        self.gender = [decoder decodeObjectForKey:@"gender"];
        self.nativeLanguage = [decoder decodeObjectForKey:@"nativeLanguage"];
        
        self.handedness = [decoder decodeIntegerForKey:@"handedness"];
        self.toneDeaf = [decoder decodeIntegerForKey:@"toneDeaf"];
        self.arrhythmic = [decoder decodeIntegerForKey:@"arrhythmic"];
        
        self.listeningHabits = [decoder decodeFloatForKey:@"listeningHabits"];
        self.instrumentTraining = [decoder decodeFloatForKey:@"instrumentTraining"];
        self.theoryTraining = [decoder decodeFloatForKey:@"theoryTraining"];
        
        self.specificTraining = [decoder decodeObjectForKey:@"specificTraining"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    NSLog(@"Encoding user data");
    
    [encoder encodeObject:self.userId forKey:@"userId"];
    
    [encoder encodeInteger:self.age forKey:@"age"];
    [encoder encodeObject:self.gender forKey:@"gender"];
    [encoder encodeObject:self.nativeLanguage forKey:@"nativeLanguage"];
    
    [encoder encodeInteger:self.handedness forKey:@"handedness"];
    [encoder encodeInteger:self.toneDeaf forKey:@"toneDeaf"];
    [encoder encodeInteger:self.arrhythmic forKey:@"arrhythmic"];
    
    [encoder encodeFloat:self.listeningHabits forKey:@"listeningHabits"];
    [encoder encodeFloat:self.instrumentTraining forKey:@"instrumentTraining"];
    [encoder encodeFloat:self.theoryTraining forKey:@"theoryTraining"];
    
    if (self.specificTraining)
        [encoder encodeObject:self.specificTraining forKey:@"specificTraining"];
}

#pragma mark - NSURLConnectionDataDelegate selectors

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if ([response class] == [NSHTTPURLResponse class]) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        
        NSLog(@"Status Code: %d", httpResponse.statusCode);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError:%@", error.description);
}

@end

