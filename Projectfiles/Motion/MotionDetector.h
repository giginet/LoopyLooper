//
//  MotionDetector.h
//  LoopyLooper
//
//  Created by  on 1/28/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "heqet.h"

@interface MotionDetector : KWSingleton {
  __weak id delegate_;
  SEL selector_;
}

@property(readwrite, weak) id delegate;
@property(readwrite) double prevYaw;
@property(readwrite) double yawOrigin;
@property(readwrite) int yawDir;
- (void)setOnDetection:(id)delegate selector:(SEL)selector;
- (BOOL)isMotionTypeRotateWithKKDeviceMotion:(KKDeviceMotion*)motion;
- (BOOL) isMotionTypeShakeWithKKDeviceMotion:(KKDeviceMotion*)motion;
@end
