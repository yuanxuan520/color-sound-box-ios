//
//  SocketObject.m
//  AyaneBox
//
//  Created by yuanxuan on 2018/7/29.
//  Copyright © 2018年 AyaneBox. All rights reserved.
//

#import "SocketObject.h"

@implementation SocketObject
#pragma mark - ABSocketServerDelegate
- (void)udpSocket:(GCDAsyncUdpSocket *)sock host:(NSString *)host didReceiveData:(NSData *)data fromAddress:(NSData *)address
{
    Byte *macByte = (Byte *)[data bytes];
    NSString *macAddressName = [NSString stringWithFormat:@"%02lx-%02lx-%02lx-%02lx-%02lx-%02lx",(long)macByte[1],(long)macByte[2],(long)macByte[3],(long)macByte[4],(long)macByte[5],(long)macByte[6]];
    NSString *macAddress = [NSString stringWithFormat:@"%d-%d-%d-%d-%d-%d",macByte[1],macByte[2],macByte[3],macByte[4],macByte[5],macByte[6]];
    DeviceData *deviceData = [DeviceData sharedData];
    DeviceObject *deviceObject = [[DeviceObject alloc] init];
    deviceObject.macAddresName = macAddressName;
    deviceObject.macAddres = macAddress;
    deviceObject.ipAddresName = host;
    deviceObject.ipAddres = host;
    deviceObject.isMatching = NO;
    NSString *deviceHost = [deviceData.deviceDict objectForKey:macAddressName];
    if (deviceHost == nil) {
        [deviceData.deviceDict setObject:host forKey:macAddressName];
        [deviceData.deviceList addObject:deviceObject];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray *deviceList = [NSObject mj_keyValuesArrayWithObjectArray:deviceData.deviceList];
            [kUserDefaults setObject:deviceList forKey:@"deviceList"];
            [kUserDefaults setObject:deviceData.deviceDict forKey:@"deviceDict"];
            [kUserDefaults synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DEVICEUPDATE" object:nil];
        });
    }else {
        if (![host isEqualToString:deviceHost]) {
            [deviceData.deviceDict removeObjectForKey:macAddressName];
            for (DeviceObject *object in deviceData.deviceList) {
                if ([object.macAddresName isEqualToString:macAddressName]) {
                    [deviceData.deviceList removeObject:object];
                    break;
                }
            }
            [deviceData.deviceDict setObject:host forKey:macAddressName];
            [deviceData.deviceList addObject:deviceObject];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableArray *deviceList = [NSObject mj_keyValuesArrayWithObjectArray:deviceData.deviceList];
                [kUserDefaults setObject:deviceList forKey:@"deviceList"];
                [kUserDefaults setObject:deviceData.deviceDict forKey:@"deviceDict"];
                [kUserDefaults synchronize];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DEVICEUPDATE" object:nil];
            });
        }
    }
}


@end
