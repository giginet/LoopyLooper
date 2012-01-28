//
//  TitleLayer.m
//  LoopyLooper
//
//  Created by 片ノ坂 卓磨 on 12/01/28.
//  Copyright (c) 2012 北海道大学大学院 情報科学研究科 複合情報学専攻 表現系工学研究室. All rights reserved.
//

#import "TitleLayer.h"
#import "MainLayer.h"

@implementation TitleLayer
@synthesize nextScene = nextScene_;

- (id)init {
  self = [super init];
  if (self) {
    /*
     label_ = [CCLabelTTF labelWithString:@"" 
     fontName:@"Helvetica" 
     fontSize:13];
     CCDirector* director = [CCDirector sharedDirector];
     label_.position = director.screenCenter;
     [self addChild:label_];
     MotionDetector* detector = [MotionDetector shared];
     [detector setOnDetection:self selector:@selector(detectMotion:)];
     */  
    
    self.isTouchEnabled = YES;
    self.nextScene = [MainLayer nodeWithScene];
    
    CCDirector* director = [CCDirector sharedDirector];
    
    [CCMenuItemFont setFontName:@"Helvetica"];
    [CCMenuItemFont setFontSize:40];
    
    start_ = [CCMenuItemFont itemFromString:@"START"
                                     target:self
                                   selector:@selector(toMain:)];
    
    menu_ = [CCMenu menuWithItems:start_, nil];
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
/*
 - (void)detectMotion:(Motion *)motion {
 if (motion.motionType == MotionTypeLeftPitch) {
 [label_ setString:@"Left"];
 } else if (motion.motionType == MotionTypeRightPitch) {
 [label_ setString:@"Right"];
 } else if (motion.motionType == MotionTypeBackForth) {
 NSLog(@"前後");
 } else if (motion.motionType == MotionTypeRoll) {
 NSLog(@"roll");
 } else if (motion.motionType == MotionTypeNone) {
 [label_ setString:@""];
 }
 }
 */
@end
