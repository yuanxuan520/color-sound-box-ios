//
//  PCMDataSource.h
//  AyaneBox
//
//  Created by yuanxuan on 2018/7/26.
//  Copyright © 2018年 AyaneBox. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "AudioData.h"
#import "EYAudio.h"
#import "ABSocketServer.h"
#import "AudioRecorder.h"

// 音频片段的帧数
#define FramePerPacket 1024
// 音频片段的设备输入字节数
#define BytePerDeviceInput (FramePerPacket * 8)
// 音频片段的手机输入字节数
#define BytePerPhoneInput (FramePerPacket * 4)

@interface PCMDataSource : NSObject
@property (nonatomic, strong) NSString *ipAddress; // 绑定的地址

@property (nonatomic, assign) int channelInput01; // 设备输入01
@property (nonatomic, assign) int channelInput02; // 设备输入02
@property (nonatomic, assign) int channelInput03; // 开启麦克风

@property (nonatomic, assign) int channelOutput01; // 设备输出01
@property (nonatomic, assign) int channelOutput02; // 设备输出02
@property (nonatomic, assign) int channelOutput03; // 开启扬声器

// 录音状态
@property (nonatomic) BOOL isRecord; // 当前是否正在录音
@property (nonatomic) BOOL isPlay;  // 当前是否正在播放

@property (nonatomic, strong) ABSocketServer *udpSocketServer; // 创建一个udp发送对象
// 临时数据存储Data对象
@property (nonatomic, strong) NSMutableData *deviceInput; //  (FramePerPacket = 1024帧) * 左声道(2个字节) * 右声道(2个字节)
@property (nonatomic, strong) NSMutableData *phoneInput; // (FramePerPacket = 1024帧) * 单声道(2个字节)
// 临时输出数据存储Data对象
@property (nonatomic, strong) NSString *defaultFileName; // 默认文件名

// 输出设备对象保存
@property (nonatomic) NSUInteger curLocationDevice01;
@property (nonatomic) NSUInteger curLocationDevice02;
@property (nonatomic) NSUInteger curLocationPhone;
@property (nonatomic, strong) NSTimer *outputTimer;
@property (nonatomic, strong) NSMutableData *outputDevice01; // 设备输出1
@property (nonatomic, strong) NSMutableData *outputDevice02; // 设备输出2
@property (nonatomic, strong) NSMutableData *outputPhone03;  // 输出对象3

@property (nonatomic, strong) NSString *longitudeStr;
@property (nonatomic, strong) NSString *latitudeStr;

//// 音频片段数据
//@property (nonatomic, strong) AudioData *audioData; // 每个包 (FramePerPacket = 1024帧)

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
// 取消保存数据
- (void)cancleSaveWavFile;
// 输出数据
- (void)writeNetworkDevice:(NSData *)outputData;
// 输出设备
- (void)writePlayNetworkDevice:(NSData *)outputData;
// 处理输入输出数据
- (void)processOutDeviceData;
// 开启udp服务
- (void)startUDPserve;
// 开启udp服务5001端口
- (void)startUDPserve5001;
// 关闭udp服务
- (void)stopUDPserve;
@end
