//
//  HomeViewController.m
//  AyaneBox
//
//  Created by yuanxuan on 2018/6/26.
//  Copyright © 2018年 AyaneBox. All rights reserved.
//

#import "HomeViewController.h"
#import "ABSocketServer.h"
#import "IPDetector.h"
#import "SocketObject.h"
#import "LEEAlert.h"
#import "EYAudio.h"
#import "Reachability.h"
#import "MJRefresh.h"

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,ABSocketServerDelegate>
@property (nonatomic, strong) NSMutableArray *deviceDataList;
@property (nonatomic, strong) NSMutableArray *deviceDataDict;
// 绑定6002 端口
@property (strong, nonatomic) ABSocketServer *socketServer6002;
@property (strong, nonatomic) SocketObject *socketObject6002;
@property (nonatomic, assign) NetworkStatus curNetState;
@property (nonatomic, strong) NSTimer *timer;

- (IBAction)showTip:(id)sender;
@end

@implementation HomeViewController
@synthesize deviceTableView,ipAddressLabel;
@synthesize socketServer6002,socketObject6002;
@synthesize timer;
@synthesize curNetState;
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.view.backgroundColor = UIColorHex(0xebebeb);
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = UIColorHex(0x303f4a);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    [self udpBroadcast];
    // Allocate a reachability objec
    self.ipAddressLabel.text = [IPDetector getIPAddress];

//    [self.socketServer startUDP];
    //    重复发送广播
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(udpBroadcast) userInfo:nil repeats:YES];
        [self.timer fire];
    }else {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(udpBroadcast) userInfo:nil repeats:YES];
        [self.timer fire];
    }
}
- (IBAction)showTip:(id)sender
{
    [LEEAlert alert].config
    .LeeTitle(@"设备使用需知")
    .LeeContent(@"A.配对说明:\n1.开启硬件，可见一个指示灯闪烁，启动成功\n2.关闭手机移动数据，断开之前的WIF1连接，点击连接硬件发出的网络( mysimplelnk-**** )\n3.重启硬件，重复操作2，激活硬件\n4.打开软件，等待页面显示设备，点击配对，显示配对成功，代表软硬件连接成功，可以正常使用\nB.通道说明:\n1.输入1/输出1， 输入2/输出2为外接通道;\n2.输入3/输出3为手机通道;\n3.输入输出通道可以任意匹配使用\n")
    .LeeAction(@"确定", ^{
    })
    .LeeShow(); // 设置完成后 别忘记调用Show来显示
}

//设备使用需知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *ipAddress = [kUserDefaults objectForKey:@"IPAddress"];
    if (ipAddress) {
        [PCMDataSource sharedData].ipAddress = ipAddress;
    }
    NSArray *deviceList = [kUserDefaults objectForKey:@"deviceList"];
    NSDictionary *deviceDict = [kUserDefaults objectForKey:@"deviceDict"];
    if (deviceList) {
        [DeviceData sharedData].deviceList = [DeviceObject mj_objectArrayWithKeyValuesArray:deviceList];
        [DeviceData sharedData].deviceDict = [NSMutableDictionary dictionaryWithDictionary:deviceDict];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDeviceList:) name:@"DEVICEUPDATE" object:nil];
//    self.eyAudio = [[EYAudio alloc] init];
    

    
    self.socketServer6002 = [[ABSocketServer alloc] init];
    self.socketObject6002 = [[SocketObject alloc] init];
    self.socketServer6002.delegate = self.socketObject6002;
    [self.socketServer6002 startUDP:6002];
    
    deviceTableView.tableFooterView = [[UIView alloc] init];
    deviceTableView.backgroundColor = [UIColor clearColor];
    deviceTableView.separatorInset = UIEdgeInsetsZero;
    
    if ([deviceTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [deviceTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([deviceTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [deviceTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    deviceTableView.separatorColor = UIColorHex(0xf0f0f0);
    
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
    [self.deviceTableView addGestureRecognizer:longGesture];
    
    // Do any additional setup after loading the view.
    MJRefreshNormalHeader *reloadheader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(resetDevice)];//@selector(loadMylogList)
    [reloadheader setTitle:@"下拉刷新设备.." forState:MJRefreshStateIdle];
    [reloadheader setTitle:@"放开刷新设备.." forState:MJRefreshStatePulling];
    [reloadheader setTitle:@"重置中.." forState:MJRefreshStateRefreshing];
    reloadheader.lastUpdatedTimeLabel.hidden = YES;
    deviceTableView.mj_header = reloadheader;
    [self netStateListen];
    [self showTip:nil];
}

- (void)resetDevice
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [self.socketServer6002 stopUDP];
    [[PCMDataSource sharedData].udpSocketServer stopUDP];
    [PCMDataSource sharedData].bindState = kUnbound;
    [[PCMDataSource sharedData].bindBtn setUserInteractionEnabled:YES];
    [PCMDataSource sharedData].bindBtn = nil;
    [PCMDataSource sharedData].ipAddress = nil;
//    [USERDEFAULTS removeObjectForKey:@"IPAddress"];
//    [USERDEFAULTS synchronize];
//    [[DeviceData sharedData].deviceList removeAllObjects];
//    [[DeviceData sharedData].deviceDict removeAllObjects];
    [deviceTableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.socketServer6002 startUDP:6002];
        [[PCMDataSource sharedData].udpSocketServer startUDP:5001];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(udpBroadcast) userInfo:nil repeats:YES];
        [self.timer fire];
        [deviceTableView.mj_header endRefreshing];
    });
}

#pragma mark 网络监听
- (void)netStateListen{
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    
    // Set the blocks
    reach.reachableBlock = ^(Reachability*reach)
    {
        self.ipAddressLabel.text = [IPDetector getIPAddress];
        // keep in mind this is called on a background thread
        // and if you are updating the UI it needs to happen
        // on the main thread, like this:
        
//        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"REACHABLE!");
//            if (self.curNetState == NotReachable) {
//                启动监听
//                [self.socketServer6002 stopUDP];
//                [[PCMDataSource sharedData].udpSocketServer stopUDP];
//
//                [self.socketServer5001 startUDP:5001];
//                [self.socketServer6002 startUDP:6002];
//                [[PCMDataSource sharedData].udpSocketServer startUDP];
                //    重复发送广播
//                self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(udpBroadcast) userInfo:nil repeats:YES];
//                [self.timer fire];
                
//            }
            self.curNetState = [reach currentReachabilityStatus];
            
            switch (self.curNetState) {
                case ReachableViaWWAN:
                {
                    self.ipAddressLabel.text = @"4G";
                }
                    break;
                case ReachableViaWiFi:
                {
                    self.ipAddressLabel.text = [IPDetector getIPAddress];
                }
                    break;
                default:
                    self.ipAddressLabel.text = [IPDetector getIPAddress];
                    break;
            }
//        });
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        if (self.curNetState != NotReachable) {
//            [self.socketServer5001 stopUDP];
//            [self.socketServer6002 stopUDP];
            
//            //    重复发送广播
//            [self.timer invalidate];
//            self.timer = nil;
            self.ipAddressLabel.text = [IPDetector getIPAddress];
        }
        self.curNetState = [reach currentReachabilityStatus];
//        self.ipAddressLabel.text = @"无网络";
        NSLog(@"UNREACHABLE!");
    };
    
    // Start the notifier, which will cause the reachability object to retain itself!
    [reach startNotifier];
}


- (void)updateDeviceList:(NSNotification *)object
{
    [deviceTableView reloadData];
}

- (NSArray *)extracted:(DeviceObject *)object {
    NSArray *macAddresArray = [object.macAddres componentsSeparatedByString:@"-"];
    return macAddresArray;
}

- (void)udpBroadcast{
    if ([PCMDataSource sharedData].bindState == kBindingSuccess) {
        [PCMDataSource sharedData].bindState = kBind;
        [[PCMDataSource sharedData].bindBtn setTitle:@"已配对" forState:UIControlStateNormal];
        [[PCMDataSource sharedData].bindBtn setUserInteractionEnabled:NO];
    }
    
    
    
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
    
    NSString *sendIP = [NSString stringWithFormat:@"%d.%d.%d.255",[[ipA objectWithIndex:0] intValue],[[ipA objectWithIndex:1] intValue],[[ipA objectWithIndex:2] intValue]];
    
    for (DeviceObject *object in [DeviceData sharedData].deviceList) {
        if (object.isMatching) {
            NSArray * macAddresArray = [self extracted:object];
            byte[5]=[[macAddresArray objectWithIndex:0] intValue];
            byte[6]=[[macAddresArray objectWithIndex:1] intValue];
            byte[7]=[[macAddresArray objectWithIndex:2] intValue];
            byte[8]=[[macAddresArray objectWithIndex:3] intValue];
            byte[9]=[[macAddresArray objectWithIndex:4] intValue];
            byte[10]=[[macAddresArray objectWithIndex:5] intValue];
            break;
        }
    }
    NSData *data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    NSLog(@"发送UDP:%@",data);
//    NSString *path=[[NSBundle mainBundle] pathForResource:@"simple-drum-beat" ofType:@"wav"];
//    NSData *data = [NSData dataWithContentsOfFile:path];
    if ([PCMDataSource sharedData].ipAddress) {
        [self.socketServer6002 sendUDPData:data toHost:[PCMDataSource sharedData].ipAddress Port:6001 Tag:1];
    }else {
        [self.socketServer6002 sendUDPData:data toHost:sendIP Port:6001 Tag:1];
    }
//    }
}


- (void)partnership:(NSString *)macAddress{
    Byte byte[1024];
    for (int i = 0; i<1024; i++) {
        byte[i]=0x00;
    }
    
    NSString *ip = [Util IPAddress];
    NSArray *ipA = [ip componentsSeparatedByString:@"."];
//    NSArray *macA = [macAddress componentsSeparatedByString:@"-"];
    byte[0]=0x7B;
    byte[1]=[[ipA objectWithIndex:0] intValue];
    byte[2]=[[ipA objectWithIndex:1] intValue];
    byte[3]=[[ipA objectWithIndex:2] intValue];
    byte[4]=[[ipA objectWithIndex:3] intValue];
    
    
    NSData *data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    //    NSString *path=[[NSBundle mainBundle] pathForResource:@"simple-drum-beat" ofType:@"wav"];
    //    NSData *data = [NSData dataWithContentsOfFile:path];
//    SLog(@"发送UDP广播--%@",data);
    [self.socketServer6002 sendUDPData:data toHost:@"255.255.255.255" Port:6001 Tag:1];
    
    [self.timer invalidate];
    self.timer = nil;

}

- (void)deviceSendMacBroadcast{
    Byte byte[1024];
    for (int i = 0; i<1024; i++) {
        byte[i]=0x00;
    }
    byte[0]=0x00;
    byte[1]=0x10;
    byte[2]=0x5C;
    byte[3]=0xAD;
    byte[4]=0x72;
    byte[5]=0xE3;

    NSData *data = [NSData dataWithBytes:&byte length:sizeof(byte)];
//    SLog(@"发送UDP广播--%@",data);
    
    [self.socketServer6002 sendUDPData:data toHost:@"255.255.255.255" Port:6002 Tag:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewDelegate & TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[DeviceData sharedData].deviceList count];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5f;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.5f;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return nil;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return nil;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"tableTableView";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = UIColorHex(0xf0f0f0);
    }
    DeviceObject *object = [[DeviceData sharedData].deviceList objectAtIndex:indexPath.row];
    cell.textLabel.text = object.macAddresName;
    cell.detailTextLabel.text = object.ipAddresName;
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    closeBtn.frame = CGRectMake(0, 0, 80, 30);
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [closeBtn setTitle:@"配对" forState:UIControlStateNormal];
    closeBtn.tag = indexPath.row;
    [closeBtn setTitleColor:UIColorHex(0x606265) forState:UIControlStateNormal];
    closeBtn.layer.borderColor = UIColorHex(0xdcdfe6).CGColor;
    closeBtn.layer.borderWidth = 1;
    closeBtn.layer.cornerRadius = 3;
    closeBtn.clipsToBounds = YES;
    closeBtn.layer.cornerRadius = 3;
    [closeBtn setBackgroundImage:[self imageWithColor:UIColorHex(0xffffff) size:closeBtn.bounds.size] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(matching:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView = closeBtn;

    return cell;
}

-(void)matching:(UIButton *)btn {
    if ([PCMDataSource sharedData].bindState == kUnbound && [PCMDataSource sharedData].bindBtn == nil) {
        [PCMDataSource sharedData].bindState = kBinding;
        [PCMDataSource sharedData].bindBtn = btn;
        DeviceObject *object = [[DeviceData sharedData].deviceList objectAtIndex:btn.tag];
        object.isMatching = YES;
        [PCMDataSource sharedData].ipAddress = object.ipAddres;
        [USERDEFAULTS setObject:object.ipAddres forKey:@"IPAddress"];
        [USERDEFAULTS synchronize];
        [btn setTitle:@"配对中" forState:UIControlStateNormal];
        [btn setUserInteractionEnabled:NO];
    }else {
        [PCMDataSource sharedData].bindBtn = nil;
        [PCMDataSource sharedData].bindState = kUnbound;
    }
}

- (void)longPressGesture:(UILongPressGestureRecognizer *)longGesture
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否删除当前选中的设备?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        CGPoint location = [longGesture locationInView:self.deviceTableView];
        NSIndexPath *indexPath = [self.deviceTableView indexPathForRowAtPoint:location];
        DeviceObject *object = [[DeviceData sharedData].deviceList objectAtIndex:indexPath.row];

        [[DeviceData sharedData].deviceDict removeObjectForKey:object.macAddresName];
        [[DeviceData sharedData].deviceList removeObjectAtIndex:indexPath.row];
        NSMutableArray *deviceList = [NSObject mj_keyValuesArrayWithObjectArray:[DeviceData sharedData].deviceList];
        [kUserDefaults setObject:deviceList forKey:@"deviceList"];
        [kUserDefaults setObject:[DeviceData sharedData].deviceDict forKey:@"deviceDict"];
        [kUserDefaults synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DEVICEUPDATE" object:nil];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


//- (void)socket:(GCDAsyncSocket *)sock didAcceptAudioNewSocket:(GCDAsyncSocket *)newSocket
//{
//    if (self.dataClientSocket) {
//        [newSocket disconnect];
//        return;
//    }
//    self.dataClientSocket = newSocket;
////    self.amrData = [NSMutableData data];
//}
//
//- (void)socket:(GCDAsyncSocket *)sock didAcceptExplorerNewSocket:(GCDAsyncSocket *)newSocket
//{
//    @weakify(self)
//    dispatch_async(GetMainQueue, ^{
//        @strongify(self);
//        [self.deviceTableView reloadData];
//    });
//}
//
//- (void)audioSocketDidDisconnect:(GCDAsyncSocket *)sock
//{
//    if (self.dataClientSocket == sock) {
//        self.dataClientSocket = nil;
////        [self writeAmr];
//        return;
//    }
//}

//- (void)explorerSocketDidDisconnect:(GCDAsyncSocket *)sock
//{
//    @weakify(self)
//    dispatch_async(GetMainQueue, ^{
//        @strongify(self);
//        [self.deviceTableView reloadData];
//    });
//}
//
//- (void)socket:(GCDAsyncSocket *)sock didReadAudioData:(NSData *)data
//{
//    if (self.dataClientSocket == sock) {
////        [self.amrData appendData:data];
//        return;
//    }
//}
//
//- (void)socket:(GCDAsyncSocket *)sock didReadExplorerData:(NSData *)data
//{
//    if (data.length>=6) {
//        Byte byte[1024];
//        for (int i = 0; i<1024; i++) {
//            byte[i]=0x00;
//        }
//
//        NSString *ip = [Util IPAddress];
//        NSArray *ipA = [ip componentsSeparatedByString:@"."];
//
//        byte[0]=0x7B;
//        byte[1]=[[ipA objectWithIndex:0] intValue];
//        byte[2]=[[ipA objectWithIndex:1] intValue];
//        byte[3]=[[ipA objectWithIndex:2] intValue];
//        byte[4]=[[ipA objectWithIndex:3] intValue];
//        const unsigned char *macBytes = data.bytes;
//        for (int i = 0; i<6; i++) {
//            byte[5+i]=macBytes[i];
//        }
//        NSData *writeData = [NSData dataWithBytes:&byte length:sizeof(byte)];
//        [sock writeData:writeData withTimeout:200 tag:111];
//    }
//}

- (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}


// 十六进制转换为普通字符串的。
- (NSString *)stringFromHexString:(NSString *)hexString {
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    NSLog(@"------字符串=======%@",unicodeString);
    return unicodeString;
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
