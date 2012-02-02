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

typedef enum {
  GameStateReady,
  GameStateExample,
  GameStatePlay,
  GameStateGameOver
} GameState;

@interface MainLayer : KWLayer {
  int currentMeasure_;
  int currentLevel_;
  int score_;
  BOOL isLevelUp_;
  BOOL isWating_;
  MotionType correctMotionType_;
  GameState state_;
  LoopMusic* music_;
  SeekBar* bar_;
}

@end
