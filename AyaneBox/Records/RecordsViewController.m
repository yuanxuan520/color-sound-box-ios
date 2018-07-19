//
//  RecordsViewController.m
//  AyaneBox
//
//  Created by yuanxuan on 2018/6/26.
//  Copyright © 2018年 AyaneBox. All rights reserved.
//

#import "RecordsViewController.h"
#import <SciChart/SciChart.h>
#import "AudioRecorder.h"
//#import "DashedLineChartView.h"
#import <Accelerate/Accelerate.h>

#import "AudioWaveformSurfaceView.h"
#import "SpectrogramSurfaceView.h"

@interface RecordsViewController ()
@property (nonatomic, strong) CADisplayLink *displaylink;
@property (nonatomic, strong) AudioRecorder *audioRecorderDataManager;
@property (nonatomic, strong) AudioWaveformSurfaceView *audioWaveformSurfaceView;
@property (nonatomic, strong) SpectrogramSurfaceView *spectrogramSurfaceView;
@end

@implementation RecordsViewController
@synthesize audioRecorderDataManager,audioWaveformSurfaceView,spectrogramSurfaceView;
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
    // Do any additional setup after loading the view.
    [self createView];
}

- (void)createView
{
    self.audioRecorderDataManager = [[AudioRecorder alloc] init];
    
    self.spectrogramSurfaceView = [[SpectrogramSurfaceView alloc] initWithFrame:CGRectMake(0, 0, APPMainViewWidth, APPMainViewHeight-APPNavStateBar-50)];
    
    self.audioWaveformSurfaceView = [[AudioWaveformSurfaceView alloc] initWithFrame:CGRectMake(0, 0, APPMainViewWidth, APPMainViewHeight-APPNavStateBar-50)];

    [self.view addSubview:spectrogramSurfaceView];
//    [self.view addSubview:audioWaveformSurfaceView];

//    audioRecorderDataManager.sampleToEngineDelegate = spectrogramSurfaceView.updateDataSeries;
    audioRecorderDataManager.spectrogramSamplesDelegate = spectrogramSurfaceView.updateDataSeries;
    [self.audioRecorderDataManager startRecording];
    
//    DashedLineChartView *dashedLineChartView = [[DashedLineChartView alloc] initWithFrame:CGRectMake(0, 50, APPMainViewWidth, APPMainViewHeight-APPNavStateBar-50)];
//    [self.view addSubview:dashedLineChartView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)updateData:(CADisplayLink *)displayLink
{
    [self.spectrogramSurfaceView updateData:displayLink];
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
