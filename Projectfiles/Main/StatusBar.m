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
@synthesize lifeGauge = lifeGauge_;

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
    CCSprite* frame = [CCSprite spriteWithFile:@"frame.png"];
    frame.position = ccp(500, 140);
    [self addChild:scoreLabel_];
    [self addChild:frame];
  }
  return self;
}

@end
