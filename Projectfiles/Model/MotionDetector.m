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
    //input.gyroActive = YES;
    input.accelerometerActive = YES;
    //input.deviceMotionActive = YES;
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
    //KKDeviceMotion* dm = input.deviceMotion;
    KKAcceleration* ac = input.acceleration;
    NSLog(@"%f", ac.y);
    if (ac.y  < -0.5) {
      type = MotionTypeLeftYaw;
    } else if (ac.y  > 0.5) {
      type = MotionTypeRightYaw;
    }
    return [Motion motionWithKKDeviceMotion:nil motionType:type];
  }
  return nil;
}

@end
