//
//  StatusBar.m
//  LoopyLooper
//
//  Created by  on 2012/2/19.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "StatusBar.h"

@implementation StatusBar
@synthesize scoreLabel = scoreLabel_;
@synthesize lifeGauge;

- (id)initWithFile:(NSString *)filename {
  self = [super initWithFile:filename];
  if (self) {
    scoreLabel_ = [[KWCounterLabel alloc] initWithNumber:0 
                                              dimensions:CGSizeMake(100, 25) 
                                               alignment:UITextAlignmentRight 
                                                fontName:@"Arial-BoldMT" 
                                                fontSize:24];
    scoreLabel_.color = ccc3(33, 37, 68);
    scoreLabel_.position = ccp(950, 118);
    scoreLabel_.duration = 3;
    lifeGauge = [KWGauge gaugeWithFile:@"lifegauge.png"];
    lifeGauge.rate = 1;
    lifeGauge.position = ccp(500, 140);
    [self addChild:lifeGauge];
    CCSprite* frame = [CCSprite spriteWithFile:@"frame.png"];
    frame.position = ccp(500, 140);
    [self addChild:scoreLabel_];
    [self addChild:frame];
    level_ = 0;
    [self setLevel:1];
  }
  return self;
}

- (void)setLevel:(int)level {
  for (int i = level; i < 4; ++i) {
    [self removeChildByTag:i cleanup:YES];
  }
  for (int i = level_; i < level; ++i) {
    CCSprite* badge = [CCSprite spriteWithFile:@"level_badge.png"];
    badge.position = ccp(938 + (i - 1) * 28, 168);
    badge.scale = 0;
    [badge runAction:[CCScaleTo actionWithDuration:1.0f scale:1]];
    [self addChild:badge z:i tag:i];
  }
  level_ = level;
}

@end
