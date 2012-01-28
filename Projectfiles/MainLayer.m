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
- (void)onClear;
- (void)onGameEnd;
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
    score_ = 0;
    isWating_ = NO;
    isLevelUp_ = NO;
    currentMeasure_ = 0;
    score_ = 0;
    
    MotionDetector* detector = [MotionDetector shared];
    [detector setOnDetection:self selector:@selector(detectMotion:)];
    manager_ = [[LoopMusic alloc] initWithMusicID:1];
    OALSimpleAudio* sa =[OALSimpleAudio sharedInstance];
    for (NSString* file in [NSArray arrayWithObjects:@"bell.caf", @"invalid0.caf", @"invalid1.caf", @"valid.caf", nil]) {
      [sa preloadEffect:file];
    }
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
                                              fontSize:288];
  readyLabel.scale = 0;
  readyLabel.position = [CCDirector sharedDirector].screenCenter;
  id expand = [CCScaleTo actionWithDuration:0.25f scale:1.0];
  id delay = [CCDelayTime actionWithDuration:1.0];
  id fadeout = [CCFadeOut actionWithDuration:0.25f];
  __weak MainLayer* layer = self;
  id start = [CCCallBlockN actionWithBlock:^(CCNode* node){
    [layer onStart];
    [layer removeChild:node cleanup:YES];
  }];
  [readyLabel runAction:[CCSequence actions:expand, delay, fadeout, start, nil]];
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
    [[OALSimpleAudio sharedInstance] playEffect:@"valid.caf"];
    score_ += 5000;
    ++currentLevel_;
  } else if (currentMeasure_ != 0) {
    [[OALSimpleAudio sharedInstance] playEffect:@"invalid1.caf"];
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

- (void)onClear {
  [[[OALSimpleAudio sharedInstance] backgroundTrack] fadeTo:0 
                                                   duration:1.5f 
                                                     target:self 
                                                   selector:@selector(onGameEnd)];
}

- (void)onGameEnd {
  CCLayer* layer = [[ResultLayer alloc] initWithScore:score_];
  CCScene* scene = [[CCScene alloc] init];
  [scene addChild:layer];
  CCTransitionFade* transition = [CCTransitionFade transitionWithDuration:0.5f 
                                                                    scene:scene];
  [[CCDirector sharedDirector] replaceScene:transition];
}

- (void)onExit {
  [manager_ stop];
}

- (void)onTick {
  MotionType type = [manager_.score motionTypeOnMeasure:manager_.measure];
  if (state_ == GameStateExample) {
    if (manager_.measure % PART_LENGTH == PART_LENGTH - 1) {
      [self onPlayPart];
    } else if (manager_.measure % PART_LENGTH == PART_LENGTH - 2) {
      [[OALSimpleAudio sharedInstance] playEffect:@"bell.caf"];
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
    currentMeasure_ += PART_LENGTH;
    if (manager_.measure % PART_LENGTH == PART_LENGTH - 1) {
      if (currentMeasure_ <= manager_.score.scoreLength) {
        [self onExamplePart];
      } else {
        // クリア
        [self onClear];
      }
    }
  }
}

- (void)beginWaiting:(ccTime *)dt {
  isWating_ = YES;
  [self unschedule:@selector(beginWaiting:)];
}

- (void)endWaiting:(ccTime *)dt {
  if (isWating_) {
    [self onFail];
  }
  isWating_ = NO;
  [self unschedule:@selector(endWaiting:)];
}

- (void)detectMotion:(Motion *)motion {
  if (state_ == GameStatePlay && isWating_ && motion.motionType) {
    if (correctMotionType_ == motion.motionType) {
      // 正しい入力をしたとき
      score_ += pow(1000, currentLevel_); // 入力のズレから決めたい 
      [[OALSimpleAudio sharedInstance] playEffect:[NSString stringWithFormat:@"%d.caf", motion.motionType]];
      isWating_ = NO;
    } else if (motion.motionType != MotionTypeNone) {
      // 間違った入力をしたとき
      [self onFail];
    }
  }
}

- (void)onFail {
  // 間違ったとき
  [[OALSimpleAudio sharedInstance] playEffect:@"invalid0.caf"];
  isWating_ = NO;
  isLevelUp_ = NO;
  manager_.player.loopMusicNumber = 0;
}

@end
