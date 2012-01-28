//
//  MainLayer.m
//  LoopyLooper
//
//  Created by  on 1/28/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "MainLayer.h"
#import "ResultLayer.h"

@implementation MainLayer
@synthesize nextScene = nextScene_;

- (id)init {
  self = [super init];
  if (self) {
    self.isTouchEnabled = YES;
    self.nextScene = [ResultLayer nodeWithScene];
    
    CCDirector* director = [CCDirector sharedDirector];
    
    [CCMenuItemFont setFontName:@"Helvetica"];
    [CCMenuItemFont setFontSize:40];
    
    result_ = [CCMenuItemFont itemFromString:@"Result"
                                     target:self
                                   selector:@selector(toResult:)];
    
    menu_ = [CCMenu menuWithItems:result_, nil];
    menu_.position = director.screenCenter;
    menu_.tag = 100;
    [self addChild:menu_];
    
    [menu_ alignItemsVerticallyWithPadding:40];
  }
  return self;
}
-(void)toResult:(id)sender{
  CCScene* scene = self.nextScene;
  CCTransitionFade* transition = [CCTransitionFade transitionWithDuration:0.5f 
                                                                    scene:scene];
  [[CCDirector sharedDirector] replaceScene:transition];
}
@end
