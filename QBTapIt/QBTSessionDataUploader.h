//
//  QBTSessionUploader.h
//  QBTapIt
//
//  Created by Ethan Kim on 3/29/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QBTSessionDataUploader : NSObject

+ (QBTSessionDataUploader *) sharedInstance;

- (void) sendSavedSessions;

@end
