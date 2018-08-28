//
//  RecordsViewController.m
//  AyaneBox
//
//  Created by yuanxuan on 2018/6/26.
//  Copyright © 2018年 AyaneBox. All rights reserved.
//

#import "RecordsViewController.h"
#import <SciChart/SciChart.h>
#import "AyaneBox-Swift.h"
#import <Accelerate/Accelerate.h>
#import "LEEAlert.h"
//#import "AudioWaveformSurfaceView.h"
//#import "SpectrogramSurfaceView.h"
#import "SetPopTextView.h"
#import "EYAudio.h"

@interface RecordsViewController ()

@property (nonatomic, strong) IBOutlet UIButton *recordBtn;
@property (nonatomic, strong) IBOutlet UIView *mainView;
@property (nonatomic, strong) IBOutlet UISegmentedControl *inputSegmentControl;
// 播放Pcm控件对象
@property (nonatomic, strong) EYAudio *playAudioDataManager;
// 录制Pcm控件对象
@property (nonatomic, strong) AudioRecorder *audioRecorderDataManager;

// 文件名部分
@property (nonatomic, strong) NSString *filename;
@property (nonatomic, assign) NSUInteger inputChannel;

@property (nonatomic, strong) IBOutlet UISegmentedControl *displaySegmentControl;
@property (nonatomic, assign) NSUInteger changeGraph;

// 绘图部分
//@property (nonatomic, strong) AudioWaveformSurfaceView *audioWaveformSurfaceView;
//@property (nonatomic, strong) SpectrogramSurfaceView *spectrogramSurfaceView;
@property (nonatomic, strong) IBOutlet SCIChartSurface *audioWaveView;
@property (nonatomic, strong) IBOutlet SCIChartSurface *spectogramView;
@property (nonatomic, strong) CADisplayLink *displaylink;
@property (nonatomic, strong) AudioWaveformSurfaceController *audioWaveformSurfaceController;
@property (nonatomic, strong) SpectogramSurfaceController *spectogramSurfaceController;

@property samplesToEngine sampleToEngineDelegate;
@property samplesToEngineFloat spectrogramSamplesDelegate;
- (IBAction)recordAudio:(UIButton *)btn;
@end

@implementation RecordsViewController
@synthesize audioRecorderDataManager;
//@synthesize audioWaveformSurfaceView;
//,spectrogramSurfaceView;
//@synthesize audioWaveformSurfaceController,spectrogramSurfaceController;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getInput01Data:) name:@"INPUT01DATA" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getInput02Data:) name:@"INPUT02DATA" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getInput03Data:) name:@"INPUT03DATA" object:nil];
    
    // 默认是输出3端口
    self.inputChannel = 3;
    [self.inputSegmentControl setSelectedSegmentIndex:self.inputChannel-1];
    
    //    默认是2d图形
    self.changeGraph = 1;
    [self.displaySegmentControl  setSelectedSegmentIndex:self.changeGraph];

    // 初始化2D图 swift
    self.audioWaveformSurfaceController = [[AudioWaveformSurfaceController alloc] init:self.audioWaveView];
    //    self.audioWaveView
    //    self.sampleToEngineDelegate = self.audioWaveformSurfaceController.updateDataSeries;
    
    
    // 初始化3D图
    
    self.spectogramSurfaceController = [[SpectogramSurfaceController alloc] init:self.spectogramView];
    //    self.spectrogramSamplesDelegate = self.spectogramSurfaceController.updateDataSeries;
    //
    
    self.audioWaveView.hidden = YES;
    self.spectogramView.hidden = NO;
}
- (void)createView
{
//    self.audioRecorderDataManager = [[AudioRecorder alloc] init];
    
    
    //    self.audioWaveformSurfaceView = [[AudioWaveformSurfaceView alloc] initWithFrame:CGRectMake(0, APPNavStateBar+80, APPMainViewWidth, APPMainViewHeight-APPNavStateBar-50-80)];
    
    
    //    [self.view addSubview:self.audioWaveformSurfaceView];
    //    [self.view insertSubview:self.audioWaveformSurfaceView atIndex:1];
    //    NSLog(@"%@",[self.view subviews]);
    //    [self.view sendSubviewToBack:self.audioWaveformSurfaceView];
    //    [self.view addSubview:spectrogramSurfaceView];
    //    self.audioWaveformSurfaceController = [[AudioWaveformSurfaceController alloc] init:self.audioWaveformSurface];
    
    //    self.spectrogramSurfaceController = [[SpectogramSurfaceController alloc] init:self.spectrogramSurface];
    
    
    //    self.audioRecorderDataManager.sampleToEngineDelegate = self.audioWaveformSurfaceController.updateDataSeries;
    //    self.audioRecorderDataManager.spectrogramSamplesDelegate = self.spectrogramSurfaceController.updateDataSeries;
    //    [self.audioRecorderDataManager startRecording];
    
    //    self.displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateData:)];
    //    [self.displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    //    DashedLineChartView *dashedLineChartView = [[DashedLineChartView alloc] initWithFrame:CGRectMake(0, 50, APPMainViewWidth, APPMainViewHeight-APPNavStateBar-50)];
    //    [self.view addSubview:dashedLineChartView];
    //    self.audioWaveformSurface.frame = CGRectMake(0, 0, APPMainViewWidth, APPMainViewHeight);
    //    [self.view addSubview:self.audioWaveformSurface];
    
}

#pragma mark - 切换2d3d图形
- (IBAction)change2D3DDisplay:(UISegmentedControl *)sender
{
    //    if ([PCMDataSource sharedData].isPlay) { // 如果当前正在播放时
    //        [LEEAlert alert].config
    //        .LeeTitle(@"注意")
    //        .LeeContent(@"当前正在播放声音无法切换图形显示.")
    //        .LeeAction(@"确定", ^{
    //        })
    //        .LeeShow(); // 设置完成后 别忘记调用Show来显示
    //        [sender setSelectedSegmentIndex:self.changeGraph];
    //    }else {
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
    //    }
    
    
}

#pragma mark - 输入数据
- (void)getInput01Data:(NSNotification *)object
{
    if (self.inputChannel == 1) {
        if ([PCMDataSource sharedData].channelInput01 > 0) {
            if ([PCMDataSource sharedData].channelOutput03 == 1) {
                NSData *data = [object object];
                [self.playAudioDataManager playWithData:data];
            }
        }
    }
    
}

- (void)getInput02Data:(NSNotification *)object
{
    if (self.inputChannel == 2) {
        if ([PCMDataSource sharedData].channelInput02 > 0) {
            if ([PCMDataSource sharedData].channelOutput03 == 2) {
                NSData *data = [object object];
                [self.playAudioDataManager playWithData:data];
            }
        }
    }
    

}

- (void)getInput03Data:(NSNotification *)object
{
    if (self.inputChannel == 3) {
        if ([PCMDataSource sharedData].channelInput03 > 0) {
            if ([PCMDataSource sharedData].channelOutput03 == 3) {
                NSData *data = [object object];
                [self.playAudioDataManager playWithData:data];
            }
        }
    }
//    NSLog(@"%@",data);
//    [self.audioWaveformSurfaceView updateDataSeries:data];
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
    // 录音
    if (![PCMDataSource sharedData].isRecord) {
        self.recordBtn.selected = YES;
        self.playAudioDataManager = [[EYAudio alloc] init];
        self.audioRecorderDataManager = [[AudioRecorder alloc] init];
        [[PCMDataSource sharedData] startRecord];
        
        if ([PCMDataSource sharedData].channelInput03 > 0) { // 输入3 开启
            self.audioRecorderDataManager.samplesToEngineDataDelegate = ^(NSData *data){
                [[PCMDataSource sharedData] appendByPhoneInput:data];
            };
            if (self.inputChannel == 3) {
//                self.audioRecorderDataManager.sampleToEngineDelegate = self.audioWaveformSurfaceController.updateDataSeries;
                self.audioRecorderDataManager.spectrogramSamplesDelegate = self.spectogramSurfaceController.updateDataSeries;
            }
        }
        if ([PCMDataSource sharedData].channelInput02 > 0 || [PCMDataSource sharedData].channelInput01 > 0 ) {
            self.playAudioDataManager.spectrogramSamplesDelegate = self.spectogramSurfaceController.updateDataSeries;
        }
        [PCMDataSource sharedData].isRecord = YES;
        [self.audioRecorderDataManager startRecording];
        
        self.displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateData:)];
        [self.displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
    }else {
// 关闭录音
        [PCMDataSource sharedData].isRecord = NO;
        self.recordBtn.selected = NO;
        [self.audioRecorderDataManager stopRecording];
        self.playAudioDataManager.spectrogramSamplesDelegate = nil;
        [self.playAudioDataManager stop];
        self.playAudioDataManager = nil;
        self.audioRecorderDataManager = nil;
        [[PCMDataSource sharedData] stopRecord];

        SetPopTextView *setPopTextView = [[SetPopTextView alloc] init];
        [setPopTextView show:self.view.window setTitle:@"存储语音文件" fileName:[PCMDataSource sharedData].defaultFileName setSetText:^(NSString *notice) {
            [[PCMDataSource sharedData] saveWavFile:notice];
        }];
//      弹出保存文件框框
//        停止播放 和录音
//        保存文件 对应的文件
        [self.displaylink invalidate];
        self.displaylink = nil;
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 显示更新
- (void)updateData:(CADisplayLink *)displayLink
{
//    if (self.changeGraph == 0) {
        [self.audioWaveformSurfaceController updateDataWithDisplayLink:displayLink];
        
//    }else {
        [self.spectogramSurfaceController updateDataWithDisplayLink:displayLink];
        
//    }
    //    oc
    //    [self.audioWaveformSurfaceView updateData:displayLink];
    //    swift
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.audioRecorderDataManager stopRecording];
//    [self.displaylink invalidate];
//    self.displaylink = nil;
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
