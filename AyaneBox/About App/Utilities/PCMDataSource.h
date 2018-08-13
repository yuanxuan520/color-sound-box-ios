//
//  PCMDataSource.h
//  AyaneBox
//
//  Created by yuanxuan on 2018/7/26.
//  Copyright © 2018年 AyaneBox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioData.h"
#import "EYAudio.h"
#import "ABSocketServer.h"
#import "AudioRecorder.h"
@interface PCMDataSource : NSObject
@property (nonatomic, assign) int channelInput01; // 设备输入01
@property (nonatomic, assign) int channelInput02; // 设备输入02
@property (nonatomic, assign) int channelInput03; // 开启麦克风

@property (nonatomic, assign) int channelOutput01; // 设备输出01
@property (nonatomic, assign) int channelOutput02; // 设备输出02
@property (nonatomic, assign) int channelOutput03; // 开启扬声器

@property (nonatomic, strong) NSString *ipAddress;

@property (nonatomic) BOOL isRecord; // 当前是否正在录音
@property (nonatomic) BOOL isPlay;  // 当前是否正在播放
// 创建一个udp发送对象
@property (nonatomic, strong) ABSocketServer *udpSocketServer;
// 临时数据存储Data对象
@property (nonatomic, strong) NSMutableData *deviceInput; //  (FramePerPacket = 1024帧) * 左声道(2个字节) * 右声道(2个字节)
@property (nonatomic, strong) NSMutableData *phoneInput; // (FramePerPacket = 1024帧) * 单声道(2个字节)
// 临时输出数据存储Data对象
@property (nonatomic, strong) NSMutableData *deviceOutput01; // 输出对象1
@property (nonatomic, strong) NSMutableData *deviceOutput02; // 输出对象2
@property (nonatomic, strong) NSMutableData *phoneOutput03;  // 输出对象3
@property (nonatomic, strong) NSString *defaultFileName; // 默认文件名
// 音频片段数据
@property (nonatomic, strong) AudioData *audioData; // 每个包 (FramePerPacket = 1024帧)
// 播放Pcm控件对象
@property (nonatomic, strong) EYAudio *playAudioDataManager;
// 录制Pcm控件对象
@property (nonatomic, strong) AudioRecorder *audioRecorderDataManager;

// 输出数据存储对象
@property (nonatomic, strong) NSMutableData *deviceOutFile01;
@property (nonatomic, strong) NSMutableData *deviceOutFile02;
@property (nonatomic, strong) NSMutableData *phoneOutFile03;

@property (nonatomic, strong) NSMutableData *phoneOutFile04;
//
@property (nonatomic, strong) NSMutableData *deviceOutput; // (FramePerPacket = 1024帧) * 左声道(2个字节) * 右声道(2个字节)
@property (nonatomic, strong) NSMutableData *phoneOutput;  // (FramePerPacket = 1024帧) * 单声道(2个字节)

+ (PCMDataSource *)sharedData;

// 设备音频数据进入
- (void)appendByDeviceInput:(NSData *)data;   // 这里 1024帧 * 4
// 手机音频数据进入
- (void)appendByPhoneInput:(NSData *)data;   // 这里 直接就2048帧
// 保存所有配置项
- (void)saveChannelInputOutput;
// 开始手机录音
- (void)startRecord;
// 停止手机录音
- (void)stopRecord;
// 保存数据
- (void)saveWavFile:(NSString *)fileName;


@end
