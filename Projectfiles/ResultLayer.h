//
//  ResultLayer.h
//  LoopyLooper
//
//  Created on 12/01/28.
//  Copyright (c) 2012 All rights reserved.
//

#import "KWLayer.h"

@interface ResultLayer : KWLayer{
    CCLabelTTF* scoreLabel_;
}
@property(readwrite, retain) CCLabelTTF* scoreLabel;
- (id)initWithScore:(NSInteger)score;
-(void)toTitle:(id)sender;
-(void)toMain:(id)sender;
@end
