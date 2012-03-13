//
//  SaveManager.m
//  LoopyLooper
//
//  Created by  on 2012/3/14.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "SaveManager.h"

@interface SaveManager()
- (NSString*)keyFromMusicAndDifficulty:(int)musicID difficulty:(Difficulty)difficulty;
@end

@implementation SaveManager

+ (id)shared {
  static id sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[[self class] alloc] init];
  });
  return sharedInstance;
}

- (BOOL)setHighScore:(int)musicID difficulty:(Difficulty)difficulty score:(int)score {
  int old = [self loadHighScore:musicID difficulty:difficulty];
  if (old >= score) return NO;
  NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
  [ud setInteger:score forKey:[self keyFromMusicAndDifficulty:musicID difficulty:difficulty]];
  return YES;
}

- (int)loadHighScore:(int)musicID difficulty:(Difficulty)difficulty {
  NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
  return [ud integerForKey:[self keyFromMusicAndDifficulty:musicID difficulty:difficulty]];
}

- (NSString*)keyFromMusicAndDifficulty:(int)musicID difficulty:(Difficulty)difficulty {
  return [NSString stringWithFormat:@"highscore_%d_%d", musicID, (int)difficulty];
}

@end
