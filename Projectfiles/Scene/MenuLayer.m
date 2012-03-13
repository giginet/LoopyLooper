//
//  MenuLayer.m
//  LoopyLooper
//
//  Created by  on 2012/2/16.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "MenuLayer.h"
#import "MenuWindow.h"
#import "HowtoLayer.h"

@interface MenuLayer()
- (void)pressMusicButton:(id)sender;
- (void)pressHowtoButton:(id)sender;
@end

@implementation MenuLayer
@synthesize musicSelect;
@synthesize menuWindow;

- (id)init {
  self = [super init];
  if (self) {
    CCDirector* director = [CCDirector sharedDirector];
    CCSprite* background = [CCSprite spriteWithFile:@"menu.png"];
    background.position = director.screenCenter;
    [self addChild:background];
    
    self.menuWindow = [[MenuWindow alloc] initWithFile:@"menu_background.png"];
    self.menuWindow.position = ccp(director.screenSize.width / 2, 227);
    [self addChild:self.menuWindow];
    
    CCMenuItemImage* howtoItem = [CCMenuItemImage itemFromNormalImage:@"howto_button.png" 
                                                        selectedImage:@"howto_button_selected.png" 
                                                               target:self 
                                                             selector:@selector(pressHowtoButton:)];
    CCMenu* howtoMenu = [CCMenu menuWithItems:howtoItem, nil];
    howtoMenu.position = ccp(director.screenSize.width / 2, 
                             director.screenSize.height - howtoItem.contentSize.height / 2);
    [self addChild:howtoMenu];
    NSMutableArray* buttons = [NSMutableArray array];
    for (int i = 0; i < 3; ++i) {
      CCMenuItemToggle* button = [CCMenuItemToggle itemWithTarget:self 
                                                         selector:@selector(pressMusicButton:) 
                                                            items:[CCMenuItemImage itemFromNormalImage:@"music.png" 
                                                                                         selectedImage:@"music_selected.png"],
                                  [CCMenuItemImage itemFromNormalImage:@"music_selected.png" 
                                                         selectedImage:@"music.png"],
                                  nil];
      button.tag = i;
      if (i == 0) {
        [button setSelectedIndex:1];
      }
      [buttons addObject:button];
    }
    self.musicSelect = [CCMenu menuWithItems:
                        [buttons objectAtIndex:0], 
                        [buttons objectAtIndex:1], 
                        [buttons objectAtIndex:2], nil];
    self.musicSelect.position = ccp(512, 560);
    [self.musicSelect alignItemsHorizontallyWithPadding:50];
    [self addChild:self.musicSelect];
  }
  return self;
}

- (void)pressMusicButton:(id)sender {
  CCMenuItemToggle* button = (CCMenuItemToggle*)sender;
  [button setSelectedIndex:1];
  self.menuWindow.musicID = button.tag + 1;
  for (int i = 0; i < 3; ++i) {
    if (button.tag != i) {
      CCMenuItemToggle* other = [self.musicSelect.children objectAtIndex:i];
      [other setSelectedIndex:0];
    }
  }
}

- (void)pressHowtoButton:(id)sender {
  CCScene* scene = [HowtoLayer nodeWithScene];
  CCTransitionFade* transition = [CCTransitionFade transitionWithDuration:0.5f 
                                                                    scene:scene];
  [[CCDirector sharedDirector] pushScene:transition];
}

@end
