//
//  TitleLayer.m
//  LoopyLooper
//
//  Created on 12/01/28.
//  Copyright (c) 2012 All rights reserved.
//

#import "TitleLayer.h"
#import "MainLayer.h"
#import "ResultLayer.h"
#import "CutIn.h"

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
    
    CCMenuItemFont *item = [CCMenuItemFont itemFromString:@"RESULT"
                                                   target:self
                                                 selector:@selector(toResult:)];
    menu_ = [CCMenu menuWithItems:start_, item, nil];
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

-(void)toResult:(id)sender{
  ResultLayer *layer = [[ResultLayer alloc] initWithScore:100];
  CCScene *scene = [[CCScene alloc] init];
  [scene addChild:layer];
  CCTransitionFade* transition = [CCTransitionFade transitionWithDuration:0.5f 
                                                                    scene:scene];
  [[CCDirector sharedDirector] replaceScene:transition];
}
@end
