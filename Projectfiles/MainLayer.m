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

@interface MainLayer()
- (void)detectMotion:(Motion*)motion;
@end

@implementation MainLayer

- (id)init {
  self = [super init];
  if (self) {
    self.isTouchEnabled = YES;
    
    CCDirector* director = [CCDirector sharedDirector];
    
    [CCMenuItemFont setFontName:@"Helvetica"];
    [CCMenuItemFont setFontSize:40];
    
    CCMenuItem* result = [CCMenuItemFont itemFromString:@"Result"
                                                 target:self
                                               selector:@selector(toResult:)];
    
    CCMenu* menu = [CCMenu menuWithItems:result, nil];
    menu.position = director.screenCenter;
    menu.tag = 100;
    [self addChild:menu];
    
    [menu alignItemsVerticallyWithPadding:40];
    
    label_ = [CCLabelTTF labelWithString:@"" 
                                fontName:@"Helvetica" 
                                fontSize:13];
    label_.position = director.screenCenter;
    [self addChild:label_];
    MotionDetector* detector = [MotionDetector shared];
    [detector setOnDetection:self selector:@selector(detectMotion:)];

  }
  return self;
}
-(void)toResult:(id)sender{
  CCScene* scene = [ResultLayer nodeWithScene];
  CCTransitionFade* transition = [CCTransitionFade transitionWithDuration:0.5f 
                                                                    scene:scene];
  [[CCDirector sharedDirector] replaceScene:transition];
}

- (void)update:(ccTime)dt {
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
  } else if (motion.motionType == MotionTypeNone) {
    [label_ setString:@""];
  }
}
@end
