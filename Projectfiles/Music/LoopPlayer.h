//
//  Looper.h
//  LoopyLooper
//
//  Created by on 12/01/28.
//  Copyright (c) 2012 All rights reserved.
//

#import "heqet.h"

@interface LoopPlayer : NSObject <AVAudioPlayerDelegate>{
  NSInteger loopMusicNumber_;
  NSString* pathFormat_;
  OALSimpleAudio* manager_;
  OALAudioTrack* nextTrack_;
}

- (id)initWithFileFormat:(NSString*)format;
- (void)play;

@property NSInteger loopMusicNumber;

@end
