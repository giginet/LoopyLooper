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

#define PART_LENGTH 16
#define FUZZY_TIME 0.1
#define MAX_LIFE 1000

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
- (void)detectMotion:(Motion*)motion;
- (void)onFail;
- (void)setLevel:(int)level;
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

- (id)initWithMusicID:(NSInteger)musicID {
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
    lifeGauge_ = [KWGauge gaugeWithColor:ccc3(0, 255, 0) andSize:CGSizeMake(400, 64)];
    beatLabel_ = [CCLabelTTF labelWithString:@"" fontName:@"Arial-BoldMT" fontSize:24];
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
    background = [CCParticleSystemQuad particleWithFile:@"background.plist"];
    background.position = director.screenCenter;
    [self addChild:background];
    
    bar_ = [SeekBar seekBarWithMusic:self.music measure:0];
    [self addChild:bar_];
    bar_.position = ccp([CCDirector sharedDirector].screenCenter.x, 150);
    scoreLabel_ = [[KWCounterLabel alloc] initWithNumber:0 
                                              dimensions:CGSizeMake(200, 40) 
                                               alignment:UITextAlignmentRight 
                                                fontName:@"Arial-BoldMT" 
                                                fontSize:24];
    scoreLabel_.color = ccc3(0, 0, 0);
    scoreLabel_.position = ccp(800, 720);
    scoreLabel_.duration = 3;
    lifeGauge_.position = ccp(500, 720);
    lifeGauge_.gaugeColor = ccc3(255, 0, 0);
    beatLabel_.position = ccp(100, 100);
    [self addChild:scoreLabel_];
    [self addChild:lifeGauge_];
    [self addChild:beatLabel_];
    CCSprite* status = [CCSprite spriteWithFile:@"status.png"];
    status.position = ccp(512, director.screenSize.height - status.contentSize.height / 2);
    [self addChild:status];
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
   */
  [self.music play];
  [bar_ play];
  startBeat_ = 0;
  currentBeat_ = startBeat_;
  [self onExamplePart];
  [self.music setCallbackOnBeat:self selector:@selector(onBeat)];
  [scoreLabel_ play];
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
  background.duration = 0;
  [self runAction:[CCSequence actions:
                   [CCDelayTime actionWithDuration:4.0],
                   [CCCallFunc actionWithTarget:self selector:@selector(onGameEnd)]
                   , nil]];
}

- (void)onClear {
  state_ = GameStateClear;
  for(OALAudioTrack* track in self.music.tracks) {
    [track fadeTo:0 
         duration:1.5f 
           target:self 
         selector:@selector(onGameEnd)];
  }
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
  /*
   * Beatを打つ度に呼ばれます
   * self.music.measureとかで何拍目か取れます
   */
  [beatLabel_ setString:[NSString stringWithFormat:@"%d", self.music.measure]];
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
    NSLog(@"Example");
    [bar_ reset];
    startBeat_ += PART_LENGTH;
    [bar_ reloadBarFrom:startBeat_];
    [self onExamplePart];
  } else if (state == GameStatePlay) {
    NSLog(@"Play");
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
    NSLog(@"change : %d", nextState);
    [self changeState:nextState];
  }
  if (state_ == GameStatePlay && currentBeat_ > prevBeat) {
    MotionType prevCorrectMotionType = [self.music.score motionTypeOnBeat:prevBeat];
    if (!isInputed_ && prevCorrectMotionType != MotionTypeNone) {
      // 入力し損ねたとき
      NSLog(@"miss : %d %d %d", currentBeat_, prevBeat, prevCorrectMotionType);
      life_ -= 200;
      [self onFail];
    } else if (currentBeat_ - startBeat_ == PART_LENGTH && isLevelUp_ && isPerfect_) {
      CutIn* cutin = [[CutIn alloc] initWithFace:@"cut_in_boss1.png" background:@"cutin.plist"];
      cutin.position = ccp(0, [CCDirector sharedDirector].screenCenter.y);
      [self addChild:cutin];
      if (currentLevel_ < self.music.loops) {
        NSLog(@"LevelUp");
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
  lifeGauge_.rate = (double)life_ / (double)MAX_LIFE;
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
        score_ += 500 * pow(2, currentLevel_) * ((FUZZY_TIME * 2) - sub) / (FUZZY_TIME * 2);
        life_ += 50 * ((FUZZY_TIME * 2) - sub) / (FUZZY_TIME * 2);
        [[OALSimpleAudio sharedInstance] playEffect:[NSString stringWithFormat:@"%d.caf", motion.motionType]];
        isInputed_ = YES;
        CCParticleSystemQuad* melody = [CCParticleSystemQuad particleWithFile:@"melody.plist"];
        melody.position = ccp(bar_.position.x - 400 + (currentBeat_ - startBeat_) * 50, bar_.position.y);
        scoreLabel_.target = (float)score_;
        [self addChild:melody];
      } else if (correctMotionType != MotionTypeNone) {
        // 間違った入力をしたとき
        life_ -= 50;
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
  NSLog(@"levelDown");
  currentLevel_ = level;
  [self.music changeLoop:currentLevel_ - 1];
  isLevelUp_ = NO;
  self.background.startSize = 8 * currentLevel_;
  self.background.endSize = 3 * currentLevel_;
}

@end
