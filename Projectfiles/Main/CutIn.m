//
//  CutIn.m
//  LoopyLooper
//
//  Created by  on 1/29/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "CutIn.h"

@implementation CutIn

- (id)initWithFace:(NSString *)faceFile background:(NSString *)backgroundFile {
  self = [super init];
  if (self) {
    CCDirector* director = [CCDirector sharedDirector];
    CCNode* cutin = [CCNode node];
    CCSprite* face = [CCSprite spriteWithFile:faceFile];
    CCParticleSystemQuad* background = [CCParticleSystemQuad particleWithFile:backgroundFile];
    background.position = ccp(self.position.x + self.contentSize.width / 2, self.position.y + self.contentSize.height / 2);
    CCLayerColor* black = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 255) width:face.contentSize.width height:face.contentSize.height];
    black.position = ccp(0, -face.contentSize.height / 2);
    [self addChild:black];
    [cutin addChild:background];
    [cutin addChild:face];
    [self addChild:cutin];
    __weak CCNode* me = self;
    self.position = ccp(-director.screenSize.width + director.screenCenter.x, 0);
    cutin.position = ccp(-face.contentSize.width / 2, 0);
    [cutin runAction:[CCSequence actions:
                     [CCMoveTo actionWithDuration:0.25 position:ccp(director.screenCenter.x, 0)], 
                     [CCDelayTime actionWithDuration:1], 
                     [CCMoveTo actionWithDuration:0.25 position:ccp(director.screenSize.width + face.contentSize.width / 2, 0)],
                     [CCCallBlock actionWithBlock:^() {
      [me.parent removeChild:me cleanup:YES];
    }],
                     nil]];
  }
  return self;
}

@end