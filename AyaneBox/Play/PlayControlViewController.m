//
//  PlayControlViewController.m
//  AyaneBox
//
//  Created by yuanxuan on 2018/6/26.
//  Copyright © 2018年 AyaneBox. All rights reserved.
//

#import "PlayControlViewController.h"
#import "AyaneBox-Swift.h"
#import <SciChart/SciChart.h>
#import "FileViewController.h"
#import "EYAudio.h"
#import "SandboxFile.h"
#import <Accelerate/Accelerate.h>
#import "LEEAlert.h"

#define audioPlayLength 4096

#define audioDeviceLength 4096

@interface PlayControlViewController ()
@property (nonatomic, strong) IBOutlet UISegmentedControl *outputSegmentControl;
@property (nonatomic, assign) NSUInteger outputChannel;
@property (nonatomic, strong) IBOutlet UIButton *manageBtn;
@property (nonatomic, strong) IBOutlet UIButton *selectFileBtn;
@property (nonatomic, strong) IBOutlet UIButton *playBtn;
@property (nonatomic, strong) IBOutlet UILabel *fileLabel;
@property (nonatomic, strong) NSTimer *playTimer;
//@property (nonatomic, strong) dispatch_source_t playTimer;
@property (nonatomic, strong) NSMutableData *playWavFileData;
@property (nonatomic) NSUInteger curLocation;
@property (nonatomic, strong) NSData *curSelectFileData;
@property (nonatomic, strong) EYAudio *outAudioPlayer;
@property (nonatomic, strong) NSString *fileName;

@property (nonatomic, strong) IBOutlet UISegmentedControl *displaySegmentControl;
@property (nonatomic, assign) NSUInteger changeGraph;

@property (nonatomic, strong) NSTimer *playDeviceTimer;
@property (nonatomic) NSUInteger curOutDeviceLocation;

@property (nonatomic, weak) IBOutlet SCIChartSurface *audioWaveView;
@property (nonatomic, weak) IBOutlet SCIChartSurface *spectogramView;

@property (nonatomic, strong) CADisplayLink *displaylink;
@property (nonatomic, strong) AudioWaveformSurfaceController *audioWaveformSurfaceController;
@property (nonatomic, strong) SpectogramSurfaceController *spectogramSurfaceController;

@property samplesToEngine sampleToEngineDelegate;
@property samplesToEngineFloat spectrogramSamplesDelegate;
@end

@implementation PlayControlViewController
@synthesize outAudioPlayer;
@synthesize playWavFileData;
//@synthesize spectrogramSurfaceView,audioWaveformSurfaceView;
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    self.title = @"播放";
    [super viewDidLoad];
//   默认输出1
    self.outputChannel = 3;
    [self.outputSegmentControl setSelectedSegmentIndex:self.outputChannel-1];
    
//    默认是2d图形
    self.changeGraph = 0;
    [self.displaySegmentControl  setSelectedSegmentIndex:self.changeGraph];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectFileName:) name:@"SelectFile" object:nil];
    [self.selectFileBtn addTarget:self action:@selector(enterFileList:) forControlEvents:UIControlEventTouchUpInside];
    [self.manageBtn addTarget:self action:@selector(enterFileList:) forControlEvents:UIControlEventTouchUpInside];
    
//  初始化2D图 swift
    self.audioWaveformSurfaceController = [[AudioWaveformSurfaceController alloc] init:self.audioWaveView];
    
//  初始化3D图 swift
    self.spectogramSurfaceController = [[SpectogramSurfaceController alloc] init:self.spectogramView];
   
//  初始化隐藏
    self.audioWaveView.hidden = NO;
    self.spectogramView.hidden = YES;
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
            self.spectogramView.hidden = YES;
        }
            break;
        case 1:
        {
            self.audioWaveView.hidden = YES;
            self.spectogramView.hidden = NO;
        }
            break;
            
        default:
            break;
    }
    self.changeGraph = sender.selectedSegmentIndex;
}

#pragma mark - 选择文件
- (void)selectFileName:(NSNotification *)obj
{
    NSString *curfileName = [obj object];
    self.fileName = curfileName;
    self.fileLabel.text = self.fileName;
    
//  保证上传的是WAV 文件
//  播放是PCM文件
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"wav"];

    
    NSString *filePath = [SandboxFile GetPathForDocuments:self.fileName inDir:@"wavFile"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSLog(@"%ld",[data length]);
    self.curSelectFileData = data;
}

#pragma mark - 播放音频
- (void)playAudioTimer{
    NSInteger wavLength = self.playWavFileData.length - self.curLocation;
    NSLog(@"self.curLocation:%ld",self.curLocation);
    if (wavLength <= audioPlayLength) {
        NSData *data = [self.playWavFileData subdataWithRange:NSMakeRange(self.curLocation, wavLength)];
        [self processAudioData:data];
        [PCMDataSource sharedData].isPlay = NO;
        [self.outAudioPlayer stop];
        self.playBtn.selected = NO;
        [self.playTimer invalidate];
        self.playTimer = nil;
        self.playWavFileData = nil;
        self.curLocation = 0;
        if (self.outputChannel == 1 || self.outputChannel == 2) {
            [self playDeviceAudioTimer];
        }
    }else {
        NSData *data = [self.playWavFileData subdataWithRange:NSMakeRange(self.curLocation, audioPlayLength)];
        //        处理数据
        [self processAudioData:data];
        self.curLocation = self.curLocation + audioPlayLength;
        if (self.outputChannel == 1 || self.outputChannel == 2) {
            [self playDeviceAudioTimer];
        }
    }
    
    
}
#pragma mark - 处理音频数据
- (void)processAudioData:(NSData *)data
{
    switch (self.outputChannel) {
        case 1:
        {
            [self.outAudioPlayer playWithData:data];
        }
            break;
        case 2:
        {
            [self.outAudioPlayer playWithData:data];
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
    [self.audioWaveformSurfaceController updateDataXY];
    [self.spectogramSurfaceController updateDataXY];
}

- (void)playDeviceAudioTimer
{
    NSInteger wavLength = self.playWavFileData.length - self.curOutDeviceLocation;
    if (wavLength <= audioDeviceLength) {
        NSData *data = [self.playWavFileData subdataWithRange:NSMakeRange(self.curOutDeviceLocation, wavLength)];
        [self processOutput:data];
        self.curOutDeviceLocation = 0;
        
    }else {
        NSData *data = [self.playWavFileData subdataWithRange:NSMakeRange(self.curOutDeviceLocation, audioDeviceLength)];
        [self processOutput:data];
        self.curOutDeviceLocation = self.curOutDeviceLocation + audioDeviceLength;
    }
}
#pragma mark - 点击播放按钮
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
        [[PCMDataSource sharedData] startUDPserve];
        [self.audioWaveformSurfaceController clearChartSurface];
        [self.spectogramSurfaceController clearChartSurface];
        if (self.outAudioPlayer) {
            self.outAudioPlayer = nil;
        }
        switch (self.outputChannel) {
            case 1:
            {
                self.outAudioPlayer = [[EYAudio alloc] initWithVolume:0];
                self.outAudioPlayer.sampleToEngineDelegate = self.audioWaveformSurfaceController.updateDataSeries;
                self.outAudioPlayer.spectrogramSamplesDelegate = self.spectogramSurfaceController.updateDataSeries;
            }
                break;
            case 2:
            {
                self.outAudioPlayer = [[EYAudio alloc] initWithVolume:0];
                self.outAudioPlayer.sampleToEngineDelegate = self.audioWaveformSurfaceController.updateDataSeries;
                self.outAudioPlayer.spectrogramSamplesDelegate = self.spectogramSurfaceController.updateDataSeries;
            }
                break;
            case 3:
            {
                self.outAudioPlayer = [[EYAudio alloc] init];
                self.outAudioPlayer.sampleToEngineDelegate = self.audioWaveformSurfaceController.updateDataSeries;
                self.outAudioPlayer.spectrogramSamplesDelegate = self.spectogramSurfaceController.updateDataSeries;
            }
                break;
            default:
                break;
        }
        [PCMDataSource sharedData].isPlay = YES;
        self.curLocation = 0;
        self.curOutDeviceLocation = 0;
        self.playBtn.selected = YES;
        if (self.playWavFileData) {
            self.playWavFileData = nil;
        }
//        [self.audioWaveformSurfaceController resetData];
        self.playWavFileData = [NSMutableData dataWithData:self.curSelectFileData];
        //        去掉头部44字节 变成pcm 格式数据
        [self.playWavFileData replaceBytesInRange:NSMakeRange(0, 44) withBytes:NULL length:0];
        
        
        self.playTimer = [NSTimer scheduledTimerWithTimeInterval:(44100/8192/1000) target:self selector:@selector(playAudioTimer) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.playTimer forMode:NSRunLoopCommonModes];
    }else {
//      回归初始状态
        [PCMDataSource sharedData].isPlay = NO;
        self.playBtn.selected = NO;
        [self.outAudioPlayer stop];
//      停止定时器
        [self.playTimer invalidate];
        self.playTimer = nil;
        self.playWavFileData = nil;
        self.curLocation = 0;
        self.curOutDeviceLocation = 0;
        [[PCMDataSource sharedData] stopUDPserve];
    }
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

#pragma mark - 输出到信道一、信道二
- (void)processOutput:(NSData *)data
{
    if (self.outputChannel == 1) {
        [self processingOutput01:data];
    }else if(self.outputChannel == 2) {
        [self processingOutput02:data];
    }else {
        
    }
}
- (void)processingOutput01:(NSData *)data
{
    NSUInteger length = data.length;
    NSMutableData *output = [NSMutableData dataWithLength:length*2];
    Byte *fileOut = (Byte *)[data bytes];
    for (int i = 0; i < length/2; i++) {
        [output replaceBytesInRange:NSMakeRange(i*4, 2) withBytes:&fileOut[i*2]];
    }
    [[PCMDataSource sharedData] writePlayNetworkDevice:output];
}

- (void)processingOutput02:(NSData *)data
{
    NSUInteger length = data.length;
    NSMutableData *output = [NSMutableData dataWithLength:length*2];
    Byte *fileOut = (Byte *)[data bytes];
    for (int i = 0; i < length/2; i++) {
        [output replaceBytesInRange:NSMakeRange(i*4+2, 2) withBytes:&fileOut[i*2]];
    }
    [[PCMDataSource sharedData] writePlayNetworkDevice:output];
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
