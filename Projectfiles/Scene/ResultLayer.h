//
//  ResultLayer.h
//  LoopyLooper
//
//  Created on 12/01/28.
//  Copyright (c) 2012 All rights reserved.
//

#import "KWLayer.h"
#import "RetryLayer.h"

@interface ResultLayer : RetryLayer {
    CCLabelTTF* scoreLabel_;
}

@property(readwrite, retain) CCLabelTTF* scoreLabel;

- (id)initWithScore:(NSInteger)score;

@end
