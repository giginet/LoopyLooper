//
//  MusicalNote.m
//  LoopyLooper
//
//  Created on 12/01/28.
//  Copyright (c) 2012 All rights reserved.
//

#import "MusicalNote.h"

@implementation MusicalNote

- (id)initWithInt:(int) musicID{
  self = [super init];

  if (self) {
    musics = [KKLua loadLuaTableFromFile:@"musics.lua"];
    music = [musics objectForKey:[NSString stringWithFormat:@"%d", musicID]];

    time = 0.0;
    beatCounter = 0;
    startPoint = 0;
    blockX = 140;
    bpm = [(NSNumber*)[music objectForKey:@"bpm"] intValue];;
    loops = [(NSNumber*)[music objectForKey:@"loops"] intValue];
    
    CCSprite* BGSeekbar = [CCSprite spriteWithFile:@"testBGSeekbar.png"];
    CCSprite* Seekbar = [CCSprite spriteWithFile:@"SeekBar.png"];
    BGSeekbar.position = CGPointMake(512, 100);
    Seekbar.position = CGPointMake(512, 100);
    [self addChild:BGSeekbar];
    [self addChild:Seekbar];
    
    score = [[Score alloc] initWithFile:[music objectForKey:@"score"]];
    MotionTypeArray = [score motionTypesWithRange:NSMakeRange(startPoint, 16)];
    for (int i = 0; i < ((int)[MotionTypeArray count]); ++i) {
      if ([[MotionTypeArray objectAtIndex:i] intValue] > 0) {
        CCSprite* TimingBar = [CCSprite spriteWithFile:@"Symbol_Circle_Unable.png"];
        TimingBar.position = CGPointMake(blockX + (50 * i), 100);
        [self addChild:TimingBar z:0 tag:(200 + i)];
      }
    }

    CCSprite* Block = [CCSprite spriteWithFile:@"Symbol_Circle.png"];
    Block.position = CGPointMake(blockX, 100);
    [self addChild:Block];
    PartsArray = [NSArray arrayWithObjects:BGSeekbar, Seekbar, Block, nil];    

    [[CCScheduler sharedScheduler] scheduleSelector:@selector(update:) 
                                          forTarget:self interval:0.033f
                                          paused:NO];
  }
  
  return self;
}

- (void)update:(ccTime)dt {
  NSString* imageName = @"";
  
  if () {
    motionType = [((NSNumber*)[MotionTypeArray objectAtIndex:beatCounter++]) intValue];
  }
  
  if (motionType > 0) {
    imageName = @"Symbol_Circle.png";
  } else {
    imageName = @"Symbol_Circle_Blink.png";
  }
  [((CCSprite*)[PartsArray objectAtIndex:2]) setTexture:[[CCTextureCache sharedTextureCache] addImage:imageName]];

  if (beatCounter > 15) {
    startPoint += loops;
    beatCounter = 0;
    
    if ([score motionTypeOnMeasure:startPoint] == MotionTypeNone) {
      startPoint = 0;
    }
    
    MotionTypeArray = [score motionTypesWithRange:NSMakeRange(startPoint, 16)];
    for (int i = 0; i < ((int)[MotionTypeArray count]); ++i) {
      if ([[MotionTypeArray objectAtIndex:i] intValue] > 1) {
        CCSprite* TimingBar = [CCSprite spriteWithFile:@"Symbol_Circle_Unable.png"];
        TimingBar.position = CGPointMake(blockX + (50 * i), 100);
      } else {
        [self removeChildByTag:(100 + i) cleanup:YES];
      }
    }
  }

  time += dt;
  if (time < 8.0) {
    blockX += 4;//Seekbarの長さ/loop_counterの上限
  } else {
    time = 0;
    blockX = 140;
  }
  ((CCSprite*)[PartsArray objectAtIndex:2]).position = CGPointMake(blockX, 100);
}

@end
