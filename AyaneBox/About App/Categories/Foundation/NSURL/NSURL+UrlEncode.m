//
//  NSURL+UrlEncode.m
//  SellHouseManager
//
//  Created by 文俊 on 16/6/17.
//  Copyright © 2016年 JiCe. All rights reserved.
//

#import "NSURL+UrlEncode.h"

@implementation NSURL (UrlEncode)

+ (NSURL*)URLWithUTF8String:(NSString*)url
{
    NSString *utf8Url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [self URLWithString:utf8Url];
}

@end
