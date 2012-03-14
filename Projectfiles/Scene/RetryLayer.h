//
//  RetryLayer.h
//  LoopyLooper
//
//  Created by  on 2012/3/14.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "KWLayer.h"
#import "LoopMusic.h"

@interface RetryLayer : KWLayer

@property(readwrite) LoopMusic* music;

- (void)toTitle:(id)sender;
- (void)toMain:(id)sender;

@end
