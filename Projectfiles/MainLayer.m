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
#import "LoopManager.h"

@interface MainLayer()
- (void)onReady;
- (void)onStart;
- (void)onExamplePart;
- (void)onPlayPart;
- (void)onGameOver;
- (void)changeState;
- (void)detectMotion:(Motion*)motion;
@end

@implementation MainLayer

- (id)init {
  self = [super init];
  if (self) {
    self.isTouchEnabled = YES;
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
    
    label_ = [CCLabelTTF labelWithString:@"" 
                                fontName:@"Helvetica" 
                                fontSize:13];
    label_.position = director.screenCenter;
    MotionDetector* detector = [MotionDetector shared];
    [detector setOnDetection:self selector:@selector(detectMotion:)];
    manager_ = [[LoopManager alloc] initWithMusicID:1];
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
  [manager_ setCallbackOnMeasure:currentMeasure_ + 15
                        delegate:self 
                        selector:@selector(changeState)];
}

- (void)onPlayPart {
  state_ = GameStatePlay;
  manager_.nextMeasure = currentMeasure_;
  [manager_ setCallbackOnMeasure:currentMeasure_ + 15
                        delegate:self 
                        selector:@selector(changeState)];
}

- (void)onGameOver {
  state_ = GameStateGameOver;
}

- (void)changeState {
  if (state_ == GameStateExample) {
    [self onPlayPart];
  } else if (state_ == GameStatePlay) {
    currentMeasure_ += 16;
    [self onExamplePart];
  }
}

- (void)detectMotion:(Motion *)motion {
  if (motion.motionType == MotionTypeUp) {
    [label_ setString:@"Up"];
  } else if (motion.motionType == MotionTypeDown) {
    [label_ setString:@"Down"];
  } else if (motion.motionType == MotionTypeBackForth) {
    NSLog(@"前後");
  } else if (motion.motionType == MotionTypeRoll) {
    [label_ setString:@"roll"];
  } else if (motion.motionType == MotionTypeRotate) {
    [label_ setString:@"rotate"];
  } else if (motion.motionType == MotionTypeShake) {
    [label_ setString:@"shake"];
  } else if (motion.motionType == MotionTypeNone) {
    [label_ setString:@""];
  }
}
@end
