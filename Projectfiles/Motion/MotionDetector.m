//
//  MotionDetector.m
//  LoopyLooper
//
//  Created by  on 1/28/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "MotionDetector.h"
#import "Motion.h"

@interface MotionDetector()
- (void)update:(ccTime)dt;
- (Motion*)detectMotion;
@end

@implementation MotionDetector
@synthesize delegate = delegate_;
@synthesize prevYaw = prevYaw_;
@synthesize yawOrigin = yawOrigin_;

- (id)init {
  self = [super init];
  if (self) {
    KKInput* input = [KKInput sharedInput];
    input.deviceMotionActive = YES;
    int fps = [[KKStartupConfig config] maxFrameRate];
    [[CCScheduler sharedScheduler] scheduleSelector:@selector(update:) 
                                          forTarget:self 
                                           interval:1.0 / fps 
                                             paused:NO];
  }
  return self;
}


- (void)setOnDetection:(id)delegate selector:(SEL)selector {
  delegate_ = delegate;
  selector_ = selector;
}

- (void)update:(ccTime)dt {
  Motion* motion = [self detectMotion];
  if (motion) {
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.delegate performSelector:selector_ withObject:motion];
    #pragma clang diagnostic pop
  }
}

- (Motion*)detectMotion {
  KKInput* input = [KKInput sharedInput];
  if (input.accelerometerAvailable) {
    MotionType type = MotionTypeNone;
    KKDeviceMotion* dm = input.deviceMotion;
    if ( dm.acceleration.rawX > .4 ) {
      type = MotionTypeUp;
    } else if ( dm.acceleration.rawX < -.4 ) {
      type = MotionTypeDown;
    } else if (abs(dm.acceleration.rawZ) > 1.0) {
      type = MotionTypeBackForth;
    } else if (dm.roll < M_PI_4 || dm.roll > M_PI_2 + M_PI_4) {
      type = MotionTypeRoll;
    } else if ( [self isMotionTypeRotateWithKKDeviceMotion:dm] ) {
      type = MotionTypeRotate;
    }
    return [Motion motionWithKKDeviceMotion:dm motionType:type];
  }
  return nil;
}

- (BOOL) isMotionTypeRotateWithKKDeviceMotion:(KKDeviceMotion*)motion {
   const double yaw = [motion yaw];
   BOOL isRoll = NO;
  if ( yaw - self.prevYaw > 0.0 ) {
     self.prevYaw = yaw;
    if ( yaw - self.yawOrigin >= M_PI / 2.0 ) {
       isRoll = YES;
     }
   } else {
     self.prevYaw = yaw;
     self.yawOrigin = yaw;
   }
   return isRoll;
}
@end
