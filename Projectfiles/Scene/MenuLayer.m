//
//  MenuLayer.m
//  LoopyLooper
//
//  Created by  on 2012/2/16.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "MenuLayer.h"
#import "MenuWindow.h"

@interface MenuLayer()
- (void)pressMusicButton:(id)sender;
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
                                                                block:^(id sender) {
    }];
    CCMenu* howtoMenu = [CCMenu menuWithItems:howtoItem, nil];
    howtoMenu.position = ccp(director.screenSize.width / 2, 
                             director.screenSize.height - howtoItem.contentSize.height / 2);
    [self addChild:howtoMenu];
    
    CCMenuItemImage* music0 = [CCMenuItemImage itemFromNormalImage:@"music.png" 
                                                     selectedImage:@"music_selected.png" 
                                                            target:self 
                                                          selector:@selector(pressMusicButton:)];
    music0.tag = 0;
    CCMenuItemImage* music1 = [CCMenuItemImage itemFromNormalImage:@"music.png" 
                                                     selectedImage:@"music_selected.png" 
                                                            target:self 
                                                          selector:@selector(pressMusicButton:)];
    music1.tag = 1;
    CCMenuItemImage* music2 = [CCMenuItemImage itemFromNormalImage:@"music.png" 
                                                     selectedImage:@"music_selected.png" 
                                                            target:self 
                                                          selector:@selector(pressMusicButton:)];
    music2.tag = 2;
    self.musicSelect = [CCMenu menuWithItems:music0, music1, music2, nil];
    self.musicSelect.position = ccp(512, 560);
    [self.musicSelect alignItemsHorizontallyWithPadding:50];
    [self addChild:self.musicSelect];
  }
  return self;
}

- (void)pressMusicButton:(id)sender {
  
}

@end
