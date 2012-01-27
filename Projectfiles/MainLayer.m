//
//  MainLayer.m
//  LoopyLooper
//
//  Created by  on 1/28/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "MainLayer.h"

@implementation MainLayer 

- (id)init {
  self = [super init];
  if (self) {
    label_ = [CCLabelTTF labelWithString:@"" 
                                fontName:@"Helvetica" 
                                fontSize:13];
    KKInput* input = [KKInput sharedInput];
    input.gyroActive = YES;
    input.accelerometerActive = YES;
    input.deviceMotionActive = YES;
    CCDirector* director = [CCDirector sharedDirector];
    label_.position = director.screenCenter;
    [self addChild:label_];
  }
  return self;
}

- (void)update:(ccTime)dt {
  [label_ setString:@""];
  KKInput* input = [KKInput sharedInput];
  if (input.accelerometerActive) {
    KKAcceleration* ac = input.acceleration;
    if (ac.y < -0.5) {
      [label_ setString:@"left"];
    } else if (ac.y > 0.5) {
      [label_ setString:@"right"];
    }
  }
  if (input.deviceMotionAvailable) {
    KKDeviceMotion* dm = input.deviceMotion;
    NSLog(@"%f", dm.yaw);
  }
}

@end
