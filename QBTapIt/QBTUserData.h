//
//  QBTUserData.h
//  QBTapIt
//
//  Created by Ethan Kim on 1/8/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

//t.column :age,			:integer
//t.column :gender,		:integer	M=0/F=1
//t.column :handedness,	:integer	L=0/R=1/A=-1
//t.column :tone_deaf,		:integer	N=0/Y=1/DN=-1
//t.column :arrythmic,		:integer	N=0/Y=1/DN=-1
//t.column :native_language,	:string		pull-down menu
//t.column :listening_habits,	:integer	(1~5)
//t.column :instrument_training,	:integer	(1~5)
//t.column :theory_training,	:integer	(1~5)


@interface QBTUserData : NSObject

+ (QBTUserData *) sharedInstance;

@property NSString* userId;

@property UInt8 age;
@property NSString* gender;

@property NSString* nativeLanguage;

@property SInt8 handedness;
@property SInt8 toneDeaf;
@property SInt8 arrythmic;

@property UInt8 listeningHabits;
@property UInt8 instrumentTraining;
@property UInt8 theoryTraining;

- (void) initData;

- (void) sendToServer;
- (void) saveToDisk;

@end

