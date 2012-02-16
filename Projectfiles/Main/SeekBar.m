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
    markers_ = [NSMutableDictionary dictionaryWithCapacity:16];
    CCSprite* background = [CCSprite spriteWithFile:@"seek_background.png"];
    self.contentSize = background.contentSize;
    music_ = music;
    startMeasure_ = measure;
    markerLayer_ = [CCNode node];
    markerLayer_.position = ccp(-self.contentSize.width / 2, 0);
    bar_ = [CCSprite spriteWithFile:@"seekbar.png"];
    bar_.position = ccp(-self.contentSize.width / 2, 0);
    time_ = self.music.currentTime;
    maxTime_ = self.music.duration;
    [self addChild:background];
    [self addChild:markerLayer_];
    [self addChild:bar_];
    [self reloadBarFrom:measure];
    [[CCTextureCache sharedTextureCache] addImage:@"seek_marker1.png"];
  }
  return self;
}

- (void)reloadBarFrom:(int)measure {
  startMeasure_ = measure;
  [markerLayer_ removeAllChildrenWithCleanup:YES];
  [markers_ removeAllObjects];
  NSArray* measures = [self.music.score motionTypesWithRange:NSMakeRange(measure, 16)];
  for(int i = 0; i < (int)[measures count]; ++i) {
    NSNumber* type = [measures objectAtIndex:i];
    if ([type intValue] != MotionTypeNone) {
      CCSprite* marker = [CCSprite spriteWithFile:@"seek_marker0.png"];
      marker.position = CGPointMake(i * marker.contentSize.width, 0);
      [markers_ setObject:marker forKey:[NSNumber numberWithInt:i]];
      [markerLayer_ addChild:marker];
    }
  }
}

- (void)update:(ccTime)dt {
  bar_.position = ccp((self.contentSize.width * time_ / maxTime_ -self.contentSize.width / 2), 0);
  for(CCSprite* marker in [markers_ allValues]) {
    int no = 0;
    if(CGRectContainsPoint(bar_.boundingBox, ccpAdd(marker.position, ccp(-self.contentSize.width / 2, 0)))) {
      no = 1;
    }
    [marker setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"seek_marker%d.png", no]]];
  }
}

- (void)play {
  int fps = [[KKStartupConfig config] maxFrameRate];
  [self schedule:@selector(update:) interval:1.0 / fps];
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
