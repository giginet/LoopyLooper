//
//  ResultLayer.m
//  LoopyLooper
//
//  Created by 片ノ坂 卓磨 on 12/01/28.
//  Copyright (c) 2012 北海道大学大学院 情報科学研究科 複合情報学専攻 表現系工学研究室. All rights reserved.
//

#import "ResultLayer.h"
#import "TitleLayer.h"
#import "MainLayer.h"

@implementation ResultLayer

- (id)init {
  self = [super init];
  if (self) {
    self.isTouchEnabled = YES;
    self.nextScene = nil;
    
    CCDirector* director = [CCDirector sharedDirector];
    
    [CCMenuItemFont setFontName:@"Helvetica"];
    [CCMenuItemFont setFontSize:40];
    
    CCMenuItem* title = [CCMenuItemFont itemFromString:@"Title"
                                                target:self
                                              selector:@selector(toTitle:)];
    
    CCMenuItem* main = [CCMenuItemFont itemFromString:@"Main"
                                               target:self
                                             selector:@selector(toMain:)];
    
    CCMenu* menu = [CCMenu menuWithItems:title, main, nil];
    menu.position = director.screenCenter;
    menu.tag = 100;
    [self addChild:menu_];
    
    [menu_ alignItemsVerticallyWithPadding:40];
  }
  return self;
}
- (void)toTitle:(id)sender{
  CCScene* scene = [TitleLayer nodeWithScene];
  CCTransitionFade* transition = [CCTransitionFade transitionWithDuration:0.5f 
                                                                    scene:scene];
  [[CCDirector sharedDirector] replaceScene:transition];
}
- (void)toMain:(id)sender{
  CCScene* scene = [MainLayer nodeWithScene];
  CCTransitionFade* transition = [CCTransitionFade transitionWithDuration:0.5f 
                                                                    scene:scene];
  [[CCDirector sharedDirector] replaceScene:transition];
}

@end