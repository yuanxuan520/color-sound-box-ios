//
//  RecordsViewController.m
//  AyaneBox
//
//  Created by yuanxuan on 2018/6/26.
//  Copyright © 2018年 AyaneBox. All rights reserved.
//

#import "RecordsViewController.h"
#import <SciChart/SciChart.h>
#import "DashedLineChartView.h"
#import <Accelerate/Accelerate.h>
#import "LEEAlert.h"
#import "AudioWaveformSurfaceView.h"
#import "SpectrogramSurfaceView.h"
#import "SetPopTextView.h"

@interface RecordsViewController ()

@property (nonatomic, strong) CADisplayLink *displaylink;
@property (nonatomic, strong) IBOutlet UIButton *recordBtn;
@property (nonatomic, strong) IBOutlet UIView *mainView;
//@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) DashedLineChartView *dashedLineChartView;
@property (nonatomic, strong) AudioRecorder *audioRecorderDataManager;
@property (nonatomic, strong) AudioWaveformSurfaceView *audioWaveformSurfaceView;
@property (nonatomic, strong) SpectrogramSurfaceView *spectrogramSurfaceView;
@property (nonatomic, strong) NSString *filename;
//@property (nonatomic, strong) AudioWaveformSurfaceController *audioWaveformSurfaceController;
//@property (nonatomic, strong) SpectogramSurfaceController *spectrogramSurfaceController;
//@property (nonatomic, strong) IBOutlet SCIChartSurface *audioWaveformSurface;
//@property (nonatomic, strong) IBOutlet SCIChartSurface *spectrogramSurface;
- (IBAction)recordAudio:(UIButton *)btn;
@end

@implementation RecordsViewController
@synthesize audioRecorderDataManager;
@synthesize audioWaveformSurfaceView,spectrogramSurfaceView;
@synthesize dashedLineChartView;
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
//    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//        self.extendedLayoutIncludesOpaqueBars = NO;
//        self.modalPresentationCapturesStatusBarAppearance = NO;
//        self.automaticallyAdjustsScrollViewInsets = YES;
//    }
    // Do any additional setup after loading the view.
    [self createView];
}

- (IBAction)recordAudio:(UIButton *)btn
{
    if (![PCMDataSource sharedData].isRecord) {
        [PCMDataSource sharedData].isRecord = YES;
//
        self.recordBtn.selected = YES;
        [[PCMDataSource sharedData] startRecord];
    }else {
        [PCMDataSource sharedData].isRecord = NO;
        self.recordBtn.selected = NO;
        [[PCMDataSource sharedData] stopRecord];

        SetPopTextView *setPopTextView = [[SetPopTextView alloc] init];
        [setPopTextView show:self.view.window setTitle:@"存储语音文件" fileName:[PCMDataSource sharedData].defaultFileName setSetText:^(NSString *notice) {
            [[PCMDataSource sharedData] saveWavFile:notice];
        }];
//      弹出保存文件框框
//        停止播放 和录音
//        保存文件 对应的文件
    }
}

- (void)createView
{
    self.audioRecorderDataManager = [[AudioRecorder alloc] init];

    self.dashedLineChartView = [[DashedLineChartView alloc] initWithFrame:CGRectMake(0,APPNavStateBar + 80, APPMainViewWidth, APPMainViewHeight-APPNavStateBar-80-50)];
    [self.mainView addSubview:self.dashedLineChartView];
    

    
    
    
//    self.spectrogramSurfaceView = [[SpectrogramSurfaceView alloc] initWithFrame:CGRectMake(0, 0, APPMainViewWidth, APPMainViewHeight-APPNavStateBar-50)];
    
    
//    [self.view addSubview:audioWaveformSurfaceView];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)updateData:(CADisplayLink *)displayLink
{
//    [self.spectrogramSurfaceController updateDataWithDisplayLink:displayLink];
//    [self.audioWaveformSurfaceController updateDataWithDisplayLink:displayLink];
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
