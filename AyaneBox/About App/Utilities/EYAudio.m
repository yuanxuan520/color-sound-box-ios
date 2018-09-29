//
//  EYAudio.m
//  AyaneBox
//
//  Created by yuanxuan on 2018/7/30.
//  Copyright © 2018年 AyaneBox. All rights reserved.
//

#import "EYAudio.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <Accelerate/Accelerate.h>

#define MIN_SIZE_PER_FRAME (1024*2)   //每个包的大小,室内机要求为960,具体看下面的配置信息
#define QUEUE_BUFFER_SIZE  3      //缓冲器个数
#define SAMPLE_RATE        44100  //采样频率
@interface EYAudio(){
    AudioQueueRef audioQueue;                                 //音频播放队列
    AudioStreamBasicDescription _audioDescription;
    AudioQueueBufferRef audioQueueBuffers[QUEUE_BUFFER_SIZE]; //音频缓存
    BOOL audioQueueBufferUsed[QUEUE_BUFFER_SIZE];             //判断音频缓存是否在使用
    NSLock *sysnLock;
    NSMutableData *tempData;
    OSStatus osState;
    FFTSetup fftSetup;
    uint length;
}
@end
@implementation EYAudio
#pragma mark - 提前设置AVAudioSessionCategoryMultiRoute 播放和录音
+ (void)initialize
{
    NSError *error = nil;
    //只想要播放:AVAudioSessionCategoryPlayback
    //只想要录音:AVAudioSessionCategoryRecord
    //想要"播放和录音"同时进行 必须设置为:AVAudioSessionCategoryMultiRoute 而不是AVAudioSessionCategoryPlayAndRecord(设置这个不好使)
    BOOL ret = [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryMultiRoute error:&error];
    if (!ret) {
        NSLog(@"设置声音环境失败");
        return;
    }
    //启用audio session
    ret = [[AVAudioSession sharedInstance] setActive:YES error:&error];
    if (!ret)
    {
        NSLog(@"启动失败");
        return;
    }
}

- (void)resetPlay
{
    if (audioQueue != nil) {
        AudioQueueReset(audioQueue);
    }
}

- (void)stop
{
    if (audioQueue != nil) {
        AudioQueueStop(audioQueue,true);
    }
    
    audioQueue = nil;
    sysnLock = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        sysnLock = [[NSLock alloc]init];
        length = (uint)floor(log2(2048));
        
        fftSetup = vDSP_create_fftsetup(length, kFFTRadix2);
        //设置音频参数 具体的信息需要问后台
        _audioDescription.mSampleRate = 44100;
        _audioDescription.mFormatID = kAudioFormatLinearPCM;
        _audioDescription.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
        _audioDescription.mFramesPerPacket  = 1;
        _audioDescription.mChannelsPerFrame = 1;
        _audioDescription.mBytesPerFrame    = sizeof(short);
        _audioDescription.mBytesPerPacket   = sizeof(short);
        _audioDescription.mBitsPerChannel   = sizeof(short) * 8;
        
        // 使用player的内部线程播放 新建输出
        AudioQueueNewOutput(&_audioDescription, AudioPlayerAQInputCallback, (__bridge void * _Nullable)(self), nil, 0, 0, &audioQueue);

        // 设置音量
        AudioQueueSetParameter(audioQueue, kAudioQueueParam_Volume, 1.0);
        
        // 初始化需要的缓冲区
        for (int i = 0; i < QUEUE_BUFFER_SIZE; i++) {
            audioQueueBufferUsed[i] = false;
            AudioQueueAllocateBuffer(audioQueue, 1024*_audioDescription.mBytesPerFrame, &audioQueueBuffers[i]);
//            AudioQueueEnqueueBuffer(audioQueue, audioQueueBufferUsed[i], 0, nil);
        }
        
        osState = AudioQueueStart(audioQueue, NULL);
        if (osState != noErr) {
            NSLog(@"AudioQueueStart Error");
        }
    }
    return self;
}

- (instancetype)initWithVolume:(Float32)volume
{
    self = [super init];
    if (self) {
        sysnLock = [[NSLock alloc]init];
        length = (uint)floor(log2(2048));
        
        fftSetup = vDSP_create_fftsetup(length, kFFTRadix2);
        //设置音频参数 具体的信息需要问后台
        _audioDescription.mSampleRate = 44100;
        _audioDescription.mFormatID = kAudioFormatLinearPCM;
        _audioDescription.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
        _audioDescription.mFramesPerPacket  = 1;
        _audioDescription.mChannelsPerFrame = 1;
        _audioDescription.mBytesPerFrame    = sizeof(short);
        _audioDescription.mBytesPerPacket   = sizeof(short);
        _audioDescription.mBitsPerChannel   = sizeof(short) * 8;
        
        // 使用player的内部线程播放 新建输出
        AudioQueueNewOutput(&_audioDescription, AudioPlayerAQInputCallback, (__bridge void * _Nullable)(self), nil, 0, 0, &audioQueue);
        
//        CFRunLoopGetCurrent(), kCFRunLoopCommonModes
        // 设置音量
        AudioQueueSetParameter(audioQueue, kAudioQueueParam_Volume, volume);
        
        // 初始化需要的缓冲区
        for (int i = 0; i < QUEUE_BUFFER_SIZE; i++) {
            audioQueueBufferUsed[i] = false;
            osState = AudioQueueAllocateBuffer(audioQueue, 1024*_audioDescription.mBytesPerFrame, &audioQueueBuffers[i]);
//            AudioQueueEnqueueBuffer(audioQueue, audioQueueBufferUsed[i], 0, nil);
        }
        
        osState = AudioQueueStart(audioQueue, NULL);
        if (osState != noErr) {
            NSLog(@"AudioQueueStart Error");
        }
    }
    return self;
}

// 播放数据
-(void)playWithData:(NSData *)data
{
    [sysnLock lock];
    
    tempData = [NSMutableData new];
    [tempData appendData: data];
    NSUInteger len = tempData.length;
    Byte *bytes = (Byte*)malloc(len);
    [tempData getBytes:bytes length: len];
    
    int i = 0;
    while (true) {
        if (!audioQueueBufferUsed[i]) {
            audioQueueBufferUsed[i] = true;
            break;
        }else {
            i++;
            if (i >= QUEUE_BUFFER_SIZE) {
                i = 0;
            }
        }
    }
    
    audioQueueBuffers[i] -> mAudioDataByteSize =  (unsigned int)len;
    // 把bytes的头地址开始的len字节给mAudioData,向第i个缓冲器
    memcpy(audioQueueBuffers[i] -> mAudioData, bytes, len);
    
    // 释放对象
    free(bytes);
    
    //将第i个缓冲器放到队列中,剩下的都交给系统了
    AudioQueueEnqueueBuffer(audioQueue, audioQueueBuffers[i], 0, NULL);
    
    [sysnLock unlock];
}

// ************************** 回调 **********************************
// 回调回来把buffer状态设为未使用
static void AudioPlayerAQInputCallback(void* inUserData,AudioQueueRef audioQueueRef, AudioQueueBufferRef audioQueueBufferRef) {
//    __weak EYAudio *playAudio = (__bridge AudioRecorder *) refToSelf;

    EYAudio* audio = (__bridge EYAudio*)inUserData;
    short* samples = (short*)audioQueueBufferRef->mAudioData;

    if ([audio sampleToEngineDelegate] != nil){
        [audio sampleToEngineDelegate](samples);
    }
    float* fftArray = [audio calculateFFT:samples size:2048];
    
    if ([audio spectrogramSamplesDelegate] != nil){
        [audio spectrogramSamplesDelegate](fftArray);
    }
    [audio resetBufferState:audioQueueRef and:audioQueueBufferRef];
}

- (void)resetBufferState:(AudioQueueRef)audioQueueRef and:(AudioQueueBufferRef)audioQueueBufferRef {
    // 防止空数据让audioqueue后续都不播放,为了安全防护一下
    if (tempData.length == 0) {
//        audioQueueBufferRef->mAudioDataByteSize = 1;
//        Byte* byte = audioQueueBufferRef->mAudioData;
//        byte = 0;
        AudioQueueEnqueueBuffer(audioQueue, audioQueueBufferRef, 0, NULL);
//        AudioQueueEnqueueBuffer(audioQueueRef, audioQueueBufferRef, 0, NULL);
    }
    
    for (int i = 0; i < QUEUE_BUFFER_SIZE; i++) {
        // 将这个buffer设为未使用
        if (audioQueueBufferRef == audioQueueBuffers[i]) {
            audioQueueBufferUsed[i] = false;
        }
    }
}

- (float*) calculateFFT: (short*)data size:(uint)numSamples{
    
    float *dataFloat = malloc(sizeof(float)*numSamples);
    vDSP_vflt16(data, 1, dataFloat, 1, numSamples);
    
    DSPSplitComplex tempSplitComplex;
    tempSplitComplex.imagp = malloc(sizeof(float)*(numSamples));
    tempSplitComplex.realp = malloc(sizeof(float)*(numSamples));
    
    DSPComplex *audioBufferComplex = malloc(sizeof(DSPComplex)*(numSamples));
    
    for (int i = 0; i < numSamples; i++) {
        audioBufferComplex[i].real = dataFloat[i];
        audioBufferComplex[i].imag = 0.0f;
    }
    
    vDSP_ctoz(audioBufferComplex, 2, &tempSplitComplex, 1, numSamples);
    
    vDSP_fft_zip(fftSetup, &tempSplitComplex, 1, length, FFT_FORWARD);
    
    float* result = malloc(sizeof(float)*numSamples);
    
    for (int i = 0 ; i < numSamples; i++) {
        
        float current = (sqrt(tempSplitComplex.realp[i]*tempSplitComplex.realp[i] + tempSplitComplex.imagp[i]*tempSplitComplex.imagp[i]) * 0.5);
        current = log10(current)*10;
        result[i] = current;
        
    }
    
    free(dataFloat);
    free(audioBufferComplex);
    free(tempSplitComplex.imagp);
    free(tempSplitComplex.realp);
    
    return result;
}

@end
