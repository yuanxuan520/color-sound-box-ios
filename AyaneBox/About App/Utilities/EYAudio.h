//
//  EYAudio.h
//  AyaneBox
//
//  Created by yuanxuan on 2018/7/30.
//  Copyright © 2018年 AyaneBox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EYAudio : NSObject
// 播放的数据流数据
- (void)playWithData:(NSData *)data;

// 声音播放出现问题的时候可以重置一下
- (void)resetPlay;

// 停止播放
- (void)stop;

@end