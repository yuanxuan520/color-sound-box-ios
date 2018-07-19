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
#import <AFNetworking/AFNetworking.h>



@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,ABSocketServerDelegate>
@property (nonatomic, strong) NSMutableArray *deviceDataList;
@property (nonatomic, strong) NSMutableArray *deviceDataDict;
@property (strong, nonatomic) ABSocketServer *socketServer;

@property (nonatomic,strong) GCDAsyncSocket *dataClientSocket;//客户机
@end

@implementation HomeViewController
@synthesize deviceTableView,ipAddressLabel;
@synthesize socketServer,dataClientSocket;
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.view.backgroundColor = UIColorHex(0xebebeb);
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = UIColorHex(0x303f4a);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    [self udpBroadcast];
    self.ipAddressLabel.text = [IPDetector getIPAddress];

//    [self.socketServer startUDP];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.socketServer stopUDP];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.socketServer = [[ABSocketServer alloc] init];
    self.socketServer.delegate = self;
    [self.socketServer startUDP];
    
//    重复发送广播
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(udpBroadcast) userInfo:nil repeats:YES];
    [timer fire];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self deviceSendMacBroadcast];
//    });
    
    self.deviceDataList = [NSMutableArray arrayWithCapacity:0];
    self.deviceDataDict = [NSMutableDictionary dictionaryWithCapacity:0];
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
    // Do any additional setup after loading the view.
    
}

- (void)udpBroadcast{
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
    SLog(@"发送UDP广播--%@",data);
    
    [self.socketServer sendUDPData:data toHost:@"255.255.255.255" Port:6002 Tag:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewDelegate & TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.deviceDataList count];
    
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
    NSDictionary *dict = [self.deviceDataList objectAtIndex:indexPath.row];
    cell.textLabel.text = dict[@"macAddress"];
    cell.detailTextLabel.text = dict[@"ip"];
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    closeBtn.frame = CGRectMake(0, 0, 80, 30);
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [closeBtn setTitle:@"配对" forState:UIControlStateNormal];
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
    [btn setTitle:@"已配对" forState:UIControlStateNormal];
    [btn setUserInteractionEnabled:YES];
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

#pragma mark - ABSocketServerDelegate
- (void)udpSocket:(GCDAsyncUdpSocket *)sock host:(NSString *)host didReceiveData:(NSData *)data fromAddress:(NSData *)address port:(UInt16)port
{
    //    if (port == 6002) {
    NSLog(@"6002: %@ %@",data,address);
    Byte *macByte = (Byte *)[data bytes];
    
    NSString *macAddress = [NSString stringWithFormat:@"%02lx-%02lx-%02lx-%02lx-%02lx-%02lx",(long)macByte[1],(long)macByte[2],(long)macByte[3],(long)macByte[4],(long)macByte[5],(long)macByte[6]];
    NSMutableDictionary *device = [NSMutableDictionary dictionaryWithCapacity:0];
    [device setObject:host forKey:@"ip"];
    [device setObject:macAddress forKey:@"macAddress"];
    if (![self.deviceDataList containsObject:device]) {
        [self.deviceDataList addObject:device];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.deviceTableView reloadData];
        });
    }
}

- (void)socket:(GCDAsyncSocket *)sock didAcceptAudioNewSocket:(GCDAsyncSocket *)newSocket
{
    if (self.dataClientSocket) {
        [newSocket disconnect];
        return;
    }
    self.dataClientSocket = newSocket;
//    self.amrData = [NSMutableData data];
}

- (void)socket:(GCDAsyncSocket *)sock didAcceptExplorerNewSocket:(GCDAsyncSocket *)newSocket
{
    @weakify(self)
    dispatch_async(GetMainQueue, ^{
        @strongify(self);
        [self.deviceTableView reloadData];
    });
}

- (void)audioSocketDidDisconnect:(GCDAsyncSocket *)sock
{
    if (self.dataClientSocket == sock) {
        self.dataClientSocket = nil;
//        [self writeAmr];
        return;
    }
}

- (void)explorerSocketDidDisconnect:(GCDAsyncSocket *)sock
{
    @weakify(self)
    dispatch_async(GetMainQueue, ^{
        @strongify(self);
        [self.deviceTableView reloadData];
    });
}

- (void)socket:(GCDAsyncSocket *)sock didReadAudioData:(NSData *)data
{
    if (self.dataClientSocket == sock) {
//        [self.amrData appendData:data];
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
