//
//  TitleLayer.h
//  LoopyLooper
//
//  Created on 12/01/28.
//  Copyright (c) 2012 All rights reserved.
//

#import "KWLayer.h"

@interface TitleLayer : KWLayer{
  /*
   CCLabelTTF* label_;
   */
  CCScene* nextScene;
  CCMenuItemFont* start_;
  CCMenu* menu_;
}

@property(readwrite, retain) CCScene* nextScene;
- (void)toMain:(id)sender;
-(void)toResult:(id)sender;
@end
