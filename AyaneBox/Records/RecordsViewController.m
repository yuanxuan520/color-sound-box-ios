//
//  RecordsViewController.m
//  AyaneBox
//
//  Created by yuanxuan on 2018/6/26.
//  Copyright © 2018年 AyaneBox. All rights reserved.
//

#import "RecordsViewController.h"
#import "AyaneBox-Swift.h"
#import <Accelerate/Accelerate.h>
#import "LEEAlert.h"
#import "SetPopTextView.h"
#import "EYAudio.h"
#define audioPlayLength 4096

@interface RecordsViewController ()

@property (nonatomic, strong) IBOutlet UIButton *recordBtn;
@property (nonatomic, strong) IBOutlet UIView *mainView;
@property (nonatomic, strong) IBOutlet UISegmentedControl *inputSegmentControl;
// 播放Pcm控件对象
@property (nonatomic, strong) EYAudio *playAudioDataManager;
// 录制Pcm控件对象
@property (nonatomic, strong) AudioRecorder *audioRecorderDataManager;
// 播放录音文件Timer
@property (nonatomic, strong) NSTimer *playTimer;
//@property (nonatomic, strong) dispatch_source_t playTimer;

@property (nonatomic) NSUInteger curLocation;


// 文件名部分
@property (nonatomic, strong) NSString *filename;
@property (nonatomic, assign) NSUInteger inputChannel;

// 图形绘图部分
@property (nonatomic, strong) IBOutlet UISegmentedControl *displaySegmentControl;
@property (nonatomic, assign) NSUInteger changeGraph;

@property (nonatomic, weak) IBOutlet SCIChartSurface *audioWaveView;
@property (nonatomic, weak) IBOutlet SCIChartSurface *spectogramView;
@property (nonatomic, strong) AudioWaveformSurfaceController *audioWaveformSurfaceController;
@property (nonatomic, strong) SpectogramSurfaceController *spectogramSurfaceController;

@property samplesToEngine sampleToEngineDelegate;
@property samplesToEngineFloat spectrogramSamplesDelegate;
- (IBAction)recordAudio:(UIButton *)btn;
@end

@implementation RecordsViewController
@synthesize audioRecorderDataManager;
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
    self.title = @"录音";
    [super viewDidLoad];
    
    // 默认是输出3端口
    self.inputChannel = 3;
    [self.inputSegmentControl setSelectedSegmentIndex:self.inputChannel-1];
    
    //    默认是3d图形
    self.changeGraph = 0;
    [self.displaySegmentControl  setSelectedSegmentIndex:self.changeGraph];

    // 初始化2D图 swift
    self.audioWaveformSurfaceController = [[AudioWaveformSurfaceController alloc] init:self.audioWaveView];
    
    // 初始化3D图
    self.spectogramSurfaceController = [[SpectogramSurfaceController alloc] init:self.spectogramView];
    
    self.audioWaveView.hidden = NO;
    self.spectogramView.hidden = YES;
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

#pragma mark - 播放音频
- (void)playAudioTimer{
    switch (self.inputChannel) {
        case 1:
        {
            NSInteger wavLength = [PCMDataSource sharedData].outputDevice01.length - self.curLocation;
            if (wavLength >= audioPlayLength) {
                NSData *data = [[PCMDataSource sharedData].outputDevice01 subdataWithRange:NSMakeRange(self.curLocation, audioPlayLength)];
                //        处理数据
                [self processAudioData:data];
                self.curLocation = self.curLocation + audioPlayLength;
            }else {
                NSData *data = [NSMutableData dataWithLength:audioPlayLength];
                [self processAudioData:data];
            }
        }
            break;
        case 2:
        {
            NSInteger wavLength = [PCMDataSource sharedData].outputDevice02.length - self.curLocation;
            if (wavLength >= audioPlayLength) {
                NSData *data = [[PCMDataSource sharedData].outputDevice01 subdataWithRange:NSMakeRange(self.curLocation, audioPlayLength)];
                //        处理数据
                [self processAudioData:data];
                self.curLocation = self.curLocation + audioPlayLength;
            }else {
                NSData *data = [NSMutableData dataWithLength:audioPlayLength];
                [self processAudioData:data];
            }
        }
            break;
        case 3:
        {
            NSInteger wavLength = [PCMDataSource sharedData].outputPhone03.length - self.curLocation;
            if (wavLength >= audioPlayLength) {
                NSData *data = [[PCMDataSource sharedData].outputPhone03 subdataWithRange:NSMakeRange(self.curLocation, audioPlayLength)];
                //        处理数据
                [self processAudioData:data];
                self.curLocation = self.curLocation + audioPlayLength;
            }else {
                NSData *data = [NSMutableData dataWithLength:audioPlayLength];
                [self processAudioData:data];
            }
        }
            break;
        default:
            break;
    }
    
}
- (void)processAudioData:(NSData *)data
{
    if (self.inputChannel == 1) {
        if ([PCMDataSource sharedData].channelInput01 > 0) {
            [self playWithDataAnd2d3dDisplay:data];
        }
    }
    
    if (self.inputChannel == 2) {
        if ([PCMDataSource sharedData].channelInput02 > 0) {
            [self playWithDataAnd2d3dDisplay:data];
        }
    }
    
    if (self.inputChannel == 3) {
        if ([PCMDataSource sharedData].channelInput03 > 0) {
            [self playWithDataAnd2d3dDisplay:data];
        }
    }
}

- (void)playWithDataAnd2d3dDisplay:(NSData *)data
{
    [self.playAudioDataManager playWithData:data];
    [self.audioWaveformSurfaceController updateDataXY];
    [self.spectogramSurfaceController updateDataXY];
}

#pragma mark - 切换输出信道
- (IBAction)changeintputChannel:(UISegmentedControl *)sender
{
    if ([PCMDataSource sharedData].isRecord) { // 如果当前正在播放时
        [LEEAlert alert].config
        .LeeTitle(@"注意")
        .LeeContent(@"当前正在录音无法切换输入.")
        .LeeAction(@"确定", ^{
        })
        .LeeShow(); // 设置完成后 别忘记调用Show来显示
        [sender setSelectedSegmentIndex:self.inputChannel-1];
    }else {
        self.inputChannel = sender.selectedSegmentIndex+1;
    }
}
#pragma mark 点击录制按钮
- (IBAction)recordAudio:(UIButton *)btn
{
//    if (self.inputChannel == 1 && [PCMDataSource sharedData].channelInput01 == 0) {
//        [LEEAlert alert].config
//        .LeeTitle(@"注意")
//        .LeeContent(@"需要在设置中开启输入信道1才可录音.")
//        .LeeAction(@"确定", ^{
//        })
//        .LeeShow(); // 设置完成后 别忘记调用Show来显示
//        return;
//    }else if(self.inputChannel == 2 && [PCMDataSource sharedData].channelInput02 == 0) {
//        [LEEAlert alert].config
//        .LeeTitle(@"注意")
//        .LeeContent(@"需要在设置中开启输入信道2才可录音.")
//        .LeeAction(@"确定", ^{
//        })
//        .LeeShow(); // 设置完成后 别忘记调用Show来显示
//        return;
//    }else if(self.inputChannel == 3 && [PCMDataSource sharedData].channelInput03 == 0){
//        [LEEAlert alert].config
//        .LeeTitle(@"注意")
//        .LeeContent(@"需要在设置中开启输入信道3才可录音.")
//        .LeeAction(@"确定", ^{
//        })
//        .LeeShow(); // 设置完成后 别忘记调用Show来显示
//        return;
//    }
    
    // 录音
    if (![PCMDataSource sharedData].isRecord) {
        [self.audioWaveformSurfaceController clearChartSurface];
        [self.spectogramSurfaceController clearChartSurface];
//      开始录制
        self.curLocation = 0;
        self.recordBtn.selected = YES;
//      初始化播放和录音 以及相关数据
//        self.playAudioDataManager = [[EYAudio alloc] init];
        [[PCMDataSource sharedData] startRecord];
        [PCMDataSource sharedData].isRecord = YES;
//       判断是否输出声音
        if ([PCMDataSource sharedData].channelOutput01 == 3) {
            self.playAudioDataManager = [[EYAudio alloc] init];
        }else if ([PCMDataSource sharedData].channelOutput02 == 3) {
            self.playAudioDataManager = [[EYAudio alloc] init];
        }else if ([PCMDataSource sharedData].channelOutput03 == 3){
            self.playAudioDataManager = [[EYAudio alloc] init];
        }else {
            self.playAudioDataManager = [[EYAudio alloc] initWithVolume:0];
        }
        
//      录音管理
        self.audioRecorderDataManager = [[AudioRecorder alloc] init];
        
        self.playAudioDataManager.sampleToEngineDelegate = self.audioWaveformSurfaceController.updateDataSeries;
        self.playAudioDataManager.spectrogramSamplesDelegate = self.spectogramSurfaceController.updateDataSeries;
        if ([PCMDataSource sharedData].channelInput03 > 0) { // 输入3 开启
            self.audioRecorderDataManager.samplesToEngineDataDelegate = ^(NSData *data){
                [[PCMDataSource sharedData] appendByPhoneInput:data];
            };
            [self.audioRecorderDataManager startRecording];
        }
        
//        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
//        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, (44100/2048/1000) * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
//        dispatch_source_set_event_handler(timer, ^{
//           [self playAudioTimer];
//        });
//        dispatch_resume(timer);
//        self.playTimer = timer; //一定要用强指针引着
        self.playTimer = [NSTimer scheduledTimerWithTimeInterval:(44100/2048/1000) target:self selector:@selector(playAudioTimer) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.playTimer forMode:NSRunLoopCommonModes];

    }else {
// 关闭录音
        [PCMDataSource sharedData].isRecord = NO;
        self.recordBtn.selected = NO;
        [self.audioRecorderDataManager stopRecording];
        [self.playAudioDataManager stop];
        self.playAudioDataManager = nil;
        self.audioRecorderDataManager = nil;
        [[PCMDataSource sharedData] stopRecord];

        SetPopTextView *setPopTextView = [[SetPopTextView alloc] init];
        [setPopTextView show:self.view.window setTitle:@"存储语音文件" fileName:[PCMDataSource sharedData].defaultFileName setSetText:^(NSString *notice) {
            [[PCMDataSource sharedData] saveWavFile:notice];
        }  close:^{
            [[PCMDataSource sharedData] cancleSaveWavFile];
        }];
        self.curLocation = 0;
        [self.playTimer invalidate];
//        dispatch_cancel(self.playTimer);
        self.playTimer = nil;
//      弹出保存文件框框
//      停止播放 和录音
//      保存文件 对应的文件
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
