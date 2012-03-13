//
//  MenuWindow.h
//  LoopyLooper
//
//  Created by  on 2012/2/28.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "CCSprite.h"
#import "difficulty.h"

@interface MenuWindow : CCSprite {
  CCMenu* difficultyMenu_;
}

@property(readwrite) int musicNumber;
@property(readwrite) Difficulty difficulty;

@end
