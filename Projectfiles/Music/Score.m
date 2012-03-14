//
//  Score.m
//  LoopyLooper
//
//  Created by  on 1/28/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "Score.h"

@implementation Score
@dynamic scoreLength;

+ (id)scoreFromMusicId:(int)musicId difficulty:(int)difficulty {
  NSDictionary* musics = [KKLua loadLuaTableFromFile:@"musics.lua"];
  NSDictionary* music = [musics objectForKey:[NSString stringWithFormat:@"%d", musicId]];
  const NSString* difficulties[] = {@"easy", @"normal", @"hard"};
  NSString* filename = [NSString stringWithFormat:[music objectForKey:@"score"], difficulties[difficulty]];
  return [[Score alloc] initWithFile:filename];
}

- (id)initWithFile:(NSString *)file {
  self = [super init];
  if (self) {
    scoreData_ = [KKLua loadLuaTableFromFile:file];
  }
  return self;
}

- (MotionType)motionTypeOnBeat:(int)beat {
  /**
   * ゲーム開始からbeat拍目に取るべき動きを返します
   * @args int beat 音楽開始からの拍
   * @return MotionType その小節で取るべき動きのType
   */
  if (beat > (int)[scoreData_ count]) return MotionTypeNone; // Luaのtableのindexは1から始まる
  MotionType type = (MotionType)[(NSNumber*)[scoreData_ objectForKey:[NSString stringWithFormat:@"%d", beat + 1]] intValue];
  return type;
}

- (NSArray*)motionTypesWithRange:(NSRange)range {
  /**
   * 範囲を渡すと、その範囲のMotionTypeを含んだ配列を返します
   * @args NSRange 取得する楽譜の長さ
   * @retruns NSArray MotionTypeをラップしたNSNumberを含んだNSArray
   */
  NSMutableArray* types = [NSMutableArray array];
  for (int i = range.location; i < (int)(range.location + range.length); ++i) {
    [types addObject:[NSNumber numberWithInt:[self motionTypeOnBeat:i]]];
  }
  return types;
}

- (int)scoreLength {
  return [scoreData_ count];
}

- (int)maxScore {
  /*
   この楽曲を全問正解したときの理論上の最高スコアを返します
   */
  int score = 0;
  for (int i = 1; i <= self.scoreLength; ++i) {
    int level = MIN(4, ceil((i - 1) / 4 + 1));
    if ([self motionTypeOnBeat:i] != MotionTypeNone) {
      score += BASE_SCORE * pow(2, level);
    }
  }
  return score;
}

- (Rank)rankFromScore:(int)score {
  /*
   この楽曲でscoreを取ったときのRankを返します。
   */
  float rate = (float)score / (float)self.maxScore;
  if (rate >= 0.85) {
    return RankS;
  } else if (rate >= 0.7){
    return RankA;
  } else if (rate >= 0.5) {
    return RankB;
  }
  return RankC;
}

@end
