//
//  Pcm2WavUtil.h
//  AyaneBox
//
//  Created by yuanxuan on 2018/7/26.
//  Copyright © 2018年 AyaneBox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pcm2WavUtil : NSObject
int convertPcm2Wav(char *src_file, char *dst_file, int channels, int sample_rate);
@end
