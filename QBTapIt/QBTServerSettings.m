//
//  QBTServerSettings.m
//  QBTapIt
//
//  Created by Ethan Kim on 1/8/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import "QBTServerSettings.h"

@interface QBTServerSettings ()

@end

@implementation QBTServerSettings

@synthesize serverIp = _serverIp;
- (NSString*) serverIp
{
    // change IP as needed
    return @"192.168.1.130:3000"; // home
//    return @"192.168.182.72:3000"; // ccrma
}

# pragma  mark - Singleton
static QBTServerSettings* sharedInstance = nil;
+ (QBTServerSettings*) sharedInstance
{
    if (sharedInstance == nil)
        sharedInstance = [[QBTServerSettings alloc] init];

    return sharedInstance;
}

@end
