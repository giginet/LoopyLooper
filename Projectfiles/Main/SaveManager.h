//
//  SaveManager.h
//  LoopyLooper
//
//  Created by  on 2012/3/14.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "KWSingleton.h"
#import "difficulty.h"

@interface SaveManager : NSObject

+ (id)shared;
- (BOOL)setHighScore:(int)musicID difficulty:(Difficulty)difficulty score:(int)score;
- (int)loadHighScore:(int)musicID difficulty:(Difficulty)difficulty;

@end
