//
//  MenuWindow.m
//  LoopyLooper
//
//  Created by  on 2012/2/28.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "MenuWindow.h"
#import "MainLayer.h"

@interface MenuWindow()
- (void)pressDifficultyButton:(id)sender;
- (void)onFinishedFadeOut:(id)sender;
@end

@implementation MenuWindow

- (id)initWithFile:(NSString *)filename {
  self = [super initWithFile:filename];
  if (self) {
    NSMutableArray* buttons = [NSMutableArray array];
    for (int i = 0; i < 3; ++i) {
      NSString* difficulties[] = {@"easy", @"normal", @"hard"};
      NSString* filename = [NSString stringWithFormat:@"%@_button.png", difficulties[i]];
      NSString* selected = [NSString stringWithFormat:@"%@_button_selected.png", difficulties[i]];
      CCMenuItemToggle* button = [CCMenuItemToggle itemWithTarget:self 
                                                         selector:@selector(pressDifficultyButton:) 
                                                            items:[CCMenuItemImage itemFromNormalImage:filename 
                                                                                       selectedImage:selected],
                                [CCMenuItemImage itemFromNormalImage:selected 
                                                       selectedImage:filename],
                                nil];
      button.tag = i;
      [buttons addObject:button];
    }
    difficultyMenu_ = [CCMenu menuWithItems:
                       [buttons objectAtIndex:0], 
                       [buttons objectAtIndex:1], 
                       [buttons objectAtIndex:2], 
                       nil];
    difficultyMenu_.position = ccp(750, 200);
    [difficultyMenu_ alignItemsVertically];
    [self addChild:difficultyMenu_];
    
    __block id window = self;
    CCMenuItemImage* play = [CCMenuItemImage itemFromNormalImage:@"play_button.png"
                                                   selectedImage:@"play_button_selected.png"
                                                           block:^(id sender){
                                                             [[OALSimpleAudio sharedInstance].backgroundTrack fadeTo:0 
                                                                                                            duration:1.0 
                                                                                                              target:window 
                                                                                                            selector:@selector(onFinishedFadeOut:)];                                                             
                                                           }];
    CCMenu* playMenu = [CCMenu menuWithItems:play, nil];
    playMenu.position = ccp(200, 80);
    [self addChild:playMenu];
    
  }
  return self;
}

- (void)pressDifficultyButton:(id)sender {
}

- (void)onFinishedFadeOut:(id)sender {
  [[OALSimpleAudio sharedInstance] stopBg];
  [OALSimpleAudio sharedInstance].backgroundTrack.volume = 1.0;
  MainLayer* mainLayer = [[MainLayer alloc] initWithMusicID:0];
  CCScene* scene = [CCScene node];
  [scene addChild:mainLayer];
  CCTransitionFade* transition = [CCTransitionFade transitionWithDuration:0.5f 
                                                                    scene:scene];
  [[CCDirector sharedDirector] pushScene:transition];
}

@end
