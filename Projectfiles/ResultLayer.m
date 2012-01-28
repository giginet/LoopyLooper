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
@synthesize nextScene = nextScene_;

- (id)init {
  self = [super init];
  if (self) {
    self.isTouchEnabled = YES;
    self.nextScene = nil;
    
    CCDirector* director = [CCDirector sharedDirector];
    
    [CCMenuItemFont setFontName:@"Helvetica"];
    [CCMenuItemFont setFontSize:40];
    
    title_ = [CCMenuItemFont itemFromString:@"Title"
                                     target:self
                                   selector:@selector(toTitle:)];
    
    main_ = [CCMenuItemFont itemFromString:@"Main"
                                     target:self
                                   selector:@selector(toMain:)];
    
    menu_ = [CCMenu menuWithItems:title_, main_, nil];
    menu_.position = director.screenCenter;
    menu_.tag = 100;
    [self addChild:menu_];
    
    [menu_ alignItemsVerticallyWithPadding:40];
  }
  return self;
}
-(void)toTitle:(id)sender{
  self.nextScene = [TitleLayer nodeWithScene];
  CCScene* scene = self.nextScene;
  CCTransitionFade* transition = [CCTransitionFade transitionWithDuration:0.5f 
                                                                    scene:scene];
  [[CCDirector sharedDirector] replaceScene:transition];
}
-(void)toMain:(id)sender{
  self.nextScene = [MainLayer nodeWithScene];
  CCScene* scene = self.nextScene;
  CCTransitionFade* transition = [CCTransitionFade transitionWithDuration:0.5f 
                                                                    scene:scene];
  [[CCDirector sharedDirector] replaceScene:transition];
}

@end