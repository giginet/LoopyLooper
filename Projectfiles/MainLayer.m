//
//  MainLayer.m
//  LoopyLooper
//
//  Created by  on 1/28/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "MainLayer.h"
#import "ResultLayer.h"
#import "MotionDetector.h"
#import "Motion.h"
#import "LoopMusic.h"
#define PART_LENGTH 16

@interface MainLayer()
- (void)onReady;
- (void)onStart;
- (void)onExamplePart;
- (void)onPlayPart;
- (void)onGameOver;
- (void)onTick;
- (void)beginWaiting:(ccTime*)dt;
- (void)endWaiting:(ccTime*)dt;
- (void)detectMotion:(Motion*)motion;
- (void)onFail;
@end

@implementation MainLayer

- (id)init {
  self = [super init];
  if (self) {
    self.isTouchEnabled = YES;
    currentLevel_ = 1;
    isWating_ = NO;
    isLevelUp_ = NO;
    currentMeasure_ = 0;
    CCDirector* director = [CCDirector sharedDirector];
    
    [CCMenuItemFont setFontName:@"Helvetica"];
    [CCMenuItemFont setFontSize:40];
    
    CCMenuItem* result = [CCMenuItemFont itemFromString:@"Result" 
                                                  block:^(id sender){
                                                    CCScene* scene = [ResultLayer nodeWithScene];
                                                    CCTransitionFade* transition = [CCTransitionFade transitionWithDuration:0.5f 
                                                                                                                      scene:scene];
                                                    [[CCDirector sharedDirector] replaceScene:transition];
                                                  }];
    
    CCMenu* menu = [CCMenu menuWithItems:result, nil];
    menu.position = director.screenCenter;
    menu.tag = 100;
    [self addChild:menu];
    
    [menu alignItemsVerticallyWithPadding:40];
    
    MotionDetector* detector = [MotionDetector shared];
    [detector setOnDetection:self selector:@selector(detectMotion:)];
    manager_ = [[LoopMusic alloc] initWithMusicID:1];
  }
  return self;
}

- (void)onEnterTransitionDidFinish {
  [self onReady];
}

- (void)update:(ccTime)dt {
}

- (void)onReady {
  state_ = GameStateReady;
  CCLabelTTF* readyLabel = [CCLabelTTF labelWithString:@"Ready" 
                                              fontName:@"Helvetica" 
                                              fontSize:24];
  readyLabel.scale = 0;
  readyLabel.position = [CCDirector sharedDirector].screenCenter;
  id expand = [CCScaleTo actionWithDuration:0.5 scale:1.0];
  id delay = [CCDelayTime actionWithDuration:1.0];
  __weak MainLayer* layer = self;
  id go = [CCCallBlockN actionWithBlock:^(CCNode* node){
    [layer onStart];
    [layer removeChild:node cleanup:YES];
  }];
  [readyLabel runAction:[CCSequence actions:expand, delay, go, nil]];
  [self addChild:readyLabel];
}

- (void)onStart {
  [manager_ play];
  currentMeasure_ = 0;
  [self onExamplePart];
}

- (void)onExamplePart {
  state_ = GameStateExample;
  if (isLevelUp_) {
    NSLog(@"LevelUp");
    ++currentLevel_;
  }
  [manager_ setCallbackOnTick:self selector:@selector(onTick)];
  manager_.player.loopMusicNumber = currentLevel_ - 1;
}

- (void)onPlayPart {
  isLevelUp_ = YES;
  state_ = GameStatePlay;
  manager_.nextMeasure = currentMeasure_;
  [manager_ setCallbackOnTick:self selector:@selector(onTick)];
}

- (void)onGameOver {
  state_ = GameStateGameOver;
}

- (void)onTick {
  MotionType type = [manager_.score motionTypeOnMeasure:manager_.measure];
  if (state_ == GameStateExample) {
    if (manager_.measure % PART_LENGTH == PART_LENGTH - 1) {
      [self onPlayPart];
    }
    if (type != 0) {
      [[OALSimpleAudio sharedInstance] playEffect:[NSString stringWithFormat:@"%d.caf", type]];
    }
  } else if (state_ == GameStatePlay) {
    MotionType nextType = [manager_.score motionTypeOnMeasure:manager_.measure + 1];
    if (nextType != MotionTypeNone) {
      correctMotionType_ = nextType;
      [self schedule:@selector(beginWaiting:) interval:60.0 / manager_.bpm - 0.2];
      [self schedule:@selector(endWaiting:) interval:60.0 / manager_.bpm + 0.2];
    }
    if (manager_.measure % PART_LENGTH == PART_LENGTH - 1) {
      currentMeasure_ += PART_LENGTH;
      [self onExamplePart];
    }
  }
}

- (void)beginWaiting:(ccTime *)dt {
  isWating_ = YES;
  [self unschedule:@selector(beginWaiting:)];
}

- (void)endWaiting:(ccTime *)dt {
  if (isWating_) {
    NSLog(@"時間切れ!");
    [self onFail];
  }
  isWating_ = NO;
  [self unschedule:@selector(endWaiting:)];
}

- (void)detectMotion:(Motion *)motion {
  if (state_ == GameStatePlay && isWating_ && motion.motionType) {
    if (correctMotionType_ == motion.motionType) {
      // 正しい入力をしたとき
      NSLog(@"正解!");
      isWating_ = NO;
    } else if (motion.motionType != MotionTypeNone) {
      // 間違った入力をしたとき
      NSLog(@"まちがい！");
      [self onFail];
    }
  }
}

- (void)onFail {
  // 間違ったとき
  isWating_ = NO;
  //isLevelUp_ = NO;
  //manager_.player.loopMusicNumber = 0;
}

@end
