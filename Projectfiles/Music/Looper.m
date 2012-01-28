//
//  Looper.m
//  LoopyLooper
//
//  Created by on 12/01/28.
//  Copyright (c) 2012 All rights reserved.
//

#import "Looper.h"

@implementation Looper

-(id)init:(NSString*) format{
  self = [super init];
  if (self) {
    loop_music_num = 0;
    path_format = format;
    backgroundTrack.delegate = self;
    manager = [OALSimpleAudio sharedInstance]; 
  }
  return self;
}

-(void)setLoopMusicNum:(NSInteger) num{
  loop_music_num = num;
}

-(void)startLooper{
  if (![manager playBg:[NSString stringWithFormat: @"%d", loop_music_num]]) {}
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
  if (!flag) {
    return;
  }
  if (![manager playBg:[NSString stringWithFormat: @"%d", loop_music_num]]) {}
}
@end
