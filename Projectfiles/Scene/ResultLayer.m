//
//  ResultLayer.m
//  LoopyLooper
//
//  Created by giginet on 12/01/28.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "ResultLayer.h"
#import "TitleLayer.h"
#import "MainLayer.h"
#import "SaveManager.h"

@implementation ResultLayer
@synthesize scoreLabel = scoreLabel_;

- (id)initWithScore:(NSInteger)score {
  self = [self init];
  if (self) {
    [self.scoreLabel setString:[NSString stringWithFormat:@"score:%d", score]];
  }
  return self;
}

@end