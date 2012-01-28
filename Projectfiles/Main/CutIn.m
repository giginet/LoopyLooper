//
//  CutIn.m
//  LoopyLooper
//
//  Created by  on 1/29/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "CutIn.h"

@implementation CutIn

- (id)initWithFace:(NSString *)faceFile background:(NSString *)backgroundFile {
  self = [super initWithFile:faceFile];
  if (self) {
    CCParticleSystemQuad* background = [CCParticleSystemQuad particleWithFile:backgroundFile];
    [background setContentSize:self.textureRect.size];
    [self addChild:background z:-1];
  }
  return self;
}

@end