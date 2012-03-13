//
//  HowtoLayer.m
//  LoopyLooper
//
//  Created by  on 2012/2/16.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "HowtoLayer.h"
#import "ObjectAL.h"

@implementation HowtoLayer

- (id)init {
  self.backgroundColor = ccc4(0, 0, 0, 200);
  self = [super init];
  if (self) {
    CCDirector* director = [CCDirector sharedDirector];
  
    CCSprite* background = [CCSprite spriteWithFile:@"menu.png"];
    background.position = director.screenCenter;
    [self addChild:background];
    
    NSDictionary* data = [[KKLua loadLuaTableFromFile:@"howto.lua"] objectForKey:@"ja"];
    NSMutableArray* messages = [NSMutableArray array];
    for (int i = 0; i < (int)[data count]; ++i) {
      [messages addObject:[data objectForKey:[NSString stringWithFormat:@"%d", i + 1]]];
    }
    CCSprite* loopy = [CCSprite spriteWithFile:@"cut_in_boss1.png"];
    loopy.position = ccp(director.screenCenter.x, 585);
    [self addChild:loopy];
    
    CCSprite* window = [CCSprite spriteWithFile:@"menu_background.png"];
    window.position = ccp(director.screenCenter.x, 220);
    [self addChild:window];
    
    messageWindow_ = [[KWMessageWindow alloc] initWithMessages:messages
                                                      fontName:@"HiraKakuProN-W6" 
                                                      fontSize:24 
                                                          size:CGSizeMake(400, 300)];
    messageWindow_.delegate = self;
    messageWindow_.position = ccp(window.contentSize.width / 4, window.contentSize.height / 2);
    [window addChild:messageWindow_];
    
    illustration_ = [CCSprite spriteWithFile:@"howto0.png"];
    illustration_.position = ccp(window.contentSize.width / 4 * 3, window.contentSize.height / 2);
    [window addChild:illustration_];
    
    self.isTouchEnabled = YES;
  }
  return self;
}

- (void)onEnter {
  [super onEnter];
  [OALSimpleAudio sharedInstance].bgVolume = 0.5;
}

- (void)onExit {
  [super onExit];
  [OALSimpleAudio sharedInstance].bgVolume = 1.0;
}

- (void)didUpdateText:(id)messageWindow text:(NSString *)text {
}

- (void)didCompleteMessage:(id)messageWindow text:(NSString *)text {
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
  return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
  if ([messageWindow_ isEndMessages]) {
    [[CCDirector sharedDirector] popScene];
  }
  messageWindow_.currentMessageIndex += 1;
}

@end
