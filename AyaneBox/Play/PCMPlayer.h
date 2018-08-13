//
//  PCMPlayer.h
//  AyaneBox
//
//  Created by yuanxuan on 2018/7/24.
//  Copyright © 2018年 AyaneBox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

#define QUEUE_BUFFER_SIZE 4   //队列缓冲个数
#define AUDIO_BUFFER_SIZE (2048 * 4) //数据区大小
#define MAX_BUFFER_SIZE (44100 * 2) //

@interface PCMPlayer : NSObject
-(BOOL)start;
-(void)play:(NSData *)data;
-(void)stop;
@end
