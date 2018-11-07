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
    _channelInput01 = 0;
    _channelInput02 = 0;
    _channelInput03 = 0;
    _channelOutput01 = 0;
    _channelOutput02 = 0;
    _channelOutput03 = 0;
    [self readChannelInputOutput];
}

// 读取所有配置项
- (void)readChannelInputOutput
{
    // 然后根据保存的值读取
    NSNumber *channelInput01 = [USERDEFAULTS objectForKey:@"channelInput01"];
    if (channelInput01) {
        _channelInput01 = [channelInput01 intValue];
    }
    
    NSNumber *channelInput02 = [USERDEFAULTS objectForKey:@"channelInput02"];
    if (channelInput02) {
        _channelInput02 = [channelInput02 intValue];
    }
    
    NSNumber *channelInput03 = [USERDEFAULTS objectForKey:@"channelInput03"];
    if (channelInput03) {
        _channelInput03 = [channelInput03 intValue];
    }
    
    NSNumber *channelOutput01 = [USERDEFAULTS objectForKey:@"channelOutput01"];
    if (channelOutput01) {
        _channelOutput01 = [channelOutput01 intValue];
    }
    
    NSNumber *channelOutput02 = [USERDEFAULTS objectForKey:@"channelOutput02"];
    if (channelOutput02) {
        _channelOutput02 = [channelOutput02 intValue];
    }
    
    NSNumber *channelOutput03 = [USERDEFAULTS objectForKey:@"channelOutput03"];
    if (channelOutput03) {
        _channelOutput03 = [channelOutput03 intValue];
    }
}

// 设置所有配置项
- (void)saveChannelInputOutput
{
    // 然后根据保存的值读取
    NSNumber *channelInput01 = [NSNumber numberWithInt:_channelInput01];
    [USERDEFAULTS setObject:channelInput01 forKey:@"channelInput01"];
    
    NSNumber *channelInput02 = [NSNumber numberWithInt:_channelInput02];
    [USERDEFAULTS setObject:channelInput02 forKey:@"channelInput02"];
    
    NSNumber *channelInput03 = [NSNumber numberWithInt:_channelInput03];
    [USERDEFAULTS setObject:channelInput03 forKey:@"channelInput03"];
    
    NSNumber *channelOutput01 = [NSNumber numberWithInt:_channelOutput01];
    [USERDEFAULTS setObject:channelOutput01 forKey:@"channelOutput01"];
    
    NSNumber *channelOutput02 = [NSNumber numberWithInt:_channelOutput02];
    [USERDEFAULTS setObject:channelOutput02 forKey:@"channelOutput02"];
    
    NSNumber *channelOutput03 = [NSNumber numberWithInt:_channelOutput03];
    [USERDEFAULTS setObject:channelOutput03 forKey:@"channelOutput03"];
    
    [USERDEFAULTS synchronize];
}


// 初始化所有需要使用的数据
- (void)initData{
    // 两个临时使用的数据初始化 主要用于存储当前数据量
    _deviceInput = [NSMutableData dataWithLength:0]; //FramePerPacket
    _phoneInput = [NSMutableData dataWithLength:0]; //FramePerPacket
//    主要用于输出到设备中
    _outputDevice01 = [NSMutableData dataWithLength:0];
    _outputDevice02 = [NSMutableData dataWithLength:0];
    _outputPhone03 = [NSMutableData dataWithLength:0];

    _curLocationDevice01 = 0;
    _curLocationDevice02 = 0;
    _curLocationPhone = 0;

    _udpSocketServer = [[ABSocketServer alloc] init];
    _udpSocketServer.delegate = self;
    
}

// 开启udp服务
- (void)startUDPserve
{
    [_udpSocketServer startUDP];
}
// 开启udp服务5001端口
- (void)startUDPserve5001
{
    [_udpSocketServer startUDP:5001];
}
// 关闭udp服务
- (void)stopUDPserve
{
    [_udpSocketServer stopUDP];
}


// 开始时创建数据
- (void)resetOutFileData {
    if (_outputDevice01) {
        _outputDevice01 = nil;
    }
    if (_outputDevice02) {
        _outputDevice02 = nil;
    }
    if (_outputPhone03) {
        _outputPhone03 = nil;
    }
    _outputDevice01 = [NSMutableData dataWithLength:0];
    _outputDevice02 = [NSMutableData dataWithLength:0];
    _outputPhone03 = [NSMutableData dataWithLength:0];
    _curLocationDevice01 = 0;
    _curLocationDevice02 = 0;
    _curLocationPhone = 0;
}

// 开始录音
- (void)startRecord{
//    [EYAudio initialize]; // 设置后可以同时录音和播放
//   开始录制的时候清空 数据
    [self resetOutFileData];
    [self startOutPutDevice];
    [self startUDPserve5001];
}

// 停止录音
- (void)stopRecord{
    _defaultFileName = [NSString stringWithFormat:@"新文件_%@",[NSDate currentDateStringWithFormat:@"yyMMddHHmmss"]];
    [self saveDefaultFile];
    [self stopOutPutDevice];
    // 保存文件
//    PPFileOperate *ppfileop = [[PPFileOperate alloc] init];
//    NSString *dirName = [NSString stringWithFormat:@"%@",@"wavFile"];
//    NSString *filePath = [ppfileop getDirName:@"wavFile" fileName:@"ceshiwenjian.pcm"];
//    NSString *newfilePath = [ppfileop getDirName:@"wavFile" fileName:@"ceshiwenjian.wav"];
//    char *cFilePath = (char *)[filePath UTF8String];
//    char *cNewfilePath = (char *)[newfilePath UTF8String];
//    NSLog(@"%@",_phoneOutFile03);
//    NSLog(@"%@",newfilePath);
//    [_phoneOutFile03 writeToFile:filePath atomically:NO];
//    convertPcm2Wav(cFilePath,cNewfilePath,1,44100);
    [self stopUDPserve];
}

- (void)saveDefaultFile{
    PPFileOperate *ppfileop = [[PPFileOperate alloc] init];
    if (_channelInput01 > 0) {
        NSString *filename = [NSString stringWithFormat:@"%@_ch01",_defaultFileName];
        NSString *filePath = [ppfileop getDirName:@"wavFilePcm" fileName:filename];
        [_outputDevice01 writeToFile:filePath atomically:NO];
    }
    
    if (_channelInput02 > 0) {
        NSString *filename = [NSString stringWithFormat:@"%@_ch02",_defaultFileName];
        NSString *filePath = [ppfileop getDirName:@"wavFilePcm" fileName:filename];
        [_outputDevice02 writeToFile:filePath atomically:NO];
    }
    
    if (_channelInput03 > 0) {
        NSString *filename = [NSString stringWithFormat:@"%@_ch03",_defaultFileName];
        NSString *filePath = [ppfileop getDirName:@"wavFilePcm" fileName:filename];
        [_outputPhone03 writeToFile:filePath atomically:NO];
    }
}

- (void)saveWavFile:(NSString *)fileName
{
    PPFileOperate *fileOP = [[PPFileOperate alloc] init];
    if (_channelInput01 > 0) {
        NSString *pcmFileName = [NSString stringWithFormat:@"%@_ch01",_defaultFileName];
        NSString *wavFileName = [NSString stringWithFormat:@"%@_ch01_\ngps(%@_%@).wav",fileName,_longitudeStr,_latitudeStr];
        NSString *filePath = [fileOP getDirName:@"wavFilePcm" fileName:pcmFileName];
        NSString *newfilePath = [fileOP getDirName:@"wavFile" fileName:wavFileName];
        char *cFilePath = (char *)[filePath UTF8String];
        char *cNewfilePath = (char *)[newfilePath UTF8String];
        convertPcm2Wav(cFilePath,cNewfilePath,1,44100);
        [fileOP deleteFile:pcmFileName];
    }
    
    if (_channelInput02 > 0) {
        NSString *pcmFileName = [NSString stringWithFormat:@"%@_ch02",_defaultFileName];
        NSString *wavFileName = [NSString stringWithFormat:@"%@_ch02_\ngps(%@_%@).wav",fileName,_longitudeStr,_latitudeStr];
        NSString *filePath = [fileOP getDirName:@"wavFilePcm" fileName:pcmFileName];
        NSString *newfilePath = [fileOP getDirName:@"wavFile" fileName:wavFileName];
        char *cFilePath = (char *)[filePath UTF8String];
        char *cNewfilePath = (char *)[newfilePath UTF8String];
        convertPcm2Wav(cFilePath,cNewfilePath,1,44100);
        [fileOP deleteFile:pcmFileName];
    }
    
    if (_channelInput03 > 0) {
        NSString *pcmFileName = [NSString stringWithFormat:@"%@_ch03",_defaultFileName];
        NSString *wavFileName = [NSString stringWithFormat:@"%@_ch03_\ngps(%@_%@).wav",fileName,_longitudeStr,_latitudeStr];
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
    if (_channelInput01 > 0) {
        NSString *pcmFileName = [NSString stringWithFormat:@"%@_1",_defaultFileName];
        [fileOP deleteFile:pcmFileName];
    }
    
    if (_channelInput02 > 0) {
        NSString *pcmFileName = [NSString stringWithFormat:@"%@_2",_defaultFileName];
        [fileOP deleteFile:pcmFileName];
    }
    
    if (_channelInput03 > 0) {
        NSString *pcmFileName = [NSString stringWithFormat:@"%@_3",_defaultFileName];
        [fileOP deleteFile:pcmFileName];
    }
}


- (void)clearData{
    _deviceInput = nil;
    _phoneInput = nil;
}

// 将数据输出到设备中
- (void)startOutPutDevice
{
    if (_outputTimer) {
        [_outputTimer invalidate];
        _outputTimer = nil;
    }
    if (_channelOutput01 > 0 || _channelOutput02 > 0) {
        _outputTimer = [NSTimer scheduledTimerWithTimeInterval:44100/2048/1000 target:self selector:@selector(processOutDeviceData) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_outputTimer forMode:NSRunLoopCommonModes];

//        [outputTimer addru]
    }
}

// 停止输入到设备中
- (void)stopOutPutDevice
{
    if (_outputTimer) {
        [_outputTimer invalidate];
        _outputTimer = nil;
    }
}

- (void)processOutDeviceData
{
    @try {
        int size = 4096;
        NSData *in01 = nil;
        NSInteger device01Length = _outputDevice01.length - _curLocationDevice01;
        if (device01Length >= size) {
            in01 = [_outputDevice01 subdataWithRange:NSMakeRange(_curLocationDevice01, size)];
            _curLocationDevice01 = _curLocationDevice01 + size;
        }else {
            in01 = [NSMutableData dataWithLength:size];
        }
        NSData *in02 = nil;
        NSInteger device02Length = _outputDevice02.length - _curLocationDevice02;
        if (device02Length >= size) {
            in02 = [_outputDevice02 subdataWithRange:NSMakeRange(_curLocationDevice02, size)];
            _curLocationDevice02 = _curLocationDevice02 + size;
        }else {
            in02 = [NSMutableData dataWithLength:size];
        }
        NSData *in03 = nil;
        NSInteger phoneLength = _outputPhone03.length - _curLocationPhone;
        if (phoneLength >= size) {
            in03 = [_outputPhone03 subdataWithRange:NSMakeRange(_curLocationPhone, size)];
            _curLocationPhone = _curLocationPhone + size;
        }else {
            in03 = [NSMutableData dataWithLength:size];
        }
        Byte *deviceInput01 = (Byte *)[in01 bytes];
        Byte *deviceInput02 = (Byte *)[in02 bytes];
        Byte *phoneInput03 = (Byte *)[in03 bytes];
        
        NSMutableData *deviceOutput = [NSMutableData dataWithLength:size*2];
        
        for (int i = 0; i<(size/2); i++) {
            // 输出1相关计算
            // --------------------------------------------------------
            // 输出1 关闭时
            if (_channelOutput01 == 0) {
                
            }
            // 输出1 指向输入1 时
            else if (_channelOutput01 == 1) {
                [deviceOutput replaceBytesInRange:NSMakeRange(i*4, 2) withBytes:&deviceInput01[i*2]];
            }
            // 输出1 指向输入2 时
            else if (_channelOutput01 == 2) {
                [deviceOutput replaceBytesInRange:NSMakeRange(i*4, 2) withBytes:&deviceInput02[i*2]];
            }
            // 输出1 指向输入3 时
            else if (_channelOutput01 == 3) {
                [deviceOutput replaceBytesInRange:NSMakeRange(i*4, 2) withBytes:&phoneInput03[i*2]];
            }
            
            // 输出2相关计算
            // --------------------------------------------------------
            // 输出2 关闭时
            if (_channelOutput02 == 0) {
                
            }
            // 输出2 指向输入1 时
            else if (_channelOutput02 == 1) {
                [deviceOutput replaceBytesInRange:NSMakeRange(i*4+2, 2) withBytes:&deviceInput01[i*2]];
            }
            // 输出2 指向输入2 时
            else if (_channelOutput02 == 2) {
                [deviceOutput replaceBytesInRange:NSMakeRange(i*4+2, 2) withBytes:&deviceInput02[i*2]];
            }
            // 输出2 指向输入3 时
            else if (_channelOutput02 == 3) {
                [deviceOutput replaceBytesInRange:NSMakeRange(i*4+2, 2) withBytes:&phoneInput03[i*2]];
            }
        }
        [self writeNetworkDevice:deviceOutput];
    } @catch (NSException *exception) {
        
    } @finally {

    }

}



#pragma mark - 处理<设备>麦克风数据
- (void)appendByDeviceInput:(NSData *)data
{
    //    将data添加到datainput中
    [_deviceInput appendData:data];
    
    //    构造audioData 对象
//    if (_deviceInput.length < BytePerDeviceInput) {
//        //        如果没有到 1024 * 8 这个长度的数据 就等待
//        return;
//    }
    [self processDeviceData];
}
- (void)processDeviceData
{
    // 读取数据并处理数据
    NSData *deviceInputData = [NSData dataWithData:_deviceInput];
    Byte *deviceInput = (Byte *)[deviceInputData bytes];
    NSMutableData *in01 = [NSMutableData dataWithLength:FramePerPacket];
    NSMutableData *in02 = [NSMutableData dataWithLength:FramePerPacket];
    
    // 直接处理设备的数据
    for (int i = 0, j = 0; i<FramePerPacket; i= i+4) {
        if (i % 4 == 0) {
            if (_channelInput01 != 0) {
                [in01 replaceBytesInRange:NSMakeRange(j, 2) withBytes:&deviceInput[i]];
            }
            if (_channelInput02 != 0) {
                [in02 replaceBytesInRange:NSMakeRange(j, 2) withBytes:&deviceInput[i+2]];
            }
            j += 2;
        }
    }
    
    // 录音操作
    if (_isRecord) {
        if (_channelInput01 > 0) {
            [_outputDevice01 appendData:in01];
        }

        if (_channelInput02 > 0) {
            [_outputDevice02 appendData:in02];
        }
    }
    //清空数据
    [_deviceInput resetBytesInRange:NSMakeRange(0, _deviceInput.length)];
    [_deviceInput setLength:0];
}


#pragma mark - 处理<手机>麦克风数据
- (void)appendByPhoneInput:(NSData *)data
{
    [_phoneInput appendData:data];
//    if (_phoneInput.length < BytePerPhoneInput) {
//        // 如果没有到 1024 * 4 这个长度的数据 就等待 不过一般不可能会出现这种情况 因为录音默认就给了值不会变
//        return;
//    }

    [self processPhoneData];
}

- (void)processPhoneData
{
    NSUInteger phoneInputLenght = [_phoneInput length];
    NSData *phoneInputData = [NSData dataWithData:_phoneInput];
    
    // 直接处理数据
    if (_isRecord) {
        if (_channelInput03 > 0) {
            [_outputPhone03 appendData:phoneInputData];
        }
    }
    //清空数据
    [_phoneInput resetBytesInRange:NSMakeRange(0, phoneInputLenght)];
    [_phoneInput setLength:0];
}


#pragma mark 直接将数据写入设备中
- (void)writeNetworkDevice:(NSData *)outputData
{
    if(_channelOutput01 > 0 || _channelOutput02 > 0){
        [_udpSocketServer sendUDPData:outputData toHost:_ipAddress Port:5002 Tag:1];
    }
}

- (void)writePlayNetworkDevice:(NSData *)outputData
{
    [_udpSocketServer sendUDPData:outputData toHost:_ipAddress Port:5002 Tag:1];
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock host:(NSString *)host didReceiveData:(NSData *)data fromAddress:(NSData *)address
{
    if (_isRecord) { // 一旦点击开始录音后,开始接收数据
        if (_channelInput01 > 0 || _channelInput02 > 0 ) { // 输入3 开启
            [self appendByDeviceInput:data];
        }
    }
}
@end
