//
//  NSString+MyString.h
//  HuiXin
//
//  Created by apple on 13-12-11.
//  Copyright (c) 2013年 文俊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MyString)

+ (NSString *)deviceUUID;
+ (NSString *)stringBySpaceTrim:(NSString *)string;
//替换@为#
- (NSString *)replacingAtWithOctothorpe;
- (NSString *)replacingOctothorpeWithAt;
- (NSString *)replacingEnterWithNull;

+ (BOOL)containsChinese:(NSString *)string;
+ (NSString *)stringByNull:(NSString *)string;
- (BOOL)nonNull;
+ (BOOL)isNull:(NSString*)string;
+ (BOOL)isEmptyAfterSpaceTrim:(NSString *)string;

- (BOOL)isBlank;
// 判断是否纯数字
+ (BOOL)isPureInt:(NSString *)string;
// 判断浮点型
+ (BOOL)isPureFloat:(NSString *)string;

// 过滤html的所有标志(图片等也被过滤) NSScanner过滤html
+ (NSString *)getClearHtmlString:(NSString *)htmlString clearSpace:(BOOL)clear;

//手机号添加空格
+ (NSString *)addBlank:(NSString *)phone;

/// 字符输入正则限制
+ (BOOL)isTrueValue:(NSString *)value withRegex:(NSString *)regex;

// end

//将数字前面加0
/*
 *numString   :   传入数字，需要先转成string
 *len         :   需要数字的长度
 */
+ (NSString *)addZero:(NSString *)numString len:(NSInteger)len;

//生成count位的**，用于用户隐私时替换字符串
+ (NSString *)creatStarWithCount:(NSUInteger)count;
+ (NSString *)hideStringWithStar:(NSString *)idStr;

// 浮点数转字符串：默认2位精度，如果2位精度不够调整为4位精度[解决有些收益金额小于0.01显示为0.00的问题]
+ (NSString *)stringByAutoAccuracy:(double)doubleValue;
///获取两个字符串是否一样的 支持字符串为nil
+ (BOOL)stringIsChangeFromString:(NSString *)fromString toString:(NSString *)toString;

//用于拼接行业和职位
+ (NSString *)appendIndustryName:(NSString *)induistryName jobName:(NSString *)jobName;

- (NSString*)isValidPassword;

@end
