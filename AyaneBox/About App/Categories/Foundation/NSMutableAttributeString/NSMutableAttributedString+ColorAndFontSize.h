//
//  NSMutableAttributedString+ColorAndFontSize.h
//  SellHouseManager
//
//  Created by 杨旭的电脑 on 16/5/12.
//  Copyright © 2016年 JiCe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (ColorAndFontSize)

// 根据文字颜色字体创建
+ (instancetype)attributedStringWithString:(NSString *)str color:(UIColor *)color fontSize:(CGFloat)fontSize;

@end
