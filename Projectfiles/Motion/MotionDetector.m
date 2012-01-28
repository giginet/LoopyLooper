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
@synthesize yawDir = yawDir_;

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
    self.yawDir = ( [[input deviceMotion] yaw] > 0.0 ) ? 1 : -1;
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
    if ( (abs(dm.acceleration.rawZ) > .5) ) {
      type = MotionTypeBackForth; // 3
    } else if ( dm.acceleration.rawX > .6 ) {
      type = MotionTypeUp; // 1
    } else if ( dm.acceleration.rawX < -.6 ) {
      type = MotionTypeDown; // 2
    } else if ( [self isMotionTypeRotateWithKKDeviceMotion:dm] ) {
      type = MotionTypeRotate; // 5
    } else if ( [self isMotionTypeShakeWithKKDeviceMotion:dm] ) {
      type = MotionTypeShake; // 4
    } else if (dm.roll < M_PI_4 || dm.roll > M_PI_2 + M_PI_4) {
      type = MotionTypeRoll; // 6
    }
    return [Motion motionWithKKDeviceMotion:dm motionType:type];
  }
  return nil;
}

- (BOOL) isMotionTypeRotateWithKKDeviceMotion:(KKDeviceMotion*)motion {
  const double yaw = [motion yaw];
  BOOL isRoll = NO;
  
  // 一定方向に回転中かどうか
  if ( self.yawDir * ( yaw - self.prevYaw ) > 0.0 ) {
    self.prevYaw = yaw;
    // 90度以上回転したかどうか
    if ( self.yawDir * ( yaw - self.yawOrigin ) >= M_PI_4 ) {
       isRoll = YES;
     }
   } else {
     // 回転方向変更
     self.yawDir = ( yaw > 0.0 ) ? 1 : -1;
     self.prevYaw = yaw;
     self.yawOrigin = yaw;
   }
   return isRoll;
}

- (BOOL) isMotionTypeShakeWithKKDeviceMotion:(KKDeviceMotion*)motion {
  static double prevAcc = 0.0;
  static int trigCnt = 0;
  static double threshold = .5;
  static NSTimeInterval trigTime = 0.0;
  const NSTimeInterval period = .5; // sec
  const int numTrigPerShake = 3;
  const double acc = [motion acceleration].rawY;
  const NSTimeInterval time = [motion acceleration].timestamp;
  
  // シェイク判定有効時間を超えた場合
  if ( trigTime + period < time ) {
    trigCnt = 0;
  }
  
  // 加速度がしきい値を超えた(トリガー)場合
  if ( ( prevAcc - threshold ) * ( acc - threshold ) < 0.0 ) {
    // 初めてのトリガーの場合
    if ( trigCnt == 0 ) {
      // 時刻を記録する
      trigTime = [motion acceleration].timestamp;
    }
    // しきい値の符号を反転
    threshold *= -1.0;
    trigCnt++;
    
    // 規定回数しきい値を超えた場合
    if ( trigCnt >= numTrigPerShake ) {
      trigCnt = 0;
      return YES;
    }
  }
  prevAcc = acc;
  return NO;
}
@end
