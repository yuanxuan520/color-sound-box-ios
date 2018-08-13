//
//  PCMPlayer.m
//  AyaneBox
//
//  Created by yuanxuan on 2018/7/24.
//  Copyright © 2018年 AyaneBox. All rights reserved.
//

#import "PCMPlayer.h"
const AudioStreamBasicDescription singleChannelDesc = {
    44100,
    kAudioFormatLinearPCM,
    kAudioFormatFlagIsSignedInteger,
    1, // mFramesPerPacket
    1, // mChannelsPerFrame
    sizeof(int), // mBytesPerFrame
    sizeof(int), // mBytesPerPacket
    sizeof(int) * 8, // mBitsPerChannel
};
static void sAudioQueueOutputCallback (
                                       void *                  inUserData,
                                       AudioQueueRef           inAQ,
                                       AudioQueueBufferRef     inBuffer);

@interface PCMPlayer(){
    
    NSCondition *mAudioLock;
    AudioQueueRef mAudioPlayer;
    AudioQueueBufferRef mAudioBufferRef[QUEUE_BUFFER_SIZE];
    void *mPCMData;
    int mDataLen;
    
}
@end

@implementation PCMPlayer
-(BOOL)start{
    
    mPCMData = malloc(MAX_BUFFER_SIZE);
    mAudioLock = [[NSCondition alloc]init];
    
    AudioQueueNewOutput(&singleChannelDesc, sAudioQueueOutputCallback, (__bridge void *)(self), nil, nil, 0, &mAudioPlayer);
    
    for(int i=0;i<QUEUE_BUFFER_SIZE;i++)
    {
        AudioQueueAllocateBuffer(mAudioPlayer, AUDIO_BUFFER_SIZE, &mAudioBufferRef[i]);
        memset(mAudioBufferRef[i]->mAudioData, 0, AUDIO_BUFFER_SIZE);
        mAudioBufferRef[i]->mAudioDataByteSize = AUDIO_BUFFER_SIZE;
        AudioQueueEnqueueBuffer(mAudioPlayer, mAudioBufferRef[i], 0, NULL);
    }
    
    AudioQueueSetParameter(mAudioPlayer, kAudioQueueParam_Volume, 1.0);
    AudioQueueStart(mAudioPlayer, NULL);
    return YES;
}

-(void)play:(NSData *)data{
    [mAudioLock lock];
    int len = (int)[data length];
    if (len > 0 && len + mDataLen < MAX_BUFFER_SIZE) {
        memcpy(mPCMData+mDataLen, [data bytes],[data length]);
        mDataLen += AUDIO_BUFFER_SIZE;
    }
    [mAudioLock unlock];
}


-(void)stop{
    
    AudioQueueStop(mAudioPlayer, YES);
    for (int i = 0; i < QUEUE_BUFFER_SIZE; i++) {
        AudioQueueFreeBuffer(mAudioPlayer, mAudioBufferRef[i]);
    }
    AudioQueueDispose(mAudioPlayer, YES);
    
    free(mPCMData);
    mPCMData = nil;
    mAudioPlayer = nil;
    mAudioLock = nil;
    
}

-(void)handlerOutputAudioQueue:(AudioQueueRef)inAQ inBuffer:(AudioQueueBufferRef)inBuffer
{
    BOOL isFull = NO;
    if( mDataLen >=  AUDIO_BUFFER_SIZE)
    {
        [mAudioLock lock];
        memcpy(inBuffer->mAudioData, mPCMData, AUDIO_BUFFER_SIZE);
        mDataLen -= AUDIO_BUFFER_SIZE;
        memmove(mPCMData, mPCMData+AUDIO_BUFFER_SIZE, mDataLen);
        [mAudioLock unlock];
        isFull = YES;
    }
    
    if (!isFull) {
        memset(inBuffer->mAudioData, 0, AUDIO_BUFFER_SIZE);
    }
    
    inBuffer->mAudioDataByteSize = AUDIO_BUFFER_SIZE;
    AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
    
}
@end

static void sAudioQueueOutputCallback (
                                       void *                  inUserData,
                                       AudioQueueRef           inAQ,
                                       AudioQueueBufferRef     inBuffer) {
    
    
    PCMPlayer *player = (__bridge PCMPlayer *)(inUserData);
    [player handlerOutputAudioQueue:inAQ inBuffer:inBuffer];
    
}
