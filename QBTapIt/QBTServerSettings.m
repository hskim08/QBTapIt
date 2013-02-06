//
//  QBTServerSettings.m
//  QBTapIt
//
//  Created by Ethan Kim on 1/8/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import "QBTServerSettings.h"

@implementation QBTServerSettings

@synthesize serverIp = _serverIp;
- (NSString*) serverIp
{
    // change IP as needed
//    return @"192.168.1.130:3000"; // home
//    return @"192.168.183.218:3000"; // ccrma
    return @"10.32.225.226:3000";
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
