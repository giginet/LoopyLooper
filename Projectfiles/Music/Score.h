//
//  Score.h
//  LoopyLooper
//
//  Created by  on 1/28/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Motion.h"

#define BASE_SCORE 500

typedef enum {
  RankE,
  RankD,
  RankC,
  RankB,
  RankA,
  RankS
} Rank;

@interface Score : NSObject {
  NSDictionary* scoreData_;
}

@property(readonly) int scoreLength;

+ (id)scoreFromMusicId:(int)musicId difficulty:(int)difficulty;

- (id)initWithFile:(NSString*)file;

- (MotionType)motionTypeOnBeat:(int)beat;
- (NSArray*)motionTypesWithRange:(NSRange)range;
- (int)maxScore;
- (Rank)rankFromScore:(int)score;

@end
