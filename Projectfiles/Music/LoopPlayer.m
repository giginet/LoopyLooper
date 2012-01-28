//
//  Looper.m
//  LoopyLooper
//
//  Created by on 12/01/28.
//  Copyright (c) 2012 All rights reserved.
//

#import "LoopPlayer.h"
#import "OALSimpleAudio.h"

@implementation LoopPlayer
@synthesize loopMusicNumber = loopMusicNumber_;

- (id)initWithFileFormat:(NSString *)format {
  self = [super init];
  if (self) {
    loopMusicNumber_ = 0;
    pathFormat_ = format;
    manager_ = [OALSimpleAudio sharedInstance];
    manager_.backgroundTrack.delegate = self;
    nextTrack_ = [OALAudioTrack track];
    [manager_ preloadEffect:[NSString stringWithFormat: pathFormat_, loopMusicNumber_]];
    [manager_ preloadEffect:[NSString stringWithFormat: pathFormat_, loopMusicNumber_ + 1]];
  }
  return self;
}

- (void)play {
  [manager_ playBg:[NSString stringWithFormat: pathFormat_, loopMusicNumber_] loop:YES];
}

- (NSInteger)loopMusicNumber {
  return loopMusicNumber_;
}

- (void)setLoopMusicNumber:(NSInteger)loopMusicNumber {
  loopMusicNumber_ = loopMusicNumber;
}

@end
