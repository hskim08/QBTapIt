//
//  QBTSessionData.h
//  QBTapIt
//
//  Created by Ethan Kim on 1/10/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

//t.column :version_number,     :integer    	CHANGE TO STRING
//t.column :user_id,            :integer    	STR
//t.column :session_date,       :datetime       STR (ex: yyyyMMDD:HH:mm:SS)
//t.column :task_order_number,  :integer
//t.column :experimenter_id,	:integer     	STR
//t.column :song_id,            :integer    	STR
//t.column :tap_data,           :string
//t.column :position_data,      :string
//t.column :with_music,         :integer
//t.column :music_was_as_expected,	:integer, true(1)/false(0)/na(-1)
//t.column :song_familiarity,	:integer, don’t know(0)/not well(1)/well(2)/by heart(3)


@interface QBTSessionData : NSObject

+ (QBTSessionData *) sharedInstance;

@property NSString* userId;
@property NSString* experimenterId;

@property UInt32 taskOrder;

@property (nonatomic) NSMutableArray* taskDataArray;

- (void) initData;

- (void) sendToServer;
- (void) saveToDisk;

@end
