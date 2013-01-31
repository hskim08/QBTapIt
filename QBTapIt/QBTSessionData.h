//
//  QBTSessionData.h
//  QBTapIt
//
//  Created by Ethan Kim on 1/10/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

//t.string   "version_number"
//t.string   "session_id"           (format: yyyy/MM/DD-HH:mm:ss)
//t.string   "song_id"
//t.string   "user_id"
//t.string   "experimenter_id"
//t.string   "tap_data"
//t.string   "tap_off_data"
//t.string   "tap_x_data"
//t.string   "tap_y_data"
//t.integer  "with_music"           0/1
//t.float    "song_familiarity"     0~5
//t.integer  "audio_helpful"        no answer(0)/Yes - it helped me remember more details of the song(1)/Yes - I thought the lyrics were from a different song, but now I know which song it is(2)/Yes - I had no idea of the song from just the lyrics, but listening made me recognize it(3)/No - I already knew the song really well(4)/No - this song is totally unfamiliar, so hearing it once didn’t help(5)


@interface QBTSessionData : NSObject

+ (QBTSessionData *) sharedInstance;

@property (readonly) NSString* version;
@property NSString* sessionId;
@property NSString* userId;
@property NSString* experimenterId;

@property UInt32 taskOrder;

@property (nonatomic) NSMutableArray* taskDataArray;

- (void) initData;

- (void) sendToServer;
- (void) saveToDisk;

@end
