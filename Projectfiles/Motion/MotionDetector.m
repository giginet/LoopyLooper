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
    if (dm.acceleration.rawY > 0.7) {
      type = MotionTypeLeft; // 4
    } else if(dm.acceleration.rawZ > 0.7 || dm.acceleration.rawZ < -0.7) {
      type = MotionTypeBackForth; // 3
    } else if ( dm.acceleration.rawX > 0.8 && abs(dm.rotationRate.y) <= M_PI ) {
      type = MotionTypeUp; // 1
    } else if ( dm.acceleration.rawX < -0.8 && abs(dm.rotationRate.y) <= M_PI ) {
      type = MotionTypeDown; // 2
    } else if (dm.acceleration.rawY < -0.7) {
      type = MotionTypeRight; // 5
    } 
    return [Motion motionWithKKDeviceMotion:dm motionType:type];
  }
  return nil;
}

@end
