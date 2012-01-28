//
//  TitleLayer.m
//  LoopyLooper
//
//  Created on 12/01/28.
//  Copyright (c) 2012 All rights reserved.
//

#import "TitleLayer.h"
#import "MainLayer.h"

@implementation TitleLayer
@synthesize nextScene = nextScene_;

- (id)init {
  self = [super init];
  if (self) {
    
    self.isTouchEnabled = YES;
    self.nextScene = [MainLayer nodeWithScene];
    
    CCDirector* director = [CCDirector sharedDirector];
    
    [CCMenuItemFont setFontName:@"Helvetica"];
    [CCMenuItemFont setFontSize:40];
    
    start_ = [CCMenuItemFont itemFromString:@"START"
                                     target:self
                                   selector:@selector(toMain:)];
    
    menu_ = [CCMenu menuWithItems:start_, nil];
    menu_.position = director.screenCenter;
    menu_.tag = 100;
    [self addChild:menu_];
    
    [menu_ alignItemsVerticallyWithPadding:40];
  }
  return self;
}

-(void)toMain:(id)sender{
  CCScene* scene = self.nextScene;
  CCTransitionFade* transition = [CCTransitionFade transitionWithDuration:0.5f 
                                                                    scene:scene];
  [[CCDirector sharedDirector] replaceScene:transition];
}

@end
