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
    audioTracks_ = [NSMutableArray array];
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
    currentTrack_ = (OALAudioTrack*)[audioTracks_ objectAtIndex:0];
  }
  return self;
}

- (void)play {
  double fps = [[KKStartupConfig config] maxFrameRate];
  [(OALAudioTrack*)[audioTracks_ objectAtIndex:0] play];
  [[CCScheduler sharedScheduler] scheduleSelector:@selector(tick:) 
                                        forTarget:self 
                                         interval:1.0 / fps
                                           paused:NO];
  [self tick:0];
}

- (void)stop {
  [(OALAudioTrack*)[audioTracks_ objectAtIndex:loop_] stop];
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
  OALAudioTrack* currentTrack = [audioTracks_ objectAtIndex:loop_];
  OALAudioTrack* nextTrack = [audioTracks_ objectAtIndex:number];
  currentTrack.numberOfLoops = 0;
  nextTrack.numberOfLoops = -1;
  NSTimeInterval deviceTime = currentTrack.deviceCurrentTime;
  NSTimeInterval trackTimeRemaining = currentTrack.duration - currentTrack.currentTime;
  [nextTrack playAtTime:deviceTime + trackTimeRemaining];
  nextLoop_ = number;
}

- (void)preLoadMusic:(NSString *)file {
  for (int i = 0; i < loops_; ++i) {
    NSString* filename = [NSString stringWithFormat:file, i];
    OALAudioTrack* track = [OALAudioTrack track];
    [track preloadFile:filename];
    track.autoPreload = YES;
    track.numberOfLoops = -1;
    track.delegate = self;
    [audioTracks_ addObject:track];
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
  currentTrack_ = [audioTracks_ objectAtIndex:nextLoop_];
  loop_ = nextLoop_;
}

- (OALAudioTrack*)track {
  return currentTrack_;
}

- (NSTimeInterval)currentTime {
  return self.track.currentTime;
}

- (NSTimeInterval)duration {
  return self.track.duration;
}

@end