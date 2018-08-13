//
//  SocketDataObject.m
//  AyaneBox
//
//  Created by yuanxuan on 2018/7/29.
//  Copyright © 2018年 AyaneBox. All rights reserved.
//

#import "SocketDataObject.h"

@implementation SocketDataObject
- (void)udpSocket:(GCDAsyncUdpSocket *)sock host:(NSString *)host didReceiveData:(NSData *)data fromAddress:(NSData *)address
{
    [[PCMDataSource sharedData] appendByDeviceInput:data];
}
@end
