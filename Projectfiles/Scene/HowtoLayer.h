//
//  HowtoLayer.h
//  LoopyLooper
//
//  Created by  on 2012/2/16.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "heqet.h"
#import "KWLayer.h"

@interface HowtoLayer : KWLayer <KWMessageWindowDelegate> {
  CCSprite* illustration_;
  KWMessageWindow* messageWindow_;
}

@end
