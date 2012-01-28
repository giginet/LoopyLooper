//
//  MainLayer.h
//  LoopyLooper
//
//  Created by  on 1/28/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "KWLayer.h"
#import "LoopManager.h"

@interface MainLayer : KWLayer {
  CCLabelTTF* label_;
  LoopManager* manager_;
}
-(void)toResult:(id)sender;
@end
