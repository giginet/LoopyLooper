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
  int level_;
  KWCounterLabel* scoreLabel_;
}

- (void)setLevel:(int)level;

@property(readwrite, strong) KWCounterLabel* scoreLabel;
@property(readonly, strong) KWGauge* lifeGauge;

@end
