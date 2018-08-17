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
{
    NSLock *lock;
}
@property (nonatomic) BOOL isLE; /** LE or BE */
@property (nonatomic) BOOL isAvoidDataOverflows; /** 是否避免数据溢出*/
@end
@implementation PCMDataSource
+ (PCMDataSource *)sharedData
{
    static PCMDataSource *sharedDataInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedDataInstance = [[self alloc] init];
//        sharedDataInstance.audioData = [[AudioData alloc] init];
        sharedDataInstance.isLE = YES;
        sharedDataInstance.isAvoidDataOverflows = YES;
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
    // 两个临时使用的数据初始化
    self.deviceInput = [NSMutableData dataWithLength:0]; //FramePerPacket
    self.phoneInput = [NSMutableData dataWithLength:0]; //FramePerPacket
    
    self.deviceOutFile01 = [NSMutableData dataWithLength:0];
    self.deviceOutFile02 = [NSMutableData dataWithLength:0];
    self.phoneOutFile03 = [NSMutableData dataWithLength:0];

    self.udpSocketServer = [[ABSocketServer alloc] init];
    self.udpSocketServer.delegate = self;
    [self.udpSocketServer startUDP];
}

// 开始时创建数据
- (void)resetOutFileData {
    if (self.deviceOutFile01) {
        self.deviceOutFile01 = nil;
    }
    if (self.deviceOutFile02) {
        self.deviceOutFile02 = nil;
    }
    if (self.phoneOutFile03) {
        self.phoneOutFile03 = nil;
    }
    
    
    self.deviceOutFile01 = [NSMutableData dataWithLength:0];
    self.deviceOutFile02 = [NSMutableData dataWithLength:0];
    self.phoneOutFile03 = [NSMutableData dataWithLength:0];
}

// 开始录音
- (void)startRecord{
//    [EYAudio initialize]; // 设置后可以同时录音和播放
//   开始录制的时候清空 数据
    [self resetOutFileData];
    self.playAudioDataManager = [[EYAudio alloc] init];
    self.audioRecorderDataManager = [[AudioRecorder alloc] init];
    self.audioRecorderDataManager.samplesToEngineDataDelegate = ^(NSData *data){
        [self appendByPhoneInput:data];
    };
    [self.audioRecorderDataManager startRecording];
}

// 停止录音
- (void)stopRecord{
    [self.audioRecorderDataManager stopRecording];
    [self.playAudioDataManager stop];
    self.playAudioDataManager = nil;
    self.audioRecorderDataManager = nil;
    self.defaultFileName = [NSString stringWithFormat:@"新文件_%@",[NSDate currentDateStringWithFormat:@"yyMMdd_HHmmss"]];
    [self saveDefaultFile];
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
        [self.deviceOutFile01 writeToFile:filePath atomically:NO];
    }
    
    if (self.channelInput02 > 0) {
        NSString *filename = [NSString stringWithFormat:@"%@_2",self.defaultFileName];
        NSString *filePath = [ppfileop getDirName:@"wavFilePcm" fileName:filename];
        [self.deviceOutFile02 writeToFile:filePath atomically:NO];
    }
    
    if (self.channelInput03 > 0) {
        NSString *filename = [NSString stringWithFormat:@"%@_3",self.defaultFileName];
        NSString *filePath = [ppfileop getDirName:@"wavFilePcm" fileName:filename];
        [self.phoneOutFile03 writeToFile:filePath atomically:NO];
    }
}

- (void)saveWavFile:(NSString *)fileName
{
    PPFileOperate *fileOP = [[PPFileOperate alloc] init];
    if (self.channelInput01 > 0) {
        NSString *pcmFileName = [NSString stringWithFormat:@"%@_1",self.defaultFileName];
        NSString *wavFileName = [NSString stringWithFormat:@"%@_1",fileName];
        NSString *filePath = [fileOP getDirName:@"wavFilePcm" fileName:pcmFileName];
        NSString *newfilePath = [fileOP getDirName:@"wavFile" fileName:wavFileName];
        char *cFilePath = (char *)[filePath UTF8String];
        char *cNewfilePath = (char *)[newfilePath UTF8String];
        NSLog(@"%@",self.deviceOutFile01);
        NSLog(@"%@",newfilePath);
        [self.deviceOutFile01 writeToFile:filePath atomically:NO];
        convertPcm2Wav(cFilePath,cNewfilePath,1,44100);
    }
    
    if (self.channelInput02 > 0) {
        NSString *pcmFileName = [NSString stringWithFormat:@"%@_2",self.defaultFileName];
        NSString *wavFileName = [NSString stringWithFormat:@"%@_2.wav",fileName];
        NSString *filePath = [fileOP getDirName:@"wavFilePcm" fileName:pcmFileName];
        NSString *newfilePath = [fileOP getDirName:@"wavFile" fileName:wavFileName];
        char *cFilePath = (char *)[filePath UTF8String];
        char *cNewfilePath = (char *)[newfilePath UTF8String];
        NSLog(@"%@",self.deviceOutFile02);
        NSLog(@"%@",newfilePath);
        [self.deviceOutFile02 writeToFile:filePath atomically:NO];
        convertPcm2Wav(cFilePath,cNewfilePath,1,44100);
    }
    
    if (self.channelInput03 > 0) {
        NSString *pcmFileName = [NSString stringWithFormat:@"%@_3",self.defaultFileName];
        NSString *wavFileName = [NSString stringWithFormat:@"%@_3.wav",fileName];
        NSString *filePath = [fileOP getDirName:@"wavFilePcm" fileName:pcmFileName];
        NSString *newfilePath = [fileOP getDirName:@"wavFile" fileName:wavFileName];
        char *cFilePath = (char *)[filePath UTF8String];
        char *cNewfilePath = (char *)[newfilePath UTF8String];
        NSLog(@"%@",self.phoneOutFile03);
        NSLog(@"%@",newfilePath);
        [self.phoneOutFile03 writeToFile:filePath atomically:NO];
        convertPcm2Wav(cFilePath,cNewfilePath,1,44100);
    }
    
   
}


- (void)clearData{
    self.deviceInput = nil;
    self.phoneInput = nil;
}

- (void)appendByDeviceInput:(NSData *)data
{
    //    将data添加到datainput中
    [self.deviceInput appendData:data];

    //    构造audioData 对象
    if (self.deviceInput.length < BytePerDeviceInput) {
        //        如果没有到 1024 * 4 这个长度的数据 就等待
        return;
    }
    [self processDeviceData];
//        [self.eyAudio playWithData:data];


    
//    dispatch_async(dispatch_get_main_queue(), ^{
//    });
//  把音频片段in01 in02 in03 保存为文件 把音频片段ou01 ou02写到输出设备   把音频片段播放只对out03   音频图绘制绘制只hui'zhi
}

- (void)processDeviceData
{
    NSUInteger deviceInputLenght = [self.deviceInput length];
    NSData *deviceInputData = [NSData dataWithData:self.deviceInput];

    Byte *deviceInput = (Byte *)[deviceInputData bytes];
    
    //清空数据
    [self.deviceInput resetBytesInRange:NSMakeRange(0, self.deviceInput.length)];
    [self.deviceInput setLength:0];
//    Byte byteData[deviceInputLenght];
    //    memcpy(byteData, [self.deviceInput bytes], deviceInputLenght);
//    for(int i=0;i<deviceInputLenght;i++)
//        NSLog(@"deviceInput = %hhx\n",deviceInput[i]);

    Byte *in01 = (Byte*)malloc(FramePerPacket * 2);
    Byte *in02 = (Byte*)malloc(FramePerPacket * 2);
    Byte *in03 = (Byte*)malloc(FramePerPacket * 2);
    
    Byte *out01 = (Byte*)malloc(FramePerPacket * 2);
    Byte *out02 = (Byte*)malloc(FramePerPacket * 2);
    Byte *out03 = (Byte*)malloc(FramePerPacket * 2);

    Byte *deviceOutput = (Byte*)malloc(BytePerDeviceInput);
    
//    NSLog(@"%@",deviceInputData);
//      channelInput01    channelInput02
    if (deviceInputLenght >= BytePerDeviceInput && (self.channelInput01 > 0 || self.channelInput02 > 0)) {
        
        for (int i = 0, j = 0; i<BytePerDeviceInput; i= i+4) {
        
            /*****************************************************/
            /*  边界处理, 四字节  */
            /*****************************************************/
            [self avoidOverflows:deviceInput startIdx:i];
            /*****************************************************/


            /*****************************************************/
            /*  拆包、重组处理  */
            /*****************************************************/
            if (i % 4 == 0) {
                // 构造01输入 第0字节 第1字节
                in01[j] = (self.channelInput01 == 0)? 0 : deviceInput[i];
                in01[j + 1] = (self.channelInput01 == 0)? 0 : deviceInput[i + 1];

                // 构造02输入 第2字节 第3字节
                in02[j] =  (self.channelInput02 == 0)? 0 : deviceInput[i + 2];
                in02[j + 1] =  (self.channelInput02 == 0)? 0 : deviceInput[i + 3];

                // 输出1相关计算
                // --------------------------------------------------------
                // 输出1 关闭时
                if (self.channelOutput01 == 0) {
                    out01[j] = 0;
                    out01[j + 1] = 0;
                }
                // 输出1 指向输入1 时
                else if (self.channelOutput01 == 1) {
                    out01[j] = in01[j];
                    out01[j + 1] = in01[j + 1];
                }
                // 输出1 指向输入2 时
                else if (self.channelOutput01 == 2) {
                    out01[j] = in02[j];
                    out01[j + 1] = in02[j + 1];
                }
                // 输出1 指向输入3 时
                else if (self.channelOutput01 == 3) {
                    out01[j] = in03[j];
                    out01[j + 1]  = in03[j + 1];
                }

                // 输出2相关计算
                // --------------------------------------------------------
                // 输出2 关闭时
                if (self.channelOutput02 == 0) {
                    out02[j] = 0;
                    out02[j + 1] = 0;
                }
                // 输出2 指向输入1 时
                else if (self.channelOutput02 == 1) {
                    out02[j] = in01[j];
                    out02[j + 1] = in01[j + 1];
                }
                // 输出2 指向输入2 时
                else if (self.channelOutput02 == 2) {
                    out02[j] = in02[j];
                    out02[j + 1] = in02[j + 1];
                }
                // 输出2 指向输入3 时
                else if (self.channelOutput02 == 3) {
                    out02[j] = in03[j];
                    out02[j + 1]  = in03[j + 1];
                }

                // 输出3相关计算
                // --------------------------------------------------------
                // 输出3 关闭时
                if (self.channelOutput03 == 0) {
                    out03[j] = 0;
                    out03[j + 1] = 0;
                }
                // 输出3 指向输入1 时
                else if (self.channelOutput03 == 1) {
                    out03[j] = in01[j];
                    out03[j + 1] = in01[j + 1];
                }
                // 输出3 指向输入2 时
                else if (self.channelOutput03 == 2) {
                    out03[j] = in02[j];
                    out03[j + 1] = in02[j + 1];
                }
                // 输出3 指向输入3 时
                else if (self.channelOutput03 == 3) {
                    out03[j] = in03[j];
                    out03[j + 1]  = in03[j + 1];
                }


                // 设备流输出
                deviceOutput[i] = out01[j];
                deviceOutput[i + 1] = out01[j + 1];
                deviceOutput[i + 2] = out02[j];
                deviceOutput[i + 3] = out02[j + 1];

                // short array
                // dest[i] = (short) (src[i * 2] << 8 | src[2 * i + 1] & 0xff);
                // 低位在前，或高位在前 LE or BE
//                if (isLE) {
//                    // short类型 显示short类型图 01
//                    v01[j / 2] = (short) (in01[j] & 0xff | in01[j + 1] << 8);
//                    v02[j / 2] = (short) (in02[j] & 0xff | in02[j + 1] << 8);
//                    //                        v01[j / 2] = (short) (deviceInput[i] & 0xff | deviceInput[i + 1] << 8);
//                    //                        v02[j / 2] = (short) (deviceInput[i + 2] & 0xff | deviceInput[i + 3] << 8);
//                } else {
//                    // short类型 显示short类型图 01
//                    v01[j / 2] = (short) (in01[j] << 8 | in01[j + 1] & 0xff);
//                    v02[j / 2] = (short) (in02[j] << 8 | in02[j + 1] & 0xff );
//                    //                        v01[j / 2] = (short) (deviceInput[i] << 8 | deviceInput[i + 1] & 0xff);
//                    //                        v02[j / 2] = (short) (deviceInput[i + 2] << 8 | deviceInput[i + 3] & 0xff );
//                }

                // step
//                NSLog(@"\nin01 = %hhx-%hhx\n in02 = %hhx-%hhx\n - deviceInput = %hhx-%hhx-%hhx-%hhx",in01[j],in01[j + 1],in02[j],in02[j + 1],deviceInput[i],deviceInput[i + 1],deviceInput[i + 2],deviceInput[i + 3]);
//
//                NSLog(@"\nout01 = %hhx-%hhx\n out02 = %hhx-%hhx\n",out01[j],out01[j + 1],out02[j],out02[j + 1]);

            
//               注意
                j += 2;
            }
            
            
            
//                        in01[j] = (channelInput01 == 0)? 0 : deviceInput[i];
//                            NSLog(@"deviceInput = %hhx\n",deviceInput[i]);
//                            NSLog(@"in01 = %hhx\n",in01[j]);
//
//            in01[j + 1] = (channelInput01 == 0)? 0 : deviceInput[i + 1];
//                            NSLog(@"deviceInput = %hhx\n",deviceInput[i + 1]);
//                            NSLog(@"in01 = %hhx\n",in01[j + 1]);
            
            
//             构造02输入 第2字节 第3字节
//            in02[j] =  (channelInput02 == 0)? 0 : deviceInput[i + 2];
//            in02[j + 1] =  (channelInput02 == 0)? 0 : deviceInput[i + 3];
            
        }
//        to do 数据到2048使用完毕有 需要释放
       
    }
    
    
    
    NSData *outputData = [NSData dataWithBytes:deviceOutput length:BytePerDeviceInput];
    [self writeNetworkDevice:outputData];
    
    
    if (self.channelInput01 > 0) {
        NSData *in01Data = [NSData dataWithBytes:in01 length:(FramePerPacket * 2)];
        [self.deviceOutFile01 appendData:in01Data];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"INPUT01DATA" object:in01Data];

    }
    
    if (self.channelInput02 > 0) {
        NSData *in02Data = [NSData dataWithBytes:in02 length:(FramePerPacket * 2)];
        [self.deviceOutFile02 appendData:in02Data];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"INPUT02DATA" object:in02Data];
    }
    

//    NSData *deviceOutputData = [NSData dataWithBytes:deviceOutput length:BytePerDeviceInput];
//    [self.deviceOutput appendData:deviceOutputData];
//
//
//    NSData *phoneOutputData = [NSData dataWithBytes:out03 length:BytePerPhoneInput];
//    [self.phoneOutput appendData:phoneOutputData];
    
//    if (self.channelOutput03 > 0) {
//
//    }


}


- (void)appendByPhoneInput:(NSData *)data
{
    //使用NSLog会使音频无法播放...
    //    将data添加到datainput中

    [self.phoneInput appendData:data];
    //    构造audioData 对象
    
    if (self.phoneInput.length < BytePerPhoneInput) {
        // 如果没有到 1024 * 2 这个长度的数据 就等待
        return;
    }
    [self processPhoneData];
    
    
    //writeAudioFile  writeSciChart  writeDevice5002  writeAudioPlayer
    //   把音频片段in01 in02 in03 保存为文件 把音频片段ou01 ou02写到输出设备   把音频片段播放只对out03   音频图绘制绘制只hui'zhi
}

- (void)processPhoneData
{
    NSUInteger phoneInputLenght = [self.phoneInput length];
    NSData *phoneInputData = [NSData dataWithData:self.phoneInput];
//    Byte *phoneInput = (Byte *)[phoneInputData bytes];
    //清空数据
    [self.phoneInput resetBytesInRange:NSMakeRange(0, self.phoneInput.length)];
    [self.phoneInput setLength:0];
//    Byte *in01 = self.audioData.in01;
//    Byte *in02 = self.audioData.in02;
    Byte *in03 = (Byte *)[phoneInputData bytes];
    
    Byte *out01 = (Byte*)malloc(FramePerPacket * 2);
    Byte *out02 = (Byte*)malloc(FramePerPacket * 2);
    Byte *out03 = (Byte*)malloc(FramePerPacket * 2);
    
    Byte *deviceOutput = (Byte*)malloc(BytePerDeviceInput);
    if (phoneInputLenght == BytePerPhoneInput && (self.channelInput03 > 0)) {
        /**
         *  循环遍历当前字节数组，步长为 2
         */
        for (int k3 = 0; k3 < BytePerPhoneInput; k3 = k3 + 2) {
            /*****************************************************/
            /*  拆包、重组处理  */
            /*****************************************************/
            if (k3 % 2 == 0) {
                // 输入3关闭时，输入3的值为 0
                if(self.channelInput03 == 0){
                    in03[k3] = 0;
                    in03[k3 + 1 ] = 0;
                }
                
                // 输出1相关计算
                // --------------------------------------------------------
                // 输出1 关闭时
                if (self.channelOutput01 == 0) {
                    out01[k3] = 0;
                    out01[k3 + 1] = 0;
                    // 重构设备输出  第0位 第1位
                    deviceOutput[2 * k3] = out01[k3];
                    deviceOutput[2 * k3 + 1] = out01[k3 + 1];
                }
                // 输出1 指向输入1 时
                else if(self.channelOutput01 == 1) {
                    
                }
                // 输出1 指向输入2 时
                else if(self.channelOutput01 == 2) {
                    
                }
                // 输出1 指向输入3 时
                else if(self.channelOutput01 == 3) {
                    out01[k3] = in03[k3];
                    out01[k3 + 1] = in03[k3 + 1];
                    // 重构设备输出 第0位 第1位
                    deviceOutput[2 * k3] = out01[k3];
                    deviceOutput[2 * k3 + 1] = out01[k3 + 1];
                }
                
                // 输出2相关计算
                // --------------------------------------------------------
                // 输出2 关闭时
                if (self.channelOutput02 == 0) {
                    out02[k3] = 0;
                    out02[k3 + 1] = 0;
                    // 重构设备输出 第2位 第3位
                    deviceOutput[2 * k3 + 2] = out02[k3];
                    deviceOutput[2 * k3 + 3] = out02[k3 + 1];
                }
                // 输出2 指向输入1 时
                else if(self.channelOutput02 == 1) {
                    
                }
                // 输出2 指向输入2 时
                else if(self.channelOutput02 == 2) {
                    
                }
                // 输出2 指向输入3 时
                else if(self.channelOutput02 == 3) {
                    out02[k3] = in03[k3];
                    out02[k3 + 1] = in03[k3 + 1];
                    // 重构设备输出 第2位 第3位
                    deviceOutput[2 * k3 + 2] = out02[k3];
                    deviceOutput[2 * k3 + 3] = out02[k3 + 1];
                }
                
                // --------------------------------------------------------
                
                
                // 输出3相关计算
                // --------------------------------------------------------
                // 输出3 关闭时
                if (self.channelOutput03 == 0) {
                    out03[k3] = 0;
                    out03[k3 + 1] = 0;
                }
                // 输出3 指向输入1 时
                else if(self.channelOutput03 == 1) {
                    
                }
                // 输出3 指向输入2 时
                else if(self.channelOutput03 == 2) {
                    
                }
                // 输出3 指向输入3 时
                else if(self.channelOutput03 == 3) {
                    out03[k3] = in03[k3];
                    out03[k3 + 1] = in03[k3 + 1];
                }
                
                // --------------------------------------------------------
                
                // 低位在前，或高位在前 LE or BE
                //            if (isLE) {
                //                // short类型 显示short类型图 03
                //                v03[k3 / 2] = (short) (in03[k3] & 0xff | in03[k3 + 1] << 8);
                //            } else {
                //                // short类型 显示short类型图 03
                //                v03[k3 / 2] = (short) (in03[k3] << 8 | in03[k3 + 1] & 0xff);
                //            }
                
            }
        }
    }
    
    NSData *data = [NSData dataWithBytes:out03 length:phoneInputLenght];
    [self.playAudioDataManager playWithData:data];

//   输出3文件写入
    [self.phoneOutFile03 appendData:data];
//    NSData *deviceOutputData = [NSData dataWithBytes:deviceOutput length:BytePerDeviceInput];
//    [self.deviceOutput appendData:deviceOutputData];
    
//    [self.phoneOutFile03 appendData:data];
    NSData *outputData = [NSData dataWithBytes:deviceOutput length:BytePerDeviceInput];
    [self writeNetworkDevice:outputData];
//    [self.phoneOutput appendData:phoneOutputData];
    //      channelInput01    channelInput02
}

- (void)writeNetworkDevice:(NSData *)outputData
{
    if(self.channelOutput01 > 0 || self.channelOutput02 > 0){
        for (int i = 0; i < outputData.length; i = i + 1024) {
            NSData *data = [outputData subdataWithRange:NSMakeRange(i, 1024)];
            [self.udpSocketServer sendUDPData:data toHost:self.ipAddress Port:5002 Tag:1];
        }
    }
}


- (void)avoidOverflows:(Byte *)data startIdx:(int)startIdx {
    if(YES) {
        int channelInput01AdjustNum = 552;
        int channelInput02AdjustNum = 846;
        
        channelInput01AdjustNum = 0;
        channelInput02AdjustNum = 0;
        
        if(self.isLE) {
            int c1 = 0;
            c1 = ( (data[startIdx] & 0xff) | data [startIdx + 1] << 8 ) + channelInput01AdjustNum;
            if (c1 < -32768) c1 = -32768;
            if (c1 > 32767) c1 = 32767;
            
            int c2 = 0;
            c2 = ( (data[startIdx + 2 ] & 0xff) | data [startIdx + 3] << 8 ) + channelInput02AdjustNum;
            if (c2 < -32768) c2 = -32768;
            if (c2 > 32767) c2 = 32767;
            
            data[startIdx] = (Byte) (c1 & 0xff);
            data[startIdx + 1] = (Byte) ((c1 >> 8) & 0xff);
            data[startIdx + 2] = (Byte) (c2 & 0xff);
            data[startIdx + 3] = (Byte) ((c2 >> 8) & 0xff);
        } else {
            int c1 = 0;
            c1 = data[startIdx] << 8 | (data [startIdx + 1] & 0xff + channelInput01AdjustNum);
            if (c1 < -32768) c1 = -32768;
            if (c1 > 32767) c1 = 32767;
            
            int c2 = 0;
            c2 = data[startIdx + 2] << 8 | (data[startIdx + 3] & 0xff  + channelInput02AdjustNum);
            if (c2 < -32768) c2 = -32768;
            if (c2 > 32767) c2 = 32767;
            
            data[startIdx] = (Byte) ((c1 >> 8) & 0xff);
            data[startIdx + 1] = (Byte) (c1 & 0xff);
            data[startIdx + 2] = (Byte) ((c2 >> 8) & 0xff);
            data[startIdx + 3] = (Byte) (c2 & 0xff);
        }
    }
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock host:(NSString *)host didReceiveData:(NSData *)data fromAddress:(NSData *)address
{
    
}
@end
