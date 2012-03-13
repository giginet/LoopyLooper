//
//  MenuWindow.m
//  LoopyLooper
//
//  Created by  on 2012/2/28.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "MenuWindow.h"
#import "MainLayer.h"
#import "SaveManager.h"

@interface MenuWindow()
- (void)pressDifficultyButton:(id)sender;
- (void)onFinishedFadeOut:(id)sender;
- (void)updateLabels;
@end

@implementation MenuWindow
@synthesize musicID;
@synthesize difficulty;

- (id)initWithFile:(NSString *)filename {
  self = [super initWithFile:filename];
  if (self) {
    NSString* fontName = @"Helvetica";
    titleLabel_ = [CCLabelTTF labelWithString:@"Undefined" 
                                   dimensions:CGSizeMake(500, 80) 
                                    alignment:UITextAlignmentLeft 
                                     fontName:fontName 
                                     fontSize:56];
    titleLabel_.position = ccp(300, 300);
    [self addChild:titleLabel_];
    
    CCLabelTTF* hsLabel = [CCLabelTTF labelWithString:@"High Score" 
                                             fontName:fontName 
                                             fontSize:36];
    hsLabel.position = ccp(175, 220);
    hsLabel.color = ccc3(255, 255, 255);
    [self addChild:hsLabel];
    
    CCLayerColor* scoreBg = [CCLayerColor layerWithColor:ccc4(255, 255, 255, 255) width:240 height:40];
    scoreBg.position = ccp(280, 200);
    [self addChild:scoreBg];
    
    highScoreLabel_ = [CCLabelTTF labelWithString:@"0" 
                                       dimensions:CGSizeMake(200, 30) 
                                        alignment:UITextAlignmentRight 
                                         fontName:fontName 
                                         fontSize:24];
    highScoreLabel_.color = ccc3(0, 0, 0);
    highScoreLabel_.position = ccp(scoreBg.contentSize.width / 2, scoreBg.contentSize.height / 2);
    [scoreBg addChild:highScoreLabel_];
    
    const NSString* difficulties[] = {@"easy", @"normal", @"hard"};
    NSMutableArray* buttons = [NSMutableArray array];
    for (int i = 0; i < 3; ++i) {
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
      if (i == 0) {
        [button setSelectedIndex:1];
      }
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
    [self updateLabels];
    self.musicID = 1;
    self.difficulty = DifficultyEasy;
  }
  return self;
}

- (void)pressDifficultyButton:(id)sender {
  CCMenuItemToggle* button = (CCMenuItemToggle*)sender;
  [button setSelectedIndex:1];
  self.difficulty = (Difficulty)button.tag;
  for (int i = 0; i < 3; ++i) {
    if (button.tag != i) {
      CCMenuItemToggle* other = [difficultyMenu_.children objectAtIndex:i];
      [other setSelectedIndex:0];
    }
  }
}

- (void)onFinishedFadeOut:(id)sender {
  [[OALSimpleAudio sharedInstance] stopBg];
  [OALSimpleAudio sharedInstance].backgroundTrack.volume = 1.0;
  NSLog(@"%d %d", self.difficulty, self.musicID);
  MainLayer* mainLayer = [[MainLayer alloc] initWithMusicID:self.musicID dificulty:self.difficulty];
  CCScene* scene = [CCScene node];
  [scene addChild:mainLayer];
  CCTransitionFade* transition = [CCTransitionFade transitionWithDuration:0.5f 
                                                                    scene:scene];
  [[CCDirector sharedDirector] pushScene:transition];
}

- (void)updateLabels {
  NSDictionary* musicInfo = [[KKLua loadLuaTableFromFile:@"musics.lua"] objectForKey:[NSString stringWithFormat:@"%d", self.musicID]];
  NSString* title = [musicInfo objectForKey:@"title"];
  [titleLabel_ setString:title];
  int highScore = [[SaveManager shared] loadHighScore:self.musicID difficulty:self.difficulty];
  [highScoreLabel_ setString:[NSString stringWithFormat:@"%d", highScore]];
}

- (int)musicID {
  return musicID;
}

- (void)setMusicID:(int)mid {
  if (self.musicID != mid) {
    musicID = mid;
    [self updateLabels];
  }
}

@end
