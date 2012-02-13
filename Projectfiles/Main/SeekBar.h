//
//  SeekBar.h
//  LoopyLooper
//
//  Created by  on 1/29/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "heqet.h"
#import "LoopMusic.h"

@interface SeekBar : CCNode {
  int startMeasure_;
  NSMutableDictionary* markers_;
  ccTime time_;
  ccTime maxTime_;
  CCNode* markerLayer_;
  CCSprite* bar_;
  LoopMusic* music_;
}

@property(readwrite) ccTime time;
@property(readwrite) ccTime maxTime;
@property(readonly) LoopMusic* music;

+ (id)seekBarWithMusic:(LoopMusic*)music measure:(int)measure;

- (id)initWithMusic:(LoopMusic*)music measure:(int)measure;
- (void)reloadBarFrom:(int)measure;
- (void)play;
- (void)pause;
- (void)stop;
- (void)reset;

@end
