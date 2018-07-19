//
//  NSString+ImageSizeUrl.m
//  SellHouseManager
//
//  Created by 文俊 on 16/7/26.
//  Copyright © 2016年 JiCe. All rights reserved.
//

#import "NSString+ImageSizeUrl.h"

@implementation NSString (ImageSizeUrl)

- (NSString*)thumbImageUrl
{
    NSString *urlStr = self;
    NSString *fileNameStr = [urlStr stringByDeletingPathExtension];
    //stringByDeletingPathExtension容错
    if (![fileNameStr hasPrefix:@"http://"]) {
        [fileNameStr stringByReplacingOccurrencesOfString:@"http:/" withString:@"http://" options:NSCaseInsensitiveSearch range:NSMakeRange(0, fileNameStr.length)];
    }
    NSString *name = [NSString stringWithFormat:@"%@-small.%@", fileNameStr, [urlStr pathExtension]];
    return name;
}

@end
