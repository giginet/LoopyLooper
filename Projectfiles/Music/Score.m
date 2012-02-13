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

@end
