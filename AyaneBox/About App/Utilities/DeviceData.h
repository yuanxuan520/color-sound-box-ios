//
//  DeviceData.h
//  AyaneBox
//
//  Created by yuanxuan on 2018/7/29.
//  Copyright © 2018年 AyaneBox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceData : NSObject
@property (nonatomic, strong) NSMutableArray *deviceList;
@property (nonatomic, strong) NSMutableDictionary *deviceDict;
+ (DeviceData *)sharedData;

@end
