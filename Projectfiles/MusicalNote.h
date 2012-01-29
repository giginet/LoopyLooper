//
//  MusicalNote.h
//  LoopyLooper
//
//  Created on 12/01/28.
//  Copyright (c) 2012 All rights reserved.
//
#include "math.h"
#import "CCNode.h"
#import "Score.h"

@interface MusicalNote : CCNode{
  @private
  double time;
  NSInteger beatCounter;
  NSInteger startPoint; //0, 4, 8, ...
  NSInteger bpm;
  NSInteger loops;
  NSInteger blockX; //ブロックのX座標
  NSInteger motionType;
  NSArray* PartsArray;
  NSArray* MotionTypeArray;
  NSDictionary* musics;
  NSDictionary* music;
  Score* score;
}
- (id)initWithInt:(int) musicID;
@end
