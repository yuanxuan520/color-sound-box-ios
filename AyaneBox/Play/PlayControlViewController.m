//
//  PlayControlViewController.m
//  AyaneBox
//
//  Created by yuanxuan on 2018/6/26.
//  Copyright © 2018年 AyaneBox. All rights reserved.
//

#import "PlayControlViewController.h"
#import "FileViewController.h"
#import "EYAudio.h"
#import "SandboxFile.h"
#import <Accelerate/Accelerate.h>
#import "SpectrogramSurfaceView.h"
#import "AudioWaveformSurfaceView.h"
#import "LEEAlert.h"
#import "AudioRecorder.h"

#define audioPlayLength 2048

@interface PlayControlViewController ()
{
    FFTSetup fftSetup;
    uint length;
}
@property (nonatomic, strong) IBOutlet UISegmentedControl *outputSegmentControl;
@property (nonatomic, assign) NSUInteger outputChannel;
@property (nonatomic, strong) IBOutlet UIButton *manageBtn;
@property (nonatomic, strong) IBOutlet UIButton *selectFileBtn;
@property (nonatomic, strong) IBOutlet UIButton *playBtn;
@property (nonatomic, strong) IBOutlet UILabel *fileLabel;
@property (nonatomic, strong) NSTimer *playTimer;
@property (nonatomic, strong) NSMutableData *playWavFileData;
@property (nonatomic) NSUInteger curLocation;
@property (nonatomic, strong) NSData *curSelectFileData;
@property (nonatomic, strong) EYAudio *outAudioPlayer;
@property (nonatomic, strong) NSString *fileName;

@property (nonatomic, strong) IBOutlet SCIChartSurface *audioWaveView;
@property (nonatomic, strong) IBOutlet UIStackView *spectogramStackView;
@property (nonatomic, strong) IBOutlet SCIChartSurface *spectogramView;
@property (nonatomic, strong) IBOutlet UISegmentedControl *displaySegmentControl;

@property (nonatomic, strong) CADisplayLink *displaylink;
@property (nonatomic, strong) AudioWaveformSurfaceController *audioWaveformSurfaceController;
@property (nonatomic, strong) SpectogramSurfaceController *spectogramSurfaceController;

@property (nonatomic, strong) AudioWaveformSurfaceView *audioWaveformSurfaceView;
@property (nonatomic, strong) SpectrogramSurfaceView *spectrogramSurfaceView;

@property samplesToEngine sampleToEngineDelegate;
@property samplesToEngineFloat spectrogramSamplesDelegate;
@end

@implementation PlayControlViewController
@synthesize outAudioPlayer;
@synthesize playWavFileData;
@synthesize spectogramStackView;
@synthesize spectrogramSurfaceView,audioWaveformSurfaceView;
@synthesize displaylink;
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.view.backgroundColor = UIColorHex(0xebebeb);
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = UIColorHex(0x303f4a);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}
- (void)viewDidLoad {
    self.title = @"播放";
    [super viewDidLoad];
    //   默认输出1
    self.outputChannel = 3;
    [self.outputSegmentControl setSelectedSegmentIndex:self.outputChannel-1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectFileName:) name:@"SelectFile" object:nil];
    [self.selectFileBtn addTarget:self action:@selector(enterFileList:) forControlEvents:UIControlEventTouchUpInside];
    [self.manageBtn addTarget:self action:@selector(enterFileList:) forControlEvents:UIControlEventTouchUpInside];

    
//   初始化2D图 swift
    self.audioWaveformSurfaceController = [[AudioWaveformSurfaceController alloc] init:self.audioWaveView];
    //    self.audioWaveView
    self.sampleToEngineDelegate = self.audioWaveformSurfaceController.updateDataSeries;
    
    
//    初始化3D图
    
//    self.spectogramSurfaceController = [[SpectogramSurfaceController alloc] init:self.spectogramView];
//    self.spectrogramSamplesDelegate = self.spectogramSurfaceController.updateDataSeries;
//
    //    [self.audioWaveView ]
    
    self.audioWaveView.hidden = NO;
//    self.spectogramStackView.hidden = YES;
    
    
    
//    oc  2D图形
//    self.audioWaveformSurfaceView = [[AudioWaveformSurfaceView alloc] initWithFrame:CGRectMake(0, APPNavStateBar+ 80, APPMainViewWidth, APPMainViewHeight-APPNavStateBar-50-80)];
//    [self.view addSubview:self.audioWaveformSurfaceView];
//    [self.view sendSubviewToBack:self.audioWaveformSurfaceView];
    
    //  oc 3D图形
    //    self.spectrogramSurfaceView = [[SpectrogramSurfaceView alloc] initWithFrame:CGRectMake(0, APPNavStateBar+ 80, APPMainViewWidth, APPMainViewHeight-APPNavStateBar-50-80)];
    //    [self.view addSubview:self.spectrogramSurfaceView];
    //    [self.view sendSubviewToBack:self.spectrogramSurfaceView];
}

#pragma mark - 切换输出信道
- (IBAction)changeOutputChannel:(UISegmentedControl *)sender
{
    if ([PCMDataSource sharedData].isPlay) { // 如果当前正在播放时
        [LEEAlert alert].config
        .LeeTitle(@"注意")
        .LeeContent(@"当前正在播放声音无法切换输出.")
        .LeeAction(@"确定", ^{
        })
        .LeeShow(); // 设置完成后 别忘记调用Show来显示
        [sender setSelectedSegmentIndex:self.outputChannel-1];
    }else {
        self.outputChannel = sender.selectedSegmentIndex+1;
    }
}
#pragma mark - 切换2d3d图形
- (IBAction)change2D3DDisplay:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
        {
            self.audioWaveView.hidden = NO;
//            self.spectogramStackView.hidden = YES;
        }
            break;
        case 1:
        {
            self.audioWaveView.hidden = YES;
//            self.spectogramStackView.hidden = NO;
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 选择文件
- (void)selectFileName:(NSNotification *)obj
{
    NSString *curfileName = [obj object];
    self.fileName = curfileName;
    self.fileLabel.text = self.fileName;
    
    //   保证上传的是WAV 文件
    //   播放是PCM 文件
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ch03" ofType:@"wav"];
    
    NSString *filePath = [SandboxFile GetPathForDocuments:self.fileName inDir:@"wavFile"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    self.curSelectFileData = data;
}

#pragma mark - 切换播放音频
- (void)playAudioTimer{
    
    NSInteger wavLength = self.playWavFileData.length - audioPlayLength;
    if (wavLength > 0) {
        
        NSData *data = [self.playWavFileData subdataWithRange:NSMakeRange(0, audioPlayLength)];
        
        [self drawingGraphics:data];
        [self processAudioData:data];
        //删除数据
        [self.playWavFileData replaceBytesInRange:NSMakeRange(0, audioPlayLength) withBytes:NULL length:0];
        //            [self.playWavFileData resetBytesInRange:NSMakeRange(0, 2048)];
    }else {
        NSData *data = [self.playWavFileData subdataWithRange:NSMakeRange(0, self.playWavFileData.length)];
        [self drawingGraphics:data];
        [self processAudioData:data];
        [self.playWavFileData replaceBytesInRange:NSMakeRange(0, self.playWavFileData.length) withBytes:NULL length:0];
        
        [PCMDataSource sharedData].isPlay = NO;
        [self.outAudioPlayer stop];
        self.playBtn.selected = NO;
        [self.playTimer invalidate];
        self.playTimer = nil;
        [self.displaylink invalidate];
        self.displaylink = nil;
    }
    
}
#pragma mark - 处理音频数据
- (void)processAudioData:(NSData *)data
{
    switch (self.outputChannel) {
        case 1:
        {
            [self ProcessingOutput01:data];
        }
            break;
        case 2:
        {
            [self ProcessingOutput02:data];
        }
            break;
        case 3:
        {
            [self.outAudioPlayer playWithData:data];
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 绘制 -2d -3d
- (void)drawingGraphics:(NSData *)data
{
//   2d图形
    Byte* samples = (Byte *)[data bytes];
    BOOL isLE = YES;
    int *v04 = malloc(audioPlayLength/2);
    for (int k4 = 0; k4 < audioPlayLength; k4 = k4 + 2) {
        if (k4 % 2 == 0) {
            // 低位在前，或高位在前 LE or BE
            if (isLE) {
                // short类型 显示short类型图 04
                v04[k4 / 2] = (int) (((samples[k4] & 0xff) | samples[k4 + 1] << 8) & 0xffff);
//                NSLog(@"%d",v04[k4 / 2]);
                //                    NSLog(@"%d-%d-%d",v04[k4 / 2],samples[k4],samples[k4+1]);
            } else {
                // short类型 显示short类型图 04
                v04[k4 / 2] = (int) (samples[k4] << 8 | (samples[k4 + 1] & 0xff));
            }
        }
    }
    if ([self sampleToEngineDelegate] != nil){
        [self sampleToEngineDelegate](v04);
    }
    
    //            绘制图形
    //        NSData *sampleData = [self.playWavFileData subdataWithRange:NSMakeRange(0, audioPlayLength)];
    //            int* fftSample = malloc([data length]);
    //            memcpy(fftSample, (int *)[data bytes], [data length]);
    //            float* fftArray = [self calculateFFT:(int *)[self.curSelectFileData bytes] size:[self.curSelectFileData length]];
    
    //
    //            [self.spectrogramSurfaceView updateDataSeries:fftArray];
    //           播放声音
}

- (IBAction)playAudio:(UIButton *)btn
{
    if (self.curSelectFileData == nil) {
        [LEEAlert alert].config
        .LeeTitle(@"注意")
        .LeeContent(@"请选择文件")
        .LeeAction(@"确定", ^{
        })
        .LeeShow(); // 设置完成后 别忘记调用Show来显示
        return;
    }
    
    if (![PCMDataSource sharedData].isPlay) {
        switch (self.outputChannel) {
            case 1:
            {
                
            }
                break;
            case 2:
            {
                
            }
                break;
            case 3:
            {
                if (self.outAudioPlayer) {
                    self.outAudioPlayer = nil;
                }
                self.outAudioPlayer = [[EYAudio alloc] init];
            }
                break;
                
            default:
                break;
        }
        [PCMDataSource sharedData].isPlay = YES;
        length = (uint)floor(log2(2048));
        fftSetup = vDSP_create_fftsetup(length, kFFTRadix2);
        self.curLocation = 0;
        self.playBtn.selected = YES;
        if (self.playWavFileData) {
            self.playWavFileData = nil;
        }
        //        [self.audioWaveformSurfaceController initData];
        self.playWavFileData = [NSMutableData dataWithData:self.curSelectFileData];
        //        去掉头部44字节 变成pcm 格式数据
        [self.playWavFileData replaceBytesInRange:NSMakeRange(0, 44) withBytes:NULL length:0];
        
        self.playTimer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(playAudioTimer) userInfo:nil repeats:YES];
        self.displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateData:)];
        [self.displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }else {
        [PCMDataSource sharedData].isPlay = NO;
        self.playBtn.selected = NO;
        switch (self.outputChannel) {
            case 1:
            {
                
            }
                break;
            case 2:
            {
                
            }
                break;
            case 3:
            {
                [self.outAudioPlayer stop];
            }
                break;
                
            default:
                break;
        }
        [self.playTimer invalidate];
        self.playTimer = nil;
        [self.displaylink invalidate];
        self.displaylink = nil;
    }
}

#pragma mark - 显示更新
- (void)updateData:(CADisplayLink *)displayLink
{
    //    [self.spectrogramSurfaceController updateDataWithDisplayLink:displayLink];
//    oc
//    [self.audioWaveformSurfaceView updateData:displayLink];
//    swift
    [self.audioWaveformSurfaceController updateDataWithDisplayLink:displayLink];
}

#pragma mark - 文件列表
- (void)enterFileList:(UIButton *)btn
{
    FileViewController *fileViewControl = [[FileViewController alloc] init];
    fileViewControl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:fileViewControl animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (float*) calculateFFT: (int*)data size:(NSUInteger)numSamples{
    
    float *dataFloat = malloc(sizeof(float)*numSamples);
    vDSP_vflt32(data, 1, dataFloat, 1, numSamples);
    
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
        
        float current = (sqrt(tempSplitComplex.realp[i]*tempSplitComplex.realp[i] + tempSplitComplex.imagp[i]*tempSplitComplex.imagp[i]) * 0.000025);
        current = log10(current)*10;
        result[i] = current;
        
    }
    
    free(dataFloat);
    free(audioBufferComplex);
    free(tempSplitComplex.imagp);
    free(tempSplitComplex.realp);
    
    return result;
}

#pragma mark - 输出到信道一、信道二、信道三

- (void)ProcessingOutput01:(NSData *)data
{
    NSMutableData *output01 = [NSMutableData dataWithLength:4096];
    Byte *out03 = (Byte *)[data bytes];
    for (int i = 0; i < data.length; i++) {
        [output01 replaceBytesInRange:NSMakeRange(i*4, 2) withBytes:&out03[i]];
    }
    
    
}

- (void)ProcessingOutput02:(NSData *)data
{
    NSMutableData *output02 = [NSMutableData dataWithLength:4096];
    Byte *out03 = (Byte *)[data bytes];
    for (int i = 0; i < data.length; i++) {
        [output02 replaceBytesInRange:NSMakeRange(i*4+2, 2) withBytes:&out03[i]];
    }
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
