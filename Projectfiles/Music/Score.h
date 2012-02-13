//
//  Score.h
//  LoopyLooper
//
//  Created by  on 1/28/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Motion.h"

@interface Score : NSObject {
  NSDictionary* scoreData_;
}

@property(readonly) int scoreLength;

- (id)initWithFile:(NSString*)file;

- (MotionType)motionTypeOnBeat:(int)beat;
- (NSArray*)motionTypesWithRange:(NSRange)range;

@end
