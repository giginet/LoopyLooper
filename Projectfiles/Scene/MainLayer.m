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
#import "CutIn.h"
#import "SaveManager.h"
#import "PauseLayer.h"

#define PART_LENGTH 16
#define FUZZY_TIME 0.15
#define MAX_LIFE 1000

@interface MainLayer()
- (void)onReady;
- (void)onStart;
- (void)onExamplePart;
- (void)onPlayPart;
- (void)onGameOver;
- (void)onClear;
- (void)onGameEnd;
- (void)addMenuLayer;
- (void)onBeat;
- (void)changeState:(GameState)state;
- (void)detectMotion:(Motion*)motion;
- (void)onFail;
- (void)setLevel:(int)level;
- (void)addMotionLabel:(NSString*)filename beat:(int)beat;
@end

/*
 * 命名規則として
 *  Tick 1/fps秒のことを指す
 *  Measure 1小節のことを指す。1/bpm秒
 *  Beat 1拍のことをさす、Measureが区間を表しているのに対し、Beatは1点を表す
 */

@implementation MainLayer
@synthesize music = music_;
@synthesize background;

- (id)initWithMusicID:(NSInteger)musicID dificulty:(Difficulty)dificulty {
  /**
   * 音楽IDを渡して初期化します
   * @args NSInteger musicID
   */
  self.backgroundColor = ccc4(255, 255, 255, 255);
  self = [super init];
  if (self) {
    self.isTouchEnabled = YES;
    currentLevel_ = 1;
    isInputed_ = NO;
    isLevelUp_ = NO;
    isPerfect_ = NO;
    CCDirector* director = [CCDirector sharedDirector];
    score_ = 0;
    prevTime_ = 0;
    life_ = MAX_LIFE / 2;
    MotionDetector* detector = [MotionDetector shared];
    [detector setOnDetection:self selector:@selector(detectMotion:)];
    music_ = [[LoopMusic alloc] initWithMusicID:musicID difficulty:dificulty];
    OALSimpleAudio* sa =[OALSimpleAudio sharedInstance];
    for (NSString* file in [NSArray arrayWithObjects:@"bell.caf", 
                            @"invalid0.caf", 
                            @"invalid1.caf", 
                            @"valid.caf", nil]) {
      [sa preloadEffect:file];
    }
    background = [CCParticleSystemQuad particleWithFile:@"background.plist"];
    background.position = director.screenCenter;
    [self addChild:background];
    
    bar_ = [SeekBar seekBarWithMusic:self.music measure:0];
    [self addChild:bar_];
    bar_.position = ccp([CCDirector sharedDirector].screenCenter.x, 150);
    status_ = [StatusBar spriteWithFile:@"status.png"];
    status_.position = ccp(512, director.screenSize.height - status_.contentSize.height / 2);
    [self addChild:status_];
    self.isTouchEnabled = YES;
  }
  return self;
}

- (id)init {
  self = [self initWithMusicID:1 dificulty:DifficultyEasy];
  return self;
}

- (void)onEnterTransitionDidFinish {
  [self onReady];
  NSLog(@"maxScore = %d", [self.music.score maxScore]);
  [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)onReady {
  /**
   * 画面表示後に呼ばれます
   */
  state_ = GameStateReady;
  CCSprite* readyLabel = [CCSprite spriteWithFile:@"ready.png"];
  readyLabel.scale = 0;
  readyLabel.position = [CCDirector sharedDirector].screenCenter;
  id expand = [CCScaleTo actionWithDuration:0.1f scale:1.0];
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
   */
  CCSprite* goLabel = [CCSprite spriteWithFile:@"go.png"];
  goLabel.scale = 0;
  goLabel.position = [CCDirector sharedDirector].screenCenter;
  id expand = [CCScaleTo actionWithDuration:0.25f scale:1.0];
  id delay = [CCDelayTime actionWithDuration:0.5f];
  id fadeout = [CCFadeOut actionWithDuration:0.25f];
  __weak MainLayer* layer = self;
  id suicide = [CCCallBlockN actionWithBlock:^(CCNode* node){
    [layer removeChild:node cleanup:YES];
  }];
  [goLabel runAction:[CCSequence actions:expand, delay, fadeout, suicide, nil]];
  [self addChild:goLabel];
  
  [self.music play];
  [bar_ play];
  startBeat_ = 0;
  currentBeat_ = startBeat_;
  [self onExamplePart];
  [self.music setCallbackOnBeat:self selector:@selector(onBeat)];
  [status_.scoreLabel play];
}

- (void)onExamplePart {
  state_ = GameStateExample;
  if (isPerfect_) {
    [[OALSimpleAudio sharedInstance] playEffect:@"valid.caf"];
    score_ += 5000;
  } else if (startBeat_ != 0) {
    [[OALSimpleAudio sharedInstance] playEffect:@"invalid1.caf"];
  }
}

- (void)onPlayPart {
  isLevelUp_ = YES;
  isPerfect_ = YES;
  state_ = GameStatePlay;
  self.music.nextMeasure = startBeat_ + 1;
}

- (void)onGameOver {
  state_ = GameStateGameOver;
  [self.music stop];
  [OALSimpleAudio sharedInstance].backgroundTrack.volume = 1.0;
  [[OALSimpleAudio sharedInstance] playBg:@"Gameover.caf" loop:true];
  background.duration = 0;
  CCSprite* gameoverLabel = [CCSprite spriteWithFile:@"gameover.png"];
  gameoverLabel.scale = 0;
  gameoverLabel.position = [CCDirector sharedDirector].screenCenter;
  id expand = [CCScaleTo actionWithDuration:0.25f scale:1.0];
  [gameoverLabel runAction:[CCSequence actions:expand, nil]];
  [self addChild:gameoverLabel];

  [self runAction:[CCSequence actions:
                   [CCDelayTime actionWithDuration:4.0],
                   [CCCallFunc actionWithTarget:self selector:@selector(addMenuLayer)]
                   , nil]];
}

- (void)onClear {
  state_ = GameStateClear;
  for(OALAudioTrack* track in self.music.tracks) {
    [track fadeTo:0 
         duration:3.0f 
           target:self 
         selector:@selector(onGameEnd)];
  }
  CCSprite* clearLabel = [CCSprite spriteWithFile:@"finish.png"];
  clearLabel.scale = 0;
  clearLabel.position = [CCDirector sharedDirector].screenCenter;
  id expand = [CCScaleTo actionWithDuration:0.25f scale:1.0];
  [clearLabel runAction:[CCSequence actions:expand, nil]];
  [self addChild:clearLabel];
}

- (void)onGameEnd {
  [OALSimpleAudio sharedInstance].backgroundTrack.volume = 1.0;
  [[OALSimpleAudio sharedInstance] playBg:@"Result.caf" loop:true];
  [self addMenuLayer];
  [self.music stop];
}

- (void)addMenuLayer {
  ResultLayer* layer = [[ResultLayer alloc] initWithScore:score_];
  layer.music = self.music;
  [self addChild:layer];
  [self.music stop];
  [[SaveManager shared] setHighScore:self.music.musicID difficulty:self.music.difficulty score:score_];
}

- (void)onExit {
  [super onExit];
  [self.music stop];
  [UIApplication sharedApplication].idleTimerDisabled = NO;
}

- (void)onBeat {
  /*
   * Beatを打つ度に呼ばれます
   * self.music.measureとかで何拍目か取れます
   */
  MotionType type = [self.music.score motionTypeOnBeat:self.music.measure];
  if (state_ == GameStateExample) {
    if (self.music.measure % PART_LENGTH == PART_LENGTH - 2) {
      [[OALSimpleAudio sharedInstance] playEffect:@"bell.caf"];
    }
    if (type != 0) {
      [[OALSimpleAudio sharedInstance] playEffect:[NSString stringWithFormat:@"%d.caf", type]];
      // チュートリアル出す
      int frames[] = {0, 1, 1, 2, 1, 1, 0, 0};
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
  }
  if (state_ != GameStateClear && startBeat_ >= self.music.score.scoreLength) {
    [self onClear];
  }
}

- (void)changeState:(GameState)state {
  if (state == GameStateExample) {
    [bar_ reset];
    startBeat_ += PART_LENGTH;
    [bar_ reloadBarFrom:startBeat_];
    [self onExamplePart];
  } else if (state == GameStatePlay) {
    [bar_ reset];
    [self onPlayPart];
  }
  state_ = state;
}

- (void)update:(ccTime)dt {
  ccTime currentTime = self.music.currentTime;
  ccTime beatDuration = self.music.duration / PART_LENGTH;
  bar_.time = currentTime;
  int prevBeat = currentBeat_;
  currentBeat_ = round(currentTime / beatDuration) + startBeat_;
  if (prevTime_ > currentTime && currentTime >= 0 && currentTime < 1 && prevTime_ > self.music.duration - 1) {
    GameState nextState = state_ == GameStatePlay ? GameStateExample : GameStatePlay;
    [self changeState:nextState];
  }
  if (state_ == GameStatePlay && currentBeat_ > prevBeat) {
    MotionType prevCorrectMotionType = [self.music.score motionTypeOnBeat:prevBeat];
    if (!isInputed_ && prevCorrectMotionType != MotionTypeNone) {
      // 入力し損ねたとき
      life_ -= 100 * ((int)self.music.difficulty + 1);
      [self addMotionLabel:@"miss.png" beat:currentBeat_ - startBeat_ - 1];
      [self onFail];
    } else if (currentBeat_ - startBeat_ == PART_LENGTH && isLevelUp_ && isPerfect_) {
      CutIn* cutin = [[CutIn alloc] initWithFace:@"cut_in_boss1.png" background:@"cutin.plist"];
      cutin.position = ccp(0, [CCDirector sharedDirector].screenCenter.y);
      [self addChild:cutin];
      if (currentLevel_ < self.music.loops) {
        [self setLevel:currentLevel_ + 1];
      }
    }
    isInputed_ = NO;
  }
  if (state_ != GameStateGameOver) {
    prevTime_ = currentTime;
    if(life_ >= MAX_LIFE) {
      life_ = MAX_LIFE;
    } else if (life_ <= 0){
      [self onGameOver];
    }
  }
  status_.lifeGauge.rate = (double)life_ / (double)MAX_LIFE;
}

- (void)detectMotion:(Motion *)motion {
  if (state_ == GameStatePlay) {
    ccTime currentTime = self.music.currentTime;
    ccTime beatDuration = self.music.duration / PART_LENGTH;
    ccTime minTime = (currentBeat_ - startBeat_) * beatDuration - FUZZY_TIME;
    ccTime maxTime = (currentBeat_ - startBeat_) * beatDuration + FUZZY_TIME;
    MotionType correctMotionType = [self.music.score motionTypeOnBeat:currentBeat_];
    if (motion.motionType != MotionTypeNone && minTime <= currentTime && currentTime <= maxTime && !isInputed_) {
      if (correctMotionType == motion.motionType) {
        // 正しい入力をしたとき
        double sub = (beatDuration * (currentBeat_ - startBeat_) - currentTime);
        if(sub < 0) sub *= -1;
        if(sub > FUZZY_TIME) sub = FUZZY_TIME;
        score_ += BASE_SCORE * pow(2, currentLevel_) * ((FUZZY_TIME * 2) - sub) / (FUZZY_TIME * 2);
        life_ += 50 * ((FUZZY_TIME * 2) - sub) / (FUZZY_TIME * 2);
        [[OALSimpleAudio sharedInstance] playEffect:[NSString stringWithFormat:@"%d.caf", motion.motionType]];
        isInputed_ = YES;
        CCParticleSystemQuad* melody = [CCParticleSystemQuad particleWithFile:@"melody.plist"];
        melody.position = ccp(bar_.position.x - 400 + (currentBeat_ - startBeat_) * 50, bar_.position.y);
        status_.scoreLabel.target = (float)score_;
        [self addChild:melody];
        if (sub <= FUZZY_TIME / 2) {
          [self addMotionLabel:@"great.png" beat:currentBeat_ - startBeat_];
        } else {
          [self addMotionLabel:@"ok.png" beat:currentBeat_ - startBeat_];
        }
      } else if (correctMotionType != MotionTypeNone) {
        // 間違った入力をしたとき
        life_ -= 50 * ((int)self.music.difficulty + 1);
        [self addMotionLabel:@"bad.png" beat:currentBeat_ - startBeat_];
        [self onFail];
        isInputed_ = YES;
      }
    }
  }
}

- (void)onFail {
  // 間違ったとき
  [[OALSimpleAudio sharedInstance] playEffect:@"invalid0.caf"];
  isInputed_ = NO;
  isLevelUp_ = NO;
  isPerfect_ = NO;
  if (currentLevel_ != 1) {
    [self setLevel:1];
  }
}

- (void)setLevel:(int)level {
  currentLevel_ = level;
  [self.music changeLoop:currentLevel_ - 1];
  isLevelUp_ = NO;
  self.background.startSize = 8 * currentLevel_;
  self.background.endSize = 3 * currentLevel_;
  [status_ setLevel:level];
}

- (void)addMotionLabel:(NSString *)filename beat:(int)beat {
  CCSprite* label = [CCSprite spriteWithFile:filename];
  label.position = ccp(bar_.position.x - 400 + beat * 50, bar_.position.y + 30);
  id expand = [CCScaleTo actionWithDuration:0.1f scale:1.0];
  id delay = [CCDelayTime actionWithDuration:0.2f];
  id fadeout = [CCFadeOut actionWithDuration:0.1f];
  __weak MainLayer* layer = self;
  id suicide = [CCCallBlockN actionWithBlock:^(CCNode* node){
    [layer removeChild:node cleanup:YES];
  }];
  [label runAction:[CCSequence actions:expand, delay, fadeout, suicide, nil]];
  [self addChild:label];
}

- (void)pause {
  [[CCDirector sharedDirector] pause];
  [self pauseSchedulerAndActions];
  [self.music pause];
  PauseLayer* pl = [PauseLayer node];
  pl.music = self.music;
  [self addChild:pl];
  [[OALSimpleAudio sharedInstance] playEffect:@"pause.caf"];
}

- (void)resume {
  [[CCDirector sharedDirector] resume];
  [self resumeSchedulerAndActions];
  [self.music resume];
  [[OALSimpleAudio sharedInstance] playEffect:@"pause.caf"];
}

@end
