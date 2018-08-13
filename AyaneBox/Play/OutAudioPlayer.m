//
//  OutAudioPlayer.m
//  AyaneBox
//
//  Created by yuanxuan on 2018/7/30.
//  Copyright © 2018年 AyaneBox. All rights reserved.
//

#import "OutAudioPlayer.h"
#import <AudioToolbox/AudioToolbox.h>

@interface OutAudioPlayer()
{
    AudioFileStreamID _audioFileStreamID; // 当前文件流句柄
    NSMutableArray *_dataArray;           // 当前data数据流
    AudioStreamBasicDescription _audioStreamDescription; // 音频流描述结构
    AudioQueueRef _outputQueue; // 输出队列
    NSInteger _readPacketIndex; // 当前读取的帧的Index
}

@end
@implementation OutAudioPlayer

//歌曲信息解析的回调，每次解析出一个歌曲信息，都会执行一次回调
void audioFileStreamPropertyListenerProc(void *inClientData,AudioFileStreamID    inAudioFileStream,AudioFileStreamPropertyID    inPropertyID,AudioFileStreamPropertyFlags *    ioFlags)
{
    OutAudioPlayer *self  = (__bridge OutAudioPlayer *)(inClientData); // 当前上下文
    [self audioFileStreamPropertyListenerProc:inClientData inAudioFileStream:inAudioFileStream inPropertyID:inPropertyID ioFlags:ioFlags];
    
}
-(void) audioFileStreamPropertyListenerProc:(void *)inClientData inAudioFileStream:(AudioFileStreamID)inAudioFileStream inPropertyID:(AudioFileStreamPropertyID)    inPropertyID ioFlags:(AudioFileStreamPropertyFlags *)ioFlags
{
    if (inPropertyID ==  kAudioFileStreamProperty_DataFormat) {
        UInt32 outDataSize = sizeof(AudioStreamBasicDescription);
        // AudioStreamBasicDescription audioStreamDescription;
        AudioFileStreamGetProperty(inAudioFileStream, inPropertyID,  &outDataSize, &_audioStreamDescription);
        [self _createAudioQueueWithAudioStreamDescription];
    }
}
// 读取文件大小
void audioFileStreamPacketsProc(void *inClientData,UInt32 inNumberBytes,UInt32 inNumberPackets,const void *inInputData,AudioStreamPacketDescription    *inPacketDescriptions){
    OutAudioPlayer *self  = (__bridge OutAudioPlayer *)(inClientData) ;
    [self _storePacketsWithNumberOfBytes:inNumberBytes numberOfPackets:inNumberPackets inputData:inInputData packetDescriptions:inPacketDescriptions];
}
// 存储包数据
- (void)_storePacketsWithNumberOfBytes:(UInt32)inNumberBytes numberOfPackets:(UInt32)inNumberPackets inputData:(const void *)inInputData packetDescriptions:(AudioStreamPacketDescription *)inPacketDescriptions
{
    if (inPacketDescriptions) {
        for (int i = 0; i < inNumberPackets; i++) {
            SInt64 packetStart = inPacketDescriptions[i].mStartOffset;
            UInt32 packetSize = inPacketDescriptions[i].mDataByteSize;
            NSData *packet = [NSData dataWithBytes:inInputData +packetStart length:packetSize];
            [_dataArray addObject:packet];
        }
    }else{
        UInt32  packetsSize = inNumberBytes/inNumberPackets;
        for (int i = 0; i < inNumberPackets; i++) {
            NSData *packet = [NSData dataWithBytes:inInputData+packetsSize*(i+1) length:packetsSize];
            [_dataArray addObject:packet];
        }
    }
    // 当前的包等于0
    if (_readPacketIndex == 0 && _dataArray.count > (int)([self packetsPerSecond]*2)) {
        OSStatus status = AudioQueueStart(_outputQueue, NULL);
        assert(status == noErr);
        [self _enqueueDataWithPacketsCount:(int)([self packetsPerSecond]*2)];
    }
}
// 创建输出项
- (void)_createAudioQueueWithAudioStreamDescription
{
    OSStatus status = AudioQueueNewOutput(&_audioStreamDescription, audioQueueCallback, (__bridge void *)(self), NULL, kCFRunLoopCommonModes, 0, &_outputQueue);
    assert(status == noErr);
}
// 队列回调 音频播放完后
void audioQueueCallback(void * __nullable inUserData,AudioQueueRef inAQ,AudioQueueBufferRef  inBuffer)
{
    OSStatus status = AudioQueueFreeBuffer(inAQ, inBuffer);
    assert(status == noErr);
    OutAudioPlayer *self  = (__bridge OutAudioPlayer *)(inUserData);
    [self _enqueueDataWithPacketsCount:(int)([self packetsPerSecond]*2)];
}

-(UInt32)packetsPerSecond{ //采样率/每帧数量
    return _audioStreamDescription.mSampleRate / _audioStreamDescription.mFramesPerPacket;
}

- (void)_enqueueDataWithPacketsCount:(size_t)inPacketCount
{
    if (!_outputQueue) {  // 输出数组未初始化
        return;
    }
    if (_readPacketIndex + inPacketCount >= _dataArray.count) {
        inPacketCount = _dataArray.count - _readPacketIndex;
    }
    
    if (inPacketCount<=0) {
        AudioQueueStop(_outputQueue, false);
        AudioFileStreamClose(_audioFileStreamID);
        return;
    }
    UInt32 totalSize = 0;
    for (UInt32 index = 0; index<inPacketCount; index++) {
        NSData  *data= [_dataArray objectAtIndex:index+_readPacketIndex];
        totalSize += data.length;
    }
    
    OSStatus status = 0;
    AudioQueueBufferRef outBuffer;
    status = AudioQueueAllocateBuffer(_outputQueue, totalSize, &outBuffer);
    assert(status == noErr);
    
    outBuffer->mAudioDataByteSize = totalSize;
    outBuffer->mUserData = (__bridge void * _Nullable)(self);
    AudioStreamPacketDescription *inPacketDescriptions = calloc(inPacketCount, sizeof(AudioStreamPacketDescription));
    //    从0开始 把音频数据读到的Data数据读到内存缓冲区中
    UInt32 startOffset = 0;
    for (int  i = 0; i<inPacketCount; i++) {
        NSData *data = [_dataArray objectAtIndex:i+_readPacketIndex];
        memcpy(outBuffer->mAudioData+startOffset, [data bytes], [data length]);
        AudioStreamPacketDescription packetDescriptions ;
        packetDescriptions.mDataByteSize = (UInt32)data.length;
        packetDescriptions.mStartOffset = startOffset;
        packetDescriptions.mVariableFramesInPacket = 0;
        startOffset += data.length;
        memcpy(&inPacketDescriptions[i], &packetDescriptions, sizeof(AudioStreamPacketDescription));
    }
    status = AudioQueueEnqueueBuffer(_outputQueue, outBuffer, (UInt32)inPacketCount, inPacketDescriptions);
    assert(status == noErr);
    free(inPacketDescriptions);
    _readPacketIndex += inPacketCount;
}

- (void)createPlay
{
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    //  创建文件输出流
    AudioFileStreamOpen((__bridge void * _Nullable)(self), audioFileStreamPropertyListenerProc, audioFileStreamPacketsProc, 0, &_audioFileStreamID);
    //    NSURLSession *session  =  [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    ////    NSString *wavString = @"http://baxiang.qiniudn.com/VoiceOriginFile.wav";// wav文件
    //    NSString *mp3String = @"http://baxiang.qiniudn.com/chengdu.mp3";// mp3文件
    //    NSURLSessionDataTask * task =  [session dataTaskWithURL:[NSURL URLWithString:mp3String]];
    //    [task resume];
//    NSString *fileBounld = [[NSBundle mainBundle] pathForResource:@"simple-drum-beat" ofType:@"wav"];
//    NSData *data = [NSData dataWithContentsOfFile:fileBounld];
//    [self play:data];
//    AudioFileStreamParseBytes(_audioFileStreamID,  (UInt32)[data length], [data bytes], 0);
}

- (void)play:(NSData *)data
{
    AudioFileStreamParseBytes(_audioFileStreamID,  (UInt32)[data length], [data bytes], 0);
    NSLog(@"play:%@",data);
}

- (void)stop{
    AudioQueueStop(_outputQueue, false);
    AudioFileStreamClose(_audioFileStreamID);
}
@end
