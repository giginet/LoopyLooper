/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim. 
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */

#import "AppDelegate.h"
#import "MainLayer.h"

@implementation AppDelegate

-(void) initializationComplete
{
#ifdef KK_ARC_ENABLED
  CCLOG(@"ARC is enabled");
#else
  CCLOG(@"ARC is either not available or not enabled");
#endif
}

-(id) alternateRootViewController
{
  return nil;
}

-(id) alternateView
{
  return nil;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  [super applicationWillResignActive:application];
  CCDirector* director = [CCDirector sharedDirector];
  CCScene* scene = director.runningScene;
  if ([[scene.children objectAtIndex:0] isKindOfClass:[MainLayer class]]) {
    MainLayer* main = (MainLayer*)[scene.children objectAtIndex:0];
    [main pause];
  }
}

@end
