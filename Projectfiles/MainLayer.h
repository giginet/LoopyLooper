//
//  MainLayer.h
//  LoopyLooper
//
//  Created by  on 1/28/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "KWLayer.h"
#import "LoopManager.h"

typedef enum {
  GameStateReady,
  GameStateExample,
  GameStatePlay,
  GameStateGameOver
} GameState;

@interface MainLayer : KWLayer {
  int currentMeasure_;
  GameState state_;
  CCLabelTTF* label_;
  LoopManager* manager_;
}
@end
