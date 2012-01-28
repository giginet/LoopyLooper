//
//  MainLayer.m
//  LoopyLooper
//
//  Created by  on 1/28/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "MainLayer.h"
<<<<<<< HEAD
#import "ResultLayer.h"
=======
#import "MotionDetector.h"
#import "Motion.h"

@interface MainLayer()
- (void)detectMotion:(Motion*)motion;
@end
>>>>>>> 9b42225c3869bcd1fc8a7c99d266340b8cdcf675

@implementation MainLayer
@synthesize nextScene = nextScene_;

- (id)init {
  self = [super init];
  if (self) {
<<<<<<< HEAD
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
=======
    label_ = [CCLabelTTF labelWithString:@"" 
                                fontName:@"Helvetica" 
                                fontSize:13];
    CCDirector* director = [CCDirector sharedDirector];
    label_.position = director.screenCenter;
    [self addChild:label_];
    MotionDetector* detector = [MotionDetector shared];
    [detector setOnDetection:self selector:@selector(detectMotion:)];
  }
  return self;
}

- (void)update:(ccTime)dt {
}

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
>>>>>>> 9b42225c3869bcd1fc8a7c99d266340b8cdcf675
}
@end
