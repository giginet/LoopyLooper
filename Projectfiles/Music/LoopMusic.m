//
//  LoopManager.m
//  LoopyLooper
//
//  Created by  on 1/28/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "LoopMusic.h"
#import "Motion.h"
#import "LoopPlayer.h"

const NSString* MUSICS_DATA = @"musics.lua";

@interface LoopMusic()
- (void)preLoadMusic:(NSString*)file;
- (void)preLoadEffects:(NSString*)file;
- (void)tick:(ccTime)dt;
@end

@implementation LoopMusic
@synthesize bpm = bpm_;
@synthesize loops = loops_;
@synthesize measure = measure_;
@synthesize title = title_;
@synthesize nextMeasure = nextMeasure_;
@synthesize score = score_;

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
    player_ = [[LoopPlayer alloc] initWithFileFormat:file_];
    [self preLoadMusic:file_];
    [self preLoadEffects:file_];
  }
  return self;
}

- (void)play {
  [player_ play];
  [[CCScheduler sharedScheduler] scheduleSelector:@selector(tick:) 
                                        forTarget:self interval:60.0 / self.bpm
                                           paused:NO];
  [self tick:0];
}

- (void)setCallbackOnTick:(id)delegate selector:(SEL)selector {
  /*
   特定のmeasureに到達したときに呼ばれるコールバックを登録します
   前回に登録されたコールバックは上書きされます。
   */
  delegate_ = delegate;
  selector_ = selector;
}

- (void)changeLoopMusic:(NSInteger)number {
  [player_ setLoopMusicNumber:number];
}

- (void)preLoadMusic:(NSString *)file {
  for (int i = 0; i < loops_; ++i) {
    [[OALSimpleAudio sharedInstance] preloadBg:[NSString stringWithFormat:file, i]];
  }
}

- (void)preLoadEffects:(NSString *)file {
  for (int i = 1; i <= 2; ++i) {
    [[OALSimpleAudio sharedInstance] preloadEffect:[NSString stringWithFormat:@"%d.caf", i]];
  }
}

- (void)tick:(ccTime)dt {
  measure_ = nextMeasure_;
  nextMeasure_ = measure_ + 1;
  #pragma clang diagnostic push
  #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
  [delegate_ performSelector:selector_];
  #pragma clang diagnostic pop
}

@end