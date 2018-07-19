//
//  NSMutableAttributedString+ColorAndFontSize.m
//  SellHouseManager
//
//  Created by 杨旭的电脑 on 16/5/12.
//  Copyright © 2016年 JiCe. All rights reserved.
//

#import "NSMutableAttributedString+ColorAndFontSize.h"

@implementation NSMutableAttributedString (ColorAndFontSize)

+ (instancetype)attributedStringWithString:(NSString *)str color:(UIColor *)color fontSize:(CGFloat)fontSize
{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0,str.length)];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:NSMakeRange(0, str.length)];
    return attStr;
}

@end
