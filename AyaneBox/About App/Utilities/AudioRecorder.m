//
//  AudioRecorder.m
//  AudioAnalyzer
//
//  Created by Yaroslav Pelyukh on 2/23/17.
//  Copyright © 2017 Yaroslav Pelyukh. All rights reserved.
//

#import "AudioRecorder.h"
#import <Accelerate/Accelerate.h>

#define AUDIO_DATA_TYPE_FORMAT int

@implementation AudioRecorder{
    FFTSetup fftSetup;
    uint length;
    float _max;
    float _min;
}

void *refToSelf;

@synthesize sampleToEngineDelegate;
@synthesize fftSamplesDelegate;
@synthesize spectrogramSamplesDelegate;
@synthesize samplesToEngineDataDelegate;
void AudioInputCallback(void * inUserData,
                        AudioQueueRef inAQ,
                        AudioQueueBufferRef inBuffer,
                        const AudioTimeStamp * inStartTime,
                        UInt32 inNumberPacketDescriptions,
                        const AudioStreamPacketDescription * inPacketDescs) {
    
    __weak AudioRecorder *rec = (__bridge AudioRecorder *) refToSelf;
    RecordState * recordState = (RecordState*)inUserData;
    
    if (!recordState->recording) {
        return;
    }
    
    AudioQueueEnqueueBuffer(recordState->queue, inBuffer, 0, NULL);
    
    rec.runningTimeInterval = [NSDate date];
//    short* samples = (short*)inBuffer->mAudioData;
    if (inNumberPacketDescriptions != 2048) {
        return;
    }
    NSData *bufferData = [NSData dataWithBytes:inBuffer->mAudioData length:inBuffer->mAudioDataByteSize];
//    NSData *bufferData = [[NSData alloc] initWithBytes:inBuffer->mAudioData length:inBuffer->mAudioDataByteSize];
    if ([rec samplesToEngineDataDelegate] != nil){
        [rec samplesToEngineDataDelegate](bufferData);
    }
//    [rec formSamplesToEngine:inNumberPacketDescriptions samples:samples];

}

- (id)init {
    self = [super init];
    if (self) {
        refToSelf = (__bridge void *)(self);
        _max = 0.0f;
        _min = 0.0f;
        _sampleRate = 44100;
    }
    return self;
}

- (void)setupAudioFormat:(AudioStreamBasicDescription*)format {
    format->mSampleRate = 44100;
    format->mFormatID = kAudioFormatLinearPCM;
    format->mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
    format->mFramesPerPacket  = 1;
    format->mChannelsPerFrame = 1;
    format->mBytesPerFrame    = sizeof(short);
    format->mBytesPerPacket   = sizeof(short);
    format->mBitsPerChannel   = sizeof(short) * 8;
}

- (void)startRecording{
    
    [self setupAudioFormat:&recordState.dataFormat];
    recordState.currentPacket = 0;
    self.recordingState = true;
    _runningTimeInterval = [NSDate date];
    
    OSStatus status;
    status = AudioQueueNewInput(&recordState.dataFormat,
                                AudioInputCallback,
                                &recordState,
                                nil, 0,
                                0,
                                &recordState.queue);
    if (status == 0) {
        for (int i = 0; i < NUM_BUFFERS; i++) {
            AudioQueueAllocateBuffer(recordState.queue, 2048*recordState.dataFormat.mBytesPerFrame, &recordState.buffers[i]);
            AudioQueueEnqueueBuffer(recordState.queue, recordState.buffers[i], 0, nil);
        }
        
        recordState.recording = true;
        
        status = AudioQueueStart(recordState.queue, NULL);
        
        length = (uint)floor(log2(2048));

        fftSetup = vDSP_create_fftsetup(length, kFFTRadix2);
    }
}

- (void)stopRecording {
    recordState.recording = false;
    self.recordingState = false;
    vDSP_destroy_fftsetup(fftSetup);
    AudioQueueStop(recordState.queue, true);
    
    for (int i = 0; i < NUM_BUFFERS; i++) {
        AudioQueueFreeBuffer(recordState.queue, recordState.buffers[i]);
    }
    
    AudioQueueDispose(recordState.queue, true);
    AudioFileClose(recordState.audioFile);
    
//    NSLog(@"max FFT Value = %i and min FFT Value = %i", _max, _min);
}

- (void)formSamplesToEngine: (int)capacity samples: (short*)samples {
    AudioRecorder *rec = (__bridge AudioRecorder *) refToSelf;
//  to do 这里sampls 这一段音频数据 写音频文件  5002端口写入数据  播放音频

    if ([rec sampleToEngineDelegate] != nil){
        [rec sampleToEngineDelegate](samples);
    }
    float* fftArray = [self calculateFFT:samples size:2048];

//    if ([rec fftSamplesDelegate] != nil){
//        [rec fftSamplesDelegate](fftArray);
//    }
    
    if ([rec spectrogramSamplesDelegate] != nil){
        [rec spectrogramSamplesDelegate](fftArray);
    }
    
    free(fftArray);
    
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
