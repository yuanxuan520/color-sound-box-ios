//
//  PCMDataSource.m
//  AyaneBox
//
//  Created by yuanxuan on 2018/7/26.
//  Copyright © 2018年 AyaneBox. All rights reserved.
//

#import "PCMDataSource.h"
#import "PPFileOperate.h"
#import "Pcm2WavUtil.h"
@interface PCMDataSource()<ABSocketServerDelegate>
@end
@implementation PCMDataSource
+ (PCMDataSource *)sharedData
{
    static PCMDataSource *sharedDataInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedDataInstance = [[self alloc] init];
//        sharedDataInstance.audioData = [[AudioData alloc] init];
        [sharedDataInstance initInputChannelOutputChannel];
        [sharedDataInstance initData];
    });
    return sharedDataInstance;
}

// 初始化所有输入输出
- (void)initInputChannelOutputChannel{
// 首先初始化
    self.channelInput01 = 0;
    self.channelInput02 = 0;
    self.channelInput03 = 0;
    self.channelOutput01 = 0;
    self.channelOutput02 = 0;
    self.channelOutput03 = 0;
    [self readChannelInputOutput];
}

// 读取所有配置项
- (void)readChannelInputOutput
{
    // 然后根据保存的值读取
    NSNumber *channelInput01 = [USERDEFAULTS objectForKey:@"channelInput01"];
    if (channelInput01) {
        self.channelInput01 = [channelInput01 intValue];
    }
    
    NSNumber *channelInput02 = [USERDEFAULTS objectForKey:@"channelInput02"];
    if (channelInput02) {
        self.channelInput02 = [channelInput02 intValue];
    }
    
    NSNumber *channelInput03 = [USERDEFAULTS objectForKey:@"channelInput03"];
    if (channelInput03) {
        self.channelInput03 = [channelInput03 intValue];
    }
    
    NSNumber *channelOutput01 = [USERDEFAULTS objectForKey:@"channelOutput01"];
    if (channelOutput01) {
        self.channelOutput01 = [channelOutput01 intValue];
    }
    
    NSNumber *channelOutput02 = [USERDEFAULTS objectForKey:@"channelOutput02"];
    if (channelOutput02) {
        self.channelOutput02 = [channelOutput02 intValue];
    }
    
    NSNumber *channelOutput03 = [USERDEFAULTS objectForKey:@"channelOutput03"];
    if (channelOutput03) {
        self.channelOutput03 = [channelOutput03 intValue];
    }
}

// 设置所有配置项
- (void)saveChannelInputOutput
{
    // 然后根据保存的值读取
    NSNumber *channelInput01 = [NSNumber numberWithInt:self.channelInput01];
    [USERDEFAULTS setObject:channelInput01 forKey:@"channelInput01"];
    
    NSNumber *channelInput02 = [NSNumber numberWithInt:self.channelInput02];
    [USERDEFAULTS setObject:channelInput02 forKey:@"channelInput02"];
    
    NSNumber *channelInput03 = [NSNumber numberWithInt:self.channelInput03];
    [USERDEFAULTS setObject:channelInput03 forKey:@"channelInput03"];
    
    NSNumber *channelOutput01 = [NSNumber numberWithInt:self.channelOutput01];
    [USERDEFAULTS setObject:channelOutput01 forKey:@"channelOutput01"];
    
    NSNumber *channelOutput02 = [NSNumber numberWithInt:self.channelOutput02];
    [USERDEFAULTS setObject:channelOutput02 forKey:@"channelOutput02"];
    
    NSNumber *channelOutput03 = [NSNumber numberWithInt:self.channelOutput03];
    [USERDEFAULTS setObject:channelOutput03 forKey:@"channelOutput03"];
    
    [USERDEFAULTS synchronize];
}


// 初始化所有需要使用的数据
- (void)initData{
    // 两个临时使用的数据初始化 主要用于存储当前数据量
    self.deviceInput = [NSMutableData dataWithLength:0]; //FramePerPacket
    self.phoneInput = [NSMutableData dataWithLength:0]; //FramePerPacket
//    主要用于输出到设备中
    self.outputDevice01 = [NSMutableData dataWithLength:0];
    self.outputDevice02 = [NSMutableData dataWithLength:0];
    self.outputPhone03 = [NSMutableData dataWithLength:0];

    self.curLocation = 0;
    self.udpSocketServer = [[ABSocketServer alloc] init];
    self.udpSocketServer.delegate = self;
    [self.udpSocketServer startUDP];
}

// 开始时创建数据
- (void)resetOutFileData {
    if (self.outputDevice01) {
        self.outputDevice01 = nil;
    }
    if (self.outputDevice02) {
        self.outputDevice02 = nil;
    }
    if (self.outputPhone03) {
        self.outputPhone03 = nil;
    }
    self.outputDevice01 = [NSMutableData dataWithLength:0];
    self.outputDevice02 = [NSMutableData dataWithLength:0];
    self.outputPhone03 = [NSMutableData dataWithLength:0];
    self.curLocation = 0;
}

// 开始录音
- (void)startRecord{
//    [EYAudio initialize]; // 设置后可以同时录音和播放
//   开始录制的时候清空 数据
    [self resetOutFileData];
    [self startOutPutDevice];
}

// 停止录音
- (void)stopRecord{
    self.defaultFileName = [NSString stringWithFormat:@"新文件_%@",[NSDate currentDateStringWithFormat:@"yyMMdd_HHmmss"]];
    [self saveDefaultFile];
    [self stopOutPutDevice];
    // 保存文件
//    PPFileOperate *ppfileop = [[PPFileOperate alloc] init];
//    NSString *dirName = [NSString stringWithFormat:@"%@",@"wavFile"];
//    NSString *filePath = [ppfileop getDirName:@"wavFile" fileName:@"ceshiwenjian.pcm"];
//    NSString *newfilePath = [ppfileop getDirName:@"wavFile" fileName:@"ceshiwenjian.wav"];
//    char *cFilePath = (char *)[filePath UTF8String];
//    char *cNewfilePath = (char *)[newfilePath UTF8String];
//    NSLog(@"%@",self.phoneOutFile03);
//    NSLog(@"%@",newfilePath);
//    [self.phoneOutFile03 writeToFile:filePath atomically:NO];
//    convertPcm2Wav(cFilePath,cNewfilePath,1,44100);
}

- (void)saveDefaultFile{
    PPFileOperate *ppfileop = [[PPFileOperate alloc] init];
    if (self.channelInput01 > 0) {
        NSString *filename = [NSString stringWithFormat:@"%@_1",self.defaultFileName];
        NSString *filePath = [ppfileop getDirName:@"wavFilePcm" fileName:filename];
        [self.outputDevice01 writeToFile:filePath atomically:NO];
    }
    
    if (self.channelInput02 > 0) {
        NSString *filename = [NSString stringWithFormat:@"%@_2",self.defaultFileName];
        NSString *filePath = [ppfileop getDirName:@"wavFilePcm" fileName:filename];
        [self.outputDevice02 writeToFile:filePath atomically:NO];
    }
    
    if (self.channelInput03 > 0) {
        NSString *filename = [NSString stringWithFormat:@"%@_3",self.defaultFileName];
        NSString *filePath = [ppfileop getDirName:@"wavFilePcm" fileName:filename];
        [self.outputPhone03 writeToFile:filePath atomically:NO];
    }
}

- (void)saveWavFile:(NSString *)fileName
{
    PPFileOperate *fileOP = [[PPFileOperate alloc] init];
    if (self.channelInput01 > 0) {
        NSString *pcmFileName = [NSString stringWithFormat:@"%@_1",self.defaultFileName];
        NSString *wavFileName = [NSString stringWithFormat:@"%@_1.wav",fileName];
        NSString *filePath = [fileOP getDirName:@"wavFilePcm" fileName:pcmFileName];
        NSString *newfilePath = [fileOP getDirName:@"wavFile" fileName:wavFileName];
        char *cFilePath = (char *)[filePath UTF8String];
        char *cNewfilePath = (char *)[newfilePath UTF8String];
        convertPcm2Wav(cFilePath,cNewfilePath,1,44100);
        [fileOP deleteFile:pcmFileName];
    }
    
    if (self.channelInput02 > 0) {
        NSString *pcmFileName = [NSString stringWithFormat:@"%@_2",self.defaultFileName];
        NSString *wavFileName = [NSString stringWithFormat:@"%@_2.wav",fileName];
        NSString *filePath = [fileOP getDirName:@"wavFilePcm" fileName:pcmFileName];
        NSString *newfilePath = [fileOP getDirName:@"wavFile" fileName:wavFileName];
        char *cFilePath = (char *)[filePath UTF8String];
        char *cNewfilePath = (char *)[newfilePath UTF8String];
        convertPcm2Wav(cFilePath,cNewfilePath,1,44100);
        [fileOP deleteFile:pcmFileName];
    }
    
    if (self.channelInput03 > 0) {
        NSString *pcmFileName = [NSString stringWithFormat:@"%@_3",self.defaultFileName];
        NSString *wavFileName = [NSString stringWithFormat:@"%@_3.wav",fileName];
        NSString *filePath = [fileOP getDirName:@"wavFilePcm" fileName:pcmFileName];
        NSString *newfilePath = [fileOP getDirName:@"wavFile" fileName:wavFileName];
        char *cFilePath = (char *)[filePath UTF8String];
        char *cNewfilePath = (char *)[newfilePath UTF8String];
        convertPcm2Wav(cFilePath,cNewfilePath,1,44100);
        [fileOP deleteFile:pcmFileName];
    }
}

- (void)cancleSaveWavFile
{
    PPFileOperate *fileOP = [[PPFileOperate alloc] init];
    if (self.channelInput01 > 0) {
        NSString *pcmFileName = [NSString stringWithFormat:@"%@_1",self.defaultFileName];
        [fileOP deleteFile:pcmFileName];
    }
    
    if (self.channelInput02 > 0) {
        NSString *pcmFileName = [NSString stringWithFormat:@"%@_2",self.defaultFileName];
        [fileOP deleteFile:pcmFileName];
    }
    
    if (self.channelInput03 > 0) {
        NSString *pcmFileName = [NSString stringWithFormat:@"%@_3",self.defaultFileName];
        [fileOP deleteFile:pcmFileName];
    }
}


- (void)clearData{
    self.deviceInput = nil;
    self.phoneInput = nil;
}

// 将数据输出到设备中
- (void)startOutPutDevice
{
    if (self.outputTimer) {
        [self.outputTimer invalidate];
        self.outputTimer = nil;
    }
    self.outputTimer = [NSTimer scheduledTimerWithTimeInterval:44100/512/1000 target:self selector:@selector(processOutDeviceData) userInfo:nil repeats:YES];
}

// 停止输入到设备中
- (void)stopOutPutDevice
{
    if (self.outputTimer) {
        [self.outputTimer invalidate];
        self.outputTimer = nil;
    }
}

- (void)processOutDeviceData
{
    int size = 512;
    NSData *in01 = nil;
    if (self.outputDevice01.length >= size) {
        in01 = [self.outputDevice01 subdataWithRange:NSMakeRange(self.curLocation, size)];
    }else {
        in01 = [NSMutableData dataWithLength:size];
    }
    NSData *in02 = nil;
    if (self.outputDevice02.length >= size) {
        in02 = [self.outputDevice02 subdataWithRange:NSMakeRange(self.curLocation, size)];
    }else {
        in02 = [NSMutableData dataWithLength:size];
    }
    NSData *in03 = nil;
    if (self.outputPhone03.length >= size) {
        in03 = [self.outputPhone03 subdataWithRange:NSMakeRange(self.curLocation, size)];
    }else {
        in03 = [NSMutableData dataWithLength:size];
    }
    Byte *deviceInput01 = (Byte *)[in01 bytes];
    Byte *deviceInput02 = (Byte *)[in02 bytes];
    Byte *phoneInput03 = (Byte *)[in03 bytes];
    
    NSMutableData *deviceOutput = [NSMutableData dataWithLength:size*2];
    
    for (int i = 0; i<512; i++) {
        // 输出1相关计算
        // --------------------------------------------------------
        // 输出1 关闭时
        if (self.channelOutput01 == 0) {
            
        }
        // 输出1 指向输入1 时
        else if (self.channelOutput01 == 1) {
            [deviceOutput replaceBytesInRange:NSMakeRange(i*4, 2) withBytes:&deviceInput01[i*2]];
        }
        // 输出1 指向输入2 时
        else if (self.channelOutput01 == 2) {
            [deviceOutput replaceBytesInRange:NSMakeRange(i*4, 2) withBytes:&deviceInput02[i*2]];
        }
        // 输出1 指向输入3 时
        else if (self.channelOutput01 == 3) {
            [deviceOutput replaceBytesInRange:NSMakeRange(i*4, 2) withBytes:&phoneInput03[i*2]];
        }
        
        // 输出2相关计算
        // --------------------------------------------------------
        // 输出2 关闭时
        if (self.channelOutput02 == 0) {
            
        }
        // 输出2 指向输入1 时
        else if (self.channelOutput02 == 1) {
            [deviceOutput replaceBytesInRange:NSMakeRange(i*4+2, 2) withBytes:&deviceInput01[i*2]];
        }
        // 输出2 指向输入2 时
        else if (self.channelOutput02 == 2) {
            [deviceOutput replaceBytesInRange:NSMakeRange(i*4+2, 2) withBytes:&deviceInput02[i*2]];
        }
        // 输出2 指向输入3 时
        else if (self.channelOutput02 == 3) {
            [deviceOutput replaceBytesInRange:NSMakeRange(i*4+2, 2) withBytes:&phoneInput03[i*2]];
        }
    }
    [self writeNetworkDevice:deviceOutput];
    
//    if (self.outputDevice01.length >= size) {
//        [self.outputDevice01 replaceBytesInRange:NSMakeRange(0, size) withBytes:NULL length:0];
//    }
//    if (self.outputDevice02.length >= size) {
//        [self.outputDevice02 replaceBytesInRange:NSMakeRange(0, size) withBytes:NULL length:0];
//    }
//    if (self.outputPhone03.length >= size) {
//        [self.outputPhone03 replaceBytesInRange:NSMakeRange(0, size) withBytes:NULL length:0];
//    }
    
//    if (self.outputDevice01.length == 0 && self.outputDevice02.length ==0 && self.outputPhone03.length ==0&&!self.isRecord) {
////        停止定时器
//        [self.outputTimer invalidate];
//        self.outputTimer = nil;
//    }
}



#pragma mark - 处理<设备>麦克风数据
- (void)appendByDeviceInput:(NSData *)data
{
    //    将data添加到datainput中
    [self.deviceInput appendData:data];
    
    //    构造audioData 对象
    if (self.deviceInput.length < BytePerDeviceInput) {
        //        如果没有到 1024 * 8 这个长度的数据 就等待
        return;
    }
    [self processDeviceData];
}
- (void)processDeviceData
{
    // 读取数据并处理数据
    NSData *deviceInputData = [NSData dataWithData:self.deviceInput];
    Byte *deviceInput = (Byte *)[deviceInputData bytes];
    NSMutableData *in01 = [NSMutableData dataWithLength:(FramePerPacket * 4)];
    NSMutableData *in02 = [NSMutableData dataWithLength:(FramePerPacket * 4)];
    
    // 直接处理设备的数据
    for (int i = 0, j = 0; i<BytePerDeviceInput; i= i+4) {
        if (i % 4 == 0) {
            if (self.channelInput01 != 0) {
                [in01 replaceBytesInRange:NSMakeRange(j, 2) withBytes:&deviceInput[i]];
            }
            if (self.channelInput02 != 0) {
                [in02 replaceBytesInRange:NSMakeRange(j, 2) withBytes:&deviceInput[i+2]];
            }
            j += 2;
        }
    }
    
    // 录音操作
    if (self.isRecord) {
        if (self.channelInput01 > 0) {
            [self.outputDevice01 appendData:in01];
        }

        if (self.channelInput02 > 0) {
            [self.outputDevice02 appendData:in02];
        }
    }
    //清空数据
    [self.deviceInput resetBytesInRange:NSMakeRange(0, self.deviceInput.length)];
    [self.deviceInput setLength:0];
}


#pragma mark - 处理<手机>麦克风数据
- (void)appendByPhoneInput:(NSData *)data
{
    [self.phoneInput appendData:data];
    if (self.phoneInput.length < BytePerPhoneInput) {
        // 如果没有到 1024 * 4 这个长度的数据 就等待 不过一般不可能会出现这种情况 因为录音默认就给了值不会变
        return;
    }
    [self processPhoneData];
}

- (void)processPhoneData
{
    NSUInteger phoneInputLenght = [self.phoneInput length];
    NSData *phoneInputData = [NSData dataWithData:self.phoneInput];
    
    // 直接处理数据
    if (self.isRecord) {
        if (self.channelInput03 > 0) {
            [self.outputPhone03 appendData:phoneInputData];
        }
    }
    //清空数据
    [self.phoneInput resetBytesInRange:NSMakeRange(0, phoneInputLenght)];
    [self.phoneInput setLength:0];
}


#pragma mark 直接将数据写入设备中
- (void)writeNetworkDevice:(NSData *)outputData
{
    if(self.channelOutput01 > 0 || self.channelOutput02 > 0){
        [self.udpSocketServer sendUDPData:outputData toHost:self.ipAddress Port:5002 Tag:1];
    }
}

- (void)writePlayNetworkDevice:(NSData *)outputData
{
    [self.udpSocketServer sendUDPData:outputData toHost:self.ipAddress Port:5002 Tag:1];
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock host:(NSString *)host didReceiveData:(NSData *)data fromAddress:(NSData *)address
{
    
}
@end
