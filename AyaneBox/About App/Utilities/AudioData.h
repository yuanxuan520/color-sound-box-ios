//
//  AudioData.h
//  AyaneBox
//
//  Created by yuanxuan on 2018/7/26.
//  Copyright © 2018年 AyaneBox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioData : NSObject
@property (nonatomic, assign) Byte *in01;
@property (nonatomic, assign) Byte *in02;
@property (nonatomic, assign) Byte *in03;
@property (nonatomic, assign) Byte *in04;

@property (nonatomic, assign) Byte *out01;
@property (nonatomic, assign) Byte *out02;
@property (nonatomic, assign) Byte *out03;
@end
