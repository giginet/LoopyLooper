//
//  LoopManager.h
//  LoopyLooper
//
//  Created by  on 1/28/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "heqet.h"
#import "Score.h"

@interface LoopManager : NSObject {
  int bpm_;
  int loops_;
  int measure_;
  int nextMeasure_;
  id delegate_;
  SEL selector_;
  int onMeasure_;
  NSString* title_;
  NSString* file_;
  Score* score_;
}

@property(readonly) int bpm;
@property(readonly) int loops;
@property(readonly) int measure;
@property(readwrite) int nextMeasure;
@property(readonly, copy) NSString* title;

- (id)initWithMusicID:(int)musicID;
- (void)play;
- (void)setCallbackOnMeasure:(int)measure delegate: (id)delegate selector:(SEL)selector;

@end
