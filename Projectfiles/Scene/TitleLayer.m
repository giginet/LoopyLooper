//
//  TitleLayer.m
//  LoopyLooper
//
//  Created on 12/01/28.
//  Copyright (c) 2012 All rights reserved.
//

#import "ObjectAL.h"

#import "TitleLayer.h"
#import "MenuLayer.h"
#import "ResultLayer.h"

@implementation TitleLayer

- (id)init {
  self = [super init];
  if (self) {
    
    self.isTouchEnabled = YES;
    CCDirector* director = [CCDirector sharedDirector];
    
    CCSprite* background = [CCSprite spriteWithFile:@"menu.png"];
    background.position = director.screenCenter;
    [self addChild:background];
  }
  return self;
}

- (void)onEnterTransitionDidFinish {
  CCDirector* director = [CCDirector sharedDirector];
  CCSprite* logo = [CCSprite spriteWithFile:@"logo.png"];
  logo.position = ccp(director.screenCenter.x, director.screenCenter.y + 150);
  [logo runAction:[CCFadeIn actionWithDuration:1.0]];
  [self addChild:logo];
  CCLabelTTF* start = [CCLabelTTF labelWithString:@"Touch to start" 
                                         fontName:@"Helvetica-Bold" 
                                         fontSize:24];
  start.color = ccc3(33, 37, 68);
  [start runAction:[CCRepeatForever actionWithAction:[CCSequence actions:
                                                      [CCFadeTo actionWithDuration:1.0f opacity:64], 
                                                      [CCFadeTo actionWithDuration:1.0f opacity:255], 
                                                      nil]]];
  start.position = ccp(director.screenCenter.x, director.screenCenter.y - 150); 
  [self addChild:start];
  [[OALSimpleAudio sharedInstance] playBg:@"Theme.caf" loop:true];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
  CCScene* scene = [MenuLayer nodeWithScene];
  CCTransitionFade* transition = [CCTransitionFade transitionWithDuration:0.5f 
                                                                    scene:scene];
  [[CCDirector sharedDirector] replaceScene:transition];
  return YES;
}

@end
