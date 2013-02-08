//
//  QBTServerSettings.h
//  QBTapIt
//
//  Created by Ethan Kim on 1/8/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QBTServerSettings : NSObject

+ (QBTServerSettings*) sharedInstance;

@property (nonatomic) NSString* uploadServer;
@property (nonatomic) NSString* songListServer;

@end
