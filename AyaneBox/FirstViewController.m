//
//  FirstViewController.m
//  AyaneBox
//
//  Created by wenjun on 2018/4/10.
//  Copyright © 2018年 AyaneBox. All rights reserved.
//

#import "FirstViewController.h"
#import "ABSocketServer.h"
#import "IPDetector.h"
#import <AFNetworking/AFNetworking.h>

@interface FirstViewController ()<UITableViewDelegate, UITableViewDataSource, ABSocketServerDelegate>
{
}
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passTextField;
@property (weak, nonatomic) IBOutlet UITextField *rTextField;
@property (weak, nonatomic) IBOutlet UITextField *bTextField;
@property (weak, nonatomic) IBOutlet UITextField *dTextField;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) ABSocketServer *socketServer;
@property (strong, nonatomic) NSMutableString *textStr;

@property (nonatomic, strong) AFHTTPSessionManager *session;
@property (nonnull,strong) NSMutableData *amrData;//录音总数据

@property (nonatomic,strong) GCDAsyncSocket *dataClientSocket;//客户机

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Demo";
    
    [self keyboardReturn];
    
    self.socketServer = [[ABSocketServer alloc] init];
    self.socketServer.delegate = self;
    [self.socketServer startUDP];
    
    self.nameTextField.text = [IPDetector currentWifiSSID];
    
    self.textStr = [[NSMutableString alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dlog:)
                                                 name:@"kDLog"
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)udpBroadcast:(id)sender {
    Byte byte[1024];
    for (int i = 0; i<1024; i++) {
        byte[i]=0x00;
    }
    
    NSString *ip = [Util IPAddress];
    NSArray *ipA = [ip componentsSeparatedByString:@"."];
    
    byte[0]=0x7B;
    byte[1]=[[ipA objectWithIndex:0] intValue];
    byte[2]=[[ipA objectWithIndex:1] intValue];
    byte[3]=[[ipA objectWithIndex:2] intValue];
    byte[4]=[[ipA objectWithIndex:3] intValue];
    
    NSData *data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    SLog(@"发送UDP广播--%@",data);
    
    [self.socketServer sendUDPData:data toHost:@"255.255.255.255" Port:6001 Tag:1];
    
    [self monitoringTCP:nil];
    [self receiveAudio:nil];
}

- (IBAction)monitoringTCP:(id)sender {
    [self.socketServer gcdSocketGetMacWithPort:6002];
}

- (IBAction)receiveAudio:(id)sender {
    [self.socketServer gcdSocketGetAudioDataWithPort:5001];
}

- (IBAction)configureNetwork:(id)sender {
    NSString *ip = [IPDetector getGatewayIPAddress];
    NSString *netName = [NSString stringByNull:self.nameTextField.text];
    NSString *pass = [NSString stringByNull:self.passTextField.text];
    NSString *rStr = [NSString stringByNull:self.rTextField.text];
    NSString *bStr = [NSString stringByNull:self.bTextField.text];
    NSString *dStr = [NSString stringByNull:self.dTextField.text];
    
    self.session = [AFHTTPSessionManager manager];
    self.session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", nil];
    
    NSString *urlString = [NSString stringWithFormat:@"http://%@/profiles_add.html",ip];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:rStr forKey:@"__SL_P_S.R"];
    [dict setObject:netName forKey:@"__SL_P_P.A"];
    [dict setObject:bStr forKey:@"__SL_P_P.B"];
    [dict setObject:pass forKey:@"__SL_P_P.C"];
    [dict setObject:dStr forKey:@"__SL_P_P.D"];
    SLog(@"%@\n%@",urlString,dict);
    [self.session POST:urlString parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        SLog(@"post请求成功%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        SLog(@"post请求失败:%@", error);
    }];
    
}

- (void)dlog:(NSNotification*)noti
{
    NSString *str = noti.object;
    [self.textStr appendString:@"\n"];
    [self.textStr appendString:str];
    @weakify(self);
    dispatch_async(GetMainQueue, ^{
        @strongify(self);
        self.textView.text = self.textStr;
        [self.textView scrollToBottomAnimated:YES];
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.socketServer.explorerClientArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.tag = 1001;
//        [btn setTitle:@"接收" forState:UIControlStateNormal];
//        [btn setTitle:@"停止" forState:UIControlStateSelected];
//        [cell addSubview:cell];
    }
    
    GCDAsyncSocket *sock = [self.socketServer.explorerClientArray objectWithIndex:indexPath.row];
    NSString *ip = [sock connectedHost];
    cell.textLabel.text = [NSString stringWithFormat:@"硬件 %@",ip];
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (void)writeAmr
{
    if (self.amrData.length <=0) {
        return;
    }
    NSString *dateString = [NSDate stringWithDate:[NSDate date] format:@"yyyyMMddHHmmss"];
    NSString *saveWAVPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",dateString]];
    [self.amrData writeToURL:[NSURL fileURLWithPath:saveWAVPath] atomically:YES];
}

#pragma mark - ABSocketServerDelegate
- (void)socket:(GCDAsyncSocket *)sock didAcceptAudioNewSocket:(GCDAsyncSocket *)newSocket
{
    if (self.dataClientSocket) {
        [newSocket disconnect];
        return;
    }
    self.dataClientSocket = newSocket;
    self.amrData = [NSMutableData data];
}

- (void)socket:(GCDAsyncSocket *)sock didAcceptExplorerNewSocket:(GCDAsyncSocket *)newSocket
{
    @weakify(self)
    dispatch_async(GetMainQueue, ^{
        @strongify(self);
        [self.myTableView reloadData];
    });
}

- (void)audioSocketDidDisconnect:(GCDAsyncSocket *)sock
{
    if (self.dataClientSocket == sock) {
        self.dataClientSocket = nil;
        [self writeAmr];
        return;
    }
}

- (void)explorerSocketDidDisconnect:(GCDAsyncSocket *)sock
{
    @weakify(self)
    dispatch_async(GetMainQueue, ^{
        @strongify(self);
        [self.myTableView reloadData];
    });
}

- (void)socket:(GCDAsyncSocket *)sock didReadAudioData:(NSData *)data
{
    if (self.dataClientSocket == sock) {
        [self.amrData appendData:data];
        return;
    }
}

- (void)socket:(GCDAsyncSocket *)sock didReadExplorerData:(NSData *)data
{
    if (data.length>=6) {
        Byte byte[1024];
        for (int i = 0; i<1024; i++) {
            byte[i]=0x00;
        }
        
        NSString *ip = [Util IPAddress];
        NSArray *ipA = [ip componentsSeparatedByString:@"."];
        
        byte[0]=0x7B;
        byte[1]=[[ipA objectWithIndex:0] intValue];
        byte[2]=[[ipA objectWithIndex:1] intValue];
        byte[3]=[[ipA objectWithIndex:2] intValue];
        byte[4]=[[ipA objectWithIndex:3] intValue];
        const unsigned char *macBytes = data.bytes;
        for (int i = 0; i<6; i++) {
            byte[5+i]=macBytes[i];
        }
        NSData *writeData = [NSData dataWithBytes:&byte length:sizeof(byte)];
        [sock writeData:writeData withTimeout:200 tag:111];
    }
}


@end
