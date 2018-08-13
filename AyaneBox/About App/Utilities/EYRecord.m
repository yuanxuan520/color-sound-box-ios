//
//  EYRecord.m
//  AyaneBox
//
//  Created by yuanxuan on 2018/8/9.
//  Copyright © 2018年 AyaneBox. All rights reserved.
//

#import "EYRecord.h"
#import <AudioToolbox/AudioToolbox.h>
#import "PPFileOperate.h"
#import "Pcm2WavUtil.h"

#define QUEUE_BUFFER_SIZE 3      // 输出音频队列缓冲个数
#define kDefaultBufferDurationSeconds 0.03//调整这个值使得录音的缓冲区大小为960,实际会小于或等于960,需要处理小于960的情况
#define kDefaultSampleRate 44100   //定义采样率为16000

extern NSString * const ESAIntercomNotifationRecordString;

static BOOL isRecording = NO;

@interface EYRecord(){
    AudioQueueRef _audioQueue;                          //输出音频播放队列
    AudioStreamBasicDescription _recordFormat;
    AudioQueueBufferRef _audioBuffers[QUEUE_BUFFER_SIZE]; //输出音频缓存
}
@property (nonatomic, assign) BOOL isRecording;

@end
@implementation EYRecord
- (instancetype)init
{
    self = [super init];
    if (self) {
        //重置下
        memset(&_recordFormat, 0, sizeof(_recordFormat));
        _recordFormat.mSampleRate = kDefaultSampleRate;
        _recordFormat.mChannelsPerFrame = 1;
        _recordFormat.mFormatID = kAudioFormatLinearPCM;
        
        _recordFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
        _recordFormat.mBitsPerChannel = 16;
        _recordFormat.mBytesPerPacket = _recordFormat.mBytesPerFrame = (_recordFormat.mBitsPerChannel / 8) * _recordFormat.mChannelsPerFrame;
        _recordFormat.mFramesPerPacket = 1;
        
        [PCMDataSource sharedData].phoneOutFile04 = [NSMutableData dataWithCapacity:0];
        //初始化音频输入队列
        AudioQueueNewInput(&_recordFormat, inputBufferHandler, (__bridge void *)(self), NULL, NULL, 0, &_audioQueue);
        
        //计算估算的缓存区大小
        int frames = (int)ceil(kDefaultBufferDurationSeconds * _recordFormat.mSampleRate);
        int bufferByteSize = frames * _recordFormat.mBytesPerFrame;
        
        NSLog(@"缓存区大小%d",bufferByteSize);
        
        //创建缓冲器
        for (int i = 0; i < QUEUE_BUFFER_SIZE; i++){
            AudioQueueAllocateBuffer(_audioQueue, bufferByteSize, &_audioBuffers[i]);
            AudioQueueEnqueueBuffer(_audioQueue, _audioBuffers[i], 0, NULL);
        }
    }
    return self;
}

-(void)startRecording
{
    // 开始录音
    AudioQueueStart(_audioQueue, NULL);
    isRecording = YES;
}

void inputBufferHandler(void *inUserData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer, const AudioTimeStamp *inStartTime,UInt32 inNumPackets, const AudioStreamPacketDescription *inPacketDesc)
{
    if (inNumPackets > 0) {
        EYRecord *recorder = (__bridge EYRecord*)inUserData;
        [recorder processAudioBuffer:inBuffer withQueue:inAQ];
    }
    
    if (isRecording) {
        AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
    }
}

- (void)processAudioBuffer:(AudioQueueBufferRef )audioQueueBufferRef withQueue:(AudioQueueRef )audioQueueRef
{
    NSMutableData * dataM = [NSMutableData dataWithBytes:audioQueueBufferRef->mAudioData length:audioQueueBufferRef->mAudioDataByteSize];
    
    if (dataM.length < 960) { //处理长度小于960的情况,此处是补00
        Byte byte[] = {0x00};
        NSData * zeroData = [[NSData alloc] initWithBytes:byte length:1];
        for (NSUInteger i = dataM.length; i < 960; i++) {
            [dataM appendData:zeroData];
        }
    }
    [[PCMDataSource sharedData].phoneOutFile04 appendData:dataM];
    // NSLog(@"实时录音的数据--%@", dataM);
    //此处是发通知将dataM 传递出去
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EYRecordNotifacation" object:@{@"data" : dataM}];
}

-(void)stopRecording
{
    if (isRecording)
    {
        isRecording = NO;
        PPFileOperate *ppfileop = [[PPFileOperate alloc] init];
        NSString *filePath = [ppfileop getDirName:@"wavFile" fileName:@"ceshiwenjian.pcm"];
        NSString *newfilePath = [ppfileop getDirName:@"wavFile" fileName:@"ceshiwenjian.wav"];
        char *cFilePath = (char *)[filePath UTF8String];
        char *cNewfilePath = (char *)[newfilePath UTF8String];
        NSLog(@"%@",[PCMDataSource sharedData].phoneOutFile04);
        NSLog(@"%@",newfilePath);
        [[PCMDataSource sharedData].phoneOutFile04 writeToFile:filePath atomically:NO];
        convertPcm2Wav(cFilePath,cNewfilePath,1,44100);
        //停止录音队列和移除缓冲区,以及关闭session，这里无需考虑成功与否
        AudioQueueStop(_audioQueue, true);
        //移除缓冲区,true代表立即结束录制，false代表将缓冲区处理完再结束
        AudioQueueDispose(_audioQueue, true);
    }
    NSLog(@"停止录音");
}

@end
