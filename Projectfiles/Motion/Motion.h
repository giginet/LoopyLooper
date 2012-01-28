//
//  Motion.h
//  LoopyLooper
//
//  Created by  on 1/28/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
  MotionTypeNone,
  MotionTypeLeftPitch,
  MotionTypeRightPitch,
  MotionTypeBackForth,
  MotionTypeShake,
  MotionTypeRotate,
  MotionTypeRoll,
  MotionTypeDoubleTap
} MotionType;

@interface Motion : NSObject {
  MotionType motionType_;
  KKDeviceMotion* motion_;
}

@property(readonly) MotionType motionType;
@property(readonly) KKDeviceMotion* motion;

+ (id)motionWithKKDeviceMotion:(KKDeviceMotion*)motion motionType:(MotionType)type;

- (id)initWithKKDeviceMotion:(KKDeviceMotion*)motion motionType:(MotionType)type;

@end
