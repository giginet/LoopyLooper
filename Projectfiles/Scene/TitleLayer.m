//
//  TitleLayer.m
//  LoopyLooper
//
//  Created on 12/01/28.
//  Copyright (c) 2012 All rights reserved.
//

#import "TitleLayer.h"
#import "MainLayer.h"
#import "ResultLayer.h"
#import "CutIn.h"

@implementation TitleLayer
@synthesize nextScene = nextScene_;

- (id)init {
  self = [super init];
  if (self) {
    
    self.isTouchEnabled = YES;
    self.nextScene = [MainLayer nodeWithScene];
    
    CCDirector* director = [CCDirector sharedDirector];
    
    CCSprite* background = [CCSprite spriteWithFile:@"title.png"];
    background.position = director.screenCenter;
    [self addChild:background];    
  }
  return self;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
  [self toMain:nil];
  return YES;
}

- (void)toMain:(id)sender{
  CCScene* scene = self.nextScene;
  CCTransitionFade* transition = [CCTransitionFade transitionWithDuration:0.5f 
                                                                    scene:scene];
  [[CCDirector sharedDirector] replaceScene:transition];
}

- (void)toResult:(id)sender{
  ResultLayer *layer = [[ResultLayer alloc] initWithScore:100];
  CCScene *scene = [[CCScene alloc] init];
  [scene addChild:layer];
  CCTransitionFade* transition = [CCTransitionFade transitionWithDuration:0.5f 
                                                                    scene:scene];
  [[CCDirector sharedDirector] replaceScene:transition];
}
@end
