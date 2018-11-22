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
#import <CoreLocation/CoreLocation.h>

#define audioPlayLength 4096

@interface RecordsViewController ()<CLLocationManagerDelegate>

@property (nonatomic,strong ) CLLocationManager *locationManager;//定位服务

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
    [self initInputChannel];
}

- (void)initInputChannel
{
    if ([PCMDataSource sharedData].channelInput01 > 0) {
        // 默认是输出3端口
        self.inputChannel = 1;
        [self.inputSegmentControl setSelectedSegmentIndex:self.inputChannel-1];
    }else if([PCMDataSource sharedData].channelInput02 > 0){
        self.inputChannel = 2;
        [self.inputSegmentControl setSelectedSegmentIndex:self.inputChannel-1];
    }else {
        self.inputChannel = 3;
        [self.inputSegmentControl setSelectedSegmentIndex:self.inputChannel-1];
    }
}

- (void)viewDidLoad {
    self.title = @"录音";
    [super viewDidLoad];
    [self locatemap];
    
    // 默认是输出1端口
    self.inputChannel = 1;
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
#pragma mark - 定位服务部分
- (void)locatemap{
    
    if ([CLLocationManager locationServicesEnabled]) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        [_locationManager requestAlwaysAuthorization];
        [_locationManager requestWhenInUseAuthorization];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 5.0;
        [_locationManager startUpdatingLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication]openURL:settingURL];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - 定位成功
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    [_locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
//    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    //当前的经纬度
    NSLog(@"当前的经纬度 %f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    //这里的代码是为了判断didUpdateLocations调用了几次 有可能会出现多次调用 为了避免不必要的麻烦 在这里加个if判断 如果大于1.0就return
    [PCMDataSource sharedData].longitudeStr = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
    [PCMDataSource sharedData].latitudeStr = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];

//    longitude 经度
//    latitude 纬度
    NSTimeInterval locationAge = -[currentLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 1.0){//如果调用已经一次，不再执行
        return;
    }
//    //地理反编码 可以根据坐标(经纬度)确定位置信息(街道 门牌等)
//    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//        if (placemarks.count >0) {
//            CLPlacemark *placeMark = placemarks[0];
//            _currentCity = placeMark.locality;
//            if (!_currentCity) {
//                _currentCity = @"无法定位当前城市";
//            }
//            //看需求定义一个全局变量来接收赋值
//            NSLog(@"当前国家 - %@",placeMark.country);//当前国家
//            NSLog(@"当前城市 - %@",_currentCity);//当前城市
//            NSLog(@"当前位置 - %@",placeMark.subLocality);//当前位置
//            NSLog(@"当前街道 - %@",placeMark.thoroughfare);//当前街道
//            NSLog(@"具体地址 - %@",placeMark.name);//具体地址
//            NSString *message = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",placeMark.country,_currentCity,placeMark.subLocality,placeMark.thoroughfare,placeMark.name];
//
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"好", nil];
//            [alert show];
//        }else if (error == nil && placemarks.count){
//
//            NSLog(@"NO location and error return");
//        }else if (error){
//
//            NSLog(@"loction error:%@",error);
//        }
//    }];
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

#pragma mark - 输出3播放音频
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
                NSData *data = [[PCMDataSource sharedData].outputDevice02 subdataWithRange:NSMakeRange(self.curLocation, audioPlayLength)];
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
    [[PCMDataSource sharedData] processOutDeviceData];
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
//       判断是否输出声音
        
        switch (self.inputChannel) {
            case 1:
            {
                if ([PCMDataSource sharedData].channelOutput03 == 1) {
                    self.playAudioDataManager = [[EYAudio alloc] init];
                } else {
                    self.playAudioDataManager = [[EYAudio alloc] initWithVolume:0];
                }
            }
                break;
            case 2:{
                if ([PCMDataSource sharedData].channelOutput03 == 2) {
                    self.playAudioDataManager = [[EYAudio alloc] init];
                } else {
                    self.playAudioDataManager = [[EYAudio alloc] initWithVolume:0];
                }
            }
                break;
            case 3:{
                if ([PCMDataSource sharedData].channelOutput03 == 3) {
                    self.playAudioDataManager = [[EYAudio alloc] init];
                } else {
                    self.playAudioDataManager = [[EYAudio alloc] initWithVolume:0];
                }
            }
                break;
            default:
                break;
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
        [PCMDataSource sharedData].isRecord = YES;
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
