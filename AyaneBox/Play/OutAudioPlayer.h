//
//  OutAudioPlayer.h
//  AyaneBox
//
//  Created by yuanxuan on 2018/7/30.
//  Copyright © 2018年 AyaneBox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OutAudioPlayer : NSObject
- (void)createPlay;
- (void)play:(NSData *)data;
- (void)stop;
@end
