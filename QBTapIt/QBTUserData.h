//
//  QBTUserData.h
//  QBTapIt
//
//  Created by Hyung-Suk Kim on 1/8/13.
//  Copyright (c) 2013 CCRMA, Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

//t.column :age,			:integer
//t.column :gender,		:integer	M=0/F=1
//t.column :handedness,	:integer	L=0/R=1/A=2 (Ambidextrous = 2 from version 1.1+)
//t.column :tone_deaf,		:integer	N=0/Y=1/DN=-1
//t.column :arrythmic,		:integer	N=0/Y=1/DN=-1
//t.column :native_language,	:string		pull-down menu
//t.column :listening_habits,	:integer	(1~5)
//t.column :instrument_training,	:integer	(1~5)
//t.column :theory_training,	:integer	(1~5)


@interface QBTUserData : NSObject

+ (QBTUserData *) sharedInstance;

@property NSString* userId;

@property NSInteger age;
@property NSString* gender;
@property NSString* nativeLanguage;

@property NSInteger handedness;
@property NSInteger toneDeaf;
@property NSInteger arrhythmic;

@property Float32 listeningHabits;
@property Float32 instrumentTraining;
@property Float32 theoryTraining;

@property NSString* specificTraining;

+ (NSString *)createUUID;

- (void) initData;

- (void) sendToServer;
- (void) saveToDisk;

@end

