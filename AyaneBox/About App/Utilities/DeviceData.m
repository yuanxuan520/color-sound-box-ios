//
//  DeviceData.m
//  AyaneBox
//
//  Created by yuanxuan on 2018/7/29.
//  Copyright © 2018年 AyaneBox. All rights reserved.
//

#import "DeviceData.h"

@implementation DeviceData
@synthesize deviceList;
+ (PCMDataSource *)sharedData
{
    static PCMDataSource *sharedDataInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedDataInstance = [[self alloc] init];
    });
    return sharedDataInstance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.deviceList = [NSMutableArray arrayWithCapacity:0];
        self.deviceDict = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return self;
}
@end
