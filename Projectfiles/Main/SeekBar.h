//
//  SeekBar.h
//  LoopyLooper
//
//  Created by  on 1/29/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "heqet.h"
#import "Score.h"

@interface SeekBar : CCNode {
  int startMeasure_;
  NSMutableDictionary* markers_;
  ccTime time_;
  CCSprite* bar_;
  Score* score_;
}

@property(readwrite) ccTime time;

+ (id)seekBarWithScore:(Score*)score measure:(int)measure;

- (id)initWithScore:(Score*)score measure:(int)measure;
- (void)reloadBarFrom:(int)measure;
- (void)play;
- (void)pause;
- (void)stop;
- (void)reset;

@end
