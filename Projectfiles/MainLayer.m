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
#import "SeekBar.h"
#define PART_LENGTH 16
#define FUZZY_TIME 0.15

@interface MainLayer()
- (void)onReady;
- (void)onStart;
- (void)onExamplePart;
- (void)onPlayPart;
- (void)onGameOver;
- (void)onClear;
- (void)onGameEnd;
- (void)onBeat;
- (void)changeState:(GameState)state;
- (void)beginWaiting:(ccTime*)dt;
- (void)endWaiting:(ccTime*)dt;
- (void)detectMotion:(Motion*)motion;
- (void)onFail;
@end

@implementation MainLayer
@synthesize music = music_;

- (id)initWithMusicID:(NSInteger)musicID {
  /**
   * 音楽IDを渡して初期化します
   * @args NSInteger musicID
   */
  self = [super init];
  if (self) {
    self.isTouchEnabled = YES;
    currentLevel_ = 1;
    isWating_ = NO;
    isLevelUp_ = NO;
    score_ = 0;
    
    MotionDetector* detector = [MotionDetector shared];
    [detector setOnDetection:self selector:@selector(detectMotion:)];
    music_ = [[LoopMusic alloc] initWithMusicID:1];
    OALSimpleAudio* sa =[OALSimpleAudio sharedInstance];
    for (NSString* file in [NSArray arrayWithObjects:@"bell.caf", 
                            @"invalid0.caf", 
                            @"invalid1.caf", 
                            @"valid.caf", nil]) {
      [sa preloadEffect:file];
    }
    
    bar_ = [SeekBar seekBarWithMusic:self.music measure:0];
    [self addChild:bar_];
    bar_.position = ccp([CCDirector sharedDirector].screenCenter.x, 150);
  }
  return self;
}

- (id)init {
  self = [self initWithMusicID:1];
  return self;
}

- (void)onEnterTransitionDidFinish {
  [self onReady];
}

- (void)update:(ccTime)dt {
  bar_.time = self.music.track.currentTime;
}

- (void)onReady {
  /**
   * 画面表示後に呼ばれます
   */
  state_ = GameStateReady;
  CCSprite* readyLabel = [CCSprite spriteWithFile:@"ready.png"];
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
  /*
   * ゲーム開始時に呼ばれます
   *
   */
  [self.music play];
  [bar_ play];
  currentMeasure_ = 0;
  [self onExamplePart];
}

- (void)onExamplePart {
  state_ = GameStateExample;
  if (isLevelUp_) {
    [[OALSimpleAudio sharedInstance] playEffect:@"valid.caf"];
    score_ += 5000;
    if (currentLevel_ < self.music.loops) {
      NSLog(@"LevelUp");
      ++currentLevel_;
      [self.music changeLoop:currentLevel_ - 1];
    }
  } else if (currentMeasure_ != 0) {
    [[OALSimpleAudio sharedInstance] playEffect:@"invalid1.caf"];
  }
  [self.music setCallbackOnBeat:self selector:@selector(onBeat)];
}

- (void)onPlayPart {
  isLevelUp_ = YES;
  state_ = GameStatePlay;
  self.music.nextMeasure = currentMeasure_;
  [self.music setCallbackOnBeat:self selector:@selector(onBeat)];
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
  [self.music stop];
}

- (void)onBeat {
  if (self.music.measure % PART_LENGTH == PART_LENGTH - 1) {
    GameState nextState = state_ == GameStatePlay ? GameStateExample : GameStatePlay;
    [self changeState:nextState];
    return;
  }
  MotionType type = [self.music.score motionTypeOnMeasure:self.music.measure];
  if (state_ == GameStateExample) {
    if (self.music.measure % PART_LENGTH == PART_LENGTH - 2) {
      [[OALSimpleAudio sharedInstance] playEffect:@"bell.caf"];
    }
    if (type != 0) {
      [[OALSimpleAudio sharedInstance] playEffect:[NSString stringWithFormat:@"%d.caf", type]];
      // チュートリアル出す
      int frames[] = {0, 1, 1, 2, 2, 2, 0, 0};
      CCAnimation* animation = [CCAnimation animationWithFiles:[NSString stringWithFormat:@"t%d_", type] frameCount:frames[type] delay:0.1f];
      CCSprite* tutorial = [CCSprite spriteWithFile:[NSString stringWithFormat:@"t%d_0.png", type]];
      __weak CCLayer* layer = self;
      [tutorial runAction:[CCSequence actions:
                           [CCFadeIn actionWithDuration:0.25], 
                           [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:animation] times:2], 
                           [CCFadeOut actionWithDuration:0.25], 
                           [CCCallBlockN actionWithBlock:^(CCNode* n){
        [layer removeChild:n cleanup:YES];
      }], 
                           nil]];
      CGPoint center = [[CCDirector sharedDirector] screenCenter];
      tutorial.position = ccp(center.x, center.y + 50);
      [self addChild:tutorial];
    }
  } else if (state_ == GameStatePlay) {
    MotionType nextType = [self.music.score motionTypeOnMeasure:self.music.measure + 1];
    if (nextType != MotionTypeNone) {
      correctMotionType_ = nextType;
      inputTime_ = self.music.track.currentTime + 60.0 / self.music.bpm;
      [self schedule:@selector(beginWaiting:) interval:60.0 / self.music.bpm - FUZZY_TIME];
      [self schedule:@selector(endWaiting:) interval:60.0 / self.music.bpm + FUZZY_TIME];
    }
    if (self.music.measure % PART_LENGTH == PART_LENGTH - 1) {
      
    }
  }
}

- (void)changeState:(GameState)state {
  state_ = state;
  if (state == GameStateExample) {
    [bar_ reset];
    currentMeasure_ += PART_LENGTH;
    [bar_ reloadBarFrom:currentMeasure_];
    if (currentMeasure_ < self.music.score.scoreLength) {
      [self onExamplePart];
    } else {
      [self onClear];
    }
  } else if (state == GameStatePlay) {
    [bar_ reset];
    [self onPlayPart];
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
      double sub = (inputTime_ - self.music.track.currentTime);
      if (sub > FUZZY_TIME) sub = FUZZY_TIME;
      score_ += 500 * pow(2, currentLevel_) * ((FUZZY_TIME * 2) - sub) / (FUZZY_TIME * 2);
      [[OALSimpleAudio sharedInstance] playEffect:[NSString stringWithFormat:@"%d.caf", motion.motionType]];
      isWating_ = NO;
    } else if (motion.motionType != MotionTypeNone) {
      // 間違った入力をしたとき
      NSLog(@"%d", motion.motionType); 
      [self onFail];
    }
  }
}

- (void)onFail {
  // 間違ったとき
  [[OALSimpleAudio sharedInstance] playEffect:@"invalid0.caf"];
  isWating_ = NO;
  isLevelUp_ = NO;
  if (currentLevel_ != 1) {
    currentLevel_ = 1;
    [self.music changeLoop:currentLevel_ - 1];
  }
}

@end
