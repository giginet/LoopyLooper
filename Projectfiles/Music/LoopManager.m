//
//  LoopManager.m
//  LoopyLooper
//
//  Created by  on 1/28/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "LoopManager.h"
#import "Motion.h"

const NSString* MUSICS_DATA = @"musics.lua";

@interface LoopManager()
- (void)preLoadBGM:(NSString*)file;
- (void)tick:(ccTime)dt;
@end

@implementation LoopManager
@synthesize bpm = bpm_;
@synthesize loops = loops_;
@synthesize title = title_;

- (id)init {
  self = [super init];
  if (self) {
    bpm_ = 0;
    loops_ = 0;
    measure_ = 0;
    title_ = @"";
  }
  return self;
}

- (id)initWithMusicID:(int)musicID {
  self = [self init];
  if (self) {
    NSDictionary* musics = [KKLua loadLuaTableFromFile:(NSString*)MUSICS_DATA];
    NSDictionary* music = [musics objectForKey:[NSString stringWithFormat:@"%d", musicID]];
    bpm_ = [(NSNumber*)[music objectForKey:@"bpm"] intValue];
    loops_ = [(NSNumber*)[music objectForKey:@"loops"] intValue];
    title_ = [music objectForKey:@"title"];
    file_ = [music objectForKey:@"file"];
    score_ = [[Score alloc] initWithFile:[music objectForKey:@"score"]];
  }
  return self;
}

- (void)play {
  NSLog(@"%@", file_);
  [[OALSimpleAudio sharedInstance] playBg:[NSString stringWithFormat:file_, 0] loop:YES];
  [[CCScheduler sharedScheduler] scheduleSelector:@selector(tick:) 
                                        forTarget:self interval:1.0/self.bpm
                                           paused:NO];
}

- (void)preLoadBGM:(NSString *)file {
  for (int i = 0; i < loops_; ++i) {
    [[OALSimpleAudio sharedInstance] preloadBg:[NSString stringWithFormat:file, i]];
  }
}

- (void)tick:(ccTime)dt {
  MotionType type = [score_ motionTypeOnMeasure:measure_];
  ++measure_;
  NSLog(@"type = %d", type);
}

@end