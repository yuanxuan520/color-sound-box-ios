//
//  SettingNetworkViewController.m
//  AyaneBox
//
//  Created by yuanxuan on 2018/7/4.
//  Copyright © 2018年 AyaneBox. All rights reserved.
//

#import "SettingNetworkViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "ABSocketServer.h"
#import <WSProgressHUD/WSProgressHUD.h>
#import "WSProgressHUD+AutoDismiss.h"

@interface SettingNetworkViewController ()<ABSocketServerDelegate>
@property (strong, nonatomic) ABSocketServer *socketServer;
@property (nonatomic, strong) AFHTTPSessionManager *session;

@end

@implementation SettingNetworkViewController
@synthesize session;
@synthesize passwordTextField,ssidTextField;
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.view.backgroundColor = UIColorHex(0xebebeb);
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设备配外网";
    self.socketServer = [[ABSocketServer alloc] init];
    self.socketServer.delegate = self;
    [self.socketServer startUDP];
    
//    //重复发送广播
    
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self deviceSendMacBroadcast];
//    });
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)configureNetWork:(id)sender
{
    NSString *ip   = [NSString stringByNull:@"192.168.1.1"];
    NSString *rStr = [NSString stringByNull:@"profiles_config.html"];
    NSString *ssid = [NSString stringByNull:self.ssidTextField.text];
    NSString *pass = [NSString stringByNull:self.passwordTextField.text];
    NSString *bStr = [NSString stringByNull:@"3"];
    NSString *dStr = [NSString stringByNull:@"0"];
    
    self.session = [AFHTTPSessionManager manager];
//    @"application/json", @"text/json", @"text/javascript",@"application/x-json",
    self.session.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    self.session.responseSerializer.stringEncoding = NSUTF8StringEncoding;
    self.session.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.session.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.session.requestSerializer.timeoutInterval = 30;
    //    multipart/form-data
    self.session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",nil];
    NSString *urlString = [NSString stringWithFormat:@"http://%@/profiles_add.html",ip];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:rStr forKey:@"__SL_P_S.R"];
    [dict setObject:ssid forKey:@"__SL_P_P.A"];
    [dict setObject:bStr forKey:@"__SL_P_P.B"];
    [dict setObject:pass forKey:@"__SL_P_P.C"];
    [dict setObject:dStr forKey:@"__SL_P_P.D"];
    SLog(@"%@\n%@",urlString,dict);
    [self.session POST:urlString parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        SLog(@"post请求成功%@", responseObject);
        [WSProgressHUD showShimmeringString:@"配置成功，设备重启中..." maskType:WSProgressHUDMaskTypeDefault];
        [WSProgressHUD autoDismiss:3];
        
        NSError *error = nil;
        //        NSString *jsonStr = responseObject;
        NSData *jsonData = responseObject;
        //        [responseObject dataUsingEncoding:NSUTF8StringEncoding];
        //        NSLog(@"json:%@",jsonData);
        NSString *datastr = [[[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        SLog(@"post1请求成功%@", datastr);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
//        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(udpBroadcast) userInfo:nil repeats:YES];
//        [timer fire];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        SLog(@"post请求失败:%@", error);
        [WSProgressHUD showShimmeringString:@"配置成功，设备重启中..." maskType:WSProgressHUDMaskTypeDefault];
        [WSProgressHUD autoDismiss:3];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    }];
}

- (void)udpBroadcast{
    Byte byte[1024];
    for (int i = 0; i<1024; i++) {
        byte[i]=0x00;
    }
    
//    NSString *ip = [Util IPAddress];
//    NSArray *ipA = [ip componentsSeparatedByString:@"."];
    
    byte[0]=0x79;
//    byte[1]=[[ipA objectWithIndex:0] intValue];
//    byte[2]=[[ipA objectWithIndex:1] intValue];
//    byte[3]=[[ipA objectWithIndex:2] intValue];
//    byte[4]=[[ipA objectWithIndex:3] intValue];
//
    NSData *data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    SLog(@"发送UDP广播--%@",data);
    
    [self.socketServer sendUDPData:data toHost:@"255.255.255.255" Port:6001 Tag:1];
}
#pragma mark - ABSocketServerDelegate
- (void)udpSocket:(GCDAsyncUdpSocket *)sock host:(NSString *)host didReceiveData:(NSData *)data fromAddress:(NSData *)address port:(UInt16)port
{
    if (port == 6002) {
        NSLog(@"6002: %@ %@",data,address);
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
