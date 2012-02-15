//
//  LoopManager.m
//  LoopyLooper
//
//  Created by  on 1/28/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "LoopMusic.h"
#import "Motion.h"

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
@dynamic track;
@dynamic currentTime;
@dynamic duration;

- (id)init {
  self = [super init];
  if (self) {
    bpm_ = 0;
    loop_ = 0;
    loops_ = 0;
    measure_ = 0;
    nextMeasure_ = 1;
    title_ = @"";
    isEndOfLoop_ = NO;
    [OALSimpleAudio sharedInstance].bgVolume = 1.0;
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
    OALSimpleAudio* sa = [OALSimpleAudio sharedInstance];
    sa.backgroundTrack.delegate = self;
    sa.backgroundTrack.meteringEnabled = YES;
  }
  return self;
}

- (void)play {
  double fps = [[KKStartupConfig config] maxFrameRate];
  [[OALSimpleAudio sharedInstance] playBg:[NSString stringWithFormat:file_, loop_] loop:YES];
  [[CCScheduler sharedScheduler] scheduleSelector:@selector(tick:) 
                                        forTarget:self 
                                         interval:1.0 / fps
                                           paused:NO];
  [self tick:0];
}

- (void)stop {
  [[OALSimpleAudio sharedInstance] stopBg];
  [[CCScheduler sharedScheduler] unscheduleSelector:@selector(tick:) 
                                          forTarget:self];
}

- (void)setCallbackOnBeat:(id)delegate selector:(SEL)selector {
  /*
   特定のmeasureに到達したときに呼ばれるコールバックを登録します
   前回に登録されたコールバックは上書きされます。
   */
  delegate_ = delegate;
  selector_ = selector;
}

- (void)changeLoop:(NSInteger)number {
  if (loop_ == number) return;
  loop_ = number;
  OALSimpleAudio* sa = [OALSimpleAudio sharedInstance];
  sa.backgroundTrack.numberOfLoops = 0;
}

- (void)preLoadMusic:(NSString *)file {
  for (int i = 0; i < loops_; ++i) {
    [[OALSimpleAudio sharedInstance] preloadBg:[NSString stringWithFormat:file, i]];
  }
}

- (void)preLoadEffects:(NSString *)file {
  for (int i = 1; i <= 5; ++i) {
    [[OALSimpleAudio sharedInstance] preloadEffect:[NSString stringWithFormat:@"%d.caf", i]];
  }
}

- (void)tick:(ccTime)dt {
  if (self.currentTime < 15 * 60.0 / self.bpm) isEndOfLoop_ = NO;
  if (self.currentTime >= nextMeasure_ % 16 * 60.0 / self.bpm && !isEndOfLoop_) {
    if (nextMeasure_ % 16 == 16 - 1) isEndOfLoop_ = YES;
    measure_ = nextMeasure_;
    nextMeasure_ = measure_ + 1;
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [delegate_ performSelector:selector_];
    #pragma clang diagnostic pop
  }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
  id delegate = self.track.delegate;
  [[OALSimpleAudio sharedInstance] playBg:[NSString stringWithFormat:file_, loop_] loop:YES];
  self.track.delegate = delegate;
  NSLog(@"change Loop");
}

- (OALAudioTrack*)track {
  return [OALSimpleAudio sharedInstance].backgroundTrack;
}

- (NSTimeInterval)currentTime {
  return self.track.currentTime;
}

- (NSTimeInterval)duration {
  return self.track.duration;
}

@end