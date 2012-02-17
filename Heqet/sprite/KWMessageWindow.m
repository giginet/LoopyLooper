//
//  KWMessageWindow.m
//  LoopyLooper
//
//  Created by  on 2012/2/17.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "KWMessageWindow.h"

@interface KWMessageWindow()
- (void)update:(ccTime)dt;
- (void)updateMessage;
- (void)onCompleteMessage;
@end

@implementation KWMessageWindow
@synthesize currentMessageIndex = currentMessageIndex_;
@synthesize currentTextIndex = currentTextIndex_;
@synthesize messageSpeed = messageSpeed_;
@synthesize touchToSkip;
@dynamic currentMessage;
@synthesize messageLabel = messageLabel_;
@synthesize delegate;

- (id)init {
  self = [super init];
  if (self) {
    self.isTouchEnabled = YES;
    self.currentTextIndex = 0;
    self.currentMessageIndex = 0;
    self.messageSpeed = 1.0 / [[KKStartupConfig config] maxFrameRate];
    messages_ = [NSMutableArray array];
    timer_ = [KWTimer timerWithMax:self.messageSpeed];
    timer_.looping = YES;
    [timer_ setOnCompleteListener:self selector:@selector(updateMessage)];
  }
  return self;
}

- (id)initWithMessages:(NSArray *)messages 
              fontName:(NSString *)fontName 
              fontSize:(double)fontSize 
                  size:(CGSize)size {
  self = [self init];
  if (self) {
    messages_ = [NSMutableArray arrayWithArray:messages];
    messageLabel_ = [CCLabelTTF labelWithString:@"" 
                                     dimensions:size
                                      alignment:UITextAlignmentLeft
                                  lineBreakMode:UILineBreakModeCharacterWrap
                                       fontName:fontName 
                                       fontSize:fontSize];
    self.contentSize = size;
    [self addChild:messageLabel_];
  }
  return self;
}

- (BOOL)isEndMessage {
  return self.currentTextIndex >= (int)[self currentMessageLength];
}

- (BOOL)isEndMessages {
  return self.currentMessageIndex >= (int)[messages_ count];
}

- (NSInteger)currentMessageLength {
  return [(NSString*)[messages_ objectAtIndex:self.currentMessageIndex] length];
}

- (void)update:(ccTime)dt {
}

- (void)updateMessage {
  [self setCurrentTextIndex:self.currentTextIndex + 1];
  NSString* text = [(NSString*)[messages_ objectAtIndex:currentMessageIndex_] substringWithRange:NSMakeRange(self.currentTextIndex - 1, 1)];
  [self.delegate didUpdateText:self text:text];
  if ([self isEndMessage]) {
    [self onCompleteMessage];
    [timer_ stop];
  }
}

- (void)onCompleteMessage {
  [self.delegate didCompleteMessage:self text:self.currentMessage];
}

- (NSString*)currentMessage {
  return [(NSString*)[messages_ objectAtIndex:currentMessageIndex_] substringToIndex:currentTextIndex_];
}

- (double)messageSpeed {
  return messageSpeed_;
}

- (void)setMessageSpeed:(double)messageSpeed {
  messageSpeed_ = messageSpeed;
  [timer_ set:messageSpeed];
}

- (int)currentTextIndex {
  return currentTextIndex_;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  //[self.delegate didTouchEnd:self touch:];
  if (touchToSkip && timer_.active) {
    self.currentTextIndex = (int)[[messages_ objectAtIndex:currentMessageIndex_] length] - 1;
  } else if(!timer_.active) {
    self.currentTextIndex = 0;
    if (![self isEndMessages]) {
      self.currentMessageIndex += 1;
    }
  }
}

- (void)setCurrentTextIndex:(int)currentTextIndex {
  if(currentTextIndex > (int)[[messages_ objectAtIndex:currentMessageIndex_] length] || currentTextIndex < 0) return;
  currentTextIndex_ = currentTextIndex;
  [messageLabel_ setString:self.currentMessage];
}

- (int)currentMessageIndex {
  return currentMessageIndex_;
}

- (void)setCurrentMessageIndex:(int)currentMessageIndex {
  if(currentMessageIndex >= (int)[messages_ count] || currentMessageIndex < 0) return;
  currentMessageIndex_ = currentMessageIndex;
  self.currentTextIndex = 0;
  [messageLabel_ setString:self.currentMessage];
}

- (void)onEnter {
  [timer_ play];
}

@end
