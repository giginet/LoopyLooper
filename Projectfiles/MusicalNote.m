//
//  MusicalNote.m
//  LoopyLooper
//
//  Created on 12/01/28.
//  Copyright (c) 2012 All rights reserved.
//

#import "MusicalNote.h"

@implementation MusicalNote

- (id)init:(int) musicID{
  self = [super init];

  if (self) {
    updateCounter = 0;
    startPoint = 0;
    blockX = 100;
    bpm = [(NSNumber*)[music objectForKey:@"bpm"] intValue];;
    loops = [(NSNumber*)[music objectForKey:@"loops"] intValue];
    
    CCSprite* BGSeekbar = [CCSprite spriteWithFile:@""];
    CCSprite* Seekbar = [CCSprite spriteWithFile:@""];
    CCSprite* Block = [CCSprite spriteWithFile:@""];
    BGSeekbar.position = CGPointMake(100, 100);
    Seekbar.position = CGPointMake(100, 100);
    Block.position = CGPointMake(blockX, 100);
    PartsArray = [NSArray arrayWithObjects:BGSeekbar, Seekbar, Block, nil];
    
    score = [[Score alloc] initWithFile:[music objectForKey:@"score"]];
    MotionTypeArray = [score motionTypesWithRange:NSMakeRange(startPoint, 16)];

    musics = [KKLua loadLuaTableFromFile:@"musics.lua"];
    music = [musics objectForKey:[NSString stringWithFormat:@"%d", musicID]];
    
    [[CCScheduler sharedScheduler] scheduleSelector:@selector(update:) 
                                          forTarget:self interval:60.0/bpm
                                             paused:NO];
  }
  
  return self;
}

- (void)update:(ccTime)dt {
  motionType = [((NSNumber*)[MotionTypeArray objectAtIndex:updateCounter]) intValue];
  
  if ((updateCounter++) < 16) {
    blockX += 10;//Seekbarの長さ/loop_counterの上限
  } else {
    startPoint += loops;
    MotionTypeArray = [score motionTypesWithRange:NSMakeRange(startPoint, 16)];
    
    blockX += 0;//初期ポジションに
  }
  
  NSLog(@"BlockCoord x:%d¥t y:%d¥n", blockX, 100);
  ((CCSprite*)[PartsArray objectAtIndex:2]).position = CGPointMake(blockX, 100);
  [((CCSprite*)[PartsArray objectAtIndex:2]) setTexture:[[CCTextureCache sharedTextureCache] addImage:@"hogehoge"]];
}
@end
