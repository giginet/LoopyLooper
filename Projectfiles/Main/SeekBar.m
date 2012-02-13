//
//  SeekBar.m
//  LoopyLooper
//
//  Created by  on 1/29/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "SeekBar.h"

@interface SeekBar()
- (void)update:(ccTime)dt;
@end

@implementation SeekBar
@synthesize time = time_;
@synthesize maxTime = maxTime_;
@synthesize music = music_;

+ (id)seekBarWithMusic:(LoopMusic *)music measure:(int)measure {
  return [[[self class] alloc] initWithMusic:music measure:measure];
}

- (id)initWithMusic:(LoopMusic *)music measure:(int)measure {
  self = [self init];
  if (self) {
    CCSprite* background = [CCSprite spriteWithFile:@"seekbarBackground.png"];
    markers_ = [NSMutableDictionary dictionaryWithCapacity:16];
    [self addChild:background];
    music_ = music;
    startMeasure_ = measure;
    [self reloadBarFrom:measure];
    bar_ = [CCSprite spriteWithFile:@"seekbar.png"];
    [self addChild:bar_ z:10000];
    bar_.position = ccp(-400, 0);
    time_ = self.music.track.currentTime;
    maxTime_ = self.music.track.duration;
  }
  return self;
}

- (void)reloadBarFrom:(int)measure {
  NSLog(@"measure = %d", measure);
  startMeasure_ = measure;
  for (CCSprite* marker in [markers_ allValues]) {
    [self removeChild:marker cleanup:YES];
  }
  [markers_ removeAllObjects];
  NSArray* measures = [self.music.score motionTypesWithRange:NSMakeRange(measure, 16)];
  for(int i = 0; i < (int)[measures count]; ++i) {
    NSNumber* type = [measures objectAtIndex:i];
    if ([type intValue] != MotionTypeNone) {
      CCSprite* marker = [CCSprite spriteWithFile:@"marker_disable.png"];
      marker.position = CGPointMake(i * 50 - 400, 0);
      [markers_ setObject:marker forKey:[NSNumber numberWithInt:i]];
      [self addChild:marker];
    }
  }
}

- (void)update:(ccTime)dt {
  bar_.position = ccp((800 * time_ / maxTime_) - 400, 0);
}

- (void)play {
  int fps = [[KKStartupConfig config] maxFrameRate];
  [self schedule:@selector(update:) interval:1.0/fps];
  [self update:0];
}

- (void)pause {
  [self unschedule:@selector(update:)];
}

- (void)stop {
  [self pause];
  time_ = 0;
}

- (void)reset {
/*  [self unschedule:@selector(update:)];
  bar_.position = ccp(-400, 0);
  time_ = 0;
  int fps = [[KKStartupConfig config] maxFrameRate];
  [self schedule:@selector(update:) interval:1.0/fps];
  [self update:0];*/
}
 
@end
