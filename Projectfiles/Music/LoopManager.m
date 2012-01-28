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
- (void)preLoadMusic:(NSString*)file;
- (void)preLoadEffects:(NSString*)file;
- (void)tick:(ccTime)dt;
@end

@implementation LoopManager
@synthesize bpm = bpm_;
@synthesize loops = loops_;
@synthesize title = title_;
@synthesize measure = measure_;
@synthesize nextMeasure = nextMeasure_;

- (id)init {
  self = [super init];
  if (self) {
    bpm_ = 0;
    loops_ = 0;
    measure_ = 0;
    nextMeasure_ = 1;
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
    [self preLoadMusic:file_];
    [self preLoadEffects:file_];
  }
  return self;
}

- (void)play {
  [[OALSimpleAudio sharedInstance] playBg:[NSString stringWithFormat:file_, 0] loop:YES];
  [[CCScheduler sharedScheduler] scheduleSelector:@selector(tick:) 
                                        forTarget:self interval:60.0/self.bpm
                                           paused:NO];
}

- (void)setCallbackOnMeasure:(int)measure delegate:(id)delegate selector:(SEL)selector {
  /*
   特定のmeasureに到達したときに呼ばれるコールバックを登録します
   前回に登録されたコールバックは上書きされます。
   */
  onMeasure_ = measure;
  delegate_ = delegate;
  selector_ = selector;
}

- (void)preLoadMusic:(NSString *)file {
  for (int i = 0; i < loops_; ++i) {
    [[OALSimpleAudio sharedInstance] preloadBg:[NSString stringWithFormat:file, i]];
  }
}

- (void)preLoadEffects:(NSString *)file {
  for (int i = 0; i < 2; ++i) {
    [[OALSimpleAudio sharedInstance] preloadEffect:[NSString stringWithFormat:@"%d.caf", i]];
  }
}

- (void)tick:(ccTime)dt {
  NSLog(@"%d", measure_);
  MotionType type = [score_ motionTypeOnMeasure:measure_];
  if (type != 0) {
    [[OALSimpleAudio sharedInstance] playEffect:[NSString stringWithFormat:@"%d.caf", type]];
  }
  if (measure_ == onMeasure_) {
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [delegate_ performSelector:selector_];
    #pragma clang diagnostic pop
  }
  measure_ = nextMeasure_;
  nextMeasure_ = measure_ + 1;
}

@end