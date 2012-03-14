//
//  MainLayer.h
//  LoopyLooper
//
//  Created by  on 1/28/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "KWLayer.h"
#import "LoopMusic.h"
#import "SeekBar.h"
#import "StatusBar.h"
#import "difficulty.h"

typedef enum {
  GameStateReady,
  GameStateExample,
  GameStatePlay,
  GameStateGameOver,
  GameStateClear
} GameState;

@interface MainLayer : KWLayer {
  int startBeat_;
  int currentBeat_;
  int currentLevel_;
  int score_;
  double life_;
  BOOL isLevelUp_;
  BOOL isPerfect_;
  BOOL isInputed_;
  NSTimeInterval prevTime_;
  GameState state_;
  LoopMusic* music_;
  SeekBar* bar_;
  StatusBar* status_;
}

@property(readonly, strong) LoopMusic* music;
@property(readwrite, strong) CCParticleSystemQuad* background;

- (id)initWithMusicID:(NSInteger)musicID dificulty:(Difficulty)dificulty;
- (void)pause;
- (void)resume;

@end
