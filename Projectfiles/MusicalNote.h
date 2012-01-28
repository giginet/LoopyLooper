//
//  MusicalNote.h
//  LoopyLooper
//
//  Created on 12/01/28.
//  Copyright (c) 2012 All rights reserved.
//

#import "CCNode.h"
#import "Score.h"

@interface MusicalNote : CCNode{
  @private
  NSInteger updateCounter; //0, 1, ... , 15
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
@end
