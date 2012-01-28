//
//  Motion.m
//  LoopyLooper
//
//  Created by  on 1/28/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "Motion.h"

@implementation Motion
@synthesize motionType = motionType_;
@synthesize motion = motion_;

+ (id)motionWithKKDeviceMotion:(KKDeviceMotion *)motion motionType:(MotionType)type {
  return [[[self class] alloc] initWithKKDeviceMotion:motion motionType:type];
}

- (id)init {
  self = [super init];
  if (self) {
    motionType_ = MotionTypeNone;
  }
  return self;
}

- (id)initWithKKDeviceMotion:(KKDeviceMotion *)motion motionType:(MotionType)type {
  self = [self init];
  if (self) {
    motion_ = motion;
    motionType_ = type;
  }
  return self;
}

@end
