//
//  TitleLayer.h
//  LoopyLooper
//
//  Created by 片ノ坂 卓磨 on 12/01/28.
//  Copyright (c) 2012 北海道大学大学院 情報科学研究科 複合情報学専攻 表現系工学研究室. All rights reserved.
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
-(void)toMain:(id)sender;
@end
