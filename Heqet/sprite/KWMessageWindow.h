//
//  KWMessageWindow.h
//  LoopyLooper
//
//  Created by  on 2012/2/17.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "CCNode.h"
#import "KWTimer.h"
#import "KWMessageWindowDelegate.h"

@interface KWMessageWindow : CCLayer {
  int currentMessageIndex_;
  int currentTextIndex_;
  double messageSpeed_;
  NSMutableArray* messages_;
  CCLabelTTF* messageLabel_;
  KWTimer* timer_;
}

- (id)initWithMessages:(NSArray*)messages 
              fontName:(NSString*)fontName 
              fontSize:(double)fontSize 
                  size:(CGSize)size;
- (BOOL)isEndMessage;
- (BOOL)isEndMessages;
- (NSInteger)currentMessageLength;

@property(readwrite) int currentMessageIndex;
@property(readwrite) int currentTextIndex;
@property(readwrite) double messageSpeed;
@property(readwrite) BOOL touchToSkip;
@property(readonly, copy) NSString* currentMessage;
@property(readonly, strong) CCLabelTTF* messageLabel;
@property(readwrite, weak) id<KWMessageWindowDelegate> delegate;

@end
