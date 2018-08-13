//
//  DeviceObject.h
//  AyaneBox
//
//  Created by yuanxuan on 2018/7/29.
//  Copyright © 2018年 AyaneBox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceObject : NSObject
@property (nonatomic, strong) NSString *macAddresName;
@property (nonatomic, strong) NSString *macAddres;
@property (nonatomic, strong) NSString *ipAddresName;
@property (nonatomic, strong) NSString *ipAddres;
@property (nonatomic, assign) BOOL isMatching;
@end
