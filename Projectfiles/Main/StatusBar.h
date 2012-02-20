//
//  StatusBar.h
//  LoopyLooper
//
//  Created by  on 2012/2/19.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "CCSprite.h"
#import "heqet.h"

@interface StatusBar : CCSprite {
  KWCounterLabel* scoreLabel_;
}

@property(readwrite, strong) KWCounterLabel* scoreLabel;

@end
