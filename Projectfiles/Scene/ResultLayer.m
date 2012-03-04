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
@synthesize scoreLabel = scoreLabel_;

- (id)init {
  self = [super init];
  if (self) {
    self.isTouchEnabled = YES;
    CCDirector* director = [CCDirector sharedDirector];
    
    [CCMenuItemFont setFontName:@"Helvetica"];
    [CCMenuItemFont setFontSize:40];
    
    CCMenuItem* title = [CCMenuItemImage itemFromNormalImage:@"title_button.png" 
                                               selectedImage:@"title_button_selected.png" 
                                                      target:self 
                                                    selector:@selector(toTitle:)];
    
    CCMenuItem* replay = [CCMenuItemImage itemFromNormalImage:@"replay_button.png" 
                                                selectedImage:@"replay_button_selected.png" 
                                                       target:self 
                                                     selector:@selector(toMain:)];
    
    CCMenu* menu = [CCMenu menuWithItems:title, replay, nil];
    [menu alignItemsHorizontallyWithPadding:40];
    menu.position = ccp(director.screenCenter.x, director.screenCenter.y - 150);
    menu.tag = 100;
    [self addChild:menu];
    
    scoreLabel_ = [CCLabelTTF labelWithString:@"" 
                                fontName:@"Helvetica" 
                                fontSize:20];
    scoreLabel_.position = director.screenCenter;
    [self addChild:scoreLabel_];
  }
  return self;
}

- (id)initWithScore:(NSInteger)score {
  self = [self init];
  if (self) {
    [self.scoreLabel setString:[NSString stringWithFormat:@"score:%d", score]];
  }
  return self;
}
- (void)toTitle:(id)sender{
  [[OALSimpleAudio sharedInstance] stopBg];
  CCScene* scene = [TitleLayer nodeWithScene];
  CCTransitionFade* transition = [CCTransitionFade transitionWithDuration:0.5f 
                                                                    scene:scene];
  [[CCDirector sharedDirector] replaceScene:transition];
}
- (void)toMain:(id)sender{
  [[OALSimpleAudio sharedInstance] stopBg];
  CCScene* scene = [MainLayer nodeWithScene];
  CCTransitionFade* transition = [CCTransitionFade transitionWithDuration:0.5f 
                                                                    scene:scene];
  [[CCDirector sharedDirector] replaceScene:transition];
}

@end