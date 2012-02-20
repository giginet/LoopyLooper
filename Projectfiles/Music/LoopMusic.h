//
//  LoopManager.h
//  LoopyLooper
//
//  Created by  on 1/28/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "heqet.h"
#import "Score.h"

@interface LoopMusic : NSObject <AVAudioPlayerDelegate> {
  int bpm_;
  int loop_;
  int nextLoop_;
  int loops_;
  int measure_;
  int nextMeasure_;
  BOOL isEndOfLoop_;
  id delegate_;
  SEL selector_;
  NSString* title_;
  NSString* file_;
  Score* score_;
  OALAudioTrack* track_;
  NSMutableArray* tracks_;
}

@property(readonly) int bpm;
@property(readonly) int loops;
@property(readonly) int measure;
@property(readonly) NSTimeInterval currentTime;
@property(readonly) NSTimeInterval duration;
@property(readwrite) int nextMeasure;
@property(readonly, copy) NSString* title;
@property(readonly) Score* score;
@property(readonly) OALAudioTrack* track;
@property(readonly) NSArray* tracks;

- (id)initWithMusicID:(int)musicID;
- (void)play;
- (void)pause;
- (void)stop;
- (void)setCallbackOnBeat:(id)delegate selector:(SEL)selector;
- (void)changeLoop:(NSInteger)number;

@end
