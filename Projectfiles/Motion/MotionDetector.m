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
- (BOOL)isMotionTypeRotateWithKKDeviceMotion:(KKDeviceMotion*)motion;
- (BOOL) isMotionTypeShakeWithKKDeviceMotion:(KKDeviceMotion*)motion;
- (void)initShakeParameter;
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

- (BOOL) isMotionTypeRotateWithKKDeviceMotion:(KKDeviceMotion*)motion {
  const double yaw = [motion yaw];
  
  // 一定方向に回転中かどうか
  if ( self.yawDir * ( yaw - self.prevYaw ) > 0.0 ) {
    self.prevYaw = yaw;
    // 45度以上回転したかどうか
    if ( self.yawDir * ( yaw - self.yawOrigin ) >= M_PI_4 ) {
       return YES;
     }
   } else {
     // 回転方向変更
     self.yawDir = ( yaw > 0.0 ) ? 1 : -1;
     self.prevYaw = yaw;
     self.yawOrigin = yaw;
   }
   return NO;
}

- (BOOL) isMotionTypeShakeWithKKDeviceMotion:(KKDeviceMotion*)motion {
  const NSTimeInterval period = .5; // sec
  const int numTrigPerShake = 3;
  const double acc = [motion acceleration].rawY;
  const NSTimeInterval time = [motion acceleration].timestamp;
  
  // シェイク判定有効時間を超えた場合
  if ( trigTime_ + period < time ) {
    trigCnt_ = 0;
  }
  
  // 加速度がしきい値を超えた(トリガー)場合
  if ( ( prevAcc_ - threshold_ ) * ( acc - threshold_ ) < 0.0 ) {
    // 初めてのトリガーの場合
    if ( trigCnt_ == 0 ) {
      // 時刻を記録する
      trigTime_ = [motion acceleration].timestamp;
    }
    // しきい値の符号を反転
    threshold_ *= -1.0;
    trigCnt_++;
    
    // 規定回数しきい値を超えた場合
    if ( trigCnt_ >= numTrigPerShake ) {
      trigCnt_ = 0;
      //return YES;
    }
  }
  prevAcc_ = acc;
  return NO;
}

- (void)initShakeParameter {
  prevAcc_ = 0;
  trigCnt_ = 0;
  threshold_ = .5;
  trigTime_ = 0; 
}

@end
