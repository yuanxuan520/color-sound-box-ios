//
//  NSString+Format.m
//  SellHouseManager
//
//  Created by luoyan on 16/6/4.
//  Copyright © 2016年 JiCe. All rights reserved.
//

#import "NSString+Format.h"

@implementation NSString (Format)

- (NSString*)numberFormatterDecimalStyle
{
    NSNumberFormatter *_labelFormatter = [[NSNumberFormatter alloc] init];
    [_labelFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *formatterStr = [_labelFormatter stringFromNumber:[_labelFormatter numberFromString:self]];
    return formatterStr;
}

@end
