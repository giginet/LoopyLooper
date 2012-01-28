//
//  MainLayer.m
//  LoopyLooper
//
//  Created by  on 1/28/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "MainLayer.h"
#import "MotionDetector.h"
#import "Motion.h"

@interface MainLayer()
- (void)detectMotion:(Motion*)motion;
@end

@implementation MainLayer 

- (id)init {
  self = [super init];
  if (self) {
    label_ = [CCLabelTTF labelWithString:@"" 
                                fontName:@"Helvetica" 
                                fontSize:13];
    CCDirector* director = [CCDirector sharedDirector];
    label_.position = director.screenCenter;
    [self addChild:label_];
    MotionDetector* detector = [MotionDetector shared];
    [detector setOnDetection:self selector:@selector(detectMotion:)];
  }
  return self;
}

- (void)update:(ccTime)dt {
}

- (void)detectMotion:(Motion *)motion {
  if (motion.motionType == MotionTypeLeftYaw) {
    [label_ setString:@"Left"];
  } else if (motion.motionType == MotionTypeRightYaw) {
    [label_ setString:@"Right"];
  } else if (motion.motionType == MotionTypeNone) {
    [label_ setString:@""];
  }
}

@end
