//
//  PauseLayer.m
//  LoopyLooper
//
//  Created by  on 2012/3/14.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "MainLayer.h"
#import "PauseLayer.h"
#import "ObjectAL.h"

@implementation PauseLayer

- (id)init {
  self.backgroundColor = ccc4(0, 0, 0, 200);
  self = [super init];
  if (self) {
    CCSprite* pause = [CCSprite spriteWithFile:@"pause.png"];
    CCDirector* director = [CCDirector sharedDirector];
    pause.position = director.screenCenter;
    [self addChild:pause];
    self.isTouchEnabled = YES;
  }
  return self;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
  return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
  [(MainLayer*)self.parent resume];
  [self.parent removeChild:self cleanup:YES];
}

@end
