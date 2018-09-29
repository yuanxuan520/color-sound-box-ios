//
//  EYAudio.h
//  AyaneBox
//
//  Created by yuanxuan on 2018/7/30.
//  Copyright © 2018年 AyaneBox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioRecorder.h"
#define NUM_BUFFERS 30
typedef struct
{
    AudioStreamBasicDescription dataFormat;
    AudioQueueRef               queue;
    AudioQueueBufferRef         buffers[NUM_BUFFERS];
    AudioFileID                 audioFile;
    SInt64                      currentPacket;
    bool                        playing;
}PlayState;

@interface EYAudio : NSObject{
    PlayState playState;
}
@property samplesToEngine sampleToEngineDelegate;
@property samplesToEngineFloat spectrogramSamplesDelegate;
- (instancetype)initWithVolume:(Float32)volume;
// 播放的数据流数据
- (void)playWithData:(NSData *)data;

// 声音播放出现问题的时候可以重置一下
- (void)resetPlay;

// 停止播放
- (void)stop;

@end
