//
//  MenuLayer.h
//  LoopyLooper
//
//  Created by  on 2012/2/16.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "KWLayer.h"
#import "MenuWindow.h"

@interface MenuLayer : KWLayer {
}

@property(readwrite, strong) CCMenu* musicSelect;
@property(readwrite, strong) MenuWindow* menuWindow;

@end
