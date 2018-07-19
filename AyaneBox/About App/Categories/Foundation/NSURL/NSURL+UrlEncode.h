//
//  NSURL+UrlEncode.h
//  SellHouseManager
//
//  Created by 文俊 on 16/6/17.
//  Copyright © 2016年 JiCe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (UrlEncode)

+ (NSURL*)URLWithUTF8String:(NSString*)url;

@end
