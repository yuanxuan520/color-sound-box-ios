//
//  AudioData.m
//  AyaneBox
//
//  Created by yuanxuan on 2018/7/26.
//  Copyright © 2018年 AyaneBox. All rights reserved.
//

#import "AudioData.h"

@implementation AudioData
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.in01 = (Byte*)malloc(FramePerPacket * 2);
        self.in02 = (Byte*)malloc(FramePerPacket * 2);
        self.in03 = (Byte*)malloc(FramePerPacket * 2);
        self.in04 = (Byte*)malloc(FramePerPacket * 2);
        self.out01 = (Byte*)malloc(FramePerPacket * 2);
        self.out02 = (Byte*)malloc(FramePerPacket * 2);
        self.out03 = (Byte*)malloc(FramePerPacket * 2);
    }
    return self;
}
@end
