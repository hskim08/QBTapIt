//
//  QBTServerSettings.h
//  QBTapIt
//
//  Created by Hyung-Suk Kim on 1/8/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QBTServerSettings : NSObject

+ (QBTServerSettings*) sharedInstance;

+ (NSString*) documentsDirectory;
+ (NSString*) tempDirectory;
+ (NSString*) savedDirectory;
+ (NSString*) backupDirectory;

+ (void) checkDirectoryPath:(NSString*)pathString;

+ (BOOL) checkWifiConnection;

@property (nonatomic) NSString* uploadServer;
@property (nonatomic) NSString* songListServer;

@end
