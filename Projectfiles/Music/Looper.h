//
//  Looper.h
//  LoopyLooper
//
//  Created by on 12/01/28.
//  Copyright (c) 2012 All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectAL.h"

@interface Looper : OALSimpleAudio <AVAudioPlayerDelegate>{
  OALSimpleAudio* manager;
  NSInteger loop_music_num;
  NSString* path_format;
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;
@end
